local function ConfigEnabled(name)
    local value = GetModConfigData(name)
    return value ~= false and value ~= "off"
end

local function CollectLayoutNames(path)
    local names = {}
    local ok, data = pcall(require, path)
    if not ok or type(data) ~= "table" then
        return names
    end

    if type(data.Layouts) == "table" then
        for name in pairs(data.Layouts) do
            names[name] = true
        end
    end

    if type(data.Sandbox) == "table" then
        for _, area in pairs(data.Sandbox) do
            if type(area) == "table" then
                for name in pairs(area) do
                    names[name] = true
                end
            end
        end
    end

    return names
end

local BOON_SETPIECES = CollectLayoutNames("map/boons")
local TRAP_SETPIECES = CollectLayoutNames("map/traps")
local POINT_SETPIECES = CollectLayoutNames("map/pointsofinterest")
local PROTECTED_RESOURCE_SETPIECES = CollectLayoutNames("map/protected_resources")
local current_level = nil

local PRESERVED_SETPIECES =
{
    CaveEntrance = true,
    CaveEntranceRuins = true,
    OceanWhirlBigPortal = true,
    HermitcrabIsland = true,
    MonkeyIsland = true,
    MonkeyIslandSmall = true,
    CrabKing = true,
    MoonAltarRockGlass = true,
    MoonAltarRockIdol = true,
    MoonAltarRockSeed = true,
    BathbombedHotspring = true,
    MoonFissures = true,
}

local function RemoveSetPiecesByNames(set_pieces, names)
    if type(set_pieces) ~= "table" then
        return
    end

    for name in pairs(names) do
        set_pieces[name] = nil
    end
end

local function RememberRandomSetPieces(level)
    local names = {}
    local random_set_pieces = level.random_set_pieces
    if type(random_set_pieces) == "table" then
        for key, value in pairs(random_set_pieces) do
            if type(key) == "string" then
                names[key] = true
            end
            if type(value) == "string" then
                names[value] = true
            end
        end
    end

    level.resource_null_random_setpiece_names = names
end

local function DisableRandomSetPieces(level)
    level.numrandom_set_pieces = 0
    level.random_set_pieces = {}
end

local function ShouldKeepTaskSetPiece(name, level)
    if name == nil then
        return true
    end

    if PRESERVED_SETPIECES[name] then
        return true
    end

    if BOON_SETPIECES[name] then
        return ConfigEnabled("worldgen_boon_setpieces")
    end

    if TRAP_SETPIECES[name] then
        return ConfigEnabled("worldgen_trap_setpieces")
    end

    if POINT_SETPIECES[name] then
        return ConfigEnabled("worldgen_point_setpieces")
    end

    if PROTECTED_RESOURCE_SETPIECES[name] then
        return ConfigEnabled("worldgen_protected_resource_setpieces")
    end

    local random_names = level ~= nil and level.resource_null_random_setpiece_names or nil
    if type(random_names) == "table" and random_names[name] then
        return ConfigEnabled("worldgen_random_setpieces")
    end

    return ConfigEnabled("worldgen_fixed_setpieces")
end

local function FilterTaskSetPieces(task, level)
    if type(task.set_pieces) ~= "table" then
        return
    end

    local filtered = {}
    for _, data in ipairs(task.set_pieces) do
        if data ~= nil and ShouldKeepTaskSetPiece(data.name, level) then
            table.insert(filtered, data)
        end
    end

    task.set_pieces = filtered
end

local function ApplyLevelSetPieceConfig(level)
    current_level = level
    RememberRandomSetPieces(level)

    if not ConfigEnabled("worldgen_random_setpieces") then
        DisableRandomSetPieces(level)
    end

    if not ConfigEnabled("worldgen_boon_setpieces") then
        if level.overrides ~= nil then
            level.overrides.boons = "never"
        end
        RemoveSetPiecesByNames(level.set_pieces, BOON_SETPIECES)
    end

    if not ConfigEnabled("worldgen_trap_setpieces") then
        RemoveSetPiecesByNames(level.set_pieces, TRAP_SETPIECES)
    end

    if not ConfigEnabled("worldgen_point_setpieces") then
        RemoveSetPiecesByNames(level.set_pieces, POINT_SETPIECES)
    end

    if not ConfigEnabled("worldgen_protected_resource_setpieces") then
        RemoveSetPiecesByNames(level.set_pieces, PROTECTED_RESOURCE_SETPIECES)
    end

    if not ConfigEnabled("worldgen_fixed_setpieces") and type(level.set_pieces) == "table" then
        for name in pairs(level.set_pieces) do
            if not ShouldKeepTaskSetPiece(name, level) then
                level.set_pieces[name] = nil
            end
        end
    end
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
                    FilterTaskSetPieces(task, self)
                end
            end

            return tasklist
        end
    end)
end

if AddTaskPreInitAny ~= nil then
    AddTaskPreInitAny(function(task)
        FilterTaskSetPieces(task, current_level)
    end)
end
