using CSV, DataFrames, StatsPlots

fifa_filepath = "data//archive//fifa.csv"

fifa_data = CSV.read(fifa_filepath, DataFrame)

describe(fifa_data)

names(fifa_data)

propertynames(fifa_data)

@df fifa_data plot(:Date, cols(2:7))

