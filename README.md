Source files for [tpapp.github.io](https://tpapp.github.io).

Mainly written so that I could weave Julia code, output, and figures
into blog posts using Hugo.  Feel free to use for your own setup.

## Prerequisites

1. [Hugo](https://gohugo.io/). Try to get at least `0.19`.
2. A working [Julia]() installation, at least `v0.5`.
3. Recent [Weave.jl](https://github.com/mpastell/Weave.jl/).

## How to use

For posts which do not need to be woven, use Hugo according to the manual.

For posts which you want to weave, use `new-jmd` to create, they will end up in `julia-src/`. Then call `jweave` with the filename for weaving.
