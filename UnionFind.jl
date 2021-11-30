mutable struct Element<:VertexType
    id::Int
    rank::Int
    p
    Element() = new()
end

function makeSet(v::VertexType)
    e = Element()
    e.id = v.id
    e.rank=0
    return e
end

function link(x::Element,y::Element)
    if x.rank>y.rank
        y.p = x
    else
        x.p = y
        if x.rank==y.rank
            y.rank += 1
        end
    end
end

function union(x::Element,y::Element)
    link(find(x),find(y))
end

function find(x::Element)
    if !isdefined(x, :p)
        return x
    else
        if x!=x.p
            x.p = find(x.p)
        end
        return x.p
    end
end

function add(T::TreeType, E::Edge, e::Vector{Element})
    if find(e.head) != find(e.tail)
        push!(T.E, E)
    end
end
