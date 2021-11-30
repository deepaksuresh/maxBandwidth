using Random
using StatsBase

abstract type GraphType end
abstract type VertexType end
abstract type EdgeType end
abstract type TreeType end

Base.isless(v1::VertexType, v2::VertexType) = v1.δ < v2.δ
w(G::GraphType, u::VertexType, v::VertexType) = G.E[Edge(u.id,v.id)]

mutable struct Vertex<:VertexType
    id::Int
    colour::String
    adj::Vector{Int}
    δ::Float64
    π::Int
    function Vertex(id;colour="white")
        return new(id, colour, Vector{Int}(), -Inf, 0)
    end
end

struct Edge<:EdgeType
    head::Int
    tail::Int
    function Edge(h::Int, t::Int)
        return new(h,t)
    end
end

struct G1<:GraphType
    V::Vector{Vertex}
    E::Dict{Edge, Int}
    function G1()
        V = Vector{Vertex}()
        E = Dict{Edge, Int}()
        for i = 1:5000
            push!(V, Vertex(i))
        end

        for i=1:5000
            next_id = i%5000+1
            if !haskey(E, Edge(i, next_id))
                push!(V[i].adj, next_id)
                push!(V[next_id].adj, i)
                w = rand(0:50)
                E[Edge(i, next_id)] = w
                E[Edge(next_id, i)] = w
            end
            candidates = filter(x->length(V[i].adj)<7, cat(1:i-1, (i%5000+2):5000;dims=1))
            if length(candidates)>=2
                tails = sample(candidates,2;replace=false)
                for tail in tails
                    if !haskey(E, Edge(i, tail))
                        w = rand(0:50)
                        E[Edge(i, tail)] = w
                        E[Edge(tail, i)] = w
                        push!(V[i].adj, tail)
                        push!(V[tail].adj, i)
                    end
                end
            end
        end
        return new(V,E)
    end
end

struct G2<:GraphType
    V::Vector{Vertex}
    E::Dict{Edge, Int}
    function G2()
        V = Vector{Vertex}()
        E = Dict{Edge, Int}()
        for i = 1:5000
            push!(V, Vertex(i))
        end
        for i=1:5000
            push!(V[i].adj, i%5000+1)
            E[Edge(i, i%5000+1)] = rand(0:50)
            tails = sample(cat(1:i-1, (i%5000+2):5000;dims=1),999;replace=false)
            for tail in tails
                E[Edge(i, tail)] = rand(0:50)
                push!(V[i].adj, tail)
            end
        end
        return new(V,E)
    end
end

mutable struct MaxSpanning <: TreeType
    E::Set{Edge}
    MaxSpanning() = new(Set{Edge}())
end

