struct ray
    origin::Vector{Float64}
    direction::Vector{Float64}
end

position(r::ray, t::Float64) = r.origin + t * r.direction

function ray_color(r::ray)
    unit_direction = normalize(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    (1.0 - t) * [1.0, 1.0, 1.0] + t * [0.5, 0.7, 1.0]
end

r1 = ray([0.0, 0.0, 0.0], [1.0, 1.0, 1.0])

println(position(r1, 2.0))