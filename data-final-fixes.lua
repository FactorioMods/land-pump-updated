data:extend({
    {
        type = "collision-layer",
        name = "oa_natural_tiles"
    }
})

local offshore = data.raw["offshore-pump"]["offshore-pump"]
offshore.tile_buildability_rules[2].required_tiles.layers["oa_natural_tiles"] = true
offshore.placeable_position_visualization = nil

local tile_data = data.raw["tile"]

for _, planet in pairs(data.raw["planet"]) do

    if settings.startup["lp-" .. planet.name] == false then break end

    local tiles = nil
    local dry_tiles = {}
    local fluid = "water"

    pcall(function() tiles = planet.map_gen_settings.autoplace_settings.tile.settings end)
    if not tiles then return end

    for tile_name, _ in pairs(tiles) do
        local tile = tile_data[tile_name]
        if not tile then break end

        if tile.fluid then
            fluid = tile.fluid
        else
            dry_tiles[tile_name] = tile
        end
    end

    for _, tile in pairs(dry_tiles) do
        tile.fluid = fluid
        tile.collision_mask.layers["oa_natural_tiles"] = true
    end
end
