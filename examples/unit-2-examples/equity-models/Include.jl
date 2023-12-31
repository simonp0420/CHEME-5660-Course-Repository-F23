# setup paths -
const _ROOT = pwd()
const _PATH_TO_DATA = joinpath(_ROOT, "data")
const _PATH_TO_FIGS = joinpath(_ROOT, "figs")

# load packages -
using JLD2
using DataFrames
using CSV
using PrettyTables
using MarkdownTables
using Distributions
using Statistics
using LinearAlgebra
using Plots
using Colors
# using CairoMakie # only uncomment if you are using Makie

# load my packages -
include(joinpath(_ROOT, "src", "Types.jl"))
include(joinpath(_ROOT, "src", "Factory.jl"))
include(joinpath(_ROOT, "src", "Files.jl"))
include(joinpath(_ROOT, "src", "Compute.jl"))

# load colors -
colors = Dict{Int64,RGB}()
colors[1] = colorant"#EE7733";
colors[2] = colorant"#0077BB";
colors[3] = colorant"#33BBEE";
colors[4] = colorant"#EE3377";
colors[5] = colorant"#CC3311";
colors[6] = colorant"#009988";
colors[7] = colorant"#BBBBBB";