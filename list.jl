abstract type ListType end

Base.size(L::ListType) = length(L.h)
Base.getindex(L::ListType, x::Int) = L.h[x]
Base.setindex!(L::ListType, x::VertexType, i::Int) = setindex!(L.h, x, i)
Base.lastindex(L::ListType) = size(L)

struct List<:ListType
    h::Vector{Vertex}
    P::Dict
    function List(A::Vector{Vertex})
        H = new(A, Dict(j.id=>i for (i,j) in enumerate(A)))
        return H
    end
end

function extractMax!(L::ListType)
    if size(L)>0
        max = L[1]
        ind = 1
        for i in 2:size(L)
            if L[i]>max
                max = L[i]
                ind = i
            end
        end
        L[ind], L[end] = L[end], L[ind]
        L.P[L[ind].id], L.P[L[end].id] = L.P[L[end].id], L.P[L[ind].id]
        pop!(L.h)
        pop!(L.P, max.id)
        return max
    else
        print("empty list")
    end
end

function increase_key!(L::List, v::VertexType, value::Float64)
    i = L.P[v.id]
    if value<v.δ
        throw("new value smaller than current")
    else
        v.δ = maximum([v.δ, value])
    end
end