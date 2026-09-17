local function ConfigEnabled(name)
    local value = GetModConfigData(name)
    return value ~= false and value ~= "off"
end

local RESOURCE_SETPIECE_CONFIGS =
{
    leif_forest = "setpiece_leif_forest",
    spider_forest = "setpiece_spider_forest",
    pigguard_berries = "setpiece_pigguard_berries",
    pigguard_berries_easy = "setpiece_pigguard_berries",
    wasphive_grass_easy = "setpiece_wasphive_grass",
    hound_rocks = "setpiece_hound_rocks",
    tenticle_reeds = "setpiece_tenticle_reeds",
    tallbird_rocks = "setpiece_tallbird_rocks",
    pigguard_grass = "setpiece_pigguard_grass",
    pigguard_grass_easy = "setpiece_pigguard_grass",

    ["Dev Graveyard"] = "setpiece_dev_graveyard",
    ["Sleeping Spider"] = "setpiece_sleeping_spider",
    ["Chilled Base"] = "setpiece_chilled_base",
    ["Rotted Base"] = "setpiece_rotted_base",
    ["Beefalo Farm"] = "setpiece_beefalo_farm",

    skeleton_researchlab1 = "setpiece_researchlab_plants",
    skeleton_researchlab2 = "setpiece_researchlab_plants",
    skeleton_researchlab3 = "setpiece_researchlab_plants",
    skeleton_miner_dirt = "setpiece_skeleton_miner_dirt",
    skeleton_hunter_swamp = "setpiece_skeleton_hunter_swamp",
    skeleton_wizard_ice = "setpiece_skeleton_wizard_trees",
    skeleton_wizard_fire = "setpiece_skeleton_wizard_trees",

}

local RESOURCE_ROOM_STATIC_LAYOUTS =
{
    SpiderfieldEasyA = { config = "setpiece_spider_blockers", layouts = { SpiderBlockerEasy = true } },
    SpiderfieldEasyB = { config = "setpiece_spider_blockers", layouts = { SpiderBlockerEasyB = true } },
    SpiderfieldA = { config = "setpiece_spider_blockers", layouts = { SpiderBlocker = true } },
    SpiderfieldB = { config = "setpiece_spider_blockers", layouts = { SpiderBlockerB = true } },
    SpiderfieldC = { config = "setpiece_spider_blockers", layouts = { SpiderBlockerC = true } },

    TallbirdfieldSmallA = { config = "setpiece_tallbird_blockers", layouts = { TallbirdBlockerSmall = true } },
    TallbirdfieldA = { config = "setpiece_tallbird_blockers", layouts = { TallbirdBlocker = true } },
    TallbirdfieldB = { config = "setpiece_tallbird_blockers", layouts = { TallbirdBlockerB = true } },

    TentaclelandSmallA = { config = "setpiece_tentacle_blockers", layouts = { TentacleBlockerSmall = true } },
    TentaclelandA = { config = "setpiece_tentacle_blockers", layouts = { TentacleBlocker = true } },
}

local RESOURCE_ROOM_PREFABS =
{
    SpiderfieldEasy = { config = "setpiece_spider_blockers", prefabs = { spiderden = true } },
    Spiderfield = { config = "setpiece_spider_blockers", prefabs = { spiderden = true } },
    Tallbirdfield = { config = "setpiece_tallbird_blockers", prefabs = { tallbirdnest = true } },
    Tentacleland = { config = "setpiece_tentacle_blockers", prefabs = { tentacle = true, pond_mos = true, reeds = true, marsh_bush = true, marsh_tree = true } },
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

local function RemoveNamedKeys(tbl, names)
    if type(tbl) ~= "table" then
        return false
    end

    local changed = false
    for name in pairs(names) do
        if tbl[name] ~= nil then
            tbl[name] = nil
            changed = true
        end
    end

    return changed
end

local function TableIsEmpty(tbl)
    return type(tbl) ~= "table" or next(tbl) == nil
end

local function ApplyRoomStaticLayoutConfig(room, data)
    if ConfigEnabled(data.config) or type(room.contents) ~= "table" then
        return
    end

    RemoveNamedKeys(room.contents.countstaticlayouts, data.layouts)
end

local function ApplyRoomPrefabConfig(room, data)
    if ConfigEnabled(data.config) or type(room.contents) ~= "table" then
        return
    end

    local contents = room.contents
    RemoveNamedKeys(contents.countprefabs, data.prefabs)
    RemoveNamedKeys(contents.distributeprefabs, data.prefabs)
    RemoveNamedKeys(contents.prefabdata, data.prefabs)

    if TableIsEmpty(contents.distributeprefabs) then
        contents.distributepercent = 0
    end
end

local function ApplyLevelSetPieceConfig(level)
    RemoveDisabledNamedSetPieces(level.set_pieces)
    FilterRandomSetPieces(level)
end

AddLevelPreInitAny(ApplyLevelSetPieceConfig)

if AddClassPostConstruct ~= nil then
    AddClassPostConstruct("map/level", function(level)
        if level.resource_null_filter_wrapped then
            return
        end

        level.resource_null_filter_wrapped = true
        local GetTasksForLevel = level.GetTasksForLevel
        level.GetTasksForLevel = function(self, ...)
            local tasklist = GetTasksForLevel(self, ...)
            if type(tasklist) == "table" then
                for _, task in ipairs(tasklist) do
                    FilterTaskSetPieces(task)
                end
            end

            return tasklist
        end
    end)
end

if AddTaskPreInitAny ~= nil then
    AddTaskPreInitAny(FilterTaskSetPieces)
end

if AddRoomPreInit ~= nil then
    for room_name, data in pairs(RESOURCE_ROOM_STATIC_LAYOUTS) do
        local room_data = data
        AddRoomPreInit(room_name, function(room)
            ApplyRoomStaticLayoutConfig(room, room_data)
        end)
    end

    for room_name, data in pairs(RESOURCE_ROOM_PREFABS) do
        local room_data = data
        AddRoomPreInit(room_name, function(room)
            ApplyRoomPrefabConfig(room, room_data)
        end)
    end
end
