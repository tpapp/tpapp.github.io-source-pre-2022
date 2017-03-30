+++
date = "2017-03-03T13:11:53+01:00"
draft = false
title = "Julia + Weave.jl + hugo test"
tags = ["julia", "weave", "hugo"]
+++

Testing the [Hugo](https://gohugo.io/) formatter for [Weave.jl](https://github.com/mpastell/Weave.jl).




Testing inline code: `1+1=2`.

Testing math:
$$x^2+y^2 = \int_0^1 f(z) dz$$

Testing code:
````julia
1+1
````


````
2
````





Testing proper highlighting:
````julia
function foo(x, y)
    x+y
end
````





A plot:
````julia
x = 1:10
y = x.^2
scatter(x, y, legend = false)
````


{{< figure src="../figures/hugo-julia-weave_4_1.svg" title="Caption for this plot"  > }}