# include -
include("Include.jl")

# load the dataset -
dataset = loaddataset();
firm_mapping_df = loadfirmmappingfile();

# main loop -
results_data_dictionary = Dict{String, Tuple{Float64, Float64}}();
for (firm_id, firm_data) ∈ dataset

    # grab the ticker -
    ticker = firm_mapping_df[firm_id, :Symbol];

    # compute the return -
    R = logR(firm_data, key = :volume_weighted_average_price, r = 0.0);

    # test this return -
    d1 = fit_mle(Normal, R);
    d2 = fit_mle(Laplace, R);
    test_value_1 = pvalue(OneSampleADTest(R, d1));
    test_value_2 = pvalue(OneSampleADTest(R, d2));

    tuple_value = (round(test_value_1, sigdigits=3), round(test_value_2, sigdigits=3));
    results_data_dictionary[ticker] = tuple_value;
end

# make a dataframe (that I can turn into md table) for some particular tickers -
firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"];
table_df = DataFrame(id=Int64[], ticker=String[], name=String[], sector=String[], Normal=Float64[], Laplace=Float64[]);
for ticker ∈ firms_to_look_at

    # get the data -
    firm_id = findfirst(firm_mapping_df[!,:Symbol] .== ticker);

    name_value = firm_mapping_df[firm_id, :Name];
    sector_value = firm_mapping_df[firm_id, :Sector];
    test_value_1, test_value_2 = results_data_dictionary[ticker];

    # store -
    push!(table_df, (firm_id, ticker, name_value, sector_value, test_value_1, test_value_2));
end

table_df |> markdown_table(String) |> clipboard