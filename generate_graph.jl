using Random
using StatsBase

abstract type Graph end
abstract type VertexType end
abstract type EdgeType end

function Base.show(io::IO, v::VertexType)
    println(io, "Id $(v.id)")
    print("edges: ")
    for i in 1:length(v.adj)-1
        print(io,v.adj[i],", ")
    end
    print(io,v.adj[end])
end

struct Vertex<:VertexType
    id::Int
    colour::String
    adj::Vector{Int}
    function Vertex(id;colour="white")
        return new(id, colour, Vector{Int}())
    end
end

struct Edge<:EdgeType
    head::Int
    tail::Int
    function Edge(h::Int, t::Int)
        return new(h,t)
    end
end

struct G1<:Graph
    V::Vector{Vertex}
    E::Dict{Edge, Int}
    function G1()
        #create 5k vertices
        #μ degree=6
        #should be connected
        #for every vertex connect it to the next and randomly choose uniform()
        V = Vector{Vertex}()
        E = Dict{Edge, Int}()
        for i = 1:5000
            push!(V, Vertex(i))
        end

        for i=1:5000
            #connect each vertex to next id/vertex
            push!(V[i].adj, i%5000+1)
            E[Edge(i, i%5000+1)] = rand(0:50)#weight is a random integer in [0..50]
            #connect each vertex to 5 other randomly chosen vertices
            tails = sample(cat(1:i-1, (i%5000+2):5000;dims=1),5;replace=false)
            for tail in tails
                E[Edge(i, tail)] = rand(0:50)
                push!(V[i].adj, tail)
            end
        end
        return new(V,E)
    end
end

struct G2<:Graph
    V::Vector{Vertex}
    E::Dict{Edge, Int}
    function G2()
        #create 5k vertices
        #μ degree=6
        #should be connected
        #for every vertex connect it to the next and randomly choose uniform()
        V = Vector{Vertex}()
        E = Dict{Edge, Int}()
        for i = 1:5000
            push!(V, Vertex(i))
        end

        for i=1:5000
            #connect each vertex to next id/vertex
            push!(V[i].adj, i%5000+1)
            E[Edge(i, i%5000+1)] = rand(0:50)#weight is a random integer in [0..50]
            #connect each vertex to 5 other randomly chosen vertices
            tails = sample(cat(1:i-1, (i%5000+2):5000;dims=1),999;replace=false)
            for tail in tails
                E[Edge(i, tail)] = rand(0:50)
                push!(V[i].adj, tail)
            end
        end
        return new(V,E)
    end
end
# struct G2<:Graph
#     G::Matrix{Int64}
#     function G2()
#         G = zeros(Int, 5000, 5000)
#         for i=1:5000
#             G[i, i%5000+1] = rand(0:50)
#             tails = sample(cat(1:i-1, (i%5000+2):5000;dims=1),999;replace=false)
#             for tail in tails
#                 G[i, tail] = rand(0:50)
#             end
#         end
#         return new(G)
#     end
# end