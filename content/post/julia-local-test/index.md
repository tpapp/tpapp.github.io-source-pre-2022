+++
date = 2017-08-23T10:10:48+02:00
draft = false
title = "Local packages in a separate directory in Julia"
slug = ""
categories = ["software"]
tags = ["julia", "packages"]
+++

I run `Pkg.update()` fairly often to stay up to date and benefit from
the latest improvements of various packages. I rarely ever `pin` to a
specific package version, but I occasionally checkout `master` for
some packages, especially if I am contributing.

Despite updating regularly, I found that the documentation subtly diverged from what I was experiencing for some packages. After looking into the issue, I learned that I was 2--3 minor versions behind despite updating regularly. For example, when I would
```julia
Pkg.update("ForwardDiff")
```
I would be told that there is a new version, and to get it I should update `ReverseDiff` and `Optim`. But
```julia
Pkg.update("ForwardDiff", "ReverseDiff", "Optim")
```
would just run quietly without updating.

I could not figure out the cause for this and did not want to get sidetracked debugging it, so I decided to wipe the package directory and start over. However, in order to do this, I had to make sure that no code is lost, especially for local packages. First, I moved my local packages into a separate directory, and added that to `LOAD_PATH` in `.juliarc.jl`:

```julia
push!(LOAD_PATH, expanduser("~/src/julia-local-packages/"))
```

Then I ran [multi-git-status](https://github.com/fboender/multi-git-status) to make sure that there were no unpushed changes. Finally, I deleted the package directory and reinstalled everything. Surprisingly, `Pkg.add` ran much faster than before.

In case I have to do this again, I decided to keep my local packages separate --- the only drawback is that `Pkg.test` now can't find them. A workaround is below, using some code from `Base.Pkg`:

```julia
"""
    local_test(pkgname, [coverage])

Find and test a package in `LOAD_PATH`. Useful when the package is outside
`Pkg.dir()`.

Assumes the usual directory structure: package has the same name as the module,
the main file is in `src/Pkgname.jl`, while tests are in `test/runtests.jl`.
"""
function local_test(pkgname; coverage::Bool=false)
    module_path = Base.find_in_path(pkgname, nothing)
    src_dir, module_file = splitdir(module_path)
    dir = normpath(src_dir, "..")
    test_path = joinpath(dir, "test", "runtests.jl")
    @assert isfile(test_path) "Could not find $(test_path)"
    Base.cd(dir) do
        try
            color = Base.have_color? "--color=yes" : "--color=no"
            codecov = coverage? ["--code-coverage=user"] : ["--code-coverage=none"]
            compilecache = "--compilecache=" * (Bool(Base.JLOptions().use_compilecache) ? "yes" : "no")
            julia_exe = Base.julia_cmd()
            run(`$julia_exe --check-bounds=yes $codecov $color $compilecache $test_path`)
            info("$module_file tests passed")
        catch err
            Base.Pkg.Entry.warnbanner(err, label="[ ERROR: $module_file ]")
        end
    end
end
```
Compared to simply `include("wherever-it-is/runtests.jl")`, this has the advantage of running a separate Julia process, so your workspace does not contaminate the test environment and in case of segfaults, the parent process won't be affected.

Hopefully, the code above will be obsolete once [Pkg3](https://github.com/StefanKarpinski/Pkg3.jl) is released, but until then it is a useful workaround.

**edit**: function above was corrupted during copy-paste, corrected.
