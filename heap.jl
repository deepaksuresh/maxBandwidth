abstract type HeapType end

function Base.size(H::HeapType)
    return length(H.h)
end

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
        if H.h[i] <= H.h[i′]
            H.h[i], H.h[i′] = H.h[i′], H.h[i]
            H.P[H.h[i]], H.P[H.h[i′]] = H.P[H.h[i′]], H.P[H.h[i]]
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
    while i>1 && H.h[i÷2] <= H.h[i]
        H.h[i÷2], H.h[i] = H.h[i], H.h[i÷2]
        H.P[H.h[i÷2]], H.P[H.h[i]] = H.P[H.h[i]], H.P[H.h[i÷2]]
        i = i÷2
    end
end

function delete!(H::Heap, key::Int)
    i = H.P[key]
    H.h[i], H.h[end] = H.h[end], H.h[i]
    H.P[H.h[i]], H.P[H.h[end]] = H.P[H.h[end]], H.P[H.h[i]]
    pop!(H.h)
    pop!(H.P, key)
    maxHeapify(H, i)
end

# function farthestRleaf(H::Heap, i::Int)
#     while 2i<=size(H)
#         if 2i+1<size(H)
#             i = 2i+1
#         else
#             i=2i
#         end
#     end
#     return i
# end