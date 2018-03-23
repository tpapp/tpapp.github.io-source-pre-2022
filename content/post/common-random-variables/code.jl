using BenchmarkTools
using StaticArrays
using Parameters


# common interface

"Dimension of noise ``ϵ`` for each observation."
const EDIM = 7

"""
Common random variables. The user needs to define

1. `observation_moments`, which should use `observation_moment`,

2. `newcrv = update!(crv)`, which returns new common random variables,
potentially (but not necessarily) overwriting `crv`.
"""
abstract type CRVContainer end

observation_moment(ϵ, μ, σ) = mean(@. exp(μ + σ * ϵ))

average_moment(crv::CRVContainer, μ, σ) = mean(observation_moments(crv, μ, σ))

"""
Calculate statistics, making `N` draws, updating every `L`th time.
"""
function stats(crv, μ, σ, N, L)
    _stat() = (N % L == 0 && (crv = update!(crv)); average_moment(crv, μ, σ))
    [_stat() for _ in 1:N]
end


# preallocated matrix

"""
Common random variables are stored in columns of a matrix.
"""
struct PreallocatedMatrix{T} <: CRVContainer
    ϵ::Matrix{T}
end

PreallocatedMatrix(M::Int) = PreallocatedMatrix(randn(EDIM, M))

update!(p::PreallocatedMatrix) = (randn!(p.ϵ); p)

observation_moments(p::PreallocatedMatrix, μ, σ) =
    vec(mapslices(ϵ -> observation_moment(ϵ, μ, σ), p.ϵ, 1))


# variations on static vectors

"Common random variables as a vector of vectors, in the `ϵs`."
abstract type CRVVectors <: CRVContainer end

observation_moments(p::CRVVectors, μ, σ) = map(ϵ -> observation_moment(ϵ, μ, σ), p.ϵs)

struct PreallocatedStaticCRV{K, T} <: CRVVectors
    ϵs::Vector{SVector{K, T}}
end

PreallocatedStaticCRV(M::Int) = PreallocatedStaticCRV([@SVector(randn(EDIM)) for _ in 1:M])

function update!(p::PreallocatedStaticCRV)
    @unpack ϵs = p
    @inbounds for i in indices(ϵs, 1)
        ϵs[i] = @SVector(randn(EDIM))
    end
    p
end

struct MutableStaticCRV{K, T} <: CRVVectors
    ϵs::Vector{MVector{K, T}}
end

MutableStaticCRV(M::Int) = MutableStaticCRV([@MVector(randn(EDIM)) for _ in 1:M])

function update!(p::MutableStaticCRV)
    @unpack ϵs = p
    @inbounds for i in indices(ϵs, 1)
        randn!(ϵs[i])
    end
    p
end

struct GeneratedStaticCRV{K, T} <: CRVVectors
    ϵs::Vector{SVector{K, T}}
end

GeneratedStaticCRV(M::Int) =
    GeneratedStaticCRV([@SVector(randn(EDIM)) for _ in 1:M])

update!(p::GeneratedStaticCRV{K, T}) where {K, T} =
    GeneratedStaticCRV([@SVector(randn(T, K)) for _ in indices(p.ϵs, 1)])


# benchmarks

@btime mean(stats(PreallocatedMatrix(100), 1.0, 0.1, 100, 10)) # 233 ms

@btime mean(stats(PreallocatedStaticCRV(100), 1.0, 0.1, 100, 10)) # 1.5ms

@btime mean(stats(MutableStaticCRV(100), 1.0, 0.1, 100, 10)) # 1.5ms

@btime mean(stats(GeneratedStaticCRV(100), 1.0, 0.1, 100, 10)) # 1.5ms
