# include -
include("Include.jl")

# load my data sets -
dataset = loaddataset();
firm_mapping_df = loadfirmmappingfile();

# set some constants -
number_of_trading_days = 1256;
Δt = 1.0/252.0;

# initialize dataframe -
gbm_model_parameters = DataFrame(id=Int64[], ticker=String[], name=String[], sector=String[],  
    μ = Float64[], σ = Float64[]);

# process each firm in the dataset -
for (firm_id, firm_data) ∈ dataset

    # get meta data about the firm -
    ticker = firm_mapping_df[firm_id, :Symbol];
    name_value = firm_mapping_df[firm_id, :Name];
    sector_value = firm_mapping_df[firm_id, :Sector];

    # compute μ -
    all_range = range(1,stop=number_of_trading_days,step=1) |> collect
    T_all = all_range*Δt .- Δt;

    # Setup the normal equations -
    A = [ones(number_of_trading_days) T_all];
    Y = log.(firm_data[!,:volume_weighted_average_price]);

    # Solve the normal equations -
    θ = inv(transpose(A)*A)*transpose(A)*Y;

    # get estimated μ -
    μ̂ = θ[2];

    # compute σ -
    growth_rate_array = Array{Float64,1}(undef, number_of_trading_days-1)
    for j ∈ 2:number_of_trading_days
        
        S₁ = firm_data[j-1, :volume_weighted_average_price];
        S₂ = firm_data[j, :volume_weighted_average_price];
        growth_rate_array[j-1] = (1/Δt)*log(S₂/S₁);
    end

    R = growth_rate_array.*Δt;
    nd = fit_mle(Normal, R);
    σ̂ = params(nd) |> last |> sqrt;

    # store the data -
    result_tuple = (
        id = firm_id,
        name = name_value,
        ticker = ticker,
        sector = sector_value,
        μ = μ̂,
        σ = σ̂
    );

    push!(gbm_model_parameters, result_tuple);
end


CSV.write(joinpath(_PATH_TO_DATA, "Parameters-Real-World-GBM.csv"), gbm_model_parameters);