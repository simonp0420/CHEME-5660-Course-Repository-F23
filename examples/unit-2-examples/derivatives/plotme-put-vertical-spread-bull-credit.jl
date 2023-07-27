include("Include.jl")

# load the options chain -
dataset = CSV.read(joinpath(_PATH_TO_DATA, "mu-options-chain-DTE-56.csv"), DataFrame);

# build a vertical spread -
long_put_contract = build(MyAmericanPutContractModel, (
    K = 50, premium = 0.23, sense = 1, copy = 1
));

short_put_contract = build(MyAmericanPutContractModel, (
    K = 60, premium = 1.39, sense = -1, copy = 1
));

# build the payoff and probability functions -
number_of_points = 1000;
S = range(40, stop=70, length = number_of_points) |> collect;
payoff_array = payoff([long_put_contract, short_put_contract], S);
profit_array = profit([long_put_contract, short_put_contract], S);

# plot the payoff -
plot(payoff_array[:,1], payoff_array[:,end], c=:black, lw=2, label="Payoff", 
    bg=:snow2, background_color_outside="white", framestyle = :box, 
    fg_legend = :transparent, layout=(1,2))
plot!(payoff_array[:,1], payoff_array[:,2], c=:red, lw=1, label="Long Put (K₂ = 50)", linestyle=:dash)
plot!(payoff_array[:,1], payoff_array[:,3], c=:blue, lw=1, label="Short Put (K₁ = 60)", linestyle=:dash)
xlabel!("Price S(T) (USD/share)", fontsize=18)
ylabel!("Payoff (USD/share)", fontsize=18)

# plot the profit -
plot!(profit_array[:,1], profit_array[:,end], c=:black, lw=2, label="Profit", subplot=2,  
    bg=:snow2, background_color_outside="white", framestyle = :box, fg_legend = :transparent)
plot!(profit_array[:,1], profit_array[:,2], c=:red, lw=1, label="Long Put (K₂ = 50)", subplot=2, linestyle=:dash)
plot!(profit_array[:,1], profit_array[:,3], c=:blue, lw=1, label="Short Put (K₁ = 60)", subplot=2, linestyle=:dash)
plot!(S, zeros(length(S)), c=:green, lw=2, subplot=2, label="Breakeven", linestyle=:dash);
xlabel!("Price S(T) (USD/share)", fontsize=18, subplot=2)
ylabel!("Profit (USD/share)", fontsize=18, subplot=2)

# dump -
savefig(joinpath(_PATH_TO_FIGS, "Fig-put-vertical-spread.svg"))



