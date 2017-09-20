+++
categories = [""]
date = "2017-07-03T10:49:56+02:00"
draft = false
slug = ""
tags = ["emacs", "emacs25", "Ubuntu"]
title = "Emacs 25.2 on Ubuntu"
+++

Emacs is undoubtedly the most important program on my computers. On my
laptop, I use it to keep track of stuff with [org-mode](http://orgmode.org/), read mail with [mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html), edit LaTeX with [AUCTeX](https://www.gnu.org/software/auctex/), and of course program. On servers, the first alias I define is usually `qe='emacs -Q -nw'`, which give me a fast and responsive editor. With [helm](https://github.com/emacs-helm/helm), doing just about anything (eg locating files, `rgrep`ing for something) is orders of magnitude faster and more convenient than any alternative I have tried.

I also try to keep up with the latest versions for software in general. Usually, whatever Ubuntu stable/Debian testing has is good enough not to justify the extra effort, but when I really need it, I grab the source and compile. That is usually only a minor hassle, but I try to restrict it to a few critical programs, otherwise it adds up. The major issue is not compiling, but having cruft in the filesystem (despite [stow](https://www.gnu.org/software/stow/manual/stow.html) and [checkinstall](https://wiki.debian.org/CheckInstall), it piles up). So I try to avoid it if I can.

Emacs 25.2 was released in April 2017, but there is no sign of an Ubuntu package for it yet. On various forums the [PPA of kelleyk](https://launchpad.net/~kelleyk/+archive/ubuntu/emacs) is recommended, but that does not have 25.2 for 17.04 (some files clash if you install previous versions).

Fortunately, Robert Bruce Park has now added Emacs 25.2 to the [Ubuntu Emacs Lisp PPA](https://launchpad.net/~ubuntu-elisp/+archive/ubuntu/ppa), so having the latest of your favorite editor is only an `add-apt-repository` away. You may want to add a file to `/etc/apt/preferences.d` with contents

```
Package: *
Pin: release o=LP-PPA-ubuntu-elisp
Pin-Priority: 600
```

to make sure the right packages are installed.
