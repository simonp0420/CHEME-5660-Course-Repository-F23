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

function _build_connectivity_dictionary(h::Int)::Dict{Int64, Array{Int64,1}}

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

    # put it back in order -
    for i ∈ 0:(N-1)
        # grab the connectivity -
        connectivity[i] = zero_based_array[i+1,2:end]
    end

    return connectivity
end

# define expectation -
_𝔼(X::Array{Float64,1}, p::Array{Float64,1}) = sum(X.*p)

### PUBLIC API BELOW HERE ---------------------------------------------------------------------------------------------------------------------------------------- #

"""
    analyze(R::Array{Float64,1};  Δt::Float64 = (1.0/365.0)) -> Tuple{Float64,Float64,Float64}
"""
function analyze(R::Array{Float64,1};  Δt::Float64 = (1.0/365.0))::Tuple{Float64,Float64,Float64}
    
    # initialize -
    u,d,p = 0.0, 0.0, 0.0;
    darray = Array{Float64,1}();
    uarray = Array{Float64,1}();
    N₊ = 0;

    # up -
    # compute the up moves, and estimate the average u value -
    index_up_moves = findall(x->x>0, R);
    for index ∈ index_up_moves
        R[index] |> (μ -> push!(uarray, exp(μ*Δt)))
    end
    u = mean(uarray);

    # down -
    # compute the down moves, and estimate the average d value -
    index_down_moves = findall(x->x<0, R);
    for index ∈ index_down_moves
        R[index] |> (μ -> push!(darray, exp(μ*Δt)))
    end
    d = mean(darray);

    # probability -
    N₊ = length(index_up_moves);
    p = N₊/length(R);

    # return -
    return (u,d,p);
end

"""
    riskneutralanalyze(R::Array{Float64,1};  Δt::Float64 = (1.0/252.0), 
        r̄::Float64 = 0.040) -> Tuple{Float64,Float64,Float64}
"""
function riskneutralanalyze(R::Array{Float64,1};  Δt::Float64 = (1.0/252.0), 
    r̄::Float64 = 0.040)::Tuple{Float64,Float64,Float64}
    
    # initialize -
    u,d,q = 0.0, 0.0, 0.0;
    darray = Array{Float64,1}();
    uarray = Array{Float64,1}();

    # up - compute the up moves, and estimate the average u value -
    index_up_moves = findall(x->x>0, R);
    for index ∈ index_up_moves
        R[index] |> (μ -> push!(uarray, exp(μ*Δt)))
    end
    u = mean(uarray);

    # down - compute the down moves, and estimate the average d value -
    index_down_moves = findall(x->x<0, R);
    for index ∈ index_down_moves
        R[index] |> (μ -> push!(darray, exp(μ*Δt)))
    end
    d = mean(darray);

    # risk neutral probability -
    q = (exp(r̄*Δt) - d)/(u - d);

    # return -
    return (u,d,q);
end


"""
    populate(model::MyCRRPriceLatticeModel, Sₒ::Float64, T::Int) -> Dict{Int,Array{NamedTuple,1}}
"""
function populate(model::MyBinomialEquityPriceTree, Sₒ::Float64, h::Int)::MyBinomialEquityPriceTree

    # initialize -
    u = model.u;
    p = model.p;
    d = model.d;
    nodes_dictionary = Dict{Int, MyBiomialLatticeEquityNodeModel}()

    # main loop -
    counter = 0;
    for t ∈ 0:h
        
        # prices -
        for k ∈ 0:t
            
            t′ = big(t)
            k′ = big(k)

            # compute the prices and P for this level
            price = Sₒ*(u^(t-k))*(d^(k));
            P = binomial(t′,k′)*(p^(t-k))*(1-p)^(k);

            # create a NamedTuple that holds values
            node = MyBiomialLatticeEquityNodeModel()
            node.price = price
            node.probability = P
          
            
            # push this into the array -
            nodes_dictionary[counter] = node;
            counter += 1
        end
    end

    # update the model -
    model.data = nodes_dictionary;
    model.levels = _build_nodes_level_dictionary(h);
    model.connectivity = _build_connectivity_dictionary(h);

    # return -
    return model
end

function 𝔼(; Sₒ::Float64 = 1.0, u::Float64 = 1.0, d::Float64 = 1.0, probability::Float64 = 0.5)
    return u*probability*Sₒ + (1 - probability)*d*Sₒ
end

"""
    𝔼(model::MyBinomialEquityPriceTree; level::Int = 0) -> Float64
"""
function 𝔼(model::MyBinomialEquityPriceTree; level::Int = 0)::Float64

    # initialize -
    expected_value = 0.0;
    X = Array{Float64,1}();
    p = Array{Float64,1}();

    # get the levels dictionary -
    levels = model.levels;
    nodes_on_this_level = levels[level]
    for i ∈ nodes_on_this_level

        # grab the node -
        node = model.data[i];
        
        # get the data -
        x_value = node.price;
        p_value = node.probability;

        # store the data -
        push!(X,x_value);
        push!(p,p_value);
    end

    # compute -
    expected_value = _𝔼(X,p) # inner product

    # return -
    return expected_value
end

"""
    𝔼(model::MyBinomialEquityPriceTree, levels::Array{Int64,1}; 
        startindex::Int64 = 0) -> Array{Float64,2}

Computes the expectation of the model simulation. Takes a model::MyBinomialEquityPriceTree instance and a vector of
tree levels, i.e., time steps and returns a variance array where the first column is the time and the second column is the expectation.
Each row is a time step.
"""
function 𝔼(model::MyBinomialEquityPriceTree, levels::Array{Int64,1}; 
    startindex::Int64 = 0)::Array{Float64,2}

    # initialize -
    number_of_levels = length(levels);
    expected_value_array = Array{Float64,2}(undef, number_of_levels, 2);

    # loop -
    for i ∈ 0:(number_of_levels-1)

        # get the level -
        level = levels[i+1];

        # get the expected value -
        expected_value = 𝔼(model, level=level);

        # store -
        expected_value_array[i+1,1] = level + startindex;
        expected_value_array[i+1,2] = expected_value;
    end

    # return -
    return expected_value_array;
end

Var(model::MyBinomialEquityPriceTree, levels::Array{Int64,1}; startindex::Int64 = 0) = 𝕍(model, levels, startindex = startindex)

"""
    𝕍(model::MyBinomialEquityPriceTree; level::Int = 0) -> Float64
"""
function 𝕍(model::MyBinomialEquityPriceTree; level::Int = 0)::Float64

    # initialize -
    variance_value = 0.0;
    X = Array{Float64,1}();
    p = Array{Float64,1}();

    # get the levels dictionary -
    levels = model.levels;
    nodes_on_this_level = levels[level]
    for i ∈ nodes_on_this_level
 
        # grab the node -
        node = model.data[i];
         
        # get the data -
        x_value = node.price;
        p_value = node.probability;
 
        # store the data -
        push!(X,x_value);
        push!(p,p_value);
    end

    # update -
    variance_value = (_𝔼(X.^2,p) - (_𝔼(X,p))^2)

    # return -
    return variance_value;
end

"""
    𝕍(model::MyBinomialEquityPriceTree, levels::Array{Int64,1}; startindex::Int64 = 0) -> Array{Float64,2}

Computes the variance of the model simulation. Takes a model::MyBinomialEquityPriceTree instance and a vector of
tree levels, i.e., time steps and returns a variance array where the first column is the time and the second column is the variance.
Each row is a time step.
"""
function 𝕍(model::MyBinomialEquityPriceTree, levels::Array{Int64,1}; startindex::Int64 = 0)::Array{Float64,2}

    # initialize -
    number_of_levels = length(levels);
    variance_value_array = Array{Float64,2}(undef, number_of_levels, 2);

    # loop -
    for i ∈ 0:(number_of_levels - 1)
        level = levels[i+1];
        variance_value = 𝕍(model, level=level);
        variance_value_array[i+1,1] = level + startindex
        variance_value_array[i+1,2] = variance_value;
    end

    # return -
    return variance_value_array;
end


### GEOMETRIC BROWNIAN MOTION EQUITY MODEL ###
"""
    MyGeometricBrownianMotionEquityModel(; μ::Float64 = 0.0, σ::Float64 = 0.0)
"""
function 𝔼(model::MyGeometricBrownianMotionEquityModel, data::NamedTuple)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]
    
    # get information from model -
    μ = model.μ

    # setup the time range -
    time_array = range(T₁,stop=T₂, step = Δt) |> collect
    N = length(time_array)

    # expectation -
    expectation_array = Array{Float64,2}(undef, N, 2)

    # main loop -
    for i ∈ 1:N

        # get the time value -
        h = (time_array[i] - time_array[1])

        # compute the expectation -
        value = Sₒ*exp(μ*h)

        # capture -
        expectation_array[i,1] = h + time_array[1]
        expectation_array[i,2] = value
    end
   
    # return -
    return expectation_array
end

Var(model::MyGeometricBrownianMotionEquityModel, data::NamedTuple) = 𝕍(model, data);
function 𝕍(model::MyGeometricBrownianMotionEquityModel, data::NamedTuple)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]

    # get information from model -
    μ = model.μ
    σ = model.σ

    # setup the time range -
    time_array = range(T₁,stop=T₂, step = Δt) |> collect
    N = length(time_array)

    # expectation -
    variance_array = Array{Float64,2}(undef, N, 2)

    # main loop -
    for i ∈ 1:N

        # get the time value -
        h = time_array[i] - time_array[1]

        # compute the expectation -
        value = (Sₒ^2)*exp(2*μ*h)*(exp((σ^2)*h) - 1)

        # capture -
        variance_array[i,1] = h + time_array[1]
        variance_array[i,2] = value
    end
   
    # return -
    return variance_array
end


## ORDRINARY BROWNIAN MOTION ##
function 𝔼(model::MyOrdinaryBrownianMotionEquityModel, data::NamedTuple)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]
    
    # get information from model -
    μ = model.μ

    # setup the time range -
    time_array = range(T₁,stop=T₂, step = Δt) |> collect
    N = length(time_array)

    # expectation -
    expectation_array = Array{Float64,2}(undef, N, 2)

    # main loop -
    for i ∈ 1:N

        # get the time value -
        h = (time_array[i] - time_array[1])

        # compute the expectation -
        value = Sₒ + μ*h

        # capture -
        expectation_array[i,1] = h + time_array[1]
        expectation_array[i,2] = value
    end
   
    # return -
    return expectation_array
end

Var(samples::Array{Float64,2}) = 𝕍(samples::Array{Float64,2});
function 𝕍(samples::Array{Float64,2})::Array{Float64,2}

    # estimate a variance -
    (N, M) = size(samples);
    variance_array = Array{Float64,2}(undef, N, 2)

    # main loop -
    for i ∈ 1:N

        # get the time value -
        h = (samples[i,1] - samples[1,1])

        # compute the variance -
        value = var(samples[i,2:end])

        # capture -
        variance_array[i,1] = h + samples[1,1]
        variance_array[i,2] = value
    end

    # return -
    return variance_array;
end

Var(model::MyOrdinaryBrownianMotionEquityModel, data::NamedTuple) = 𝕍(model, data);
function 𝕍(model::MyOrdinaryBrownianMotionEquityModel, data::NamedTuple)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]

    # get information from model -
    μ = model.μ
    σ = model.σ

    # setup the time range -
    time_array = range(T₁,stop=T₂, step = Δt) |> collect
    N = length(time_array)

    # expectation -
    variance_array = Array{Float64,2}(undef, N, 2)

    # main loop -
    for i ∈ 1:N

        # get the time value -
        h = time_array[i] - time_array[1]

        # compute the expectation -
        value = (σ^2)*h

        # capture -
        variance_array[i,1] = h + time_array[1]
        variance_array[i,2] = value
    end
   
    # return -
    return variance_array
end


function sample(model::MyOrdinaryBrownianMotionEquityModel, data::NamedTuple; 
    number_of_paths::Int64 = 100)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]

    # get information from model -
    μ = model.μ
    σ = model.σ

	# initialize -
	time_array = range(T₁, stop=T₂, step=Δt) |> collect
	number_of_time_steps = length(time_array)
    X = zeros(number_of_time_steps, number_of_paths + 1) # extra column for time -

    # put the time in the first col -
    for t ∈ 1:number_of_time_steps
        X[t,1] = time_array[t]
    end

	# replace first-row w/Sₒ -
	for p ∈ 1:number_of_paths
		X[1, p+1] = Sₒ
	end

	# build a noise array of Z(0,1)
	d = Normal(0,1)
	ZM = rand(d,number_of_time_steps, number_of_paths);

	# main simulation loop -
	for p ∈ 1:number_of_paths
		for t ∈ 1:number_of_time_steps-1
			X[t+1,p+1] = X[t,p+1] + μ*Δt + σ*(sqrt(Δt))*ZM[t,p]
		end
	end

	# return -
	return X
end

""" 
    sample(model::MyGeometricBrownianMotionEquityModel, data::NamedTuple) -> Array{Float64,2}
"""
function sample(model::MyGeometricBrownianMotionEquityModel, data::NamedTuple; 
    number_of_paths::Int64 = 100)::Array{Float64,2}

    # get information from data -
    T₁ = data[:T₁]
    T₂ = data[:T₂]
    Δt = data[:Δt]
    Sₒ = data[:Sₒ]

    # get information from model -
    μ = model.μ
    σ = model.σ

	# initialize -
	time_array = range(T₁, stop=T₂, step=Δt) |> collect
	number_of_time_steps = length(time_array)
    X = zeros(number_of_time_steps, number_of_paths + 1) # extra column for time -

    # put the time in the first col -
    for t ∈ 1:number_of_time_steps
        X[t,1] = time_array[t]
    end

	# replace first-row w/Sₒ -
	for p ∈ 1:number_of_paths
		X[1, p+1] = Sₒ
	end

	# build a noise array of Z(0,1)
	d = Normal(0,1)
	ZM = rand(d,number_of_time_steps, number_of_paths);

	# main simulation loop -
	for p ∈ 1:number_of_paths
		for t ∈ 1:number_of_time_steps-1
			X[t+1,p+1] = X[t,p+1]*exp((μ - σ^2/2)*Δt + σ*(sqrt(Δt))*ZM[t,p])
		end
	end

	# return -
	return X
end