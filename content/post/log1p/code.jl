# consistent random numbers
srand(UInt32[0xfd909253, 0x7859c364, 0x7cd42419, 0x4c06a3b6])

"""
    err(x, [prec])

Return two values, which are the log2 relative errors for calculating
`log1p(x)`, using `Base.log1p` and `Base.Math.JuliaLibm.log1p`.

The errors are calculated by compating to `BigFloat` calculations with the given
precision `prec`.
"""
function err(x, prec = 1024)
    yb = log(1+BigFloat(x, prec))
    e2(y) = Float64(log2(abs(y-yb)/abs(yb)))
    e2(log1p(x)), e2(Base.Math.JuliaLibm.log1p(x))
end

z = exp.(randn(20000)*10)       # z > 0, Lognormal(0, 10)
x = z .- 1                      # x > -1
es = map(err, x)                # errors

using Plots; gr()               # plots

scatter(log2.(z), first.(es), xlab = "log2(x+1)", ylab = "log2 error of Base.log1p",
        legend = false)
hline!(log2(eps())-[0,1])
Plots.svg("Base_log1p_error.svg")
scatter(log2.(z), last.(es) .- first.(es), xlab = "log2(x+1)",
        ylab = "improvement (Base.Math.JuliaLibm.log1p)", legend = false)
Plots.svg("JuliaLibm_improvement.svg")
scatter(log2.(z), last.(es), xlab = "log2(x+1)",
        ylab = "log2 error of Base.Math.JuliaLibm.log1p", legend = false)
hline!(log2(eps())-[0,1])
Plots.svg("JuliaLibm_log1p_error.svg")
