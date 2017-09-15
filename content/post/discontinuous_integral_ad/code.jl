using ForwardDiff
import ForwardDiff: Dual, value, partials, Tag
using Distributions
using Plots
using LaTeXStrings
gr()

######################################################################
# elasticity calculation
######################################################################

"""
    elasticity(x)

Calculate `x/x`, stripping `x` of partial derivative information. Useful for
calculating elasticities of the form `∂f/f` using ForwardDiff.
"""
elasticity(x::Real) = one(x)

elasticity(x::Dual{T,V,N}) where {T,V,N} = Dual{T}(one(V), partials(x) / value(x))

######################################################################
# example application
######################################################################

integral_approx(g, d, x) = mean((g.(x) .> 0) .* elasticity.(pdf.(d, x)))

"Helper function that returns the value and derivative at the same time."
function value_and_derivative(f::F, x::R) where {F,R<:Real}
    T = typeof(Tag(F, R))
    y = f(Dual{T}(x, one(x)))
    value(y), partials(y, 1)
end

distr(θ) = Normal(θ, 1)

g(x) = x

function ID_analytical(θ)
    d = distr(θ)
    ccdf(d, 0), pdf(d, 0)
end

function ID_approx(θ)
    x = rand(distr(θ), 1000)
    value_and_derivative(θ->integral_approx(g, distr(θ), x), θ)
end

θs = linspace(-2, 2, 51)
ID0s = ID_analytical.(θs)
ID1s = ID_approx.(θs)

scatter(θs, first.(ID0s), xlab = "\\theta", ylab = "integral",
        label = "analytical", legend = :topleft)
scatter!(θs, first.(ID1s), label = "approximation")
savefig("integral.svg")

scatter(θs, last.(ID0s), xlab = "\\theta", ylab = "derivative",
        label = "analytical", legend = :topleft)
scatter!(θs, last.(ID1s), label = "approximation")
savefig("derivative.svg")
