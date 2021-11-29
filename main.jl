include("generate_graph.jl")
include("heap_graph.jl")
include("list.jl")

function initializeSource(G::GraphType, s::VertexType)
    for v in G.V
        if v==s
            setfield!(v, :δ, Inf)
        end
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