# setup paths
const _ROOT = pwd()
const _PATH_TO_SRC = joinpath(_ROOT, "src")
const _PATH_TO_DATA = joinpath(_ROOT, "data")
const _PATH_TO_FIGS = joinpath(_ROOT, "figs")

# load external packages -
using JLD2
using FileIO
using DataFrames
using CSV
using Plots
using Colors
using StatsBase
using StatsPlots
using Statistics
using Distributions
using MarkdownTables
using HypothesisTests

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"))
include(joinpath(_PATH_TO_SRC, "Factory.jl"))
include(joinpath(_PATH_TO_SRC, "Files.jl"))
include(joinpath(_PATH_TO_SRC, "Compute.jl"))