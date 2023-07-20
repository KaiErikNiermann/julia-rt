using LinearAlgebra

# vectors
v1 = [1, 2, 3]
v2 = [4, 5, 6]

println(typeof(v1))

# vector additon
println(v1 + v2)

# scalar multiplication
println(2 * v1)

# length 
println(norm(v1))

# transpose 
T = transpose(v1)
println(typeof(T))

# dot product
println(dot(v1, v2))

# cross product
println(cross(v1, v2))

# unit vector
println(v1/norm(v1))
