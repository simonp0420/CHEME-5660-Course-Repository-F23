"""
    loaddataset() -> Dict{Int64, DataFrame}
"""
function loaddataset()::Dict{Int64, DataFrame}
    path_to_dataset = joinpath(_PATH_TO_DATA, "OHLC-Daily-SP500-5-years-TD-1256.jld2")
    dataset = load(path_to_dataset, "dataset");
    return dataset;
end

"""
    loadmodelparametersfile(type::MyEquityModelParameters) -> DataFrame
"""
function loadmodelparametersfile(type::Type{MyEquityModelParameters})::DataFrame
    path_to_parameters = joinpath(_PATH_TO_DATA, "Parameters-Binomial.csv")
    parameters = CSV.read(path_to_parameters, DataFrame);
    return parameters;
end

function loadfirmmappingfile()::DataFrame
    path_to_mapping_file = joinpath(_PATH_TO_DATA, "Firm-Mapping-06-22-23.csv")
    mapping_file = CSV.read(path_to_mapping_file, DataFrame);
    return mapping_file;
end