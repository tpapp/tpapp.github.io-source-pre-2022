using StatsBase                 # for skewness
using JLD2                      # saving data
cd(joinpath(BLOG_POSTS, "plot-workflow")) # default path
sample_skewness = [skewness(randn(100)) for _ in 1:1000]
@save "data.jld2" sample_skewness # save data
