## PRIVATE METHODS BELOW HERE ============================================================================================== #
function _clean(data::Dict{String, DataFrame})::Dict{String, DataFrame}

    # how many elements do we have in SPY?
    spy_df_length = length(data["SPY"][!,:close]);

    # go through each of the tickers and *remove* tickers that don't have the same length as SPY -
    price_data_dictionary = Dict{String, DataFrame}();
    for (ticker, test_df) ∈ data
    
        # how long is test_df?
        test_df_length = length(test_df[!,:close])
        if (test_df_length == spy_df_length)
        price_data_dictionary[ticker] = test_df; 
        else
            println("Length violation: $(ticker) was removed; dim(SPY) = $(spy_df_length) days and dim($(ticker)) = $(test_df_length) days")
        end
    end

    # return -
    return price_data_dictionary;
end
## PRIVATE METHODS ABOVE HERE ============================================================================================== #

## PUBLIC METHODS BELOW HERE =============================================================================================== #
function loadfile(path::String)
    return (load(path)["dd"] |> _clean)
end

function loaddataset()::Dict{Int64, DataFrame}
    path_to_dataset = joinpath(_PATH_TO_DATA, "OHLC-Daily-SP500-5-years-TD-1256.jld2");
    return load(path_to_dataset, "dataset");
end

function loadfirmmappingfile()::DataFrame
    path_to_mapping_file = joinpath(_PATH_TO_DATA, "Firm-Mapping-06-22-23.csv")
    mapping_file = CSV.read(path_to_mapping_file, DataFrame);
    return mapping_file;
end

## PUBLIC METHODS ABOVE HERE =============================================================================================== #