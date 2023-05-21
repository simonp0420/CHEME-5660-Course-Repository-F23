function loaddata(path::String)::DataFrame
    return CSV.read(path, DataFrame);
end