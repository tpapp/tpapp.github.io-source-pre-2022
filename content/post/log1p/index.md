+++
date = 2017-09-13T11:18:59+02:00
draft = false
title = "log1p in Julia"
slug = ""
categories = [""]
tags = ["julia", "log1p", "numerical error"]
+++

*edit*: fixed bogus interaction of MathJax and code highlighting.

*edit2*: added benchmarks.

This is a follow-up on a [question](https://discourse.julialang.org/t/log1p-in-base-vs-base-math-julialibm/5852) I asked on the Julia forums about calculating
\[
\text{log1p}(x) = \log(1+x)
\]
This calculation is tricky because if $x \approx 0$,
\[
\log(1+x) \approx x
\]
while as $x \to \infty$, $\log(1+x)$ approaches $\log(x)$, so simply using `log(1+x)` will not be as accurate as it could be. Numerical analysts have developed specialized methods for these calculations that try to get an accurate answer, and all programming languages serious about numerical calculations have an implementation either in the core language or a library.

Julia's `Base.log1p` currently suggests that `Base.Math.JuliaLibm.log1p` would be preferable, but then I was wondering why isn't that the default? So I decided to perform a trivial numerical experiment, calculating the error for both, and also benchmark the two methods.

## Accuracy

The key question is what to compare the results with. One could compare to an existing "gold standard" implementation, or simply calculate the results using a higher precision representation. Fortunately, Julia has `BigFloat`s available right out of the box.

The graph below shows the base-2 logarithm of the *relative* error for `Base.log1p` vs $\log\_2(1+x)$; horizontal lines are `log2(eps())` and ``log2(eps())+1``. This suggests that `Base.log1p` is *very accurate*, but not as good as it could be when $x \approx 0$.

![Base.log1p error](Base_log1p_error.svg)

The next plot shows the relative accuracy of the relative error above, comparing `Base.Math.JuliaLibm.log1p` to `Base.log1p` (lower values better). In these simulations, `Base.Math.JuliaLibm.log1p` is never worse, but sometimes significantly better (resulting in an extra binary digit of accuracy). This matters especially when $x \approx 0$.

![relative log2 acccuracy improvement over Base.log1p](JuliaLibm_improvement.svg)

The next plot confirms this.

![JuliaLibm log1p error](JuliaLibm_log1p_error.svg)

## Speed

I also evaluated relative speed. The graph below shows the relative runtimes, obtained using `BenchmarkTools.@belapsed`. Values below $1$ mean that `Base.Math.JuliaLibm.log1p` is faster: indeed, this seems to be the case except for values very close to $0$, where there is a 10--20% performance penalty. At other values, `Base.Math.JuliaLibm.log1p` is 30--40% *faster*.

![relative time](relative_time.svg)

## Conclusion

1. For values near $0$, `Base.Math.JuliaLibm.log1p` is more accurate, at a slight performance cost.

2. For values away from $0$, it is at least as accurate as `Base.log1p`, and 30--40% faster.

To me, this suggests that `Base.Math.JuliaLibm.log1p` should be the default method --- mostly because the extra accuracy is more important to me than the slight performance cost.

Code is available below.

{{< inclsrc "julia" "code.jl" >}}
