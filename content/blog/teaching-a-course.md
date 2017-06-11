+++
categories = [""]
date = "2017-03-24T14:34:22+01:00"
draft = false
slug = ""
tags = ["julia", "teaching"]
title = "Teaching a course using Julia"
+++

I just finished teaching a graduate course on practical aspects of dynamic optimization to our economics students. This year, for the first time, I taught the course using Julia, and this is a writeup of the experience. This was an intensive, 10-week course, with two classes per week, taught in the computer lab. A course on the theory of dynamic optimization was a prerequisite, this one was all about the actual numerical methods. The students had prior exposure to R and Matlab, and some of them have been using Julia for a while. In some classes, I talked about theory, sometimes I wrote code, ran it, and made improved versions, sometimes we treated the class as a practice session.

I wanted to focus on the actual methods, so I decided to use a subset of the language, "Julia light", using the following concepts:

1. scalars, algebra, arrays, indexing
2. functions (with very basic dispatch, on an argument that contained problem parameters)
3. control flow: `for` and `if`
4. comprehension, concatenation
5. structures (only `immutable`)
6. docstrings

The purpose of the course was to show that one can easily implement seemingly abstract methods encountered in textbooks, dissect them, look at the caveats, and possibly adapt them to particular problems. Writing what I think of as production code would have involved teaching many new concepts to a class coming with very heterogeneous experience in programming, so I decided to steer clear of the following topics:

1. modules
2. macros
3. the type system
4. writing efficient code (even though we ended up doing a bit on that, and benchmarking, could not resist)

We used [NLsolve](https://github.com/EconForge/NLsolve.jl), [Optim](https://github.com/JuliaNLSolvers/Optim.jl), and [Plots](https://github.com/JuliaPlots/Plots.jl) extensively, and [ForwardDiff](https://github.com/JuliaDiff/ForwardDiff.jl) under the hood. [Parameters](https://github.com/mauro3/Parameters.jl) was very useful for clean code.

## Perspective of the instructor

Even when I wrote something in a suboptimal manner, it turned out to be fast enough. Julia is great in that respect. However, compilation time dominated almost everything that we did, especially for plots.

I was using Jupyter notebooks, inspired by [18.S096](https://math.mit.edu/classes/18.S096/iap17/). While I am much, much slower writing code in Jupyter compared to Emacs, I think that this turned out to be a benefit: jumping around between windows is very difficult to follow. [Interact](https://github.com/JuliaGizmos/Interact.jl) was just great.

I made a small package for code we wrote in class, and distributed new code via `Pkg.update()`. This worked well most of the time.

We were using `v0.5.0` and later transitioned to `v0.5.1`, which was seamless.

Since I was not using modules, sometimes the best way to extricate myself from a state was restarting the kernel. This became a running joke among the students ("when in doubt, restart the kernel"). This actually worked very well for the infamous [#265](https://github.com/julialang/julia/issues/265).

Jupyter is great for interactive notes in class. I mixed a great deal of marked up text and LaTeX equations into the workbooks. Problem sets were handed in using Jupyter notebooks, and the exam (solving a dynamic programming problem) was also written in and graded as a notebook.

Unicode specials are addictive. Once you learn about `α`, you never name a variable `alpha` again.

## Perspective of the students

I talked to the class at the end of the course about their experience with Julia, and some of them individually. The biggest issue for them was lack of easily searchable answers to common questions: for R and Matlab, a "how do you ..." query turns up 100+ answers because many people have encountered the problem before. This was not the case for Julia. Lack of examples was an especially difficult issue for plots.

Debugging in Jupyter was difficult, since it mostly amounted to debugging by bisection, isolation, and occasionally printing. Students found some of the error messages cryptic (especially when it was about not having a matching method, since we did not really go into the type system).

The most puzzling transient bugs were because of [#265](https://github.com/julialang/julia/issues/265) ("but I recompiled that function!"). This was solved by restarting the kernel, so the latter became somewhat of a panacea. Since compilation time dominated everything, this slowed things down considerably.

## Takeaway

Would definitely do it again. Even with the issues, Julia was the most comfortable language to teach in.
