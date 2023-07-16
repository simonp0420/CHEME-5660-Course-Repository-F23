function _build(modeltype::Type{T}, data::NamedTuple) where T <: AbstractAssetModel
    
    # build an empty model
    model = modeltype();

    # if we have options, add them to the contract model -
    if (isempty(data) == false)
        for key ∈ fieldnames(modeltype)
            
            # check the for the key - if we have it, then grab this value
            value = nothing
            if (haskey(data, key) == true)
                # get the value -
                value = data[key]
            end

            # set -
            setproperty!(model, key, value)
        end
    end
 
    # return -
    return model
end

# build methods -
build(model::Type{MyBinomialEquityPriceTree}, data::NamedTuple)::MyBinomialEquityPriceTree = _build(model, data)
build(model::Type{MyGeometricBrownianMotionEquityModel}, data::NamedTuple)::MyGeometricBrownianMotionEquityModel = _build(model, data)
build(model::Type{MyOrdinaryBrownianMotionEquityModel}, data::NamedTuple)::MyOrdinaryBrownianMotionEquityModel = _build(model, data)