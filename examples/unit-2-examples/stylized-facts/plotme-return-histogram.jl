# include -
include("runme.jl")

# setuo color dictionary -
colors = Dict{Int64,RGB}()
colors[1] = colorant"#EE7733"
colors[2] = colorant"#0077BB" 
colors[3] = colorant"#33BBEE" 
colors[4] = colorant"#EE3377" 
colors[5] = colorant"#CC3311" 
colors[6] = colorant"#009988" 
colors[7] = colorant"#DDDDDD"

# make histogram -
histogram(R,normalize=:true, c=colors[7], label="Actual",
    bg="floralwhite", background_color_outside="white", framestyle = :box, fg_legend = :transparent);
ld = fit_mle(Laplace, R);
nd = fit_mle(Normal, R);
plot!(ld, lw=3, c=colors[5],label="Laplace")
plot!(nd, lw=3, c=colors[2], label="Normal")
xlabel!("Daily Return $(ticker)", fontsize=18)
ylabel!("Count", fontsize=18)

# save figure -
savefig(joinpath(_PATH_TO_FIGS, "Fig-$(ticker)-Daily-Return-4yr-histogram.svg"))
