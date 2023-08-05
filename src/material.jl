abstract type material end

struct lambertian <: material
    albedo::color
end

struct metal <: material
    albedo::color
    fuzz::Float64   
    metal(a::color) = new(a, 0.0)
    function metal(a::color, f::Float64)
        f < 1 ? new(a, f) : new(a, 1.0)
    end
end

struct dielectric <: material
    ir::Float64
    dielectric(i::Float64) = new(i)
    dialectric() = new(0)
end


