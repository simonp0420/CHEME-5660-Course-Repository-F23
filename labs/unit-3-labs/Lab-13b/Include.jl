# setup -
const _ROOT = pwd();
const _PATH_TO_SRC = joinpath(_ROOT, "src")

# load packages -
using Distributions
using Plots
using Colors
using LinearAlgebra
using Statistics
using StatsBase
using DataFrames
using CSV
using StatsPlots

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"))
include(joinpath(_PATH_TO_SRC, "Factory.jl"))
include(joinpath(_PATH_TO_SRC, "Compute.jl"))