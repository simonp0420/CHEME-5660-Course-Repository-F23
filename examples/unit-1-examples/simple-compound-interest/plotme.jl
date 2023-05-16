# include -
include("Include.jl")

# setuo color dictionary -
colors = Dict{Int64,RGB}()
colors[1] = colorant"#EE7733"
colors[2] = colorant"#0077BB" 
colors[3] = colorant"#33BBEE" 
colors[4] = colorant"#EE3377" 
colors[5] = colorant"#CC3311" 
colors[6] = colorant"#009988" 
colors[7] = colorant"#BBBBBB"

# initialize -
number_of_periods = 24
A = Array{Any,2}(undef, number_of_periods+1, 3);
r = 0.05;   # 5% interest per period 
Aₒ = 100.0; # we have 100.0 initially

# Set initial -
A[1,1] = 0;
A[1,2] = Aₒ
A[1,3] = Aₒ

# main -
for t ∈ 2:(number_of_periods+1)
    A[t,1] = (t-1);
    A[t,2] = Aₒ*(1+(t-1)*r);
    A[t,3] = Aₒ*((1+r)^(t-1));
end

# plot -
plot(A[:,1],A[:,2],lw=2,c=colors[1], label="Simple r = 0.05", 
    bg="floralwhite", background_color_outside="white", framestyle = :box, 
    fg_legend = :transparent)
plot!(A[:,1],A[:,3],lw=2,c=colors[2], label="Compound r = 0.05")

# labels -
xlabel!("Period n", fontsize=18)
ylabel!("Amount A(n) USD", fontsize=18)

# save -
savefig(joinpath(_PATH_TO_FIGS, "Fig-Simple-Compound-Balance.pdf"))