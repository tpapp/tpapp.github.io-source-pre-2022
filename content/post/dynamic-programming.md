+++
title = "Continuous-time deterministic dynamic programming in Julia"
draft = false
date = "2017-04-02T19:06:04+02:00"
tags = ["julia", "economics", "tutorial", "numerical methods", "my packages"]
categories = [""]
slug = ""
+++

For the past few weeks I have been organizing pieces of code I have used to solve economic models into Julia packages. [EconFunctions.jl](https://github.com/tpapp/EconFunctions.jl) is a collection of trivial functions that I noticed that I kept recoding/copy-pasting everywhere, occasionally making errors. [ContinuousTransformations.jl](https://github.com/tpapp/ContinuousTransformations.jl) is a library for manipulating various commonly used homeomorphisms (univariate at the moment), which are useful in functional equations or Markov Chain Monte Carlo. Finally [ParametricFunctions.jl](https://github.com/tpapp/ParametricFunctions.jl) is for working with parametric function families.

In this post I use these three to solve a simple, deterministic dynamic programming model in continuous time, known as the Ramsey growth model. If you are not an economist, it is very unlikely that it will make a lot of sense. If you are a student, I added basic references at the end, which are consistent with the methods in this post.

**Caveat**: *these libraries are in development, I am refining the API and changing things all the time. It is very likely that as time progresses, code in this post will not run without changes.* In other words, treat this as a sneak peak into a library which is in development.

## Theory

This is standard material, I am just repeating it so that this post is self-contained. We solve

$$\max \int_0^\infty e^{-\rho t} u(c_t) dt$$
subject to
$$\dot{k}_t = F(k_t) - c_t, k_t \ge 0 \forall t.$$

where $u( c )$ is a CRRA utility function with IES $\theta$, $F(k) = A k^\alpha - \delta k$ is a production function that accounts for depreciation. Our problem is described by the Hamilton-Jacobi-Bellman equation

$$\rho V(k) = \max_c u( c ) + (F(k)-c) V'(k)$$

Notice that once we have $V$, the first-order condition

$$u'(c(k)) = V'(k)$$

yields the policy function $c(k)$, which we are interested in. Combining the envelope condition

$$\rho V'(k) = F'(k) V'(k) + (F(k)-c) V{'}{'}(k)$$

and using the functional form for CRRA utility, we obtain

$$\frac{c'(k)}{c(k)} (F(k)-c(k)) = \frac{1}{\theta} (F'(k)-\rho)$$

which is a recursive form of the so-called Euler equation.

Also, note that we can characterize the steady state capital and consumption by

$$k_s = \left(\frac{\delta+\rho}{A\alpha}\right)^{1/(\alpha-1)}$$

and 

$$c_s = F(k_s)$$

## Julia code: solving the Euler equation

Load the libraries (you need to clone some code, as the packages are not registered).
````julia
using ParametricFunctions       # unregistered, clone from repo
using ContinuousTransformations # unregistered, clone from repo
using EconFunctions             # unregistered, clone from repo
using Plots; gr()
using Parameters
using NLsolve
````





It is useful to put model parameters in a single structure.
````julia
"""
Very simple (normalized) Ramsey model with isoelastic production
function and utility.
"""
@with_kw immutable RamseyModel{T}
    θ::T                        # IES
    α::T                        # capital share
    A::T                        # TFP
    ρ::T                        # discount rate
    δ::T                        # depreciation
end
````





This is the key part: we code the residual for the Euler equation. The function should take the model (which contains the parameters), a function $c$ that has been constructed using a function family and a set of parameters, and a scalar $k$, at which we evaluate the residual above. Everything else can be automated very well.
````julia
"""
Residual of the Euler equation.
"""
function euler_residual(model::RamseyModel, c, k)
    @unpack θ, ρ, α, A, δ = model
    Fk = A*k^α - δ*k
    F′k = A*α*k^(α-1) - δ
    ck, c′k = c(ValuePartial(k))
    (c′k/ck)*(Fk-ck) - 1/θ*(F′k-ρ)
end
````




Above, `c` can be treated like an ordinary function, except that if you call it with `ValuePartial(x)`, you get the value *and* the derivative.

The steady state will be handy:
````julia
"Return the steady state capital and consumption for the model."
function steady_state(model::RamseyModel)
    @unpack α, A, ρ, δ = model
    k = ((δ+ρ)/(A*α))^(1/(α-1))
    c = A*k^α - δ*k
    k, c
end
````




Let's make a model object (parameters are pretty standard), and calculate the steady state:
````julia
model = RamseyModel(θ = 2.0, α = 0.3, A = 1.0, ρ = 0.02, δ = 0.05)

kₛ, cₛ = steady_state(model)
````




We will solve in a domain around the steady state capital.
````julia
kdom = (0.5*kₛ)..(2*kₛ)
````




Given the pieces above, obtaining the solution can be done very conscisely: create a residual object, which is basically a mapping from parameters to the function family to the residuals:
````julia
res = CollocationResidual(model, DomainTrans(kdom, Chebyshev(10)),
                          euler_residual)
````




The above say that we want 10 Chebyshev polynomials, transformed to the domain `kdom`, to be used for constructing the $c(k)$.

We call the solver, providing an initial guess, $c(k) = k\cdot c_s/k_s$, for the policy function $c(k)$. The guess is that consumption is linear in capital, and the line goes through the steady state values. Other reasonable guesses are possible, but note that it is worthwhile thinking a bit about a good one, so that you get fast convergence.

The function below fits a parametric function from the given family to the initial guess, then solves for the residual being $0$ using `NLsolve` with automatic differentiation under the hood.
````julia
c_sol, o = solve_collocation(res, k->cₛ*k/kₛ; ftol=1e-10,
                             method = :newton)
````




Convergence statistics:
````
Results of Nonlinear Solver Algorithm
 * Algorithm: Newton with line-search
 * Starting Point: [1.83249,1.09949,7.10543e-16,4.44089e-16,-1.77636e-16,-8
.88178e-17,-8.43769e-16,1.64313e-15,1.33227e-16,3.10862e-16]
 * Zero: [1.57794,0.433992,-0.0360164,0.00624848,-0.00134301,0.000320829,-8
.21347e-5,2.28742e-5,-6.85183e-6,1.48105e-6]
 * Inf-norm of residuals: 0.000000
 * Iterations: 6
 * Convergence: true
   * |x - x'| < 0.0e+00: false
   * |f(x)| < 1.0e-10: true
 * Function Calls (f): 7
 * Jacobian Calls (df/dx): 6
````




Overall, pretty good, very few iterations. We plot the resulting function:
````julia
plot(c_sol, xlab = "k", ylab = "c(k)", legend = false)
scatter!([kₛ], [cₛ])
````


{{< figure src="../figures/dynamic-programming_10_1.svg"  >}}

Notive how the collocation nodes are added automatically (this is done with a plot recipe). It should, of course, go thought the steady state.

It is very important to plot the residual:
````julia
plot(k->euler_residual(model, c_sol, k), linspace(kdom, 100),
     legend = false, xlab="k", ylab="Euler residual")
scatter!(zero, points(c_sol))
````


{{< figure src="../figures/dynamic-programming_11_1.svg"  >}}

Note the near-equioscillation property, which you get from using Chebyshev polynomials. You get $10^{-6}$ accuracy, which is neat (but note that this is a simple textbook problem, very smooth and tractable).

## Selected reading

Acemoglu, Daron. Introduction to modern economic growth. Princeton University Press, 2008. *Chapter 8.*

Miranda, Mario J., and Paul L. Fackler. Applied computational economics and finance. MIT press, 2004. *Chapters 10 and 11*.