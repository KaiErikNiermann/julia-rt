struct ray
    origin::Vector{Float64}
    direction::Vector{Float64}
    function ray(origin::Vector{Float64}, direction::Vector{Float64})
        new(origin, direction)
    end
    function ray()
        new([0.0, 0.0, 0.0], [0.0, 0.0, 0.0])
    end
end

function at(r::ray, t::Float64)::Vector{Float64} 
    r.origin + t * r.direction
end 