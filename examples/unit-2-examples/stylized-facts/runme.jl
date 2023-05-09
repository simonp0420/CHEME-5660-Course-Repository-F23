# include the include -
include("Include.jl")

# load the data -
price_dataframe_dictionary = loadfile(joinpath(_PATH_TO_DATA, "CHEME-5660-Portfolio-11-28-22-4Y.jld2"));

# grab a ticker -
ticker = "AAPL"

# compute the return -
R = logR(price_dataframe_dictionary[ticker]);