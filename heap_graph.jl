include("generate_graph.jl")
abstract type HeapType end

Base.size(H::HeapType) = length(H.h)
Base.getindex(H::HeapType, x::Int) = H.h[x]
Base.setindex!(H::HeapType, x::VertexType, i::Int) = setindex!(H.h, x, i)
Base.lastindex(H::HeapType) = size(H)

struct Heap <: HeapType
    h::Vector{Vertex}
    P::Dict
    function Heap(A::Vector{Vertex})
        H = new(A, Dict(j.id=>i for (i,j) in enumerate(A)))
        for i=(size(H)÷2):-1:1
            maxHeapify(H, i)
        end
        return H
    end
end

function maxHeapify(H::Heap, i::Int)
    while 2i<=size(H)
        i′ = max_child(H,i)
        if H[i] <= H[i′]
            H[i], H[i′] = H[i′], H[i]
            H.P[H[i].id], H.P[H[i′].id] = H.P[H[i′].id], H.P[H[i].id]
        end
        i = i′
    end
end

function max_child(H::Heap, i::Int)
    if 2i+1 > size(H)
        return 2i
    else
        if H[2i] >= H[2i+1]
            return 2i
        else
            return 2i+1
        end
    end
end

function extractMax!(H::Heap)
    if size(H)>0
        H[1], H[end] = H[end], H[1]
        H.P[H[1].id], H.P[H[end].id] = H.P[H[end].id], H.P[H[1].id]
        pop!(H.P, H[end].id)
        max = pop!(H.h)
        maxHeapify(H, 1)
        return max
    else
        print("empty heap")
    end
end

function Base.maximum(H::Heap)
    return H[1]
end

function insert!(H::Heap, key::VertexType)
    push!(H.h, key)
    H.P[key.id] = size(H)
    i = size(H)
    while i>1 && H[i÷2] <= H[i]
        H[i÷2], H[i] = H[i], H[i÷2]
        H.P[H[i÷2].id], H.P[H[i].id] = H.P[H[i].id], H.P[H[i÷2].id]
        i = i÷2
    end
end

function delete!(H::Heap, key::VertexType)
    i = H.P[key.id]
    H[i], H[end] = H[end], H[i]
    H.P[H[i].id], H.P[H[end].id] = H.P[H[end].id], H.P[H[i].id]
    pop!(H.h)
    pop!(H.P, key.id)
    maxHeapify(H, i)
end

function increase_key!(H::Heap, v::VertexType, value::Int)
    i = H.P[v.id]
    if value<w(v)
        throw("new value smaller than current")
    else
        v.δ = maximum([v.δ, value])
        while i>1 && H[i÷2] <= H[i]
            H[i÷2], H[i] = H[i], H[i÷2]
            H.P[H[i÷2].id], H.P[H[i].id] = H.P[H[i].id], H.P[H[i÷2].id]
            i = i÷2
        end
    end
end