-- paths.lua
-- Comprehensive path system with all variants for cohesive village roads
local modpath = minetest.get_modpath("nativevillages")

-- Path schematic sets for each biome
local path_sets = {
    grass = {
        prefix = "grass_dirt",
        biomes = {"grassland", "snowy_grassland", "deciduous_forest"},
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        y_min = 1,
        y_max = 110,
    },
    savanna = {
        prefix = "savanna_dirt",
        biomes = {"savanna"},
        place_on = {"default:dry_dirt_with_dry_grass"},
        y_min = 1,
        y_max = 140,
    },
    snow = {
        prefix = "snow_dirt",
        biomes = {"icesheet", "icesheet_ocean", "tundra"},
        place_on = {"default:snowblock", "default:ice"},
        y_min = -2,
        y_max = 40,
    },
}

-- Path variants (matching your schematic naming)
local path_variants = {
    "forward_straight",
    "sideways_straight",
    "left",
    "right",
    "junction",
}

-- Higher density noise for paths - more paths within village areas
local dense_path_noise = {
    offset = 0,
    scale = 0.003,              -- 3x denser than buildings
    spread = {x = 250, y = 250, z = 250},
    seed = 987654322,
    octaves = 2,
    persistence = 0.65,
    lacunarity = 2.0,
    flags = "defaults",
}

-- Register all path variants for each biome
for biome_key, biome_data in pairs(path_sets) do
    for _, variant in ipairs(path_variants) do
        local schematic_name = biome_data.prefix .. "_" .. variant .. "_5x5.mts"
        local decoration_name = "nativevillages:" .. biome_key .. "_path_" .. variant

        -- Different fill_ratio for different path types to create natural distribution
        local fill_ratio = 0.002  -- Base ratio for straights
        if variant == "junction" then
            fill_ratio = 0.0005    -- Fewer intersections
        elseif variant == "left" or variant == "right" then
            fill_ratio = 0.001     -- Moderate turns
        end

        minetest.register_decoration({
            name = decoration_name,
            deco_type = "schematic",
            place_on = biome_data.place_on,
            sidelen = 32,           -- Smaller sidelen = more attempts = denser paths
            fill_ratio = fill_ratio,
            noise_params = dense_path_noise,
            biomes = biome_data.biomes,
            y_min = biome_data.y_min,
            y_max = biome_data.y_max,

            place_offset_y = 0,
            flags = "place_center_x, place_center_z, force_placement",

            schematic = modpath .. "/schematics/" .. schematic_name,
            rotation = "random",
        })
    end
end

-- Special handling for desert paths (if they exist with different naming)
-- Check if desert paths use the same naming convention or different
local desert_check = io.open(modpath .. "/schematics/desert_dirt_forward_straight_5x5.mts", "r")
if desert_check then
    desert_check:close()

    -- Desert has its own path set
    for _, variant in ipairs(path_variants) do
        local schematic_name = "desert_dirt_" .. variant .. "_5x5.mts"
        local decoration_name = "nativevillages:desert_path_" .. variant

        local fill_ratio = 0.002
        if variant == "junction" then
            fill_ratio = 0.0005
        elseif variant == "left" or variant == "right" then
            fill_ratio = 0.001
        end

        minetest.register_decoration({
            name = decoration_name,
            deco_type = "schematic",
            place_on = {"default:desert_sand"},
            sidelen = 32,
            fill_ratio = fill_ratio,
            noise_params = dense_path_noise,
            biomes = {"desert"},
            y_min = 1,
            y_max = 50,

            place_offset_y = 0,
            flags = "place_center_x, place_center_z, force_placement",

            schematic = modpath .. "/schematics/" .. schematic_name,
            rotation = "random",
        })
    end
end

-- Jungle paths (if they exist)
local jungle_check = io.open(modpath .. "/schematics/jungle_dirt_forward_straight_5x5.mts", "r")
if jungle_check then
    jungle_check:close()

    for _, variant in ipairs(path_variants) do
        local schematic_name = "jungle_dirt_" .. variant .. "_5x5.mts"
        local decoration_name = "nativevillages:jungle_path_" .. variant

        local fill_ratio = 0.002
        if variant == "junction" then
            fill_ratio = 0.0005
        elseif variant == "left" or variant == "right" then
            fill_ratio = 0.001
        end

        minetest.register_decoration({
            name = decoration_name,
            deco_type = "schematic",
            place_on = {"default:dirt_with_rainforest_litter"},
            sidelen = 32,
            fill_ratio = fill_ratio,
            noise_params = dense_path_noise,
            biomes = {"rainforest", "rainforest_swamp"},
            y_min = 4,
            y_max = 100,

            place_offset_y = 0,
            flags = "place_center_x, place_center_z, force_placement",

            schematic = modpath .. "/schematics/" .. schematic_name,
            rotation = "random",
        })
    end
end

minetest.log("action", "[nativevillages] Path system loaded with " ..
    (#path_variants * #path_sets) .. " path decorations")
print("[nativevillages] Path system loaded - all variants registered")
