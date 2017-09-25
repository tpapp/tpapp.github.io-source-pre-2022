Source files for [tpapp.github.io](https://tpapp.github.io).

Mainly written so that I could weave Julia code, output, and figures
into blog posts using Hugo.  Feel free to use for your own setup.

## Prerequisites

1. [Hugo](https://gohugo.io/), at least version `0.28`.
2. A working [Julia](https://julialang.org/) installation, at least `v0.6`.

## How to use

See the site source and the Hugo manual for examples. The only shortcode I added is `inclsrc`, use it as

```hugo
{{< inclsrc "julia" "code.jl" >}}
```
