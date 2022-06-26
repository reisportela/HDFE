VERSION

cd("/Users/miguelportela/Documents/GitHub/HDFE")

using RData, DelimitedFiles, FixedEffectModels, DataFrames, CSV, RDatasets, ReadStat, StatFiles
Jdata = DataFrame(load("nlswork_regression.dta"))

@elapsed Julia_Wages = reg(Jdata, @formula(ln_wage ~ ttl_exp + union + not_smsa + nev_mar + fe(idcode) + fe(year)))

Julia_Wages