import Base: +, -, *

struct color
    r::Float32
    g::Float32
    b::Float32
    function color(c)
        new(c[1], c[2], c[3])
    end
    color() = new(0.0, 0.0, 0.0)
end

+(c1::color, c2::color)::color = color(SA_F32[c1.r .+ c2.r, c1.g .+ c2.g, c1.b .+ c2.b])

*(t::Float64, c::color)::color = color(SA_F32[t .* c.r, t .* c.g, t .* c.b])

*(c1::color, c2::color)::color = color(SA_F32[c1.r .* c2.r, c1.g .* c2.g, c1.b .* c2.b])

@inline function random()::SVector{3,Float64}
    return SVector{3,Float64}(random_double(), random_double(), random_double())
end

@inline function random(min::Float64, max::Float64)::SVector{3,Float64}
    return SVector{3,Float64}(random_double(min, max), random_double(min, max), random_double(min, max))
end

@inline function random_double()::Float64
    rand(Uniform(0.0, 1.0))
end

@inline function random_double(min::Float64, max::Float64)::Float64
    rand(Uniform(min, max))
end

@inline function random_in_unit_sphere()
    while true
        p = random(-1.0, 1.0)
        if(norm(p) >= 1.0)  
            continue
        end
        return p
    end
end

@inline function random_unit_vector()
    return normalize(random_in_unit_sphere())
end

@inline function random_in_unit_disk()
    while(true)
        p = SA_F64[random_double(-1.0, 1.0), random_double(-1.0, 1.0), 0]
        if(dot(p, p) >= 1)
            continue
        end
        return p
    end
end

@inline function random_in_hemisphere(normal::SVector{3,Float64})::SVector{3,Float64}
    in_unit_sphere = random_in_unit_sphere()
    if(dot(in_unit_sphere, normal) > 0.0)
        return in_unit_sphere
    end 
    return -in_unit_sphere
end 

@inline function near_zero(vec::SVector{3,Float64})::Bool
    s = 1e-8
    return (abs(vec[1]) < s) && (abs(vec[2]) < s) && (abs(vec[3]) < s)
end

reflect(v::SVector{3,Float64}, n::SVector{3,Float64})::SVector{3,Float64} = v + 2.0 * dot(-n, v) * n

@inline function refract(uv::SVector{3,Float64}, n::SVector{3,Float64}, r::Float64)::SVector{3,Float64} 
    cos_theta = min(dot(-uv, n), 1)
    r_out_perp = r * (uv + cos_theta * n)
    r_out_parallel = -sqrt(abs(1.0 - r^2 * (1 - cos_theta^2))) * n
    r_out_perp + r_out_parallel
end

@inline function reflectance(cosine, ref_idx)
    r0 = ((1 - ref_idx) / (1 + ref_idx))^2
    r0 + (1 - r0) * (1 - cosine)^5
end