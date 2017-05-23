+++
draft = false
date = "2017-05-23T16:39:26+02:00"
tags = ["MCMC", "Jacobian", "Stan"]
categories = [""]
slug = ""
title = "Two tricks for change of variables in MCMC"
+++

Change of variables are sometimes advantageous, and occasionally inevitable for MCMC if you want efficient sampling, or to model a distribution that was obtained by a transformation. A classic example is the *lognormal distribution*: when

$$\log(y) \sim N(\mu, \sigma^2)$$

one has to adjust the log posterior by $-\log y$ since

$$\frac{\partial \log(y)}{\partial y} = \frac{1}{y}$$

and

$$\log(1/y) = -\log(y).$$

In [Stan](http://mc-stan.org/), one would accomplish this as

```stan
target += -log(y)
```

In general, when you transform using a multivariate function $f$, you would adjust by

$$\log\det J\_f(y)$$

which is the log of the determinant of the Jacobian --- some texts simply refer to this as "the Jacobian".

The above is well-known, but the following two tricks are worth mentioning.

## Chaining transformations

Suppose that you are changing a variable by using a chain of two functions $f \circ g$. Then
\begin{multline}
\log\det J\_{f \circ g}(y) = \log \bigl(\det J\_f(g(y)) \cdot \det J\_g(y)\bigr) \newline
= \log\det J\_f(g(y)) + \log\det J\_g(y)
\end{multline}
which means that you can simply add (the log determinant of) the Jacobians, of course evaluated at the appropriate points.

This is very useful when $f \circ g$ is complicated and $J\_{f\circ g}$ is tedious to derive, or if you want to use multiple $f$s or $g$s and economize on the algebra.
 From the above, it is also easy to see that this generalizes to arbitrarily long chains of functions $f\_1 \circ f\_2 \circ \dots$.

This trick turned out to be very useful when I was fitting a model where a transformation was general to both equilibrium concepts I was using (a noncooperative game and a social planner), so I could save on code. Of course, since [#2224](https://github.com/stan-dev/stan/issues/2224) is WIP, I had to copy-paste the code, but still saved quite a bit of work.

## Transforming a subset of variables

Suppose $x \in \mathbb{R}^m$ and $y \in \mathbb{R}^n$ are vectors, and you are interested in transforming to
$$
z = f(x,y)
$$
where $x$ and $z$ have the same dimension. It is useful to think about this transformation as
$$g(x,y) = [f(x,y), y]^\top$$
where $g : \mathbb{R}^{m+n} \to \mathbb{R}^{m+n}$. Since $y$ is mapped to itself,
$$
J_g = \begin{bmatrix}
J\_{f,x} & J\_{f,y} \newline
0 & I
\end{bmatrix}
$$
has a block structure, where
$$
J\_{f,x} = \frac{\partial f(x,y)}{\partial x}
$$
and similarly for $J\_{f,y}$. For the calculation of the determinant, you can safely ignore the latter, and $\log \det I = 0$, so
$$
\log\det J\_g = \log\det J\_{f,x}
$$
