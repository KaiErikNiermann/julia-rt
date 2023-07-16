using LinearAlgebra
include("ray.jl")  

function hit_sphere(center, radius, r::ray)
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

# Rendering code
struct color
    r::Float64
    g::Float64
    b::Float64
end

function write_color(file, c::color)
    write(file, string(255.99 * c.r, " ", 255.99 * c.g, " ", 255.99 * c.b, "\n"))
end

function gen_img(width, height, file)
    write(file, "P3\n$width $height\n255\n")
    for j in height-1:-1:0
        println(stderr, "Scanlines remaining: $j")
        for i in 0:1:width-1
            u = Float64(i) / (width - 1)
            v = Float64(j) / (height - 1)
            r = ray(origin, lower_left_corner + (u * horizontal) + (v * vertical) - origin)
            pixel_color = ray_color(r)
            write_color(file, pixel_color)
        end
    end
end

# image 
aspect_ratio = 16.0 / 9.0
width = 400
height = trunc(Int, width / aspect_ratio)
println(stderr, "width: $width, height: $height")

# camera 
viewport_height = 2.0
viewport_width = aspect_ratio * viewport_height 
focal_length = 1

origin = [0, 0, 0]
horizontal = [viewport_width, 0, 0]
vertical = [0, viewport_height, 0]
lower_left_corner = origin - (horizontal / 2) - (vertical / 2) - [0, 0, focal_length]
println(stderr, "$lower_left_corner $horizontal $vertical")

file = open("test.ppm", "w")
gen_img(width, height, file)