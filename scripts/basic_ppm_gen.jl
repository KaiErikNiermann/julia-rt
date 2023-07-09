function gen_img(width, height)
    println("P3\n$width $height\n255")
    for i in height-1:-1:0
        println(stderr, "Scanlines remaining: $i")
        flush(stderr)
        for j in 0:1:width-1
            r = i / (width - 1)
            g = j / (height - 1)
            b = 0.25

            ir = Int(floor(255.99 * r))
            ig = Int(floor(255.99 * g))
            ib = Int(floor(255.99 * b))
            println("$ig $ir $ib")
        end
    end
end

gen_img(256, 256)

