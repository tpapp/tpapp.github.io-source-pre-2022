+++
date = 2019-12-21T16:33:38+01:00
draft = false
title = "Julia and batteries"
slug = ""
categories = [""]
tags = ["julia", "packages", "unit-testing"]
+++

New Julia users frequently suggest that some features should be included in `Base` (the part that is available directly without `using` any packages) or the standard libraries. The colloquial phrase is that *“Julia should come with batteries included”*, hence the title of this post.

In this blog post, I explain why doing this is unlikely to improve anything, likely to make some things *worse*, and thus often meets with resistance from developers. Most of these points are well-known, and repeated in various discussions. I thought it would be nice to have them in one place.

# About the standard libraries

Before the 0.7/1.0 release of Julia, a lot of functionality now in the standard libraries was part of `Base`. As the codebase grew, this was causing practical problems, so modularizing the code was on the agenda from [the very beginning](https://github.com/JuliaLang/julia/issues/5155), with the understanding that this would make things load faster, encapsulate implementation details better, and the code would be easier to maintain. The [excision](https://github.com/JuliaLang/julia/issues?utf8=%E2%9C%93&q=label%3Aexcision+) was completed for 0.7, and “standard libraries” as we know them now were born.

One very neat thing about Julia is that conceptually, *standard libraries are like any other package*. There is no “secret sauce” that makes them special: some things like precompilation are enabled by default, but you can do the same for any package.

What *is* different about standard libraries is an [implicit guarantee](https://github.com/JuliaLang/julia/issues/27197) for code quality and support: they are officially endorsed, and the Julia maintainers fix issues relating to these packages.

When users suggest that other packages they find useful are included in the standard libraries, they usually expect that the same kind of code quality and support guarantees would extend *automatically* to these packages.

Unfortunately, since developer time is a scarce resource, this would only mean that *the same number of people would now have to maintain more code*. This would most likely result in longer delays for releases, and is not necessarily a guarantee of better support: some standard libraries have (minor) issues that have been outstanding for a long time.

# The benefits of (third party) packages

Below, I list some major advantages of having code in third party packages (what we normally think of as “packages”, usually registered) that are maintained outside the Julia repository.

## Separate versioning, more frequent releases

Standard libraries, not being versioned separately, maintain the same [SemVer](https://semver.org/) compatibility guarantees as the rest of Julia. This means that no incompatible changes are allowed without changing the major version --- in other words, anything that ends up there would have to be supported *without breaking changes* for the rest of the 1.x life cycle.

Since nontrivial interfaces usually require a few iterations to become polished, this would mean that the authors would need to get it right without a lot of community testing, or keep legacy methods around for the rest of 1.x.

Third party packages have their own version. This means that they can release as often they like, experiment with new ways of doing things and deprecate old APIs, and add and reorganize features without the implicit cost of having to support them for a long time. Because of this, it is not uncommon for actively maintained packages to have minor releases with new features every month or so, and bugfix releases within a day.

## Easier contribution

Contributing to standard libraries is usually a more involved process than making a PR to third party packages. Unit tests take longer to run (since the whole of Julia is tested), ramifications of changes have to be considered in wider context, and contributors have to be much more cautious with experimentation since anything that ends up there would need to be supported for a long time.

The changes will need to be reviewed by people who may be very busy working on some other part of Julia, and may take a longer time; decisions frequently need a wider consensus and some PRs just languish unresolved for months. This naturally raises the barrier to entry, and can be quite frustrating to contributors.

In contrast, many packages have a single or a few authors, who have a clear vision of where they want to take their package, and are usually able to make decisions quicker.

## Separate documentation and issue tracker

The Julia repository has a total of 17k issues (!), 14k of them closed, a similar number of open pull requests, and a manual that has 400 pages on the standard libraries (in PDF format). It is occasionally challenging to find an earlier issue, discussion, or documentation for something.

For third party packages, having a separate issue tracker and documentation makes it much easier to find what you are looking for.

# Development happens in packages

If you would like Julia to support something that is experimental or not fully specified (and most software isn't), it is unlikely that adding it to `Base` or the standard libraries is the right solution.

Instead, it is usually recommended that you put it in a package and work out the details, improving the code based on experience and feedback. There is no downside to this in most cases, just the benefits mentioned above.

If the experiment pans out, great: you have created a nice package! If it doesn't, it can be retired and archived, without having to commit to continued support.
