abstract type HeapType end

Base.size(H::HeapType) =length(H.h)
Base.getindex(H::HeapType, x::Int) = H.h[x]
Base.setindex!(H::HeapType, x::Int, i::Int) = setindex!(H.h, x, i)

struct Heap <: HeapType
    h::Vector
    P::Dict
    function Heap(A::Vector)
        H = new(A, Dict(j=>i for (i,j) in enumerate(A)))
        for i=(size(H)÷2):-1:1
            maxHeapify(H, i)
        end
        return H
    end
end

function maxHeapify(H::Heap, i::Int)
    while 2i<=size(H)
        i′ = max_child(H,i)
        if H[i] <= H.h[i′]
            H[i], H.h[i′] = H.h[i′], H[i]
            H.P[H[i]], H.P[H.h[i′]] = H.P[H.h[i′]], H.P[H[i]]
        end
        i = i′
    end
end

function max_child(H::Heap, i::Int)
    if 2i+1 > size(H)
        return 2i
    else
        if H.h[2i] >= H.h[2i+1]
            return 2i
        else
            return 2i+1
        end
    end
end

function extractMax!(H::Heap)
    if size(H)>0
        H.h[1], H.h[end] = H.h[end], H.h[1]
        H.P[H.h[1]], H.P[H.h[end]] = H.P[H.h[end]], H.P[H.h[1]]
        pop!(H.P, H.h[end])
        max = pop!(H.h)
        maxHeapify(H, 1)
        return max
    else
        print("empty heap")
    end
end

function Base.maximum(H::Heap)
    return H.h[1]
end

function insert!(H::Heap, key::Int)
    push!(H.h, key)
    H.P[key] = size(H)
    i = size(H)
    while i>1 && H.h[i÷2] <= H[i]
        H.h[i÷2], H[i] = H[i], H.h[i÷2]
        H.P[H.h[i÷2]], H.P[H[i]] = H.P[H[i]], H.P[H.h[i÷2]]
        i = i÷2
    end
end

function delete!(H::Heap, key::Int)
    i = H.P[key]
    H[i], H.h[end] = H.h[end], H[i]
    H.P[H[i]], H.P[H.h[end]] = H.P[H.h[end]], H.P[H[i]]
    pop!(H.h)
    pop!(H.P, key)
    maxHeapify(H, i)
end