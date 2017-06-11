+++
title = "Disabling Privacy Badger"
draft = false
date = "2017-05-02T16:35:37+02:00"
tags = ["firefox", "browser plugins"]
categories = [""]
slug = ""
+++

Firefox has been my primary browser for the last decade. I find it very fast and convenient, and use quite a few addons, including [Google Scholar Button](https://addons.mozilla.org/en-gb/firefox/addon/google-scholar-button/), [NoScript](https://addons.mozilla.org/en-gb/firefox/addon/noscript/?src=search),  and [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/).

I can't recall exactly when, but about half a year ago various sites started to break. I have not bothered to debug what's happening, suspecting it was was a combination of various plugins, but continued to use Firefox and installed [openwith](https://github.com/darktrojan/openwith) to open broken pages in Chromium (yes, I know, the ultimate kludge). More sites became broken, and I found that now I am spending 99% of my time in Chromium, which I don't like that much, but moreover, it is a resource hog: while using the plugins above I can get the CPU load of Firefox to around 1--2% when I am not using it, Chromium drains my laptop battery in effectively half the time. To make things worse, Chromium apparently can't open links in the background like Firefox, and insists on raising the window every time I open a link from another process, which is distracting.

Finally, [Julia's Discourse forum](https://discourse.julialang.org/) started showing up empty, which was the last straw and I went through my plugins. It turns out hat [Privacy Badger](https://www.eff.org/privacybadger) was responsible for everything: apparently it relies on heavy-handed heuristics and breaks a lot of webpages. One can report this, but instead of reporting around 10--20 pages which were broken, I simply removed the plugin. I have a lot of respect for what the Electronic Frontier Foundation does, but I am not sure that this plugin is very useful.

So finally I got back the web the way I like it. Moral of the story: temporary workarounds become permanent, and bite back.
