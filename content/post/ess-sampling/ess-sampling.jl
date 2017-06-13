"""
Lag-`k` autocorrelation of `x` from a variogram. `v` is the variance
of `x`, used when supplied.
"""
function ρ(x, k, v=var(x))
    x1 = @view(x[1:(end-k)])
    x2 = @view(x[(1+k):end])
    V = sum((x1 .- x2).^2)/length(x1)
    1-V/(2*v)
end

"""
Factor `τ` for effective sample size and the last lag which was used
in the estimation.
"""
function ess_factor(x)
    v = var(x)
    invfactor = 1 + 2*ρ(x, 1, v)
    K = 2
    while K < length(x)-2
        increment = ρ(x, K, v) + ρ(x, K+1, v)
        if increment < 0
            break
        else
            K += 2
            invfactor += 2*increment
        end
    end
    1/invfactor, K
end

"""
Simulate `N` draws from an AR(1) process with AR coefficient `ϕ`. `σ`
is the variance (has no effect on autocorrelations).
"""
function simulate_ar1(ϕ, N; σ=1.0)
    x = Vector{Float64}(N)
    z = σ*randn()/√(1-ϕ^2)
    for i in 1:N
        z = ϕ*z + randn()*σ
        x[i] = z
    end
    x
end

"Theoretical ESS factor for an AR(1) process."
ar1_ess_factor(ϕ) = 1/(1+2*ϕ/(1-ϕ))

"""
Return `M` draws of ESS factors and last lags, for simulated AR(1)
processes with the given parameters.
"""
function simulate_ar1_ess_factors(M, ϕ, N; σ=1.0)
    sim = [ess_factor(simulate_ar1(ϕ, N; σ=σ)) for _ in 1:M]
    first.(sim), last.(sim)
end

# runtime code
using Plots
using LaTeXStrings
pgfplots()

function allplots(M, ϕ, N; size = (900,300))
    τs, ks = simulate_ar1_ess_factors(M, ϕ, N)
    function plot_hist(x, xlab)
        plot(histogram(x), xlab=xlab, ylab="frequency", legend = false,
             title = "CV: $(round(Int,std(x)/mean(x)*100))\\%")
    end
    p1 = plot_hist(τs, L"\tau")
    vline!(p1, [ar1_ess_factor(ϕ)])
    p2 = plot_hist(ks, "last lag")
    ks_jitter = ks + rand(length(ks))-0.5
    p3 = scatter(ks_jitter, τs, xlab="last lag", ylab=L"\tau", legend = false,
                 markersize=3, markeralpha = 0.5)
    plot(p1, p2, p3; layout=grid(1,3), size = size)
end

cd(expanduser("~/doc/tpapp.github.io/content/post/ess-sampling/"))
savefig(allplots(1000, 0.0, 1000), "ess-phi0N1000.svg")
savefig(allplots(1000, 0.0, 10000), "ess-phi0N10000.svg")
savefig(allplots(1000, 0.5, 1000), "ess-phi05N1000.svg")
savefig(allplots(1000, 0.5, 10000), "ess-phi05N10000.svg")
savefig(allplots(1000, 0.8, 1000), "ess-phi08N1000.svg")
savefig(allplots(1000, 0.8, 10000), "ess-phi08N10000.svg")



