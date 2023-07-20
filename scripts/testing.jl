mutable struct foo
    name::String
end

function a(f)
    f2 = foo("hello")
    f = f2
end 

function b(f)
    println(f.name)
end

function main()
    f = foo("world")
    a(f)
    b(f)
end

main()