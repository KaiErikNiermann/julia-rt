struct sphere_t <: object
    center::Float64
    radius::Float64
end

function hit(center, radius, r::ray)
    oc = r.origin - center
    a = dot(r.direction, r.direction)
    half_b = dot(oc, r.direction)
    c = dot(oc, oc) - radius^2
    discriminant = half_b^2 - a * c
    if(discriminant < 0)
        return -1.0
    else 
        return (-half_b - sqrt(discriminant)) / (a)
    end
end

function hit(s::sphere_t, r::ray, t_min, t_max, rec::hit_record) 
    oc = r.origin - center
    a = dot(r.direction, r.direction)
    half_b = dot(oc, r.direction)
    c = dot(oc, oc) - radius^2
    discriminant = half_b^2 - a * c

    if (discriminant < 0)
        return false
    end

    root = (-half_b - sqrt(discriminant)) / (a)
    if (root < t_min || t_max < root)
        root = (-half_b + sqrt(discriminant)) / (a)
        if (root < t_min || t_max < root)
            return false
        end
    end

    rec.t = root
    rec.p = at(rec.t)
    rec.normal = (rec.p - center) / radius

    return true
end