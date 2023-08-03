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