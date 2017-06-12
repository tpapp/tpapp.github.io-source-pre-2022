+++
date = "2017-06-12T14:12:43+02:00"
title = "Blog redesign"
+++

I am in the process of rebuilding my personal website using [Hugo](http://gohugo.io/). I tried various themes, including [hugo-academic](https://github.com/gcushen/hugo-academic), but in the process of adapting them to my needs I realized that it is less work to write one from scratch.

The result is now 80% ready (blog works, automatic listing of research papers will take some more work), and the [source is on Github](https://github.com/tpapp/tpapp.github.io-source). It is available under the CC-BY-SA license, feel free to adapt parts from it, not that there is anything special in there.

Hugo is really an excellent framework, it is clean, logical, and allows a lot of code reuse. I ~~wasted~~ spent most of the time on fiddling with CSS, and I am still not 100% satisfied with the result, but at some point I decided to stop. [SCSS](http://sass-lang.com/) was extremely useful for writing organized CSS.

I am especially satisfied with moving the code highlighting to the generator side. The only non-static parts are now [Disqus](https://disqus.com/) and [MathJax](http://www.mathjax.org/).
