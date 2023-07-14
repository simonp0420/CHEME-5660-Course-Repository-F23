# include -
include("Include.jl")

# load data -
dataset = loaddataset();
gbm_model_parameters = loadmodelparametersfile(MyHistoricalVolatilityGBMEquityModelParameters);

# my tickers -
my_tickes = ["AMD", "WFC", "IBM", "GS", "TSLA"];
number_of_trading_days = 1256;
T = 66;
Δt = 1.0/252.0;
start_index = rand(1:(number_of_trading_days - T - 1))
start_index = 458
stop_index = start_index + T
T₁ = start_index*Δt
T₂ = stop_index*Δt

# setup the simulation -
id_array = [11, 437,487, 221, 241];
sample_data = Dict{Int64, Array{Float64,2}}()
expectation_data = Dict{Int64, Array{Float64,2}}()
variance_data = Dict{Int64, Array{Float64,2}}()
for firm_id ∈ id_array

    firm_data = dataset[firm_id];

    μ̂ = gbm_model_parameters[gbm_model_parameters.id .== firm_id, :μ][1]
    σ̂ = gbm_model_parameters[gbm_model_parameters.id .== firm_id, :σ][1]

    model = build(MyGeometricBrownianMotionEquityModel, (
            μ = μ̂, σ = σ̂ ));


    Sₒ = firm_data[start_index,:volume_weighted_average_price];
    X = sample(model, (Sₒ = Sₒ, T₁ = T₁, T₂ = T₂, Δt = Δt), 
        number_of_paths = 100);
    
    expectation = 𝔼(model, (Sₒ = Sₒ, T₁ = T₁, T₂ = T₂, Δt = Δt));
    variance = Var(model, (Sₒ = Sₒ, T₁ = T₁, T₂ = T₂, Δt = Δt));

    sample_data[firm_id] = X;
    expectation_data[firm_id] =  expectation;
    variance_data[firm_id] = variance;
end

fig = Figure(resolution = (800, 600));

# setup the plot -
firm_id = 241;
zs95 = 1.96;
zs99 = 2.58;
expectation = expectation_data[firm_id];
variance = variance_data[firm_id];
firm_data = dataset[firm_id];

L68 = expectation[:,2] .- sqrt.(variance[:,2])
U68 = expectation[:,2] .+ sqrt.(variance[:,2])
L95 = expectation[:,2] .- 1.96*sqrt.(variance[:,2])
U95 = expectation[:,2] .+ 1.96*sqrt.(variance[:,2])
L99 = expectation[:,2] .- 2.576*sqrt.(variance[:,2])
U99 = expectation[:,2] .+ 2.576*sqrt.(variance[:,2])

ax = Axis(fig[1,1], xlabel = "Time (years)", ylabel = "Daily volume weighted average price (USD/share)", backgroundcolor=:snow2);
TS = sample_data[firm_id][:,1];
XS = sample_data[firm_id][:,2:end];
AS = firm_data[start_index:stop_index, :volume_weighted_average_price];
mean_XS = vec(mean(XS, dims=2));
std_XS = vec(std(XS, dims=2));
band!(TS, mean_XS + zs99*std_XS, mean_XS - zs99*std_XS, color=(:skyblue1,0.4), transparent = true); 
band!(TS, mean_XS + zs95*std_XS, mean_XS - zs95*std_XS, color=(:deepskyblue,0.5), transparent = true); 
band!(TS, mean_XS + std_XS, mean_XS - std_XS, color=(:dodgerblue,0.6), transparent = true);
lines!(ax, TS, L68, color=:gray25); 
lines!(ax, TS, U68, color=:gray25); 
lines!(ax, TS, L95, color=:gray25); 
lines!(ax, TS, U95, color=:gray25); 
lines!(ax, TS, L99, color=:gray25); 
lines!(ax, TS, U99, color=:gray25); 
lines!(ax, TS, mean_XS, linewidth=3);
lines!(ax, TS, AS, color=:red, label="IBM (actual)", linewidth=3); 
lines!(ax, TS, mean_XS, linewidth=3, color=:navy, label="IBM (expected)");
lines!(ax, TS, expectation[:,2], linewidth=3, color=:navy, linestyle=:dash);
axislegend(ax, position=:lt, framevisible = false)

# setup the plot -
firm_id = 221;
zs95 = 1.96;
zs99 = 2.58;
expectation = expectation_data[firm_id];
variance = variance_data[firm_id];
firm_data = dataset[firm_id];

L68 = expectation[:,2] .- sqrt.(variance[:,2])
U68 = expectation[:,2] .+ sqrt.(variance[:,2])
L95 = expectation[:,2] .- 1.96*sqrt.(variance[:,2])
U95 = expectation[:,2] .+ 1.96*sqrt.(variance[:,2])
L99 = expectation[:,2] .- 2.576*sqrt.(variance[:,2])
U99 = expectation[:,2] .+ 2.576*sqrt.(variance[:,2])

ax = Axis(fig[1,2], xlabel = "Time (years)", ylabel = "Daily volume weighted average price (USD/share)", backgroundcolor=:snow2);
TS = sample_data[firm_id][:,1];
XS = sample_data[firm_id][:,2:end];
AS = firm_data[start_index:stop_index, :volume_weighted_average_price];
mean_XS = vec(mean(XS, dims=2));
std_XS = vec(std(XS, dims=2));
band!(TS, mean_XS + zs99*std_XS, mean_XS - zs99*std_XS, color=(:skyblue1,0.4), transparent = true); 
band!(TS, mean_XS + zs95*std_XS, mean_XS - zs95*std_XS, color=(:deepskyblue,0.5), transparent = true); 
band!(TS, mean_XS + std_XS, mean_XS - std_XS, color=(:dodgerblue,0.6), transparent = true);
lines!(ax, TS, L68, color=:gray25); 
lines!(ax, TS, U68, color=:gray25); 
lines!(ax, TS, L95, color=:gray25); 
lines!(ax, TS, U95, color=:gray25); 
lines!(ax, TS, L99, color=:gray25); 
lines!(ax, TS, U99, color=:gray25); 
lines!(ax, TS, mean_XS, linewidth=3, color=:navy, label="GS (expected)");
lines!(ax, TS, expectation[:,2], linewidth=3, color=:navy, linestyle=:dash);
lines!(ax, TS, AS, color=:red, label="GS (actual)", linewidth=3); 
axislegend(ax, position=:lt, framevisible = false)

# setup the plot -
firm_id = 437;
zs95 = 1.96;
zs99 = 2.58;
expectation = expectation_data[firm_id];
variance = variance_data[firm_id];
firm_data = dataset[firm_id];

L68 = expectation[:,2] .- sqrt.(variance[:,2])
U68 = expectation[:,2] .+ sqrt.(variance[:,2])
L95 = expectation[:,2] .- 1.96*sqrt.(variance[:,2])
U95 = expectation[:,2] .+ 1.96*sqrt.(variance[:,2])
L99 = expectation[:,2] .- 2.576*sqrt.(variance[:,2])
U99 = expectation[:,2] .+ 2.576*sqrt.(variance[:,2])


# ax = Axis(fig[1,3], xlabel = "Time (years)", ylabel = "Daily volume weighted average price (USD/share)", backgroundcolor=:snow2);
# TS = sample_data[firm_id][:,1];
# XS = sample_data[firm_id][:,2:end];
# AS = firm_data[start_index:stop_index, :volume_weighted_average_price];
# mean_XS = vec(mean(XS, dims=2));
# std_XS = vec(std(XS, dims=2));
# band!(TS, mean_XS + zs99*std_XS, mean_XS - zs99*std_XS, color=(:skyblue1,0.4), transparent = true); 
# band!(TS, mean_XS + zs95*std_XS, mean_XS - zs95*std_XS, color=(:deepskyblue,0.5), transparent = true); 
# band!(TS, mean_XS + std_XS, mean_XS - std_XS, color=(:dodgerblue,0.6), transparent = true);
# lines!(ax, TS, L68, color=:gray25); 
# lines!(ax, TS, U68, color=:gray25); 
# lines!(ax, TS, L95, color=:gray25); 
# lines!(ax, TS, U95, color=:gray25); 
# lines!(ax, TS, L99, color=:gray25); 
# lines!(ax, TS, U99, color=:gray25); 
# lines!(ax, TS, mean_XS, linewidth=3, color=:navy, label="TSLA (expected)");
# lines!(ax, TS, expectation[:,2], linewidth=3, color=:navy, linestyle=:dash);
# lines!(ax, TS, AS, color=:red, label="TSLA (actual)", linewidth=3); 
# axislegend(ax, position=:lt, framevisible = false)

# ax = Axis(fig[1,3], xlabel = "Time (years)", ylabel = "Daily Price", backgroundcolor=:snow2);
# TS = sample_data[firm_id][:,1];
# XS = sample_data[firm_id][:,2:end];
# AS = firm_data[start_index:stop_index, :volume_weighted_average_price];
# mean_XS = vec(mean(XS, dims=2));
# std_XS = vec(std(XS, dims=2));
# band!(TS, mean_XS + zs99*std_XS, mean_XS - zs99*std_XS, color=(:gray75,0.4), transparent = true); 
# band!(TS, mean_XS + zs95*std_XS, mean_XS - zs95*std_XS, color=(:lightskyblue,0.5), transparent = true); 
# band!(TS, mean_XS + std_XS, mean_XS - std_XS, color=(:dodgerblue,0.6), transparent = true);
# lines!(ax, TS, L68, color=:gray25); 
# lines!(ax, TS, U68, color=:gray25); 
# lines!(ax, TS, L95, color=:gray25); 
# lines!(ax, TS, U95, color=:gray25); 
# lines!(ax, TS, L99, color=:gray25); 
# lines!(ax, TS, U99, color=:gray25); 
# lines!(ax, TS, mean_XS, linewidth=3);
# lines!(ax, TS, AS, color=:red, label="AMD (actual)", linewidth=3); 

# save
save("Test.svg", fig);

