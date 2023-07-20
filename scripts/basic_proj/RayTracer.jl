using Base

# Rendering code
struct color
    r::Float64
    g::Float64
    b::Float64
    function color(c::Vector{Float64})
        new(c[1], c[2], c[3])
    end
end

function +(c1::color, c2::color)::color
    color([c1.r + c2.r, c1.g + c2.g, c1.b + c2.b])
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
    scale = 1.0 / samples_per_pixel

    r = c.r * scale
    g = c.g * scale
    b = c.b * scale
    
    write(file, string(256 * clamp(r, 0, 0.999), " "
                     , 256 * clamp(g, 0, 0.999), " "
                     , 256 * clamp(b, 0, 0.999), "\n"))
end

function gen_img(width, height, file, world::hittable_list)
    write(file, "P3\n$width $height\n255\n")
    for j in height-1:-1:0
        println(stderr, "Scanlines remaining: $j")
        for i in 0:1:width-1
            pixel_color = color([0.0, 0.0, 0.0])
            for s in 1:1:samples_per_pixel
                u = (i + rand(Int64, 1)[1] ) / (width - 1)
                v = (j + rand(Int64, 1)[1] ) / (height - 1)
                r = cam.get_ray(u, v)
                pixel_color += ray_color(r, world)
            end
        end
    end
end

# image 
aspect_ratio = 16.0 / 9.0
width = 400
height = trunc(Int, width / aspect_ratio)
samples_per_pixel = 100
println(stderr, "width: $width, height: $height")

# world 
world = hittable_list()
Base.push!(world.objects, sphere([0, 0, -1], 0.5))
Base.push!(world.objects, sphere([0, -100.5, -1], 100))

# camera 
cam = camera()

file = open("test.ppm", "w")
gen_img(width, height, file, world)