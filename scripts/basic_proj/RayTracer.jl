import Base: +, -, *

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

function *(t::Float64, c::color)::color
    color([t * c.r, t * c.g, t * c.b])
end

function ray_color(r::ray, world::hittable_list, depth)::color
    rec = hit_record([0.0, 0.0, 0.0], [0.0, 0.0, 0.0], 0.0, false)

    if(depth <= 0)
        return color([0.0, 0.0, 0.0])
    end

    # 0.001 to avoid shadow acne
    if(hit!(world, r, 0.001, Inf, rec))
        # target = rec.p + rec.normal + random_unit_vector()
        target = rec.p + random_in_hemisphere(rec.normal)
        return 0.5 * ray_color(ray(rec.p, target - rec.p), world, depth - 1)
    end
    unit_direction = r.direction/norm(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    color((1.0 - t) * [1.0, 1.0, 1.0] + t * [0.5, 0.7, 1.0])
end

function write_color(file, c::color)
    # Divide the color by the number of samples and gamma-correct 
    scale = 1.0 / samples_per_pixel
    r = sqrt(scale * c.r)
    g = sqrt(scale * c.g)
    b = sqrt(scale * c.b)

    write(file, string(256 * my_clamp(r, 0.0, 0.999), " "
                     , 256 * my_clamp(g, 0.0, 0.999), " "
                     , 256 * my_clamp(b, 0.0, 0.999), "\n"))
end

function gen_img(width, height, file, world::hittable_list)
    write(file, "P3\n$width $height\n255\n")
    for j in height-1:-1:0
        println(stderr, "Scanlines remaining: $j")
        for i in 0:1:width-1
            pixel_color = color([0.0, 0.0, 0.0])
            for s in 1:1:samples_per_pixel
                u = (Float64(i) + random_double() ) / (width - 1)
                v = (Float64(j) + random_double() ) / (height - 1)
                r = get_ray(cam, u, v)
                pixel_color += ray_color(r, world, max_depth)
            end
            write_color(file, pixel_color)
        end
    end
end

# image 
aspect_ratio = 16.0 / 9.0
width = 400
height = trunc(Int, width / aspect_ratio)
samples_per_pixel = 100
max_depth = 50
println(stderr, "width: $width, height: $height")

# world 
world = hittable_list()
Base.push!(world.objects, sphere([0, 0, -1], 0.5))
Base.push!(world.objects, sphere([0, -100.5, -1], 100))

# camera 
cam = camera()

file = open("image.ppm", "w")
gen_img(width, height, file, world)