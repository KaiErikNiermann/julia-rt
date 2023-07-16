struct ray
    origin::Vector{Float64}
    direction::Vector{Float64}
end

function at(r::ray, t::Float64) 
    r.origin + t * r.direction
end 

function ray_color(r::ray)
    t = hit_sphere([0.0, 0.0, -1.0], 0.5, r)
    if(t > 0.0)
        v = at(r, t) - [0, 0, -1]
        N = v/norm(v)
        res = 0.5 * [N[1] + 1, N[2] + 1, N[3] + 1]
        return color(res[1], res[2], res[3])
    end
    unit_direction = r.direction/norm(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    r_color = (1.0 - t) * [1.0, 1.0, 1.0] + t * [0.5, 0.7, 1.0]
    color(r_color[1], r_color[2], r_color[3])
end