include("ray.jl")
include("hittable.jl")

abstract type object end

function hit(obj::object, r::ray, t_min::Float64, t_max::Float64, rec::hit_record)::Bool end

include("sphere.jl")