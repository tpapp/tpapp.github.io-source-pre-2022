+++
categories = [""]
date = "2017-05-24T12:59:53+02:00"
draft = false
slug = ""
tags = ["LaTeX", "math", "MCMC"]
title = "Getting a nice += in LaTeX math"
+++

I am working on an appendix for a paper that uses MCMC, and I decided to document some [change of varible calculations]( 
{{< ref "blog/jacobian-chain.md" >}}) in the interest of reproducibility (they are quite complex, because of multivariate determinants). But how can I typeset them nicely in $\LaTeX$? 

```latex
\mathtt{target} += J_f
```
gives
$$
\mathtt{target} += J_f
$$
which is to be expected, as `+` is a binary operator and `=` is a relation, so $\LaTeX$ is not expecting them to show up this way.

We can remedy this as
```latex
\mathtt{target} \mathrel{+}= J_f
```
which shows up as
$$
\mathtt{target} \mathrel{+}= J_f
$$
which is an improvement, but is still not visually appealing.

Making the `+` a bit smaller with
```latex
\mathrel{\raisebox{0.19ex}{$\scriptstyle+$}}=}
```
yields
$$
\mathtt{target} \mathrel{\raise{0.19ex}{\scriptstyle+}} = J_f
$$
which looks OK enough to preclude further tweaking. Note that [MathJax](http://www.mathjax.org/) does not support `\raisebox`, but you can use
```latex
\mathrel{\raise{0.19ex}{\scriptstyle+}} = J_f
```
which renders the as above.
