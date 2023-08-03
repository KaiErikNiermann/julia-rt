mutable struct num
    n::Float64
end

function foo1(n)
    n += 10
end

function foo2(n::num)
    n.n += 10
end

a = num(10)

foo1(a.n)
println(a.n)

foo2(a)
println(a.n)

