struct ray
    origin::SVector{3,Float64}
    direction::SVector{3,Float64}
    function ray(origin::SVector{3,Float64}, direction::SVector{3,Float64})
        new(origin, direction)
    end
    ray() = new([0.0, 0.0, 0.0], [0.0, 0.0, 0.0])
end

function at(r::ray, t::Float64)::SVector{3,Float64} 
    r.origin + t * r.direction
end 