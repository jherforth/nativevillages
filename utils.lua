-- Shared function — add this once
nativevillages.fill_under_house = function(pos)
    local ground_node = minetest.get_node(vector.new(pos.x, pos.y-1, pos.z))
    local fill_node = "default:dirt"

    if minetest.get_item_group(ground_node.name, "sand") > 0 then
        fill_node = "default:desert_sand"
    elseif ground_node.name == "default:snowblock" or ground_node.name == "default:ice" then
        fill_node = "default:dirt_with_snow"
    elseif ground_node.name == "default:dirt_with_dry_grass" then
        fill_node = "default:dry_dirt"
    end

    local p1 = vector.new(pos.x - 25, pos.y - 25, pos.z - 25)
    local p2 = vector.new(pos.x + 25, pos.y, pos.z + 25)

    minetest.emerge_area(p1, p2)
    minetest.after(0.5, function()
        local vm = minetest.get_voxel_manip()
        local emin, emax = vm:read_from_map(p1, p2)
        local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
        local data = vm:get_data()

        local fill_id = minetest.get_content_id(fill_node)

        for x = p1.x, p2.x do
        for z = p1.z, p2.z do
            local found_surface = false
            for y = p2.y, p1.y, -1 do
                local vi = area:index(x, y, z)
                if not found_surface and data[vi] ~= minetest.get_content_id("air") then
                    found_surface = true
                elseif found_surface and data[vi] == minetest.get_content_id("air") then
                    data[vi] = fill_id
                end
            end
        end
        end

        vm:set_data(data)
        vm:write_to_map()
    end)
end
