# Ray Tracing in one weekend - Julia

## Basics

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

### `red_sphere.jl`

In this file we draw a basic red sphere with a center at $(0, 0, -1)$ and a radius of $0.5$ units.

The equation for a sphere with a center at $(C_x, C_y, C_z)$ with a radius $r$ is as follows.

$$
(x - C_x)^2+(y - C_y)^2 + (z - C_z)^2 = r^2
$$

Expressing this using vector notation where $\mathbf{P}=(x, y, z)$ and $\mathbf{C}=(C_x, C_y, C_z)$ we can rewrite the equation above as follows

$$
(\mathbf{P} - \mathbf{C}) \cdot (\mathbf{P} - \mathbf{C})=r^2
$$

To then figure out if our ray - which we denote by the equation $\mathbf{P}(t)=\mathbf{A}+t\mathbf{b}$ - hits our sphere we need to figure out if there exists some $t$ for which the following equation holds.

$$
(\mathbf{P}(t) - \mathbf{C}) \cdot (\mathbf{P}(t) - \mathbf{C})=r^2
$$

After we expand this we get the following. From this we can observe the equation becomes a quadratic.

```math
t^{2}\underbrace{\mathbf{b} \cdot \mathbf{b}}_{a} +t2\underbrace{\mathbf{b} \cdot (\mathbf{A} -\mathbf{C})}_{b} +\underbrace{(\mathbf{A} -\mathbf{C}) \cdot (\mathbf{A} -\mathbf{C}) -r^{2}}_{c} =0
```

As we don't need to solve for $t$ but simply check if the equation holds we apply the concept of the discriminant in which the equation only for real numbers of the disciminant is $\geq 0$. The discriminant is given by:

$$
b^2-4ac
$$

### `basic_normals.jl`

Here we vizalize the normals of the surface of the sphere by assuming each normal $\mathbf{n}$ is of unit length then mapping this to the interval $[0, 1]$ and then finally mapping each $(x, y, z)$ component which is now in the range of $[0, 1]$ to some corresponding $(r, g, b)$ value. In our code this roughly translates to.

To calculate the actual unit normal vector we simply make the observation that the unit normal vector is just the vector perpendicular to the surface at the point of intersection. So given sphere with center $C$, in our case $(0, 0, -1)$, and some intersection point $P$ has a normal given by $P - C$ and after normalizing this we get:

$$
\vec{N}=\frac{P - C}{|P - C|}
$$

## Advanced

### `/basic_proj`

#### How did I structure the project

Here I started to try and build out some of the basics for the actual project. Up untill now we were just working with scripts but of course this does not scale very well for any larger additions. One of this first interesting questions when encountering a new language is how do you properly structure new projects, especially in reference to good import/include practices. After looking at some examples and discussions online I felt a nice approach, especially to avoid things like circular dependencies, was to create a `main.jl` file in which I would have all of my `include`'s. Then running this file meant that the project would be construct in a manner akin to making a smaller script while still maintaining the modularity of separation of concerns.

#### Abstractions

Following along with the guide I also introduced the necessary abstractions. While you could use Julia to emulate the object oriented features applied in the guide such as abstract functions and function overloading I opted for a more straightforward approach.

I created an abstract `hittable` type which acts as the supertype to all objects. And in turn allows me to keep a list of varying objects. For the `hit` methods, as opposed to using abstract functions, I used multiple dispatch in which I simply pass the required object as opposed to implementing the `hit` function as a class method for the object.

Similarly for materials there is the abstract `materials` type of which `metal` and `lambertian` are a subtype. Then to simulate the different types of scattering (specular and diffuse) I implemented the respective scatter functions. In `hittable.jl`.

### Scattering

#### Specular

#### Diffuse

### Notes
