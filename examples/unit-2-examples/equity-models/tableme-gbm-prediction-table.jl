# include -
include("Include.jl")

# load data -
firm_mapping_df = loadfirmmappingfile();

# load probability dictionaries -
pd_68 = load(joinpath(_PATH_TO_DATA, "PD-GBM-68.jld2"), "dataset");
pd_95 = load(joinpath(_PATH_TO_DATA, "PD-GBM-95.jld2"), "dataset");
pd_99 = load(joinpath(_PATH_TO_DATA, "PD-GBM-99.jld2"), "dataset");

# iterate over the firm_id
table_data = DataFrame(id=Int64[], ticker=String[], name=String[], P68=Float64[], P95=Float64[], P99=Float64[]);
firmids = collect(keys(pd_68));
for firm_id ∈ firmids

    # get the ticker -
    ticker = firm_mapping_df[firm_id, :Symbol];
    name_value = firm_mapping_df[firm_id, :Name];

    # get the data -
    p68 = pd_68[firm_id];
    p95 = pd_95[firm_id];
    p99 = pd_99[firm_id];

    # push to the table -
    push!(table_data, (id = firm_id, ticker = ticker, name = name_value, P68 = p68, P95 = p95, P99 = p99));
end

firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"];
df = filter(row -> row[:ticker] ∈ firms_to_look_at, table_data);
transform!(df, 
    :P68 => (x -> round.(x, sigdigits=4)) => :P68, 
    :P95 => (x -> round.(x, sigdigits=4)) => :P95,
    :P99 => (x -> round.(x, sigdigits=4)) => :P99);

# build -
df |> markdown_table(String) |> clipboard
