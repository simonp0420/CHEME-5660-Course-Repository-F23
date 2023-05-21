# include -
include("Include.jl")

# load the data -
path_to_data = joinpath(_PATH_TO_DATA, "US-daily-treasury-rates-2022.csv")
df = loaddata(path_to_data)

# plot the 4 Week rate -
key = Symbol("4 WEEKS BANK DISCOUNT")
data = df[:,key] |> reverse
plot(data, lw=2,label="4-week Bank discount 2022", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, fg_legend = :transparent)
xlabel!("Day index", fontsize=18)
ylabel!("Bank discount rate (%) 4-week t-bill", fontsize=18)

# save -
savefig(joinpath(_PATH_TO_FIGS, "Fig-4-week-Daily-2022.pdf"))
