function mysum(vec::AbstractVector{T}) where T
    s = zero(T)
    for elt in vec
        s += elt
    end
    s
end

struct Ones{T <: Number} <: AbstractVector{T}
    len::Int
end

Base.length(x::Ones) = x.len

mysum(vec::Ones{T}) where T = vec.len * one(T)

mysum(Ones{Float64}(3))
