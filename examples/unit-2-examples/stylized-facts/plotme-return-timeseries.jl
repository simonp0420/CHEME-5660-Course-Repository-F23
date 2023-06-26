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

# plot -
plot!(R, lw=3, c=colors[2], label="$(ticker)", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, 
    fg_legend = :transparent);
xlabel!("Time (day)", fontsize=18)
ylabel!("logarithmic Return", fontsize=18)

# save figure -
savefig(joinpath(_PATH_TO_FIGS, "Fig-$(ticker)-Daily-Return-4yr.pdf"))