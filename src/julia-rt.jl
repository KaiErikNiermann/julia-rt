using Base
using LinearAlgebra
using Distributions
using Profile
using ProfileView
using StaticArrays

include("util.jl")
include("ray.jl")
include("material.jl")
include("hittable.jl")
include("sphere.jl")
include("hittable_list.jl")
include("camera.jl")
include("scenes.jl")

include("RayTracer.jl")