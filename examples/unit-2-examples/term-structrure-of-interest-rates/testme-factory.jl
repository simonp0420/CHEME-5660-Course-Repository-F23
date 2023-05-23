# include -
include("Include.jl");

# initialize -
u = 1.25;    # up factor
d = 0.90;    # down factor
p = 0.5;     # probability of an up move
rₒ = 0.06;   # root value
T = 4;       # number of time periods
Vₚ = 100.0;  # par value of the T-bill

# build a type -
model = build(MySymmetricBinaryLatticeModel,(
    u = u, d = d, p = p, rₒ = rₒ, T = T,
)) |> populate |> (model -> solve(model, Vₚ = Vₚ));