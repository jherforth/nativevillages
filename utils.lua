-- utils.lua  –  SAFE version that only fills under the actual house footprint

nativevillages.fill_under_house = function(pos, schem_path_or_size)
    -- 1. Determine the actual size of the schematic that was just placed
    local size = {x = 20, y = 15, z = 20}  -- sensible default if we can't detect

    if schem_path_or_size then
        if type(schem_path_or_size) == "string" then
            -- It's a path → read the real size
            local filepath = schem_path_or_size
            if minetest.get_modpath("nativevillages") then
                filepath = minetest.get_modpath("nativevillages") .. "/schematics/" .. schem_path_or_size:gsub("%.mts$","") .. ".mts"
            end
            size = minetest.get_schematic_size(filepath) or size
        elseif type(schem_path_or_size) == "table" then
            size = schem_path_or_size
        end
    end

    -- 2. Add a small padding so corners are always covered
    local padding = 3
    local minp = {
        x = pos.x - math.floor(size.x/2) - padding,
        y = pos.y - 20,                     -- max 20 nodes down is more than enough
        z = pos.z - math.floor(size.z/2) - padding
    }
    local maxp = {
        x = pos.x + math.floor(size.x/2) + padding,
        y = pos.y + 5,                      -- a few nodes above in case of basement
        z = pos.z + math.floor(size.z/2) + padding
    }

    -- 3. Detect correct fill material (sand, dirt, snow, etc.)
    local ground_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
    local fill_name = "default:dirt"
    if minetest.get_item_group(ground_node.name, "sand") > 0 then
        fill_name = "default:desert_sand"
    elseif ground_node.name == "default:snowblock" or ground_node.name == "default:ice" then
        fill_name = "default:dirt"
    elseif ground_node.name == "default:dirt_with_dry_grass" then
        fill_name = "default:dry_dirt"
    end

    -- 4. Fill only air → solid fill, and stop at natural ground
    minetest.emerge_area(minp, maxp)
    minetest.after(0.5, function()
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        if not vm then return end
        local data = vm:get_data()
        local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
        local fill_id = minetest.get_content_id(fill_name)
        local air_id   = minetest.get_content_id("air")

        for x = minp.x, maxp.x do
            for z = minp.z, maxp.z do
                local found_ground = false
                for y = maxp.y, minp.y, -1 do
                    local vi = area:index(x, y, z)
                    if data[vi] and data[vi] ~= air_id and data[vi] ~= minetest.get_content_id("ignore") then
                        found_ground = true          -- we hit natural terrain or the house itself
                    elseif found_ground and data[vi] == air_id then
                        data[vi] = fill_id           -- fill the gap underneath
                    end
                end
            end
        end

        vm:set_data(data)
        vm:write_to_map()
    end)
end
