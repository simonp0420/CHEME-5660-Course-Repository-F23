# include -
include("Include.jl")

# load GBM model parameters -
gbm_model_parameters = loadmodelparametersfile(MyHistoricalVolatilityGBMEquityModelParameters);

# my tickers -
firms_to_look_at = ["AMD", "WFC", "IBM", "GS", "TSLA"];
df = filter(row -> row[:ticker] ∈ firms_to_look_at, gbm_model_parameters);
transform!(df, :μ => (x -> round.(x, sigdigits=4)) => :μ, :σ => (x -> round.(x, sigdigits=4)) => :σ)

# build -
df |> markdown_table(String) |> clipboard