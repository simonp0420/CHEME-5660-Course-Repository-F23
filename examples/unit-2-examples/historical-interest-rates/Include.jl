# setup paths -
const _ROOT = pwd();
const _PATH_TO_DATA = joinpath(_ROOT, "data")
const _PATH_TO_SRC = joinpath(_ROOT, "src")
const _PATH_TO_FIGS = joinpath(_ROOT, "figs")

# load packages -
using CSV
using DataFrames
using Plots
using Colors

# load my codes -
include(joinpath(_PATH_TO_SRC, "Files.jl"))
