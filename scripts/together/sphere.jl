struct sphere <: hittable
    center::Vector{Float64}
    radius::Float64
end

function hit(sphere::hittable, r::ray, t_min::Float64, t_max::Float64, rec::hit_record)
    oc = r.origin - sphere.center
    a = dot(r.direction, r.direction)
    half_b = dot(oc, r.direction)
    c = dot(oc, oc) - sphere.radius^2
    discriminant = half_b^2 - a * c
    if(discriminant < 0) 
        return false
    end

    sqrtd = sqrt(discriminant)
    
    root = (-half_b - sqrtd) / a
    if(root < t_min || t_max < root)
        root = (-half_b + sqrtd) / a
        if(root < t_min || t_max < root)
            return false
        end
    end

    rec.t = root
    rec.p = at(r, rec.t)
    outward_normal = (rec.p - sphere.center) / sphere.radius
    set_face_normal(rec, r, outward_normal)

    return true
end