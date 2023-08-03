abstract type material end

struct lambertian <: material
    albedo::color
end

struct metal <: material
    albedo::color
end


