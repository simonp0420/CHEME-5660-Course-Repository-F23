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
colors[7] = colorant"#BBBBBB"

# compute the AC -
nd = fit_mle(Normal, R);
ld = fit_mle(Laplace, R);
plot(
    qqplot(R, nd, qqline = :fit, lw=4, label="r $(ticker)", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, fg_legend = :transparent, 
    xlabel="Observed return data", ylabel="Normal distributed return data"),
    qqplot(R, ld, qqline = :fit, lw=4, label="r $(ticker)", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, fg_legend = :transparent, 
    xlabel="Observed return data", ylabel="Laplace distributed return data")
);

# save figure -
savefig(joinpath(_PATH_TO_FIGS, "Fig-$(ticker)-Daily-Return-4yr-QQ-plot-Normal-Laplace.pdf"))