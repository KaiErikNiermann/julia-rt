struct color
    r::Float64
    g::Float64
    b::Float64
end

function write_color(file, color)
    write(file, string(255.99 * color.r, " ", 255.99 * color.g, " ", 255.99 * color.b, "\n"))
end

function gen_img(width, height, file)
    write(file, "P3\n$width $height\n255\n")
    for i in height-1:-1:0
        println(stderr, "Scanlines remaining: $i")
        flush(stderr)
        for j in 0:1:width-1
            r = i / (width - 1)
            g = j / (height - 1)
            b = 0.25
            pixel_color = color(r, g, b)
            write_color(file, pixel_color)
        end
    end
end

file = open("test.ppm", "w")
gen_img(256, 256, file)

