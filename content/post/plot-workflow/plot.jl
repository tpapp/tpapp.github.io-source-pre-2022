using JLD2                      # loading data
using Plots; pgfplots()         # PGFPlots backend
using LaTeXStrings              # nice LaTeX strings
cd(joinpath(BLOG_POSTS, "plot-workflow")) # default path
@load "data.jld2"                         # load data
# make plot and tweak; this is the end result
plot(histogram(sample_skewness, normalize = true),
     xlab = L"\gamma_1", fillcolor = :lightgray,
     yaxis = ("frequency", (0, 2)), title = "sample skewness", legend = false)
# finally save
savefig("sample_skewness.svg")  # for quick viewing and web content
savefig("sample_skewness.tex")  # for inclusion into papers
savefig("sample_skewness.pdf")  # for quick viewing
