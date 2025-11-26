-- utils.lua  –  FINAL safe version (2025 standard)

nativevillages.fill_under_house = function(pos, schematic_filename)
    -- Get real schematic size
    local fullpath = minetest.get_modpath("nativevillages") .. "/schematics/" .. schematic_filename
    local size = minetest.get_schematic_size(fullpath)
    if not size or size.x == 0 then
        size = {x = 16, y = 12, z = 16}  -- safe fallback
    end

    -- Padding so corners and edges are always covered
    local pad = 4
    local minp = {
        x = pos.x - math.floor(size.x/2) - pad,
        y = pos.y - 20,        -- max 20 nodes down is plenty
        z = pos.z - math.floor(size.z/2) - pad
    }
    local maxp = {
        x = pos.x + math.floor(size.x/2) + pad,
        y = pos.y + 6,         -- slight upward buffer
        z = pos.z + math.floor(size.z/2) + pad
    }

    -- Detect correct fill material
    local ground = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
    local fill = "default:dirt"
    if minetest.get_item_group(ground, "sand") > 0 or ground == "default:desert_sand" or ground == "default:sand" then
        fill = "default:desert_sand"
    elseif ground == "default:snowblock" or ground == "default:ice" then
        fill = "default:dirt"
    elseif ground:find("dry") then
        fill = "default:dry_dirt"
    end

    -- Fill only air below the house, stop at natural ground
    minetest.emerge_area(minp, maxp)
    minetest.after(0.3, function()
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        if not vm then return end
        local data = vm:get_data()
        local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
        local fill_id = minetest.get_content_id(fill)
        local air_id = minetest.get_content_id("air")

        for x = minp.x, maxp.x do
            for z = minp.z, maxp.z do
                local found_surface = false
                for y = maxp.y, minp.y, -1 do
                    local vi = area:index(x, y, z)
                    local nid = data[vi]
                    if nid and nid ~= air_id and nid ~= minetest.get_content_id("ignore") then
                        found_surface = true
                    elseif found_surface and nid == air_id then
                        data[vi] = fill_id
                    end
                end
            end
        end
        vm:set_data(data)
        vm:write_to_map()
    end)
end
