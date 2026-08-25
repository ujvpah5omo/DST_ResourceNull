local _G = GLOBAL

PrefabFiles =
{
    "resource_null_lunar_warg_clue",
}

_G.STRINGS.NAMES.RESOURCE_NULL_LUNAR_WARG_CLUE = "月化踪迹"
_G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.RESOURCE_NULL_LUNAR_WARG_CLUE = "这些痕迹不该出现在这里。"

_G.TUNING.RESOURCE_NULL_FIX_DISABLE_LUNAR_WARG_SUMMONS =
    GetModConfigData("lunar_warg_disable_summons")

local WORLD_SCAN_RADIUS = 10000
local METEOR_TILE_ATTEMPTS = 1500

local function IsMasterSim()
    return _G.TheWorld ~= nil and _G.TheWorld.ismastersim
end

local function IsCave()
    return _G.TheWorld ~= nil and _G.TheWorld:HasTag("cave")
end

local function GetWorldState()
    local world = _G.TheWorld
    return world ~= nil and world.components.resource_null_worldstate or nil
end

local function GetOverride(name)
    local world = _G.TheWorld
    local overrides = world ~= nil
        and world.topology ~= nil
        and world.topology.overrides
        or nil

    return overrides ~= nil and overrides[name] or nil
end

local function IsNeverValue(value)
    return value == "never" or value == "none" or value == false or value == 0
end

local function AnyOverrideIsNever(...)
    for i = 1, select("#", ...) do
        if IsNeverValue(GetOverride(select(i, ...))) then
            return true
        end
    end

    return false
end

local function MeteorsAreDisabled()
    if AnyOverrideIsNever("meteorshowers", "meteorspawner") then
        return true
    end

    local tuning = _G.TUNING
    return tuning.METEORSHOWER_BASEDELAY ~= nil
        and tuning.METEORSHOWER_BASEDELAY < 0
end

local function HuntsAreDisabled()
    return AnyOverrideIsNever("hunt", "alternatehunt")
        or _G.TUNING.HUNT_ENABLED == false
end

local function FindEntityByPrefab(prefabs)
    local entities = _G.TheSim:FindEntities(0, 0, 0, WORLD_SCAN_RADIUS, nil, { "INLIMBO" })
    for _, ent in ipairs(entities) do
        if prefabs[ent.prefab] then
            return ent
        end
    end
end

local function FindSpawnAnchor()
    return FindEntityByPrefab({
            multiplayer_portal = true,
            multiplayer_portal_moonrock = true,
        })
        or _G.AllPlayers[1]
        or _G.TheWorld
end

local function FindSpawnPointNear(anchor, min_radius, max_radius)
    local x, y, z = anchor.Transform:GetWorldPosition()
    local radius = min_radius + math.random() * (max_radius - min_radius)
    local offset = _G.FindWalkableOffset(_G.Vector3(x, y, z), math.random() * _G.TWOPI, radius, 24, true, false)

    if offset ~= nil then
        return x + offset.x, 0, z + offset.z
    end

    return x, y, z
end

local function IsMeteorTile(tile)
    return _G.WORLD_TILES ~= nil
        and _G.WORLD_TILES.METEOR ~= nil
        and tile == _G.WORLD_TILES.METEOR
end

local function IsWalkablePoint(x, y, z)
    local map = _G.TheWorld ~= nil and _G.TheWorld.Map or nil
    if map == nil then
        return false
    end

    if map.IsPassableAtPoint ~= nil then
        return map:IsPassableAtPoint(x, y, z)
    end

    return not map:IsOceanAtPoint(x, y, z)
end

local function FindMeteorTilePoint()
    local map = _G.TheWorld ~= nil and _G.TheWorld.Map or nil
    if map == nil or map.GetSize == nil then
        return nil
    end

    local width, height = map:GetSize()
    local scale = _G.TILE_SCALE or 4

    for _ = 1, METEOR_TILE_ATTEMPTS do
        local x = (math.random() * width - width * 0.5) * scale
        local z = (math.random() * height - height * 0.5) * scale

        if IsMeteorTile(map:GetTileAtPoint(x, 0, z)) and IsWalkablePoint(x, 0, z) then
            return x, 0, z
        end
    end

    local spawner = FindEntityByPrefab({ meteorspawner = true })
    if spawner ~= nil and spawner.Transform ~= nil then
        local x, y, z = FindSpawnPointNear(spawner, 4, 12)
        if IsMeteorTile(map:GetTileAtPoint(x, y, z)) then
            return x, y, z
        end
    end
end

local function ShouldCompensateCelestialOrb()
    local mode = GetModConfigData("celestial_orb_compensation")
    if mode == "off" or IsCave() then
        return false
    end

    return mode == "always_boulder"
        or MeteorsAreDisabled()
end

local function SpawnCelestialOrbCompensation()
    local state = GetWorldState()
    if state == nil or state.celestial_orb_spawned or not ShouldCompensateCelestialOrb() then
        return
    end

    local x, y, z = FindMeteorTilePoint()
    if x == nil then
        return
    end

    local ent = _G.SpawnPrefab("rock_moon_shell")

    if ent ~= nil then
        ent.Transform:SetPosition(x, y, z)
        state.celestial_orb_spawned = true
    end
end

local function LunarRiftIsActive()
    local world = _G.TheWorld
    local riftspawner = world ~= nil and world.components.riftspawner or nil

    if riftspawner ~= nil then
        if riftspawner.IsLunarPortalActive ~= nil and riftspawner:IsLunarPortalActive() then
            return true
        end
        if riftspawner.IsLunarRiftActive ~= nil and riftspawner:IsLunarRiftActive() then
            return true
        end
    end

    return FindEntityByPrefab({ lunarrift_portal = true }) ~= nil
end

local function MutatedWargIsDefeated()
    local world = _G.TheWorld
    local manager = world ~= nil and world.components.lunarriftmutationsmanager or nil
    return manager ~= nil
        and manager.HasDefeatedThisMutation ~= nil
        and manager:HasDefeatedThisMutation("mutatedwarg")
end

local function HasExistingLunarWargFixEntity()
    local entities = _G.TheSim:FindEntities(0, 0, 0, WORLD_SCAN_RADIUS, { "resource_null_lunar_warg_fix" }, { "INLIMBO" })
    return #entities > 0
end

local function ShouldSpawnLunarWargClue()
    local mode = GetModConfigData("lunar_warg_compensation")
    if mode == "off" or IsCave() then
        return false
    end

    if mode == "auto_clue" and not HuntsAreDisabled() then
        return false
    end

    return LunarRiftIsActive()
        and not MutatedWargIsDefeated()
        and not HasExistingLunarWargFixEntity()
end

local function FindLunarRiftAnchor()
    return FindEntityByPrefab({ lunarrift_portal = true })
end

local function SpawnLunarWargClueNear(anchor)
    local state = GetWorldState()
    if state == nil or not ShouldSpawnLunarWargClue() then
        return
    end

    if anchor == nil or anchor.Transform == nil then
        return
    end

    local x, y, z = FindSpawnPointNear(anchor, 10, 18)
    local clue = _G.SpawnPrefab("resource_null_lunar_warg_clue")
    if clue ~= nil then
        clue.Transform:SetPosition(x, y, z)
        clue:FacePoint(anchor.Transform:GetWorldPosition())
        clue.resource_null_lunar_warg_spawn_x,
        clue.resource_null_lunar_warg_spawn_y,
        clue.resource_null_lunar_warg_spawn_z = anchor.Transform:GetWorldPosition()
        state.lunar_warg_clue_spawned_count = (state.lunar_warg_clue_spawned_count or 0) + 1
    end
end

local function SpawnLunarWargClue()
    SpawnLunarWargClueNear(FindLunarRiftAnchor())
end

local function DisableWargSummonsIfNeeded(inst)
    if inst:HasTag("resource_null_lunar_warg_fix")
        and GetModConfigData("lunar_warg_disable_summons") then
        inst.NumHoundsToSpawn = function()
            return 0
        end
    end
end

AddPrefabPostInit("mutatedwarg", function(inst)
    if not IsMasterSim() then
        return
    end

    inst:DoTaskInTime(0, DisableWargSummonsIfNeeded)
end)

AddPrefabPostInit("lunarrift_portal", function(inst)
    if not IsMasterSim() then
        return
    end

    inst:DoTaskInTime(3, function()
        SpawnLunarWargClueNear(inst)
    end)
end)

local function IsSavannaPoint(x, y, z)
    return _G.TheWorld ~= nil
        and _G.TheWorld.Map ~= nil
        and _G.TheWorld.Map:GetTileAtPoint(x, y, z) == _G.WORLD_TILES.SAVANNA
end

local function SpawnBeefaloAt(x, y, z)
    local beefalo = _G.SpawnPrefab("beefalo")
    if beefalo ~= nil then
        beefalo.Transform:SetPosition(x, y, z)
    end

    return beefalo
end

local function TryBeefaloHuntSurprise(inst, data)
    local mode = GetModConfigData("beefalo_hunt_surprise")
    if mode == "off"
        or _G.TheWorld == nil
        or not _G.TheWorld.state.isspring
        or not _G.TheWorld.state.israining
        or math.random() >= GetModConfigData("beefalo_hunt_chance") then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if not IsSavannaPoint(x, y, z) then
        return
    end

    if mode == "replace" then
        inst:Remove()
        local beefalo = SpawnBeefaloAt(x, y, z)
        if beefalo ~= nil then
            beefalo:PushEvent("spawnedforhunt", data)
        end
    elseif mode == "add" then
        local beefalo = SpawnBeefaloAt(x + 2, y, z + 2)
        if beefalo ~= nil then
            beefalo:PushEvent("spawnedforhunt", data)
        end
    end
end

for _, prefab in ipairs({ "koalefant_summer", "koalefant_winter" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not IsMasterSim() then
            return
        end

        inst:ListenForEvent("spawnedforhunt", TryBeefaloHuntSurprise)
    end)
end

AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then
        return
    end

    if inst.components.resource_null_worldstate == nil then
        inst:AddComponent("resource_null_worldstate")
    end

    inst:DoTaskInTime(2, SpawnCelestialOrbCompensation)
    inst:DoPeriodicTask(30, SpawnCelestialOrbCompensation)
    inst:DoTaskInTime(10, SpawnLunarWargClue)
    inst:DoPeriodicTask(60, SpawnLunarWargClue)
end)
