using Random
using StatsBase

abstract type GraphType end
abstract type VertexType end
abstract type EdgeType end

Base.isless(v1::VertexType, v2::VertexType) = v1.δ < v2.δ
w(G::GraphType, u::VertexType, v::VertexType) = G.E[Edge(u.id,v.id)]

# function Base.show(io::IO, v::VertexType)
#     println(io, "Id $(v.id)")
#     print("edges: ")
#     for i in 1:length(v.adj)-1
#         print(io,v.adj[i],", ")
#     end
#     print(io,v.adj[end])
# end

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
        for i = 1:5000000
            push!(V, Vertex(i))
        end

        for i=1:5000000
            push!(V[i].adj, i%5000000+1)
            E[Edge(i, i%5000000+1)] = rand(0:50)
            tails = sample(cat(1:i-1, (i%5000000+2):5000000;dims=1),5;replace=false)
            for tail in tails
                E[Edge(i, tail)] = rand(0:50)
                push!(V[i].adj, tail)
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
