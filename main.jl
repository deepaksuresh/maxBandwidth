include("generate_graph.jl")
include("heap_graph.jl")
include("list.jl")
include("UnionFind.jl")

function initializeSource(G::GraphType, s::VertexType)
    setfield!(s, :δ, Inf)
    s.colour = "gray"
end

function BFS(G::GraphType, T::TreeType, s::VertexType, t::VertexType)
    initializeSource(G::GraphType, s::VertexType)
    Q=Vector{Vertex}()
    push!(Q, s)
    while length(Q)>0 && t.colour != "black"
        u = pop!(Q)
        for v in u.adj
            if ((Edge(u.id, v) in T.E) || (Edge(v, u.id) in T.E)) && G.V[v].colour=="white"
                G.V[v].colour="gray"
                G.V[v].π = u.id
                weight = G.E[Edge(u.id, v)]
                G.V[v].δ = minimum([weight, u.δ])
                push!(Q, G.V[v])
            end
        end
        u.colour = "black"
    end
end

function Dijkstra1(G, s, t)
    initializeSource(G, s)
    Q = Heap(copy(G.V))
    while size(Q)>0
        u = extractMax!(Q)
        for v in u.adj
            if haskey(Q.P, v)
                v′ = Q[Q.P[v]]
                Δ = maximum([minimum([u.δ, w(G, u, v′)]), v′.δ])
                if Δ > v′.δ
                    increase_key!(Q, v′, Δ)
                    v′.π = u.id
                end
            end
        end
    end
end

function Dijkstra2(G, s, t)
    initializeSource(G, s)
    Q = Heap(copy(G.V))
    while size(Q)>0
        u = extractMax!(Q)
        for v in u.adj
            if haskey(Q.P, v)
                v′ = Q[Q.P[v]]
                Δ = maximum([minimum([u.δ, w(G, u, v′)]), v′.δ])
                if Δ > v′.δ
                    increase_key!(Q, v′, Δ)
                    v′.π = u.id
                end
            end
        end
    end
end

function Kruskal(G::GraphType, s::VertexType, t::VertexType)
    #sort edges
    #kruskals max spanning tree
    #s-t path on that tree using bfs
    T = MaxSpanning()
    e = [makeSet(v) for v in G.V]
    sorted_edges = sort(collect(G.E), by = x->x[2], rev=true)
    for edge_pair in sorted_edges
        edge = edge_pair[1]
        #check if edge is in tree
        #union and add to tree
        if find(e[edge.head]) != find(e[edge.tail])
            push!(T.E, edge)
            union(e[edge.head], e[edge.tail])
        end
    end
    BFS(G, T, s, t)
end