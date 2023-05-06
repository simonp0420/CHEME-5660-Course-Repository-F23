"""
    iterate(P::Array{Float64,2}, counter::Int; 
        maxcount::Int = 100, ϵ::Float64 = 0.1) -> Array{Float64,2}

Recursively computes a stationary distribution. Computation stops if ||P_new - P|| < ϵ or the max number of iterations
is hit. 
"""
function iterate(P::Array{Float64,2}, counter::Int; maxcount::Int = 100, ϵ::Float64 = 0.1)::Array{Float64,2}

    # base case -
    if (counter == maxcount)
        return P
    else
        # generate a new P -
        P_new = P^(counter+1)
        err = P_new - P;
        if (norm(err)<=ϵ)
            return P_new
        else
            # we have NOT hit the error target, or the max iterations
            iterate(P_new, (counter+1), maxcount=maxcount, ϵ = ϵ)
        end
    end
end

"""
    R(data::DataFrame; r::Float64 = 0.045) -> Array{Float64,1}

Computes the log excess return for firm i from the Open High Low Close (OHLC) data set in 
the dataset which is type DataFrame.

See: https://dataframes.juliadata.org/stable/man/getting_started/
"""
function R(data::DataFrame; r::Float64 = 0.045)::Array{Float64,1}

    # initialize -
    number_of_trading_days = nrow(data);
    r̄ = (1+r)^(1/365) - 1; # convert the annual risk free rate to daily value

    # TODO: compute the excess returns, store them in an array.
    log_excess_return_array = Array{Float64,1}(undef,  number_of_trading_days - 1)
    
    # main loop -
    for i ∈ 2:number_of_trading_days
        
        # grab yesterday's close price
        P₁ = data[i-1, :close]; # yesterday
        P₂ = data[i, :close];   # today

        # compute the excess return -
        log_excess_return_array[i-1] = log(P₂/P₁) - r̄
    end

    # return -
    return log_excess_return_array;
end


"""
    R(data::DataFrame; r::Float64 = 0.045) -> Array{Float64,1}

Computes the log excess return for firm i from the Open High Low Close (OHLC) data set in 
the dataset which is type DataFrame.

See: https://dataframes.juliadata.org/stable/man/getting_started/
"""
function R(data::Array{Float64,1}; r::Float64 = 0.045)::Array{Float64,1}

    # initialize -
    number_of_trading_days = length(data);
    r̄ = (1+r)^(1/365) - 1; # convert the annual risk free rate to daily value

    # TODO: compute the excess returns, store them in an array.
    log_excess_return_array = Array{Float64,1}(undef,  number_of_trading_days - 1)
    
    # main loop -
    for i ∈ 2:number_of_trading_days
        
        # grab yesterday's close price
        P₁ = data[i-1]; # yesterday
        P₂ = data[i];   # today

        # compute the excess return -
        log_excess_return_array[i-1] = log(P₂/P₁) - r̄
    end

    # return -
    return log_excess_return_array;
end


