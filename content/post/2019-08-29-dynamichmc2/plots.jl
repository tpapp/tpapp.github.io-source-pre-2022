using LogDensityTestSuite, Contour, PGFPlotsX, DynamicHMC, LinearAlgebra, Random
using LogDensityProblems: logdensity


"""
2D plot of the logdensity `ℓ` over the given ranges.

`zΔ` determines level stepsize (for consistency between plots).
"""
function contour2d(ℓ, xrange, yrange, zΔ; xn = 100, yn = 100)
    x = range(xrange...; length = xn)
    y = range(yrange...; length = yn)
    z = ((x, y) -> logdensity(ℓ, [x, y])).(x, y')
    levels = range(reverse(extrema(z))...; step = -zΔ)
    @pgf Plot({ no_marks }, Table(contours(x, y, z, levels )))
end

function visualize_2d_trajectory(traj; scale = 1)
    x = map(t -> t.z.Q.q[1], traj)
    y = map(t -> t.z.Q.q[2], traj)
    u = map(t -> t.z.p[1], traj) .* scale
    v = map(t -> t.z.p[2], traj) .* scale
    @pgf Axis(Plot({ red, mark = "o" }, Table(x, y)),
              Plot({ blue, quiver = { u = raw"\thisrow{u}", v = raw"\thisrow{v}" }, "-stealth" },
                   Table(; x = x, y = y, u = u, v = v)))
end

𝑁 = StandardMultivariateNormal(2)
ℓ = mix(0.2, elongate(0.2, shift(ones(2), 𝑁)),
        shift([-1, -1], linear(Diagonal([0.4, 0.5]), 𝑁)))

results = mcmc_with_warmup(Random.GLOBAL_RNG, ℓ, 1000; reporter = NoProgressReport());
results.tree_statistics[1]
summarize_tree_statistics(results.tree_statistics)

p1 = contour2d(ℓ, (-3, 4), (-3, 4), 1)


using DynamicHMC.Diagnostics

traj = leapfrog_trajectory(ℓ, [0, -2], 0.2, -6:10;
                           κ = GaussianKineticEnergy(2),
                           p = [2, 2])

a2 = visualize_2d_trajectory(traj; scale = 0.2)
push!(a2, p1)
pgfsave("trajectory.svg", a2)

a3 = @pgf Axis({ xlabel = "relative position", ylabel = "relative energy",
                 scaled_y_ticks = false, yticklabel_style = { "/pgf/number format/fixed" }},
               Plot(Table(map(t -> t.position, traj), map(t -> t.Δ, traj))), HLine(0))
pgfsave("relative_energy.svg", a3)

log2ϵs = -2:0.2:0
logAs = explore_log_acceptance_ratios(ℓ, [0, -2], log2ϵs)

a4 = @pgf Axis({ xlabel = raw"$\log_2(\epsilon)$", ylabel = "log accept ratio (uncapped)" },
               [Plot({ no_marks, opacity = 0.4 }, Table(log2ϵs, logAs))
                for logAs in eachcol(logAs)]...)
pgfsave("log_accept.svg", a4)
