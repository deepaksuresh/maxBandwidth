abstract type HeapType end

function Base.size(H::HeapType)
    return length(H.h)
end

struct Heap <: HeapType
    h::Vector
    function Heap(A::Vector)
        H = new(A)
        for i=(size(H)÷2):-1:1
            maxHeapify(H, i)
        end
        return H
    end
end

function maxHeapify(H::Heap, i::Int)
    while 2i<=size(H)
        i′ = max_child(H,i)
        if H.h[i] <= H.h[i′]
            H.h[i], H.h[i′] = H.h[i′], H.h[i]
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

function extractMax(H::Heap)
    if size(H)>0
        H.h[1], H.h[end] = H.h[end], H.h[1]
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

function insert(H::Heap, key::Int)
    push!(H.h, key)
    i = size(H)
    while i>1 && H.h[i÷2] <= H.h[i]
        H.h[i÷2], H.h[i] = H.h[i], H.h[i÷2]
        i = i÷2
    end
end
