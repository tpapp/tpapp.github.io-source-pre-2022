# code for blog post https://tpapp.github.io/post/branch_prediction2/
using BenchmarkTools

"Sum elements if ≥ 128."
function sumabove_if(x)
    s = zero(eltype(x))
    for elt in x
        if elt ≥ 128
            s += elt
        end
    end
    s
end

function sumabove_ifelse(x)
    s = zero(eltype(x))
    for elt in x
        s += ifelse(elt ≥ 128, elt, zero(eltype(x)))
    end
    s
end

function sumabove_tricky(x::Vector{Int64})
    s = Int64(0)
    for elt in x
        s += ~((elt - 128) >> 63) & elt
    end
    s
end

x_rand = rand(1:256, 32768) # original example on stackoverflow, except using Int
x_sorted = sort(x_rand)

@assert sumabove_if(x_rand) == sumabove_if(x_sorted) ==
    sumabove_ifelse(x_rand) == sumabove_ifelse(x_sorted) ==
    sumabove_tricky(x_rand) == sumabove_tricky(x_sorted)

@btime sumabove_if($x_rand)
@btime sumabove_if($x_sorted)

@btime sumabove_ifelse($x_rand)
@btime sumabove_ifelse($x_sorted)

@btime sumabove_tricky($x_rand)
@btime sumabove_tricky($x_sorted)

function sumabove_if_sort(x)
    x = sort(x)
    s = zero(eltype(x))
    for elt in x
        if elt ≥ 128
            s += elt
        end
    end
    s
end

@btime sumabove_if_sort($x_rand)

sumabove_generator(x) = sum(y for y in x if y ≥ 128)

@btime sumabove_generator($x_rand)
@btime sumabove_generator($x_sorted)
