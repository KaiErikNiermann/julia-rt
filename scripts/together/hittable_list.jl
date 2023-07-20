struct hittable_list <: hittable
    objects::Vector{hittable}
    function hittable_list()
        objects::Vector{hittable} = [] 
        new(objects)
    end
end

function clear!(list::hittable_list)
    list.objects = []
end

function list_objs(list::hittable_list)
    for object in list.objects
        println(object)
    end
end

function hit(list::hittable_list, r::ray, t_min::Float64, t_max::Float64, rec::hit_record)
    temp_rec = hit_record([0.0, 0.0, 0.0], [0.0, 0.0, 0.0], 0.0, false)
    hit_anything = false
    closest_so_far = t_max

    for object in list.objects
        if(hit(object, r, t_min, closest_so_far, temp_rec))
            hit_anything = true
            closest_so_far = temp_rec.t
            rec = temp_rec
        end
    end

    return hit_anything
end