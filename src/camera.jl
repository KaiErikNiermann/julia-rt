struct camera 
    origin::SVector{3,Float64}
    lower_left_corner::SVector{3,Float64}
    horizontal::SVector{3,Float64}
    vertical::SVector{3,Float64}
    u::SVector{3,Float64}
    v::SVector{3,Float64}
    w::SVector{3,Float64}
    lens_radius::Float64
    function camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, focus_dist)
        theta = vfov * ( pi / 180 )
        h = tan(theta / 2)
        viewport_height = 2.0 * h
        viewport_width = aspect_ratio * viewport_height

        w = (lookfrom - lookat) / norm(lookfrom - lookat)
        u = (cross(vup, w)) / norm(cross(vup, w))
        v = cross(w, u) 

        origin = lookfrom
        horizontal = focus_dist * viewport_width * u
        vertical = focus_dist * viewport_height * v
        lower_left_corner = origin - (horizontal / 2) - (vertical / 2) - (focus_dist * w)

        lens_radius = aperture / 2
        new(origin, lower_left_corner, horizontal, vertical, u, v, w, lens_radius)
    end
end 

function get_ray(cam::camera, u::Float64, v::Float64)
    rd = cam.lens_radius * random_in_unit_disk()
    offset = (cam.u * rd[1]) + (cam.v * rd[2])
    ray(
        cam.origin + offset, 
        cam.lower_left_corner + (u * cam.horizontal) + (v * cam.vertical) - cam.origin - offset
    )
end
