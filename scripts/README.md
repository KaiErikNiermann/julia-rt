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
t^{2}\underbrace{\mathbf{b} \cdot \mathbf{b}}_{a} +t\underbrace{2\mathbf{b} \cdot (\mathbf{A} -\mathbf{C})}_{b} +\underbrace{(\mathbf{A} -\mathbf{C}) \cdot (\mathbf{A} -\mathbf{C}) -r^{2}}_{c} =0
```

As we don't need to solve for $t$ but simply check if the equation holds we apply the concept of the discriminant in which the equation only for real numbers of the disciminant is $\geq 0$. The discriminant is given by:

$$
b^2-4ac
$$

### `basic_normals.jl`

```math
\usepackage{amsmath}
\usepackage{tikz}
\usetikzlibrary{arrows}

\begin{tikzpicture}
  \shade[ball color = gray!40, opacity = 0.4] (0,0) circle (2cm);
  
  % outline
  \draw (0,0) circle (2cm);
  
  % front filled line
  \draw (-2,0) arc (180:360:2 and 0.6);
  
  % back dashed line
  \draw[dashed] (2,0) arc (0:180:2 and 0.6);
  
  
  \node[fill, circle, inner sep=1pt, label={left:$\vec{C}$}] at (0, 0) {};

  % arrow from center to edge denoting radius
  \draw[dashed] (0,0 ) -- node[above] {$r$} (2,0);

  % draw dashed arrow from center pointing at a 45 degree angle out of circle 
  \draw[dashed, ->] (0, 0) -- (45:2) node[above] {$\vec{P}$};

  % draw arrow from the previous tip of above arrow even further outside
  \draw[->] (45:2) -- (45:3.5) node[above] {$ \frac{\vec{P} - \vec{C}}{||\vec{P} - \vec{C}||} $};;

  % label for the unit normal 
  \node[align=center] at (4, 0) (normal) {\text{unit normal}};
  % arrow to edge of normal
  \draw[->,help lines,shorten >=3pt] (normal) .. controls (20:3) and (30:3) .. (45:3.5);

\end{tikzpicture}
```
