import Base: +, -, *

# Rendering code
function +(c1::color, c2::color)::color
    color([c1.r + c2.r, c1.g + c2.g, c1.b + c2.b])
end

function *(t::Float64, c::color)::color
    color([t * c.r, t * c.g, t * c.b])
end

function *(c1::color, c2::color)::color
    color([c1.r * c2.r, c1.g * c2.g, c1.b * c2.b])
end

function ray_color(r::ray, world::hittable_list, depth)::color
    rec = hit_record()

    if(depth <= 0)
        return color([0.0, 0.0, 0.0])
    end

    # 0.001 to avoid shadow acne
    if(hit!(world, r, 0.001, Inf, rec))
        sd = scatter_data(color(), ray())
        if(scatter(rec.mat, r, rec, sd))
            return sd.attenuation * ray_color(sd.scattered, world, depth - 1)
        end
        return color([0.0, 0.0, 0.0])
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
ground_materal = lambertian(color([0.8, 0.8, 0.0]))
center_material = lambertian(color([0.7, 0.3, 0.3]))
left_material = metal(color([0.8, 0.8, 0.8]))
right_material = metal(color([0.8, 0.6, 0.2]))

push!(world.objects, sphere([0.0, -100.5, -1.0], 100.0, ground_materal))
push!(world.objects, sphere([0.0, 0.0, -1.0], 0.5, center_material))
push!(world.objects, sphere([-1.0, 0.0, -1.0], 0.5, left_material))
push!(world.objects, sphere([1.0, 0.0, -1.0], -0.4, left_material))

# camera 
cam = camera()

file = open("image.ppm", "w")
gen_img(width, height, file, world)