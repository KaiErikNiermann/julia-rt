struct image
    width::Int64
    height::Int64
    samples_per_pixel::Int64
    max_depth::Int64
end

struct scene
    world::hittable_list
    cam::camera
    img::image
end

function final_scene()::scene
    aspect_ratio = 3.0 / 2.0
    width = 1200
    height = trunc(Int, width / aspect_ratio)
    samples_per_pixel = 500
    max_depth = 50

    world = hittable_list()
    ground_material = lambertian(color(SA_F32[0.5, 0.5, 0.5]))
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
                    push!(world.objects, sphere(center, 0.2, sphere_material))
                elseif(choose_mat < 0.95)
                    # metal
                    albedo = color(random(0.5, 1.0))
                    fuzz = random_double(0.0, 0.5)
                    sphere_material = metal(albedo, fuzz)
                    push!(world.objects, sphere(center, 0.2, sphere_material))
                else
                    # glass
                    sphere_material = dielectric(1.5)
                    push!(world.objects, sphere(center, 0.2, sphere_material))
                end
            end
        end
    end

    material1 = dielectric(1.5)
    push!(world.objects, sphere(SA_F64[0.0, 1.0, 0.0], 1.0, material1))

    material2 = lambertian(color(SA_F32[0.4, 0.2, 0.1]))
    push!(world.objects, sphere(SA_F64[-4.0, 1.0, 0.0], 1.0, material2))

    material3 = metal(color(SA_F32[0.7, 0.6, 0.5]), 0.0)
    push!(world.objects, sphere(SA_F64[4.0, 1.0, 0.0], 1.0, material3))
    
    cam = camera(
        SA_F64[13.0, 2.0, 3.0], SA_F64[0.0, 0.0, 0.0], SA_F64[0.0, 1.0, 0.0], 20, 16.0 / 9.0, 10.0, 0.1
    )
    
    scene(world, cam, image(width, height, samples_per_pixel, max_depth))
end

function basic_scene()::scene
    # image
    aspect_ratio = 16.0 / 9.0
    width = 400
    height = trunc(Int, width / aspect_ratio)
    samples_per_pixel = 50
    max_depth = 50

    # world
    world = hittable_list()
    ground_materal = lambertian(color(SA_F32[0.8, 0.8, 0.0]))
    center_material = lambertian(color(SA_F32[0.1, 0.2, 0.5]))
    left_material= dielectric(1.5)
    right_material = metal(color(SA_F32[0.8, 0.6, 0.2]), 0.0)

    push!(world.objects, sphere(SA_F64[0.0, -100.5, -1.0], 100.0, ground_materal))
    push!(world.objects, sphere(SA_F64[0.0, 0.0, -1.0], 0.5, center_material))
    push!(world.objects, sphere(SA_F64[-1.0, 0.0, -1.0], 0.5, left_material))
    push!(world.objects, sphere(SA_F64[-1.0, 0.0, -1.0], -0.45, left_material))
    push!(world.objects, sphere(SA_F64[1.0, 0.0, -1.0], 0.5, right_material))
    
    # camera
    cam = camera(
        SA_F64[3, 3, 2], SA_F64[0, 0, -1], SA_F64[0, 1, 0], 20, 16.0 / 9.0, 2, norm(SA_F64[3, 3, 2] - SA_F64[0, 0, -1])
    )

    scene(world, cam, image(width, height, samples_per_pixel, max_depth))
end