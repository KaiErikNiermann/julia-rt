function ray_color(r::ray, world::hittable_list, depth)::color
    rec = rec_buf
    def_color = color(SA_F32[0.0, 0.0, 0.0])

    if(depth <= 0)
        return def_color
    end
    
    # 0.001 to avoid shadow acne
    if(hit!(world, r, 0.001, Inf, rec))
        sd = sd_buf
        if(scatter(rec.mat, r, rec, sd))
            return  sd.attenuation * ray_color(sd.scattered, world, depth - 1)
        end
        return def_color
    end
    unit_direction = r.direction/norm(r.direction)
    t = 0.5 * (unit_direction[1] + 1.0)
    color((1.0 - t) * SA_F64[1.0, 1.0, 1.0] + t * SA_F64[0.5, 0.7, 1.0])
end

function write_color(file, c::color)
    # Divide the color by the number of samples and gamma-correct 
    r::Float16 = sqrt(SCALE * c.r)
    g::Float16 = sqrt(SCALE * c.g)
    b::Float16 = sqrt(SCALE * c.b)

    write(file, string(256 * clamp.(r, 0.0, 0.999), " "
                     , 256 * clamp.(g, 0.0, 0.999), " "
                     , 256 * clamp.(b, 0.0, 0.999), "\n"))
end

function gen_img(width::Int64, height::Int64, file, world::hittable_list, img::image) 
    max_depth = img.max_depth
    spp = img.samples_per_pixel
    c = SC.cam
    write(file, "P3\n$width $height\n255\n")
    for j in height-1:-1:0
        println(stderr, "Scanlines remaining: $j")
        for i in 0:1:width-1
            pixel_color = color(SA_F32[0.0, 0.0, 0.0])
            for _ in 1:1:spp
                u = ( i + random_double() ) / (width - 1)
                v = ( j + random_double() ) / (height - 1)
                r = get_ray(c, u, v)
                pixel_color += ray_color(r, world, max_depth)
            end
            write_color(file, pixel_color)
        end
    end
end

rec_buf = hit_record()
sd_buf = scatter_data(color(), ray())

# const SC = final_scene()
const SC = basic_scene()
const SCALE::Float16 = 1.0 / SC.img.samples_per_pixel

file = open("image.ppm", "w")

# ProfileView.@profview gen_img(SC.img.width, SC.img.height, file, SC.world, SC.img)
@time gen_img(SC.img.width, SC.img.height, file, SC.world, SC.img)

