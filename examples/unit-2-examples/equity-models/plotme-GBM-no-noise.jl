# using -
using JLD2, CairoMakie, Colors, DataFrames



# set constants -
z = 3.8906;
# z = 1.96;
N = 100;
number_of_trading_days = 1256;

# load data files -
data_dictionary_AMD = load(joinpath(@__DIR__, "data", "Data-AMD-GBM-NoNoise-N-100.jld2"))
data_dictionary_WFC = load(joinpath(@__DIR__, "data", "Data-WFC-GBM-NoNoise-N-100.jld2"))

_PATH_TO_DATA = joinpath(@__DIR__, "data");
path_to_dataset = joinpath(_PATH_TO_DATA, "OHLC-Daily-SP500-5-years-TD-1256.jld2")
dataset = load(path_to_dataset, "dataset");

firm_data_AMD = dataset[11];
firm_data_WFC = dataset[487];
Y_AMD = log.(firm_data_AMD[!,:volume_weighted_average_price]);
Y_WFC = log.(firm_data_WFC[!,:volume_weighted_average_price]);

# grab the data -
T = data_dictionary_AMD["time"];
S_AMD = data_dictionary_AMD["data"];
S_WFC = data_dictionary_WFC["data"];

mean_prediction_AMD = reshape(mean(S_AMD, dims=1), number_of_trading_days);
std_prediction_AMD = reshape(std(S_AMD, dims=1), number_of_trading_days);
mean_prediction_WFC = reshape(mean(S_WFC, dims=1), number_of_trading_days);
std_prediction_WFC = reshape(std(S_WFC, dims=1), number_of_trading_days);

L1_AMD = mean_prediction_AMD - z*std_prediction_AMD;
U1_AMD = mean_prediction_AMD + z*std_prediction_AMD;
L1_WFC = mean_prediction_WFC - z*std_prediction_WFC;
U1_WFC = mean_prediction_WFC + z*std_prediction_WFC;
L2_AMD = mean_prediction_AMD - sqrt(N)*z*std_prediction_AMD;
U2_AMD = mean_prediction_AMD + sqrt(N)*z*std_prediction_AMD;
L2_WFC = mean_prediction_WFC - sqrt(N)*z*std_prediction_WFC;
U2_WFC = mean_prediction_WFC + sqrt(N)*z*std_prediction_WFC;

# plot -
fig = Figure(resolution = (800, 600));
ax_amd = Axis(fig[1,1], xlabel = "Time (years)", ylabel = "ln(price)", backgroundcolor=:snow2);
ax_wfc = Axis(fig[1,2], xlabel = "Time (years)", ylabel = "ln(price)", backgroundcolor=:snow2);
# lines!(ax_amd, T, L1_AMD, color=:gray75);
# lines!(ax_amd, T, U1_AMD, color=:gray75);

# AMD
lines!(ax_amd, T, L2_AMD, color=:gray75);
lines!(ax_amd, T, U2_AMD, color=:gray75);
band!(ax_amd, T, L1_AMD, U1_AMD, color=(:red,0.25), transparent = true);
lines!(ax_amd, T, mean_prediction_AMD, color=:red, linewidth=2, linestyle=:dash, label="AMD (model)");
band!(ax_amd, T, L2_AMD, U2_AMD, color=(:lightskyblue,0.25), transparent = true);
lines!(ax_amd, T, Y_AMD, color=:navyblue, label="AMD (actual)");
a1 = axislegend(ax_amd, position=:lt, framevisible = false)

# WFC
lines!(ax_wfc, T, L2_WFC, color=:gray75);
lines!(ax_wfc, T, U2_WFC, color=:gray75);
band!(ax_wfc, T, L1_WFC, U1_WFC, color=(:red,0.25), transparent = true);
lines!(ax_wfc, T, mean_prediction_WFC, color=:red, linewidth=2, linestyle=:dash, label="WFC (model)");
band!(ax_wfc, T, L2_WFC, U2_WFC, color=(:lightskyblue,0.25), transparent = true);
lines!(ax_wfc, T, Y_WFC, color=:navyblue, label="WFC (actual)");
axislegend(ax_wfc, position=:rt, framevisible = false)
lines!(ax_wfc, T, Y_WFC, color=:navyblue);
ylims!(ax_wfc, 1.95, 5.0)

# save
save("Test.svg", fig);