+++
date = 2017-09-29T19:55:44+02:00
draft = false
title = "Blog redesign 2.0"
slug = ""
categories = [""]
tags = ["emacs", "Hugo"]
+++

I have redesigned my blog (again), mainly tweaking the CSS and
hopefully achieving better support on small screens (which are still
not ideal for math, but now you should get a red warning float at the
bottom).

I also re-did the feed code so that it would render better on
[juliabloggers.com](https://www.juliabloggers.com/). Now the whole
content of each post should be scraped seamlessly, and appear
correctly. However, the only way to test the whole toolchain is to do
it live, and I apologize if something is still not perfect and you get
bogus updates (BTW, this post should not show up in the Julia feed).

Highlights of the changes:

1. responsive design,

2. nicer fonts,

3. line breaks in MathJax when necessary and supported,

4. better highlighting (Julia now looks especially nice),

5. embedded code blocks with a download link,

6. better image placement,

7. Emacs screenshots now use a branch of [emacs-htmlize](https://github.com/tpapp/emacs-htmlize/tree/pre-colors), which hopefully gets merged soon.

As always, the source code for the whole site is [available](https://github.com/tpapp/tpapp.github.io-source).

