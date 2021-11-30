abstract type ListType end

Base.size(L::ListType) = length(L.h)
Base.getindex(L::ListType, x::Int) = L.h[x]
Base.setindex!(L::ListType, x::VertexType, i::Int) = setindex!(L.h, x, i)
Base.lastindex(L::ListType) = size(L)

struct List<:ListType
    h::Vector{Vertex}
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
            popat!(L.h, ind)
            return max
        end
    else
        print("empty list")
    end
end

function increase_key!(L::List, v::VertexType, value::Float64)
    if value<v.δ
        throw("new value smaller than current")
    else
        v.δ = maximum([v.δ, value])
    end
end