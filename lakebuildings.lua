local S = minetest.get_translator("nativevillages")

-- Load the shared fill-under function map gen helper
dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

-- ===================================================================
-- LAKE / STILT VILLAGE NOISE
-- Elongated clusters that naturally follow coastlines
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper: regular lake houses
-- ===================================================================

local function register_lake_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"deciduous_forest_shore"},
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
-- REGISTER ALL LAKE HOUSES
-- ===================================================================

register_lake_building({ name = "lakehouse1", file = "lakehouse1_12_11_15.mts", offset_y = 2 })
register_lake_building({ name = "lakehouse2", file = "lakehouse2_6_8_8.mts"})
register_lake_building({ name = "lakehouse3", file = "lakehouse3_5_9_9.mts"})
register_lake_building({ name = "lakehouse4", file = "lakehouse4_5_9_9.mts"})
register_lake_building({ name = "lakehouse5", file = "lakehouse5_6_11_10.mts"})

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Lower density + offset seeds → appear at the "heart" of each hamlet
-- ===================================================================

local function register_lake_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"deciduous_forest_shore"},
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

register_lake_central({ name = "lakechurch",  file = "lakechurch_9_13_13.mts", offset_y = 2 })
register_lake_central({ name = "lakemarket",  file = "lakemarket_7_6_10.mts",  offset_y = 1 })
register_lake_central({ name = "lakestable",  file = "lakestable_7_7_13.mts",  offset_y = 1 })














