struct color
    r::Float64
    g::Float64
    b::Float64
    function color(c::SVector{3,Float64})
        new(c[1], c[2], c[3])
    end
    color() = new(0.0, 0.0, 0.0)
end

function random()::SA_F64
    return SA_F64[random_double(), random_double(), random_double()]
end

function random(min::Float64, max::Float64)
    return [random_double(min, max), random_double(min, max), random_double(min, max)]
end

function my_clamp(x::Float64, min::Float64, max::Float64)::Float64
    if(x < min)
        return min
    end
    if(x > max)
        return max
    end
    return x
end

function random_double()::Float64
    rand(Uniform(0.0, 1.0))
end

function random_double(min::Float64, max::Float64)::Float64
    rand(Uniform(min, max))
end

function random_in_unit_sphere()
    while true
        p = random(-1.0, 1.0)
        if(norm(p) >= 1.0)  
            continue
        end
        return p
    end
end

function random_unit_vector()
    rv = random_in_unit_sphere()
    return rv/norm(rv)
end

function random_in_unit_disk()
    while(true)
        p = [random_double(-1.0, 1.0), random_double(-1.0, 1.0), 0]
        if(dot(p, p) >= 1)
            continue
        end
        return p
    end
end

function random_in_hemisphere(normal::SVector{3,Float64})::SVector{3,Float64}
    in_unit_sphere = random_in_unit_sphere()
    if(dot(in_unit_sphere, normal) > 0.0)
        return in_unit_sphere
    else 
        return -in_unit_sphere
    end
end 

function near_zero(vec::SVector{3,Float64})::Bool
    s = 1e-8
    return (abs(vec[1]) < s) && (abs(vec[2]) < s) && (abs(vec[3]) < s)
end

function reflect(v::SVector{3,Float64}, n::SVector{3,Float64})::SVector{3,Float64}
    v + 2.0 * dot(-n, v) * n
end

function refract(uv::SVector{3,Float64}, n::SVector{3,Float64}, r::Float64)::SVector{3,Float64} 
    cos_theta = min(dot(-uv, n), 1)
    r_out_perp = r * (uv + cos_theta * n)
    r_out_parallel = -sqrt(abs(1.0 - r^2 * (1 - cos_theta^2))) * n
    r_out_perp + r_out_parallel
end

function reflectance(cosine, ref_idx)
    r0 = ((1 - ref_idx) / (1 + ref_idx))^2
    r0 + (1 - r0) * (1 - cosine)^5
end