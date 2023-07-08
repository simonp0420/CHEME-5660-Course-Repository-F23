# setup paths -
const _ROOT = pwd()
const _PATH_TO_DATA = joinpath(_ROOT, "data")

# load packages -
using JLD2
using DataFrames
using CSV
using PrettyTables
using MarkdownTables

# load my packages -
include(joinpath(_ROOT, "src", "Types.jl"))
include(joinpath(_ROOT, "src", "Factory.jl"))
include(joinpath(_ROOT, "src", "Files.jl"))
include(joinpath(_ROOT, "src", "Compute.jl"))