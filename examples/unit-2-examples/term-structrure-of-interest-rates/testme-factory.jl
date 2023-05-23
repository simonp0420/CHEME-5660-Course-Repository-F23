# include -
include("Include.jl");

# initialize -
u = 1.25;    # up factor
d = 0.90;    # down factor
p = 0.5;     # probability of an up move
rₒ = 0.06;   # root value

# build a type -
model = build(MySymmetricBinaryLatticeModel,(
    u = u, d = d, p = p, rₒ = rₒ, T = 4,
)) |> populate;

# solve -
solve(model)