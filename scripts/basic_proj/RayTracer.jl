# Rendering code
struct color
    r::Float64
    g::Float64
    b::Float64
    function color(c::Vector{Float64})
        new(c[1], c[2], c[3])
    end
end

function ray_color(r::ray, world::hittable_list)::color
    rec = hit_record([0.0, 0.0, 0.0], [0.0, 0.0, 0.0], 0.0, false)
    if(hit!(world, r, 0.0, Inf, rec))
        return color(0.5 * (rec.normal + [1, 1, 1]))
    end
    unit_direction = r.direction/norm(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    color((1.0 - t) * [1.0, 1.0, 1.0] + t * [0.5, 0.7, 1.0])
end

function write_color(file, c::color)
    write(file, string(255.99 * c.r, " ", 255.99 * c.g, " ", 255.99 * c.b, "\n"))
end

function gen_img(width, height, file, world::hittable_list)
    write(file, "P3\n$width $height\n255\n")
    for j in height-1:-1:0
        println(stderr, "Scanlines remaining: $j")
        for i in 0:1:width-1
            u = Float64(i) / (width - 1)
            v = Float64(j) / (height - 1)
            r = ray(origin, lower_left_corner + (u * horizontal) + (v * vertical) - origin)
            pixel_color = ray_color(r, world)
            write_color(file, pixel_color)
        end
    end
end

# image 
aspect_ratio = 16.0 / 9.0
width = 400
height = trunc(Int, width / aspect_ratio)
println(stderr, "width: $width, height: $height")

# world 
world = hittable_list()
Base.push!(world.objects, sphere([0, 0, -1], 0.5))
Base.push!(world.objects, sphere([0, -100.5, -1], 100))

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
gen_img(width, height, file, world)