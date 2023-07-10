# include -
include("Include.jl")

# constants -
Δt = (1.0/252.0);
r̄ = 0.04061; # 07/07/23 https://www.marketwatch.com/investing/bond/tmubmusd10y?countrycode=bx

# dicoount factor -
𝒟(r̄,Δt) = exp(r̄*Δt);

# load the real world data -
dataset = loaddataset();

# load the mapping file -
firm_mapping_df = loadfirmmappingfile();

# what firms do we want to look at -
# firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"]
# number_of_firms_to_look_at = length(firms_to_look_at);
number_of_firms_to_look_at = length(dataset);
table_df = DataFrame(id=Int64[], ticker=String[], name=String[], sector=String[], probability=Float64[], up=Float64[], down=Float64[])

for (firm_id, data) ∈ dataset

    firm = firm_mapping_df[firm_id, :Symbol];
    name_value = firm_mapping_df[firm_id, :Name];
    sector_value = firm_mapping_df[firm_id, :Sector];

    # compute the (u,d,p) -
    number_of_trading_days = nrow(data);
    return_array = Array{Float64,1}(undef, number_of_trading_days-1)
    for j ∈ 2:number_of_trading_days
    
        S₁ = data[j-1,:volume_weighted_average_price];
        S₂ = data[j,:volume_weighted_average_price];
        return_array[j-1] = (1/Δt)*log(S₂/S₁);
    end

    # analyze the returns -
    (ū,d̄,p̄) = analyze(return_array, Δt = Δt);

    # package -
    results_tuple = (
        id = firm_id,
        ticker = firm,
        name = name_value,
        sector = sector_value,
        probability = round(p̄, sigdigits=4),
        up = round(ū, sigdigits=4),
        down = round(d̄, sigdigits=4)
    );

    push!(table_df, results_tuple);
end

# save markdown table to the clipboard -
# table_df |> markdown_table(String) |> clipboard

# dump -
CSV.write(joinpath(_PATH_TO_DATA, "Parameters-Real-World-Binomial.csv"), table_df);

# build a markdown table -
# firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"];
# table_for_book = filter(row -> row[:ticker] ∈ firms_to_look_at, table_df);
# table_for_book |> markdown_table(String) |> clipboard

