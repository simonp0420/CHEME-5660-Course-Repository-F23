# include -
include("Include.jl")

# load the parameters -
parameters_df = loadmodelparametersfile(MyEquityModelParameters);

# load the mapping file -
firm_mapping_df = loadfirmmappingfile();

# what firms do we want to look at -
firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"]
number_of_firms_to_look_at = length(firms_to_look_at);
table_df = DataFrame(id=Int64[], ticker=String[], name=String[], sector=String[], probability=Float64[], up=Float64[], down=Float64[])

for i ∈ 1:number_of_firms_to_look_at
    
    firm = firms_to_look_at[i];
    firm_id = 0;
    for row ∈ eachrow(firm_mapping_df)
        firm_id += 1;
        if row[:Symbol] == firm
            break;
        end
    end
    name_value = firm_mapping_df[firm_id, :Name];
    sector_value = firm_mapping_df[firm_id, :Sector];

    # get the parameters for this firm -
    parameters_for_this_firm = parameters_df[parameters_df.firm .== firm_id, :];
    results_tuple = (
        id = firm_id,
        ticker = firm,
        name = name_value,
        sector = sector_value,
        probability = round(parameters_for_this_firm[1, :probability],sigdigits=4),
        up = round(parameters_for_this_firm[1, :up], sigdigits=4),
        down = round(parameters_for_this_firm[1, :down], sigdigits=4)
    );

    push!(table_df, results_tuple);

    # populate table -
    # table_data_array[i, 1] = firm_id;
    # table_data_array[i, 2] = firm;
    # table_data_array[i, 3] = parameters_for_this_firm[1, :probability];
    # table_data_array[i, 4] = parameters_for_this_firm[1, :up];
    # table_data_array[i, 5] = parameters_for_this_firm[1, :down];
end

# pretty_table(table_data_array, header=(["Firm ID", "Firm", "Probability", "Up", "Down"])) |> markdown_table()

# save markdown table to the clipboard -
table_df |> markdown_table(String) |> clipboard