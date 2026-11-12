data:extend({{type = "collision-layer", name = "oa_natural_tiles"}})

local offshore = data.raw["offshore-pump"]["offshore-pump"]
offshore.tile_buildability_rules[2].required_tiles.layers.oa_natural_tiles = true
offshore.placeable_position_visualization = nil

for _, planet in pairs(data.raw.planet) do
    local setting = settings.startup["lp-" .. planet.name]
    local map_gen = planet.map_gen_settings
    local autoplace = map_gen and map_gen.autoplace_settings
    local tiles = autoplace and autoplace.tile and autoplace.tile.settings
    -- A disabled or non-generated planet must not stop processing other planets.
    if (not setting or setting.value) and tiles then
        local dry_tiles = {}
        local fluid = "water"
        for tile_name in pairs(tiles) do
            local tile = data.raw.tile[tile_name]
            if tile then
                if tile.fluid then
                    fluid = tile.fluid
                else
                    dry_tiles[#dry_tiles + 1] = tile
                end
            end
        end
        for _, tile in pairs(dry_tiles) do
            tile.fluid = fluid
            tile.collision_mask.layers.oa_natural_tiles = true
        end
    end
end
