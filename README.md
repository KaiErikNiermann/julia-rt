
# Ray Tracing - Julia

[![Julia v1.9.2](https://img.shields.io/badge/Julia-v1.9.2-blue.svg)](https://julialang.org/downloads/oldreleases/#v192)

This project is an exploration into ray tracing using the Julia programming language. I included the intermediary steps following the [_Ray Tracing in One Weekend_](https://raytracing.github.io/books/RayTracingInOneWeekend.html) guide in the `scripts` folder, along with some explanation for each of the files to document anything of interest. The final ray tracer resides `src` folder.

## Motivation

There are various reasons I've wanted to do this.
For a while I have been interested in Julia and I thought this project would be a nice way to learn the language.
Additionally I thought this would be a nice way to solidify certain concepts in linear algebra and geometry.
And finally there is the obvious aspect of gaining some nice insights into the basics of ray tracing and computer graphics.

## Progression

### Basic sphere

Generated with `julia scripts/basic_sphere.jl`

![sphere](assets/red_sphere.png)

### Surface normals

Generated with `julia scripts/basic_normals`

![normals](assets/basic_normals.png)

### Surface normals with AA

Generated using `scripts/basic_proj` @ commit `257c5cd3cbf507299bcb9677d786cb984bb66bd0`

![normals_w_AA](assets/normals_with_AA.png)

### Lambertian

Generated using `scripts/basic_proj` @ commit `cee94f5dd9f1c15bfea6616898079167c33d4b8d`

![lambertian](assets/correct_lambertian.png)

### Fuzzed metals

Generated using `scripts/basic_proj` @ commit `988b814b8a6d8f9ecb5b996979471f70d4fe3523`

![fuzzed_metal](assets/fuzzed_metals.png)

### Refraction

Generated using `scripts/basic_proj` @ commit `988b814b8a6d8f9ecb5b996979471f70d4fe3523`

![refraction_demo](assets/refraction.png)

## References

- [_Ray Tracing in One Weekend_](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
- [_Linear Algebra and its Applications_](https://www.pearson.com/en-us/subject-catalog/p/linear-algebra-and-its-applications/P200000006235)
- [_Julia Documentation_](https://docs.julialang.org/en/v1/)
- [_Computer Graphics from Scratch_](https://gabrielgambetta.com/computer-graphics-from-scratch/)
