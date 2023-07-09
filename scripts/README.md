# Ray Tracing in one weekend - Julia

## Files

### `basic_ppm_gen.jl`

In this file we generate a basic `.ppm` image.
The code is for the most part quite unremarkable, just applies some very basic programming concepts.

### `color_util.jl`

Here we refactor the code slightly and apply some more features of julia. Of note being that instead of
piping the output like we did with the first file, we now create a file using the `open()` method and then
write to the file stream. Additionally we created a struct to denote the different color values from 0 to 1.

### `vec_funcs.jl`

In this file we test out some of the required Linear Algebra functions we will need later on. A nice thing here
is that Julia alread has a Linear Algebra library and was obviously built for scientific computing which means
we already have most of the required vector/matrix operations available to us and don't need to build them on
our own.
