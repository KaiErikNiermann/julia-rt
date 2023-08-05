struct hittable_list
    objects::Vector{hittable}
    function hittable_list()
        objects::Vector{hittable} = []
        new(objects)
    end
end

function clear!(list::hittable_list)
    list.objects = []
end

"""
    hit!(list::hittable_list, r::ray, t_min::Float64, t_max::Float64, rec::hit_record)

Check if the ray `r` hits any object in the list of objects `list`.
    
If it does then the hit record `rec` is updated with the hit information.
If the ray then hits an object closer to the camera than the previous hit, 
then the hit record `rec` is updated with the new hit information.

"""
function hit!(list::hittable_list, r::ray, t_min::Float64, t_max::Float64, rec::hit_record)
    hit_anything = false
    closest_so_far = t_max

    for object in list.objects
        if(hit!(object, r, t_min, closest_so_far, rec))
            hit_anything = true
            closest_so_far = rec.t
        end
    end

    return hit_anything
end