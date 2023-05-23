"""
    _build_nodes_level_dictionary(levels::Int64) -> Dict{Int64,Array{Int64,1}}
"""
function _build_nodes_level_dictionary(levels::Int64)::Dict{Int64,Array{Int64,1}}

    # initialize -
    index_dict = Dict{Int64, Array{Int64,1}}()

    counter = 0
    for l = 0:levels
        
        # create index set for this level -
        index_array = Array{Int64,1}()
        for _ = 1:(l+1)
            counter = counter + 1
            push!(index_array, counter)
        end

        index_dict[l] = (index_array .- 1) # zero based
    end

    # return -
    return index_dict
end


function solve(model::MySymmetricBinaryLatticeModel; Vₚ::Float64 = 100.0)

    # initialize -
    # ...

    # get stuff from the model -
    T = model.T;
    levels = model.levels;
    connectivity = model.connectivity;
    nodes = model.data;

    # all the leaves, have the par value -
    leaves = levels[T];
    for i ∈ leaves
        nodes[i].price = Vₚ; # all the leaves have the par value
    end

    # compute the other values -
    # get the levels that are going to process -
    list_of_levels = sort(keys(levels) |> collect, rev=true);
    for level ∈ list_of_levels[2:end]
        
        # get nodes on this level -
        parent_node_index = levels[level];
        for i ∈ parent_node_index
            
            # for this node, get the kids
            children_nodes = connectivity[i];
            up_node_index = children_nodes[1];
            down_node_index = children_nodes[2];

            # compute the dfactor -
            parent_node = nodes[i]
            rate_parent = parent_node.rate;
            dfactor = 1/(1+rate_parent);

            # compute the future_payback, and current payback
            node_price = dfactor*((p*nodes[up_node_index].price)+(1-p)*(nodes[down_node_index].price))
            nodes[i].price = node_price;
        end
    end

    # return -
    return model;
end

function populate(model::MySymmetricBinaryLatticeModel)

    # initialize -
    nodes_dictionary = Dict{Int, MyBinaryLatticeNodeModel}()

    # get stuff from the model -
    T = model.T;
    u = model.u;
    d = model.d;
    p = model.p;
    rₒ = model.rₒ;
    h = T;

    # compute connectivity - 
    number_items_per_level = [i for i = 1:(h+1)]
    tmp_array = Array{Int64,1}()
    theta = 0
    for value in number_items_per_level
        for _ = 1:value
            push!(tmp_array, theta)
        end
        theta = theta + 1
    end

    N = sum(number_items_per_level[1:(h)])
    connectivity_index_array = Array{Int64,2}(undef, N, 3)
    for row_index = 1:N

        # index_array[row_index,1] = tmp_array[row_index]
        connectivity_index_array[row_index, 1] = row_index
        connectivity_index_array[row_index, 2] = row_index + 1 + tmp_array[row_index]
        connectivity_index_array[row_index, 3] = row_index + 2 + tmp_array[row_index]
    end
    
    # adjust for zero base -
    zero_based_array = connectivity_index_array .- 1;

    # build connectivity dictionary -
    N = sum(number_items_per_level[1:end-1])
    connectivity = Dict{Int64, Array{Int64,1}}()
    for i ∈ 0:(N-1)
        # grab the connectivity -
        connectivity[i] = reverse(zero_based_array[i+1,2:end])
    end

    # compute the price and probability, and store in the nodes dictionary
    counter = 0;
    for t ∈ 0:h

        # prices -
        for k ∈ 0:t
            
            t′ = big(t)
            k′ = big(k)

            # compute the prices and P for this level
            rate = rₒ*(u^(t-k))*(d^(k));
            P = binomial(t′,k′)*(p^(t-k))*(1-p)^(k);

            # create a node model -
            node = MyBinaryLatticeNodeModel();
            node.probability = P;
            node.rate = rate;
            
            # push this into the array -
            nodes_dictionary[counter] = node;
            counter += 1
        end
    end

    # put it back in order -
    for i ∈ 0:(N-1)
        # grab the connectivity -
        connectivity[i] = zero_based_array[i+1,2:end]
    end

    # add data to the model -
    model.connectivity = connectivity
    model.data = nodes_dictionary;
    model.levels = _build_nodes_level_dictionary(h)

    # return -
    return model;
end