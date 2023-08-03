
struct color
    r::Float64
    g::Float64
    b::Float64
    function color(c::Vector{Float64})
        new(c[1], c[2], c[3])
    end
    color() = new(0.0, 0.0, 0.0)
end

function random()::Vector{Float64}
    return [random_double(), random_double(), random_double()]
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

function random_in_hemisphere(normal::Vector{Float64})::Vector{Float64}
    in_unit_sphere = random_in_unit_sphere()
    if(dot(in_unit_sphere, normal) > 0.0)
        return in_unit_sphere
    else 
        return -in_unit_sphere
    end
end 

function near_zero(vec::Vector{Float64})::Bool
    s = 1e-8
    return (abs(vec[1]) < s) && (abs(vec[2]) < s) && (abs(vec[3]) < s)
end

function reflect(v::Vector{Float64}, n::Vector{Float64})::Vector{Float64}
    v - 2.0 * dot(v, n) * n
end