abstract type AbstractEquityModelParametersType end
abstract type AbstractAssetModel end
abstract type AbstractEquityPriceTreeModel <: AbstractAssetModel end

struct MyRealWorldEquityModelParameters <: AbstractEquityModelParametersType
    MyRealWorldEquityModelParameters() = new()
end

struct MyRiskNeutralEquityModelParameters <: AbstractEquityModelParametersType
    MyRiskNeutralEquityModelParameters() = new()
end

struct MySymmetricRiskNeutralEquityModelParameters <: AbstractEquityModelParametersType
    MySymmetricRiskNeutralEquityModelParameters() = new()
end

struct MyHistoricalVolatilityGBMEquityModelParameters <: AbstractEquityModelParametersType
    MyHistoricalVolatilityGBMEquityModelParameters() = new()
end

mutable struct MyBiomialLatticeEquityNodeModel

    # data -
    price::Float64
    probability::Float64

    # constructor -
    MyBiomialLatticeEquityNodeModel() = new();
end

"""
MyBinomialEquityPriceTree
"""
mutable struct MyBinomialEquityPriceTree <: AbstractEquityPriceTreeModel

    # data -
    connectivity::Union{Nothing, Dict{Int64, Array{Int64,1}}}
    levels::Union{Nothing, Dict{Int64,Array{Int64,1}}}
    u::Float64
    d::Float64
    p::Float64
    data::Union{Nothing, Dict{Int64, MyBiomialLatticeEquityNodeModel}} # holds data in the tree
    
    # constructor 
    MyBinomialEquityPriceTree() = new()
end

"""
    mutable struct MyGeometricBrownianMotionModel <: AbstractSecurityModel
"""
mutable struct MyGeometricBrownianMotionEquityModel <: AbstractAssetModel

    # data -
    μ::Float64
    σ::Float64

    # constructor -
    MyGeometricBrownianMotionEquityModel() = new()
end