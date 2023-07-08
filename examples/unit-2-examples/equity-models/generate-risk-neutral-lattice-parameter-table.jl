# include -
include("Include.jl")

# constants -
Δt = (1.0/252.0);
r̄ = 0.04061; # 07/07/23 https://www.marketwatch.com/investing/bond/tmubmusd10y?countrycode=bx

# dicoount factor -
𝒟(r̄,Δt) = exp(r̄*Δt);

# load the real world data -
parameters_df = loadmodelparametersfile(MyEquityModelParameters);

# load the mapping file -
firm_mapping_df = loadfirmmappingfile();

# what firms do we want to look at -
# firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"]
# number_of_firms_to_look_at = length(firms_to_look_at);
number_of_firms_to_look_at = nrow(parameters_df);
table_df = DataFrame(id=Int64[], ticker=String[], name=String[], sector=String[], probability=Float64[], up=Float64[], down=Float64[])

for i ∈ 1:number_of_firms_to_look_at
    
    # firm = firms_to_look_at[i];
    # firm_id = 0;
    # for row ∈ eachrow(firm_mapping_df)
    #     firm_id += 1;
    #     if row[:Symbol] == firm
    #         break;
    #     end
    # end
    firm_id = parameters_df[i, :firm];
    firm = firm_mapping_df[firm_id, :Symbol];
    name_value = firm_mapping_df[firm_id, :Name];
    sector_value = firm_mapping_df[firm_id, :Sector];

    # compute the risk neutral probability -
    parameters_for_this_firm = parameters_df[parameters_df.firm .== firm_id, :];
    u = parameters_for_this_firm[1, :up];
    d = 1/u;
    p = (𝒟(r̄,Δt) - d)/(u - d);

    results_tuple = (
        id = firm_id,
        ticker = firm,
        name = name_value,
        sector = sector_value,
        probability = round(p, sigdigits=4),
        up = round(u, sigdigits=4),
        down = round(d, sigdigits=4)
    );

    push!(table_df, results_tuple);
end

# save markdown table to the clipboard -
# table_df |> markdown_table(String) |> clipboard

# dump -
CSV.write(joinpath(_PATH_TO_DATA,"Parameters-Risk-Neutral-Binomial-Symmetric.csv"), table_df);

# build a markdown table -
firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"];
table_for_book = filter(row -> row[:ticker] ∈ firms_to_look_at, table_df);
table_for_book |> markdown_table(String) |> clipboard

