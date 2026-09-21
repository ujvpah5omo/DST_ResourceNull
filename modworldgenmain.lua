local function ConfigEnabled(name)
    local value = GetModConfigData(name)
    return value ~= false and value ~= "off"
end

local function ConfigRequired(name)
    return GetModConfigData(name) == "required"
end

local function ConfigPriority(name)
    return GetModConfigData(name) == "priority"
end

local FOREST_ONLY_SETPIECES =
{
    CookingBoon = true,
    FishingBoon = true,
    FarmingBoon = true,
    Level2WoodBoon = true,
    Level2RockBoon = true,
    Level2GrassBoon = true,
    skeleton_trapper = true,
    skeleton_entomologist = true,
    skeleton_miner_dirt = true,
    skeleton_miner = true,
    skeleton_camper = true,
    skeleton_construction = true,
    skeleton_night_hunter = true,
    skeleton_rain_coat = true,
    skeleton_winter_hard = true,
}

local BOON_PRIORITY_SETPIECES =
{
    CookingBoon = true,
    FishingBoon = true,
    FarmingBoon = true,
    Level2WoodBoon = true,
    Level2RockBoon = true,
    Level2GrassBoon = true,
}

local POINTSOFINTEREST_PRIORITY_SETPIECES =
{
    skeleton_trapper = true,
    skeleton_entomologist = true,
    skeleton_miner_dirt = true,
    skeleton_miner = true,
    skeleton_camper = true,
    skeleton_construction = true,
    skeleton_night_hunter = true,
    skeleton_rain_coat = true,
    skeleton_winter_hard = true,
}

local RESOURCE_SETPIECE_CONFIGS =
{
    CookingBoon = "boon_cooking",
    FishingBoon = "boon_fishing",
    FarmingBoon = "boon_farming",
    Level2WoodBoon = "boon_level2_wood",
    Level2RockBoon = "boon_level2_rock",
    Level2GrassBoon = "boon_level2_grass",

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

    skeleton_trapper = "setpiece_skeleton_trapper",
    skeleton_entomologist = "setpiece_skeleton_entomologist",
    skeleton_miner = "setpiece_skeleton_miner",
    skeleton_camper = "setpiece_skeleton_camper",
    skeleton_construction = "setpiece_skeleton_construction",
    skeleton_night_hunter = "setpiece_skeleton_night_hunter",
    skeleton_rain_coat = "setpiece_skeleton_rain_coat",
    skeleton_winter_hard = "setpiece_skeleton_winter_hard",
    skeleton_researchlab1 = "setpiece_skeleton_researchlab1",
    skeleton_researchlab2 = "setpiece_skeleton_researchlab2",
    skeleton_researchlab3 = "setpiece_skeleton_researchlab3",
    skeleton_miner_dirt = "setpiece_skeleton_miner_dirt",
    skeleton_hunter_swamp = "setpiece_skeleton_hunter_swamp",
    skeleton_wizard_ice = "setpiece_skeleton_wizard_ice",
    skeleton_wizard_fire = "setpiece_skeleton_wizard_fire",
    skeleton_lightfarmer = "setpiece_skeleton_lightfarmer",

    lures_and_worms = "setpiece_lures_and_worms",
}

local function SetPieceConfigPriority(name)
    local config_name = name ~= nil and RESOURCE_SETPIECE_CONFIGS[name] or nil
    return config_name ~= nil and ConfigPriority(config_name)
end

local function SetPieceConfigRequired(name)
    local config_name = name ~= nil and RESOURCE_SETPIECE_CONFIGS[name] or nil
    return config_name ~= nil and ConfigRequired(config_name)
end

local function SetPieceConfiguredSpecial(name)
    return SetPieceConfigPriority(name) or SetPieceConfigRequired(name)
end

local function AnyPrioritySetPiece(candidates)
    for name in pairs(candidates) do
        if SetPieceConfigPriority(name) then
            return true
        end
    end

    return false
end

local function EnsureLayout(data, name)
    if type(data.Layouts) ~= "table" then
        data.Layouts = {}
    end

    if data.Layouts[name] == nil then
        local StaticLayout = require("map/static_layout")
        data.Layouts[name] = StaticLayout.Get("map/static_layouts/" .. name)
    end

    return data.Layouts[name]
end

local function RemoveSetPieceFromSandbox(sandbox, name)
    if type(sandbox) ~= "table" then
        return
    end

    for _, layouts in pairs(sandbox) do
        if type(layouts) == "table" then
            layouts[name] = nil
        end
    end
end

local function AddPrioritySetPiece(priority_sandbox, area, name, layout)
    if priority_sandbox[area] == nil then
        priority_sandbox[area] = {}
    end

    priority_sandbox[area][name] = layout
end

local function ApplyPrioritySetPiecesFromLayoutSource(path, candidates)
    local has_priority = AnyPrioritySetPiece(candidates)
    local has_special = has_priority
    if not has_special then
        for name in pairs(candidates) do
            if SetPieceConfigRequired(name) then
                has_special = true
                break
            end
        end
    end

    if not has_special then
        return
    end

    local data = require(path)
    if type(data) ~= "table" or type(data.Sandbox) ~= "table" then
        return
    end

    local priority_sandbox = {}
    local added = {}

    for name in pairs(candidates) do
        if SetPieceConfiguredSpecial(name) then
            EnsureLayout(data, name)
        end
        if SetPieceConfigRequired(name) then
            RemoveSetPieceFromSandbox(data.Sandbox, name)
        end
    end

    if not has_priority then
        return
    end

    for area, layouts in pairs(data.Sandbox) do
        if type(layouts) == "table" then
            for name, layout in pairs(layouts) do
                if candidates[name] and SetPieceConfigPriority(name) then
                    AddPrioritySetPiece(priority_sandbox, area, name, layout)
                    added[name] = true
                end
            end
        end
    end

    for name in pairs(candidates) do
        if SetPieceConfigPriority(name) and not added[name] then
            AddPrioritySetPiece(priority_sandbox, "Any", name, EnsureLayout(data, name))
        end
    end

    data.Sandbox = priority_sandbox
end

local function RemoveDisabledSetPiecesFromLayoutSource(path)
    local data = require(path)
    if type(data) ~= "table" then
        return
    end

    for name, config_name in pairs(RESOURCE_SETPIECE_CONFIGS) do
        if not ConfigEnabled(config_name) then
            if type(data.Layouts) == "table" then
                data.Layouts[name] = nil
            end

            if type(data.Sandbox) == "table" then
                for _, area in pairs(data.Sandbox) do
                    if type(area) == "table" then
                        area[name] = nil
                    end
                end
            end
        end
    end
end

local function ShouldKeepSetPiece(name)
    local config_name = name ~= nil and RESOURCE_SETPIECE_CONFIGS[name] or nil
    return config_name == nil or ConfigEnabled(config_name)
end

local function ShouldForceSetPiece(name)
    local config_name = name ~= nil and RESOURCE_SETPIECE_CONFIGS[name] or nil
    return config_name ~= nil and ConfigRequired(config_name)
end

local function SetPieceAllowedOnLevel(level, name)
    return not FOREST_ONLY_SETPIECES[name] or level.location == "forest"
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

local function HasSetPiece(set_pieces, name)
    if type(set_pieces) ~= "table" then
        return false
    end

    for _, value in ipairs(set_pieces) do
        if value == name then
            return true
        end
    end

    return false
end

local function FilterRequiredSetPieces(level)
    if type(level.required_setpieces) ~= "table" then
        return
    end

    local filtered = {}
    local seen = {}
    for _, name in ipairs(level.required_setpieces) do
        if ShouldKeepSetPiece(name) and seen[name] == nil then
            table.insert(filtered, name)
            seen[name] = true
        end
    end

    level.required_setpieces = filtered
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
        local key_required = type(key) == "string" and ShouldForceSetPiece(key) and SetPieceAllowedOnLevel(level, key)
        local value_required = type(value) == "string" and ShouldForceSetPiece(value) and SetPieceAllowedOnLevel(level, value)
        if key_disabled or value_disabled or key_required or value_required then
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

local function AddRequiredSetPieces(level)
    for name, config_name in pairs(RESOURCE_SETPIECE_CONFIGS) do
        if ConfigRequired(config_name) and SetPieceAllowedOnLevel(level, name) then
            local required_setpieces = level.required_setpieces
            if type(required_setpieces) ~= "table" then
                required_setpieces = {}
                level.required_setpieces = required_setpieces
            end

            if not HasSetPiece(required_setpieces, name) then
                table.insert(required_setpieces, name)
            end
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
    FilterRequiredSetPieces(level)
    FilterRandomSetPieces(level)
    AddRequiredSetPieces(level)
    if level.location == "forest" then
        ApplyPrioritySetPiecesFromLayoutSource("map/boons", BOON_PRIORITY_SETPIECES)
        ApplyPrioritySetPiecesFromLayoutSource("map/pointsofinterest", POINTSOFINTEREST_PRIORITY_SETPIECES)
    end
end

RemoveDisabledSetPiecesFromLayoutSource("map/boons")
RemoveDisabledSetPiecesFromLayoutSource("map/traps")
RemoveDisabledSetPiecesFromLayoutSource("map/pointsofinterest")
RemoveDisabledSetPiecesFromLayoutSource("map/protected_resources")

AddLevelPreInitAny(ApplyLevelSetPieceConfig)

if AddTaskPreInitAny ~= nil then
    AddTaskPreInitAny(FilterTaskSetPieces)
end
