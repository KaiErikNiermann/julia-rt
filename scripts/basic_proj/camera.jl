struct camera
    aspect_ratio::Float64
    viewport_height::Float64
    viewport_width::Float64
    focal_length::Float64
    origin::Vector{Float64}
    horizontal::Vector{Float64}
    vertical::Vector{Float64}
    lower_left_corner::Vector{Float64}
end

function camera()
    aspect_ratio = 16.0 / 9.0
    viewport_height = 2.0
    viewport_width = aspect_ratio * viewport_height
    origin = [0.0, 0.0, 0.0]
    horizontal = [viewport_width, 0.0, 0.0]
    vertical = [0.0, viewport_height, 0.0]
    focal_length = 1.0
    lower_left_corner = origin - horizontal / 2 - vertical / 2 - [0.0, 0.0, focal_length]

    camera(aspect_ratio, viewport_height, viewport_width, focal_length, origin, horizontal, vertical, lower_left_corner)
end


function get_ray(cam::camera, u::Float64, v::Float64)
    ray(cam.origin, cam.lower_left_corner + (u * cam.horizontal) + (v * cam.vertical) - cam.origin)
end