# include -
include("Include.jl")

# setup color dictionary -
# Colors taken from: https://personal.sron.nl/~pault/
colors = Dict{Int64,RGB}()
colors[1] = colorant"#0077BB" 
colors[2] = colorant"#33BBEE"
colors[3] = colorant"#009988"
colors[4] = colorant"#EE7733"
colors[5] = colorant"#CC3311"
colors[6] = colorant"#EE3377" 
colors[7] = colorant"#BBBBBB"

# initialize -
Cₜ = 1.0;
R = [0.02, 0.04, 0.06, 0.08, 0.10];
number_of_periods = 25;
number_of_rates = length(R)
Cₒ = Array{Float64,2}(undef, number_of_periods, number_of_rates + 1);

# main loop - compute the present values
for j ∈ 1:number_of_rates
        
    # pick a rate -
    r = R[j];

    # iterare of period -
    for i ∈ 1:number_of_periods
        
        # compute the discount -
        D = (1+r)^(i-1)

        Cₒ[i,1] = i-1
        Cₒ[i,j+1] = (1/D)*Cₜ
    end
end

# plot -
for i ∈ 1:number_of_rates
    plot!(Cₒ[:,1],Cₒ[:,i+1], c = colors[i], label="r = $(R[i])", lw=2, xlim=(0.0,number_of_periods), ylim=(0.0,1.1),
        bg="floralwhite", background_color_outside="white", framestyle = :box, 
        fg_legend = :transparent)
    #scatter!(Cₒ[:,1],Cₒ[:,i+1], msc=colors[i], label="", mc="white")
end
current();
xlabel!("Period index (AU)", fontsize=18)
ylabel!("Present value (USD)", fontsize=18)

# save -
savefig(joinpath(_PATH_TO_FIGS, "Fig-PresentValue-FuturePayment.pdf"))
