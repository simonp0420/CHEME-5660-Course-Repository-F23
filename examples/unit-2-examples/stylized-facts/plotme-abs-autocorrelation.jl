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
L = length(R);
lags = range(0,step=1,stop=(L-1));
AC = autocor(abs.(R), lags);

# compute the bounds -
LB = zeros(L) .- 1.96/sqrt(L);
UB = zeros(L) .+ 1.96/sqrt(L);

# plot -
plot!(AC,xlim=(0,100), lw=3, c=colors[2], label="abs(r) $(ticker)", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, 
    fg_legend = :transparent);
plot!(LB,c=colors[5], lw=1, label="Lower bound 95% CI")
plot!(UB,c=colors[5], lw=1, label="Upper bound 95% CI")
xlabel!("Lag (day)", fontsize=18)
ylabel!("Autocorrelation", fontsize=18)