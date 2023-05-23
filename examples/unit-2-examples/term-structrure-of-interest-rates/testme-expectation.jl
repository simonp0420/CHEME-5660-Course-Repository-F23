# include -
include("Include.jl");

# initialize -
u = 1.25;    # up factor
d = 0.90;    # down factor
p = 0.51;     # probability of an up move
rₒ = 0.06;   # root value
T = 4;       # number of time periods
Vₚ = 100.0;  # par value of the T-bill

# build a type -
model = build(MySymmetricBinaryLatticeModel,(
    u = u, d = d, p = p, rₒ = rₒ, T = T,
)) |> populate |> (model -> solve(model, Vₚ = Vₚ));

# compute the expectation at level L -
L = 0:T |> collect
expectation = Array{Float64,1}()
for level ∈ L
    push!(expectation, 𝔼(model, level = level))
end

variance = Array{Float64,1}()
for level ∈ L
    push!(variance, 𝕍(model, level = level))
end
