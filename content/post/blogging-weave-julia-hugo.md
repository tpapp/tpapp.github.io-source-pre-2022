+++
categories = [""]
slug = ""
title = "Blogging with Hugo, Julia, Weave.jl"
draft = false
date = "2017-03-30T10:02:32+02:00"
tags = ["julia", "blogging", "Weave", "Hugo"]
+++

I have made a PR to [Weave.jl](https://github.com/mpastell/Weave.jl) which Matti Pastell kindly merged recently. This allows a relatively smooth workflow for blogging using the static website generator [Hugo](https://gohugo.io/), and generating some pages with plots and evaluated Julia results. I made the source for my blog [available](https://github.com/tpapp/tpapp.github.io-source) so that others can use it for their own blogging about Julia. An example is [this post]({{< relref "hugo-julia-weave.md" >}}).

The gist of the workflow is as follows:

1. for posts which do not need `Weave`, just use `Hugo`. Make sure you read their [excellent tutorial](https://gohugo.io/overview/introduction/). **This very fast**.

2. for posts which contain Julia code and generated plots, use a script to generate a skeleton file in a separate directory, and work on that. Call another script to generate the `.md` file using `Weave.jl`. **This is the slow part**, so it is not automated.

The [README](https://github.com/tpapp/tpapp.github.io-source) gives more details. Feel free to ask questions here. If you have a better workflow, I would like to hear about it.


