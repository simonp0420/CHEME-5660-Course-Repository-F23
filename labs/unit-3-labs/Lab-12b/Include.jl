# setup paths -
const _ROOT = pwd();
const _PATH_TO_DATA = joinpath(_ROOT, "data");
const _PATH_TO_SRC = joinpath(_ROOT, "src");

# load external packages
using CSV
using DataFrames
using Distributions
using Statistics
using LinearAlgebra
using Plots
using Colors
using PrettyTables

# load my codes -
include(joinpath(_PATH_TO_SRC,"Files.jl"));
include(joinpath(_PATH_TO_SRC,"Compute.jl"));