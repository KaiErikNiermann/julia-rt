function math_expr(op, op1, op2)
    expr = Expr(:call, op, op1, op2)
    return expr
end

ex = math_expr(:+, 1, 2)
println(ex)
println(typeof(ex))
println(eval(ex))

arr = [1, 2, 3]
arr = map(x -> x + 1, arr)
println(arr)

function add_two(x)
    return add_one(y) = x + y
end

println(add_two(1)(2))

a = x -> x + 1
b = (x, y) -> x + y
c = (x, y) -> begin
    x + y
end

println(b(2, 3))
println(c(2, 3))

a2 = [1, 2, 3, 4, 5, 6]
a2 = filter(x -> x % 2 == 0, a2)
println(a2)

struct Squares
    count::Int
end

Base.iterate(s::Squares, state=1) = state > s.count ? nothing : (state * state, state + 1)

for i in Squares(5)
    println(i)
end