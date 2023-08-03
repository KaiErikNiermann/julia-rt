mutable struct hit_record
    p::Vector{Float64}
    normal::Vector{Float64}
    t::Float64
    front_face::Bool
end

function set_face_normal!(rec::hit_record, r::ray, outward_normal::Vector{Float64})
    rec.front_face = dot(r.direction, outward_normal) < 0
    if(rec.front_face)
        # ray is outside
        rec.normal = outward_normal
    else
        # ray is inside
        rec.normal = -outward_normal
    end
end

abstract type hittable end