-- village_grid.lua
-- Grid-based village layout system for cohesive, connected villages

nativevillages = nativevillages or {}

-- Grid configuration
nativevillages.GRID_SIZE = 20  -- Each plot is 20x20 nodes
nativevillages.VILLAGE_RADIUS = 3  -- 3x3 grid (9 plots total)

-- Village registry - tracks generated villages to prevent overlap
local village_centers = {}
local storage = minetest.get_mod_storage()

local function load_villages()
    local data = storage:get_string("village_centers")
    if data and data ~= "" then
        village_centers = minetest.deserialize(data) or {}
    end
end

local save_timer = 0
minetest.register_globalstep(function(dtime)
    save_timer = save_timer + dtime
    if save_timer >= 60 then
        save_timer = 0
        storage:set_string("village_centers", minetest.serialize(village_centers))
    end
end)

load_villages()

-- Check if a position is too close to existing villages
function nativevillages.check_village_spacing(pos)
    local min_distance = nativevillages.GRID_SIZE * nativevillages.VILLAGE_RADIUS * 3
    for _, center in ipairs(village_centers) do
        local dist = vector.distance(pos, center)
        if dist < min_distance then
            return false
        end
    end
    return true
end

-- Register a new village center
function nativevillages.register_village_center(pos)
    table.insert(village_centers, vector.new(pos))
end

-- Get grid position for a world position
function nativevillages.get_grid_pos(world_pos, center_pos)
    local relative = vector.subtract(world_pos, center_pos)
    return {
        x = math.floor(relative.x / nativevillages.GRID_SIZE + 0.5),
        z = math.floor(relative.z / nativevillages.GRID_SIZE + 0.5)
    }
end

-- Convert grid coordinates to world position
function nativevillages.grid_to_world(grid_x, grid_z, center_pos)
    return {
        x = center_pos.x + (grid_x * nativevillages.GRID_SIZE),
        y = center_pos.y,
        z = center_pos.z + (grid_z * nativevillages.GRID_SIZE)
    }
end

-- Check if terrain is suitable for building (relatively flat)
function nativevillages.check_terrain_flatness(pos, radius)
    local heights = {}
    local samples = 5

    for dx = -radius, radius, radius/samples do
        for dz = -radius, radius, radius/samples do
            local check_pos = {x = pos.x + dx, y = pos.y, z = pos.z + dz}
            local surface_y = minetest.find_nodes_in_area_under_air(
                {x=check_pos.x, y=pos.y-5, z=check_pos.z},
                {x=check_pos.x, y=pos.y+30, z=check_pos.z},
                {"group:soil", "default:desert_sand", "default:snowblock"}
            )
            if surface_y and #surface_y > 0 then
                table.insert(heights, surface_y[1].y)
            end
        end
    end

    if #heights < 3 then return false, pos.y end

    -- Calculate average and max deviation
    local sum = 0
    for _, h in ipairs(heights) do
        sum = sum + h
    end
    local avg = sum / #heights

    local max_deviation = 0
    for _, h in ipairs(heights) do
        max_deviation = math.max(max_deviation, math.abs(h - avg))
    end

    -- Terrain is flat enough if deviation is less than 3 nodes
    return max_deviation <= 3, math.floor(avg + 0.5)
end

-- Village layout templates (defines which plots get buildings)
nativevillages.VILLAGE_LAYOUTS = {
    small = {
        {x=0, z=0, type="center"},   -- Central building
        {x=1, z=0, type="house"},
        {x=-1, z=0, type="house"},
        {x=0, z=1, type="house"},
        {x=0, z=-1, type="house"},
    },
    medium = {
        {x=0, z=0, type="center"},
        {x=1, z=0, type="house"},
        {x=-1, z=0, type="house"},
        {x=0, z=1, type="house"},
        {x=0, z=-1, type="house"},
        {x=1, z=1, type="house"},
        {x=-1, z=-1, type="house"},
        {x=1, z=-1, type="path"},
        {x=-1, z=1, type="path"},
    },
    large = {
        {x=0, z=0, type="center"},
        {x=1, z=0, type="house"},
        {x=-1, z=0, type="house"},
        {x=0, z=1, type="house"},
        {x=0, z=-1, type="house"},
        {x=2, z=0, type="house"},
        {x=-2, z=0, type="house"},
        {x=0, z=2, type="house"},
        {x=0, z=-2, type="house"},
        {x=1, z=1, type="house"},
        {x=-1, z=-1, type="house"},
        {x=1, z=-1, type="path"},
        {x=-1, z=1, type="path"},
        {x=2, z=1, type="path"},
        {x=2, z=-1, type="path"},
        {x=-2, z=1, type="path"},
        {x=-2, z=-1, type="path"},
    }
}

print("[nativevillages] Village grid system loaded")
