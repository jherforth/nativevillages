local S = minetest.get_translator("nativevillages")

-- Load the shared fill-under function map gen helper
dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

-- ===================================================================
-- GRASSLAND / FOREST VILLAGE CLUSTERING NOISE
-- Same noise for all houses → perfect village grouping
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper function (DRY — don't repeat yourself)
-- ===================================================================

local function register_grassland_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"grassland"},
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
-- REGISTER ALL GRASSLAND HOUSES
-- ===================================================================

register_grassland_building({ name = "grasslandhouse1", file = "grasslandhouse1_7_9_7.mts"})
register_grassland_building({ name = "grasslandhouse2", file = "grasslandhouse2_6_7_7.mts"})
register_grassland_building({ name = "grasslandhouse4", file = "grasslandhouse4_7_7_9.mts"})
register_grassland_building({ name = "grasslandhouse5", file = "grasslandhouse5_6_6_6.mts"})

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Use slightly lower density and offset seeds so they appear near village centers
-- ===================================================================

local function register_grassland_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"grassland"},
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

register_grassland_central({name = "grasslandchurch", file = "grasslandchurch_11_17_21.mts", offset_y = 0})
register_grassland_central({name = "grasslandmarket",file = "grasslandmarket_9_5_9.mts", offset_y = 0})
register_grassland_central({name = "grasslandstable", file = "grasslandstable_15_8_16.mts", offset_y = 0})
register_grassland_central({name = "grasslandhouse3", file = "grasslandhouse3_10_10_9.mts", offset_y = 0})


















