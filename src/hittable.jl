mutable struct hit_record
    p::SVector{3,Float64}
    normal::SVector{3,Float64}
    mat::material
    t::Float64
    front_face::Bool
    function hit_record()
        new(SA_F64[0.0, 0.0, 0.0], SA_F64[0.0, 0.0, 0.0], lambertian(color(SA_F32[0.0, 0.0, 0.0])), 0.0, false)
    end
end

@inline function set_face_normal!(rec::hit_record, r::ray, outward_normal::SVector{3,Float64})
    rec.front_face = dot(r.direction, outward_normal) < 0
    rec.normal = rec.front_face ? outward_normal : -outward_normal
end

mutable struct scatter_data
    attenuation::color
    scattered::ray
end

function scatter(mat::lambertian, r_in::ray, rec::hit_record, sd::scatter_data)::Bool
    scatter_direction = rec.normal + random_unit_vector()

    # Catch degenerate scatter direction
    if (near_zero(scatter_direction))
        scatter_direction = rec.normal
    end

    sd.scattered = ray(rec.p, scatter_direction)
    sd.attenuation = mat.albedo
    return true
end

function scatter(mat::metal, r_in::ray, rec::hit_record, sd::scatter_data)::Bool
    reflected = reflect(normalize(r_in.direction), rec.normal)
    sd.scattered = ray(rec.p, reflected + mat.fuzz * random_in_unit_sphere())
    sd.attenuation = mat.albedo
    return (dot(sd.scattered.direction, rec.normal) > 0)
end

function scatter(mat::dielectric, r_in::ray, rec::hit_record, sd::scatter_data)::Bool
    sd.attenuation = color(SA_F64[1.0, 1.0, 1.0])
    refraction_ratio = rec.front_face ? (1.0 / mat.ir) : mat.ir

    unit_direction = normalize(r_in.direction)
    cos_theta = min(dot(-unit_direction, rec.normal), 1.0)
    sin_theta = sqrt.(1.0 - cos_theta^2)

    cannot_refract = refraction_ratio * sin_theta > 1.0
    dir = SA_F64[0.0, 0.0, 0.0]
    if (cannot_refract || reflectance(cos_theta, refraction_ratio) > random_double())
        dir = reflect(unit_direction, rec.normal)
    else
        dir = refract(unit_direction, rec.normal, refraction_ratio)
    end

    sd.scattered = ray(rec.p, dir)
    return true
end

abstract type hittable end