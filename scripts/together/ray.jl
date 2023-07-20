struct ray
    origin::Vector{Float64}
    direction::Vector{Float64}
end

function at(r::ray, t::Float64)::Vector{Float64} 
    r.origin + t * r.direction
end 