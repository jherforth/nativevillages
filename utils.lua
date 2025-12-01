-- utils.lua - Building foundation system

-- Function to fill gaps under buildings and create proper foundations
nativevillages.fill_under_house = function(pos, schematic_filename)
    -- Parse schematic size from filename (format: name_X_Y_Z.mts)
    local size = {x = 10, y = 10, z = 10}  -- default fallback

    local parts = {}
    for part in schematic_filename:gmatch("[^_]+") do
        table.insert(parts, part)
    end

    -- Extract dimensions (last 3 parts before .mts)
    if #parts >= 3 then
        local x = tonumber(parts[#parts - 2])
        local y = tonumber(parts[#parts - 1])
        local z_part = parts[#parts]:gsub("%.mts", "")
        local z = tonumber(z_part)

        if x and y and z then
            size = {x = x, y = y, z = z}
        end
    end

    -- Detect biome and set appropriate fill material
    local test_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
    local fill_material = "default:dirt"

    if test_node.name:find("desert") or test_node.name == "default:sand" then
        fill_material = "default:desert_sand"
    elseif test_node.name:find("snow") or test_node.name == "default:ice" then
        fill_material = "default:snowblock"
    elseif test_node.name:find("dry") then
        fill_material = "default:dry_dirt"
    elseif test_node.name:find("rainforest") then
        fill_material = "default:dirt"
    end

    -- Calculate foundation area (slightly larger than building footprint)
    local half_x = math.ceil(size.x / 2) + 2
    local half_z = math.ceil(size.z / 2) + 2

    local minp = {
        x = pos.x - half_x,
        y = pos.y - 15,  -- Check up to 15 nodes down
        z = pos.z - half_z
    }
    local maxp = {
        x = pos.x + half_x,
        y = pos.y + 2,   -- Slightly above placement to catch the floor
        z = pos.z + half_z
    }

    -- Emerge area and fill after slight delay
    minetest.emerge_area(minp, maxp, function(blockpos, action, calls_remaining)
        if calls_remaining > 0 then return end

        minetest.after(0.5, function()
            -- Fill column by column
            for x = minp.x, maxp.x do
                for z = minp.z, maxp.z do
                    -- Find the first solid block from top down
                    local found_solid_y = nil

                    for y = maxp.y, minp.y, -1 do
                        local check_pos = {x=x, y=y, z=z}
                        local node = minetest.get_node(check_pos)

                        -- Check if it's a solid ground-type node
                        if node.name ~= "air" and
                           node.name ~= "ignore" and
                           (minetest.get_item_group(node.name, "soil") > 0 or
                            minetest.get_item_group(node.name, "sand") > 0 or
                            node.name:find("dirt") or
                            node.name:find("stone") or
                            node.name:find("snow")) then
                            found_solid_y = y
                            break
                        end
                    end

                    -- Fill air gaps from building floor down to solid ground
                    if found_solid_y then
                        for y = pos.y - 1, found_solid_y + 1, -1 do
                            local fill_pos = {x=x, y=y, z=z}
                            local node = minetest.get_node(fill_pos)

                            if node.name == "air" then
                                minetest.set_node(fill_pos, {name=fill_material})
                            end
                        end
                    end
                end
            end
        end)
    end)
end

print("[nativevillages] Utils loaded - foundation filling system active")
