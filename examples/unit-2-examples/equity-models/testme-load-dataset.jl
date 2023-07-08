# include -
include("Include.jl")

# setup path to data -
path_to_dataset = joinpath(_PATH_TO_DATA, "OHLC-Daily-SP500-5-years-TD-1256.jld2")
dataset = load(path_to_dataset, "dataset");