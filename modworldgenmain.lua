local function ConfigEnabled(name)
    local value = GetModConfigData(name)
    return value ~= false and value ~= "off"
end

local RESOURCE_SETPIECE_CONFIGS =
{
    leif_forest = "setpiece_leif_forest",
    spider_forest = "setpiece_spider_forest",
    pigguard_berries = "setpiece_pigguard_berries",
    pigguard_berries_easy = "setpiece_pigguard_berries_easy",
    wasphive_grass_easy = "setpiece_wasphive_grass_easy",
    hound_rocks = "setpiece_hound_rocks",
    tenticle_reeds = "setpiece_tenticle_reeds",
    tallbird_rocks = "setpiece_tallbird_rocks",
    pigguard_grass = "setpiece_pigguard_grass",
    pigguard_grass_easy = "setpiece_pigguard_grass_easy",

    ["Dev Graveyard"] = "setpiece_dev_graveyard",
    ["Sleeping Spider"] = "setpiece_sleeping_spider",
    ["Chilled Base"] = "setpiece_chilled_base",
    ["Rotted Base"] = "setpiece_rotted_base",
    ["Beefalo Farm"] = "setpiece_beefalo_farm",

    skeleton_researchlab1 = "setpiece_skeleton_researchlab1",
    skeleton_researchlab2 = "setpiece_skeleton_researchlab2",
    skeleton_researchlab3 = "setpiece_skeleton_researchlab3",
    skeleton_miner_dirt = "setpiece_skeleton_miner_dirt",
    skeleton_hunter_swamp = "setpiece_skeleton_hunter_swamp",
    skeleton_wizard_ice = "setpiece_skeleton_wizard_ice",
    skeleton_wizard_fire = "setpiece_skeleton_wizard_fire",
}

local function ShouldKeepSetPiece(name)
    local config_name = name ~= nil and RESOURCE_SETPIECE_CONFIGS[name] or nil
    return config_name == nil or ConfigEnabled(config_name)
end

local function RemoveDisabledNamedSetPieces(set_pieces)
    if type(set_pieces) ~= "table" then
        return
    end

    for name in pairs(RESOURCE_SETPIECE_CONFIGS) do
        if not ShouldKeepSetPiece(name) then
            set_pieces[name] = nil
        end
    end
end

local function AddRandomSetPiece(filtered, key, value)
    if type(key) == "number" then
        table.insert(filtered, value)
    else
        filtered[key] = value
    end
end

local function CountRandomSetPieces(random_set_pieces)
    local count = 0
    for key, value in pairs(random_set_pieces) do
        if type(key) == "string" or type(value) == "string" then
            count = count + 1
        end
    end
    return count
end

local function FilterRandomSetPieces(level)
    local random_set_pieces = level.random_set_pieces
    if type(random_set_pieces) ~= "table" then
        return
    end

    local filtered = {}
    local changed = false
    for key, value in pairs(random_set_pieces) do
        local key_disabled = type(key) == "string" and not ShouldKeepSetPiece(key)
        local value_disabled = type(value) == "string" and not ShouldKeepSetPiece(value)
        if key_disabled or value_disabled then
            changed = true
        else
            AddRandomSetPiece(filtered, key, value)
        end
    end

    if changed then
        level.random_set_pieces = filtered
        if type(level.numrandom_set_pieces) == "number" then
            level.numrandom_set_pieces = math.min(level.numrandom_set_pieces, CountRandomSetPieces(filtered))
        end
    end
end

local function FilterTaskSetPieces(task)
    if type(task.set_pieces) ~= "table" then
        return
    end

    local filtered = {}
    for _, data in ipairs(task.set_pieces) do
        if data ~= nil and ShouldKeepSetPiece(data.name) then
            table.insert(filtered, data)
        end
    end

    task.set_pieces = filtered
end

local function ApplyLevelSetPieceConfig(level)
    RemoveDisabledNamedSetPieces(level.set_pieces)
    FilterRandomSetPieces(level)
end

AddLevelPreInitAny(ApplyLevelSetPieceConfig)

if AddTaskPreInitAny ~= nil then
    AddTaskPreInitAny(FilterTaskSetPieces)
end
