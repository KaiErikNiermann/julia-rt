import Base: +, -, *

# Rendering code
function +(c1::color, c2::color)::color
    color(SA_F64[c1.r + c2.r, c1.g + c2.g, c1.b + c2.b])
end

function *(t::Float64, c::color)::color
    color(SA_F64[t * c.r, t * c.g, t * c.b])
end

function *(c1::color, c2::color)::color
    color(SA_F64[c1.r * c2.r, c1.g * c2.g, c1.b * c2.b])
end

function ray_color(r::ray, world::hittable_list, depth)::color
    rec = rec_buf
    def_color = color(SA_F64[0.0, 0.0, 0.0])

    if(depth <= 0)
        return def_color
    end
    
    # 0.001 to avoid shadow acne
    if(hit!(world, r, 0.001, Inf, rec))
        sd = sd_buf
        if(scatter(rec.mat, r, rec, sd))
            return sd.attenuation * ray_color(sd.scattered, world, depth - 1)
        end
        return def_color
    end
    unit_direction = r.direction/norm(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    color((1.0 - t) * SA_F64[1.0, 1.0, 1.0] + t * SA_F64[0.5, 0.7, 1.0])
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
            pixel_color = color(SA_F64[0.0, 0.0, 0.0])
            for s in 1:1:samples_per_pixel
                u = ( Float64(i) + random_double() ) / (width - 1)
                v = ( Float64(j) + random_double() ) / (height - 1)
                r = get_ray(cam, u, v)
                pixel_color += ray_color(r, world, max_depth)
            end
            write_color(file, pixel_color)
        end
    end
end

# image 
# aspect_ratio = 3 / 2
# width = 1200
# height = trunc(Int, width / aspect_ratio)
# samples_per_pixel = 500
# max_depth = 50
# println(stderr, "width: $width, height: $height")

aspect_ratio = 16.0 / 9.0 
width = 400
height = trunc(Int, width / aspect_ratio)
samples_per_pixel = 50
max_depth = 50

# world 

function final_scene()
    world = hittable_list()
    ground_material = lambertian(color(SA_F64[0.5, 0.5, 0.5]))
    push!(world.objects, sphere(SA_F64[0.0, -1000.0, 0.0], 1000.0, ground_material))
    for a in -11:1:11
        for b in -11:1:11
            choose_mat = random_double()
            center = SA_F64[a + 0.9 * random_double(), 0.2, b + 0.9 * random_double()]
            if(norm(center - SA_F64[4.0, 0.2, 0.0]) > 0.9)
                if(choose_mat < 0.8)
                    # diffuse
                    albedo = color(random()) * color(random())
                    sphere_material = lambertian(albedo)
                    # push!(world.objects, sphere(center, 0.2, sphere_material))
                elseif(choose_mat < 0.95)
                    # metal
                    albedo = color(random(0.5, 1.0))
                    fuzz = random_double(0.0, 0.5)
                    sphere_material = metal(albedo, fuzz)
                    # push!(world.objects, sphere(center, 0.2, sphere_material))
                else
                    # glass
                    # sphere_material = dielectric(1.5)
                    # push!(world.objects, sphere(center, 0.2, sphere_material))
                end
            end
        end
    end

    material1 = dielectric(1.5)
    push!(world.objects, sphere(SA_F64[0.0, 1.0, 0.0], 1.0, material1))

    material2 = lambertian(color(SA_F64[0.4, 0.2, 0.1]))
    push!(world.objects, sphere(SA_F64[-4.0, 1.0, 0.0], 1.0, material2))

    material3 = metal(color(SA_F64[0.7, 0.6, 0.5]), 0.0)
    push!(world.objects, sphere(SA_F64[4.0, 1.0, 0.0], 1.0, material3))
    world
end

function basic_scene()
    world = hittable_list()
    ground_materal = lambertian(color(SA_F64[0.8, 0.8, 0.0]))
    center_material = lambertian(color(SA_F64[0.1, 0.2, 0.5]))
    left_material= dielectric(1.5)
    right_material = metal(color(SA_F64[0.8, 0.6, 0.2]), 0.0)

    push!(world.objects, sphere(SA_F64[0.0, -100.5, -1.0], 100.0, ground_materal))
    push!(world.objects, sphere(SA_F64[0.0, 0.0, -1.0], 0.5, center_material))
    push!(world.objects, sphere(SA_F64[-1.0, 0.0, -1.0], 0.5, left_material))
    push!(world.objects, sphere(SA_F64[-1.0, 0.0, -1.0], -0.45, left_material))
    push!(world.objects, sphere(SA_F64[1.0, 0.0, -1.0], 0.5, right_material))
    world
end

# world = final_scene()
world = basic_scene()

# cam = camera(
#     SA_F64[13.0, 2.0, 3.0], SA_F64[0.0, 0.0, 0.0], SA_F64[0.0, 1.0, 0.0], 20, 16.0 / 9.0, 10.0, 0.1
# )

cam = camera(
    SA_F64[3, 3, 2], SA_F64[0, 0, -1], SA_F64[0, 1, 0], 20, 16.0 / 9.0, 2, norm(SA_F64[3, 3, 2] - SA_F64[0, 0, -1])
)

rec_buf = hit_record()
sd_buf = scatter_data(color(), ray())

file = open("image.ppm", "w")
gen_img(width, height, file, world)
