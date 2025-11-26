local S = minetest.get_translator("nativevillages")

-- Load the shared fill-under function map gen helper
dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

-- ===================================================================
-- DESERT VILLAGE CLUSTERING NOISE
-- One shared noise = all buildings appear in the same village spots
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper function so we don't repeat the same 20 lines 8 times
-- ===================================================================

local function register_desert_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"desert"},
        y_min = 1,
        y_max = 110,

        -- This is the magic: actually check the whole footprint
        place_offset_y = (params.offset_y or 0) - 1,   -- we check one node lower

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z",   -- ← REMOVED force_placement
        rotation = "random",

        -- This function runs BEFORE placement and rejects bad spots
        placement = "simple",  -- required for the callback to work correctly

        -- The real flatness check
        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,

        -- This is the key part — only place if the entire area is nearly flat
        check = function(minp, maxp, noise_val)
            -- Get schematic size
            local path = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file
            local size = minetest.get_schematic_size(path)
            if not size then return false end

            local radius_x = math.floor(size.x / 2) + 2
            local radius_z = math.floor(size.z / 2) + 2

            local y_values = {}
            local samples = 0
            for x = -radius_x, radius_x, 4 do
                for z = -radius_z, radius_z, 4 do
                    local checkpos = {x = minp.x + x, y = minp.y, z = minp.z + z}
                    local y = minetest.get_node_or_nil(checkpos)
                    if y then
                        table.insert(y_values, checkpos.y)
                        samples = samples + 1
                    end
                end
            end

            if samples < 6 then return false end

            -- Calculate max height difference across the whole footprint
            table.sort(y_values)
            local height_diff = y_values[#y_values] - y_values[1]

            -- Allow max 2–3 block difference (adjust to taste)
            return height_diff <= 3
        end,
    })
end

-- ===================================================================
-- REGISTER ALL DESERT BUILDINGS
-- ===================================================================

register_desert_building({name = "deserthouse1", file = "deserthouse1_12_14_9.mts", offset_y = -1 })
register_desert_building({name = "deserthouse2", file = "deserthouse2_8_7_8.mts" })
register_desert_building({name = "deserthouse3", file = "deserthouse3_8_10_8.mts" })
register_desert_building({name = "deserthouse4", file = "deserthouse4_10_8_7.mts" })
register_desert_building({name = "deserthouse5", file = "deserthouse5_10_6_8.mts" })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS — use the global central noise
-- ===================================================================

local function register_desert_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"desert"},
        y_min = 1,
        y_max = 110,

        -- This is the magic: actually check the whole footprint
        place_offset_y = (params.offset_y or 0) - 1,   -- we check one node lower

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z",   -- ← REMOVED force_placement
        rotation = "random",

        -- This function runs BEFORE placement and rejects bad spots
        placement = "simple",  -- required for the callback to work correctly

        -- The real flatness check
        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,

        -- This is the key part — only place if the entire area is nearly flat
        check = function(minp, maxp, noise_val)
            -- Get schematic size
            local path = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file
            local size = minetest.get_schematic_size(path)
            if not size then return false end

            local radius_x = math.floor(size.x / 2) + 2
            local radius_z = math.floor(size.z / 2) + 2

            local y_values = {}
            local samples = 0
            for x = -radius_x, radius_x, 4 do
                for z = -radius_z, radius_z, 4 do
                    local checkpos = {x = minp.x + x, y = minp.y, z = minp.z + z}
                    local y = minetest.get_node_or_nil(checkpos)
                    if y then
                        table.insert(y_values, checkpos.y)
                        samples = samples + 1
                    end
                end
            end

            if samples < 6 then return false end

            -- Calculate max height difference across the whole footprint
            table.sort(y_values)
            local height_diff = y_values[#y_values] - y_values[1]

            -- Allow max 2–3 block difference (adjust to taste)
            return height_diff <= 3
        end,
    })
end

register_desert_central({name = "desertchurch", file = "desertchurch_9_12_16.mts", offset_y = 0})
register_desert_central({name = "desertmarket", file = "desertmarket_12_16_13.mts", offset_y = 0})
register_desert_central({name = "desertstable",file = "desertstable_13_6_9.mts", offset_y = 0})


















