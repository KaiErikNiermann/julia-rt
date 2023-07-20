a::Int64 = 1 
b::Float64 = 2 

sum = a + b

println(sum)

function foo()
    for i in 1:1:10
        println(i + rand(Int64, 1)[1] )
    end
end

foo()