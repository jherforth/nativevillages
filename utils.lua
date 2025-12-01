-- utils.lua - Minimal utility functions

-- Empty foundation function - placement parameters handle grounding
-- Foundation filling disabled to prevent floating node artifacts
nativevillages.fill_under_house = function(pos, schematic_filename)
    -- Disabled: Caused floating nodes in air
    -- Buildings are now properly grounded via place_offset_y = 0
    -- and strict height_max = 2 for flat terrain only
end

print("[nativevillages] Utils loaded - foundation filling disabled")
