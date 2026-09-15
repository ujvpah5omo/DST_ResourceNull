local _G = GLOBAL

PrefabFiles =
{
    "resource_null_lunar_warg_clue",
}

_G.STRINGS.NAMES.RESOURCE_NULL_LUNAR_WARG_CLUE = "月化踪迹"
_G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.RESOURCE_NULL_LUNAR_WARG_CLUE = "这些痕迹不该出现在这里。"

local WORLD_SCAN_RADIUS = 10000
local METEOR_SPAWNER_POINT_ATTEMPTS = 80
local METEOR_SPAWNER_SEARCH_RADIUS = 48
local SPAWN_FALLBACK_RELOCATE_DISTANCE_SQ = 20 * 20
local CELESTIAL_ORB_METEOR_TIMEOUT = 120

local LUNAR_ISLAND_NODE_TAGS =
{
    "lunacy",
    "lunacyarea",
    "lunarisland",
    "moonisland",
    "moon_island",
}

local LIGHTNING_GOAT_HUNT_CHANCES =
{
    never = 0,
    none = 0,
    rare = 0.10,
    default = 0.25,
    often = 0.50,
    always = 1,
}

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
    local names = { ... }
    for _, name in ipairs(names) do
        if IsNeverValue(GetOverride(name)) then
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

local function GetLightningGoatHuntChance()
    local value = GetOverride("lightninggoat")
    if type(value) == "number" then
        return math.max(0, math.min(1, value))
    end

    return LIGHTNING_GOAT_HUNT_CHANCES[value] or LIGHTNING_GOAT_HUNT_CHANCES.default
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

local function GetDistanceSqToSpawnAnchor(x, z)
    local anchor = FindSpawnAnchor()
    if anchor == nil or anchor.Transform == nil then
        return 0
    end

    local anchor_x, _, anchor_z = anchor.Transform:GetWorldPosition()
    local dx = x - anchor_x
    local dz = z - anchor_z
    return dx * dx + dz * dz
end

local function RememberMeteorSpawnerPoint(x, y, z)
    local world = _G.TheWorld
    if world == nil or x == nil or z == nil then
        return
    end

    if math.abs(x) < 1 and math.abs(z) < 1 then
        return
    end

    local points = world.resource_null_meteorspawner_points
    if points == nil then
        points = {}
        world.resource_null_meteorspawner_points = points
    end

    for _, point in ipairs(points) do
        local dx = point.x - x
        local dz = point.z - z
        if dx * dx + dz * dz < 4 then
            return
        end
    end

    table.insert(points, { x = x, y = y or 0, z = z })
end

local function RememberMeteorSpawner(inst)
    if inst == nil or inst.Transform == nil then
        return
    end

    local function remember()
        if inst.Transform ~= nil then
            RememberMeteorSpawnerPoint(inst.Transform:GetWorldPosition())
        end
    end

    remember()
    inst:DoTaskInTime(0, remember)
    inst:ListenForEvent("onremove", remember)
end

local function IsMeteorTile(tile)
    return _G.WORLD_TILES ~= nil
        and _G.WORLD_TILES.METEOR ~= nil
        and tile == _G.WORLD_TILES.METEOR
end

local function NodeHasTag(node, tag)
    local tags = node ~= nil and node.tags or nil
    if type(tags) ~= "table" then
        return false
    end

    for _, node_tag in ipairs(tags) do
        if type(node_tag) == "string" and string.lower(node_tag) == tag then
            return true
        end
    end

    for node_tag, value in pairs(tags) do
        if value and type(node_tag) == "string" and string.lower(node_tag) == tag then
            return true
        end
    end

    return false
end

local function PointHasVisualNodeTag(map, x, y, z, tag)
    if map == nil or map.FindVisualNodeAtPoint == nil then
        return false
    end

    return map:FindVisualNodeAtPoint(x, y, z, tag) ~= nil
end

local function PointHasTopologyNodeTag(map, x, y, z, tag)
    if map == nil or map.FindNodeAtPoint == nil then
        return false
    end

    local node_index = map:FindNodeAtPoint(x, y, z)
    if node_index == nil then
        return false
    end

    local node = type(node_index) == "table"
        and node_index
        or (_G.TheWorld ~= nil
            and _G.TheWorld.topology ~= nil
            and _G.TheWorld.topology.nodes ~= nil
            and _G.TheWorld.topology.nodes[node_index]
            or nil)

    return NodeHasTag(node, tag)
end

local function IsLunarIslandPoint(x, y, z)
    local map = _G.TheWorld ~= nil and _G.TheWorld.Map or nil
    if map == nil then
        return false
    end

    for _, tag in ipairs(LUNAR_ISLAND_NODE_TAGS) do
        if PointHasVisualNodeTag(map, x, y, z, tag)
            or PointHasTopologyNodeTag(map, x, y, z, tag) then
            return true
        end
    end

    return false
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

local function IsMainlandMeteorPoint(map, x, y, z)
    return IsMeteorTile(map:GetTileAtPoint(x, y, z))
        and IsWalkablePoint(x, y, z)
        and not IsLunarIslandPoint(x, y, z)
end

local function IsNonLunarWalkablePoint(x, y, z)
    return IsWalkablePoint(x, y, z)
        and not IsLunarIslandPoint(x, y, z)
end

local function FindMeteorPointNearPosition(spawner_x, spawner_y, spawner_z, map)
    if spawner_x == nil or spawner_z == nil or map == nil then
        return nil
    end

    spawner_y = spawner_y or 0

    if IsMainlandMeteorPoint(map, spawner_x, spawner_y, spawner_z) then
        return spawner_x, spawner_y, spawner_z
    end

    for _ = 1, METEOR_SPAWNER_POINT_ATTEMPTS do
        local radius = math.random() * METEOR_SPAWNER_SEARCH_RADIUS
        local angle = math.random() * _G.TWOPI
        local offset = _G.FindWalkableOffset(_G.Vector3(spawner_x, spawner_y, spawner_z), angle, radius, 24, true, false)
        local x = offset ~= nil and spawner_x + offset.x or spawner_x + math.cos(angle) * radius
        local z = offset ~= nil and spawner_z + offset.z or spawner_z + math.sin(angle) * radius

        if IsMainlandMeteorPoint(map, x, 0, z) then
            return x, 0, z
        end
    end

    for _ = 1, METEOR_SPAWNER_POINT_ATTEMPTS do
        local radius = 4 + math.random() * 12
        local angle = math.random() * _G.TWOPI
        local offset = _G.FindWalkableOffset(_G.Vector3(spawner_x, spawner_y, spawner_z), angle, radius, 24, true, false)
        local x = offset ~= nil and spawner_x + offset.x or spawner_x + math.cos(angle) * radius
        local z = offset ~= nil and spawner_z + offset.z or spawner_z + math.sin(angle) * radius

        if IsNonLunarWalkablePoint(x, 0, z) then
            return x, 0, z
        end
    end

    return spawner_x, spawner_y, spawner_z
end

local function FindMeteorPointNearSpawner(spawner, map)
    if spawner == nil or spawner.Transform == nil then
        return nil
    end

    local spawner_x, spawner_y, spawner_z = spawner.Transform:GetWorldPosition()
    return FindMeteorPointNearPosition(spawner_x, spawner_y, spawner_z, map)
end

local function FindMeteorSpawnerPoint()
    local map = _G.TheWorld ~= nil and _G.TheWorld.Map or nil
    if map == nil then
        return nil
    end

    local candidates = {}
    local entities = _G.TheSim:FindEntities(0, 0, 0, WORLD_SCAN_RADIUS, nil, { "INLIMBO" })
    for _, ent in ipairs(entities) do
        if ent.prefab == "meteorspawner" then
            local spawner_x, _, spawner_z = ent.Transform:GetWorldPosition()
            RememberMeteorSpawnerPoint(ent.Transform:GetWorldPosition())
            table.insert(candidates, {
                spawner = ent,
                x = spawner_x,
                y = 0,
                z = spawner_z,
                distance_sq = GetDistanceSqToSpawnAnchor(spawner_x, spawner_z),
                lunar = IsLunarIslandPoint(spawner_x, 0, spawner_z),
            })
        end
    end

    local remembered_points = _G.TheWorld ~= nil and _G.TheWorld.resource_null_meteorspawner_points or nil
    if remembered_points ~= nil then
        for _, point in ipairs(remembered_points) do
            table.insert(candidates, {
                x = point.x,
                y = point.y or 0,
                z = point.z,
                distance_sq = GetDistanceSqToSpawnAnchor(point.x, point.z),
                lunar = IsLunarIslandPoint(point.x, point.y or 0, point.z),
            })
        end
    end

    table.sort(candidates, function(a, b)
        if a.lunar ~= b.lunar then
            return not a.lunar
        end

        return a.distance_sq < b.distance_sq
    end)

    for _, candidate in ipairs(candidates) do
        local x, y, z
        if candidate.spawner ~= nil then
            x, y, z = FindMeteorPointNearSpawner(candidate.spawner, map)
        else
            x, y, z = FindMeteorPointNearPosition(candidate.x, candidate.y, candidate.z, map)
        end

        if x ~= nil then
            return x, 0, z
        end
    end
end

local function CelestialOrbCompensationIsEnabled()
    local mode = GetModConfigData("celestial_orb_compensation")
    if mode == false or mode == "off" or IsCave() then
        return false
    end

    return true
end

local function ShouldCompensateCelestialOrb()
    if not CelestialOrbCompensationIsEnabled() then
        return false
    end

    return MeteorsAreDisabled()
end

local function MarkCelestialOrbDone(state)
    state.celestial_orb_spawned = true
    state.celestial_orb_pending = false
    if _G.TheWorld.components.worldmeteorshower ~= nil then
        _G.TheWorld.components.worldmeteorshower.moonrockshell_chance = 1
    end
end

local function FindCelestialOrbEntry(prefabs)
    return FindEntityByPrefab(prefabs or {
        moonrockseed = true,
        rock_moon_shell = true,
    })
end

local function HasCelestialOrbEntry()
    return FindCelestialOrbEntry() ~= nil
end

local function GetDistanceSqToSpawnAnchorForEntity(ent)
    if ent == nil or ent.Transform == nil then
        return nil
    end

    local x, _, z = ent.Transform:GetWorldPosition()
    return GetDistanceSqToSpawnAnchor(x, z)
end

local function RelocateSpawnFallbackRockMoonShell()
    local shell = FindCelestialOrbEntry({ rock_moon_shell = true })
    local shell_distance_sq = GetDistanceSqToSpawnAnchorForEntity(shell)
    if shell_distance_sq == nil or shell_distance_sq > SPAWN_FALLBACK_RELOCATE_DISTANCE_SQ then
        return false
    end

    local x, y, z = FindMeteorSpawnerPoint()
    if x == nil or GetDistanceSqToSpawnAnchor(x, z) <= SPAWN_FALLBACK_RELOCATE_DISTANCE_SQ then
        return false
    end

    shell.Transform:SetPosition(x, y or 0, z)
    return true
end

local function SpawnFallbackRockMoonShell()
    local x, y, z = FindMeteorSpawnerPoint()
    if x == nil then
        local anchor = FindSpawnAnchor()
        if anchor == nil or anchor.Transform == nil then
            return false
        end

        x, y, z = FindSpawnPointNear(anchor, 5, 9)
    end

    local shell = _G.SpawnPrefab("rock_moon_shell")
    if shell == nil then
        return false
    end

    shell.Transform:SetPosition(x, y, z)

    return true
end

local function StartCelestialOrbPending(state)
    state.celestial_orb_pending = true
    _G.TheWorld:DoTaskInTime(CELESTIAL_ORB_METEOR_TIMEOUT, function()
        local current_state = GetWorldState()
        if current_state ~= nil
            and current_state.celestial_orb_pending
            and not HasCelestialOrbEntry() then
            current_state.celestial_orb_pending = false
        end
    end)
end

local function SpawnCelestialOrbCompensation()
    local state = GetWorldState()
    if state == nil or not ShouldCompensateCelestialOrb() then
        return
    end

    RelocateSpawnFallbackRockMoonShell()

    if state.celestial_orb_spawned or HasCelestialOrbEntry() then
        MarkCelestialOrbDone(state)
        return
    end

    if state.celestial_orb_pending then
        return
    end

    if SpawnFallbackRockMoonShell() then
        StartCelestialOrbPending(state)
    end
end

local function OnCelestialOrbEntryExists()
    local state = GetWorldState()
    if state ~= nil and CelestialOrbCompensationIsEnabled() then
        MarkCelestialOrbDone(state)
    end
end

local function ShouldSpawnLunarWargClue()
    local mode = GetModConfigData("lunar_warg_compensation")
    return mode ~= false and mode ~= "off" and not IsCave()
end

local function ForEachLunarRiftPortal(fn)
    local entities = _G.TheSim:FindEntities(0, 0, 0, WORLD_SCAN_RADIUS, nil, { "INLIMBO" })
    for _, ent in ipairs(entities) do
        if ent.prefab == "lunarrift_portal" then
            fn(ent)
        end
    end
end

local function RemoveLiveLunarWargForRift(rift_guid)
    local entities = _G.TheSim:FindEntities(0, 0, 0, WORLD_SCAN_RADIUS, { "resource_null_lunar_warg_fix" }, { "INLIMBO" })
    for _, ent in ipairs(entities) do
        if ent.prefab == "mutatedwarg"
            and ent.resource_null_lunar_rift_guid == rift_guid
            and ent.components.health ~= nil
            and not ent.components.health:IsDead() then
            ent:Remove()
        end
    end
end

local function SpawnLunarWargClueNear(anchor)
    local state = GetWorldState()
    if anchor == nil
        or anchor.Transform == nil
        or anchor.resource_null_lunar_warg_clue_done
        or state == nil
        or state:IsLunarWargRiftDone(anchor.GUID)
        or not ShouldSpawnLunarWargClue() then
        return
    end

    local x, y, z = FindSpawnPointNear(anchor, 10, 18)
    local clue = _G.SpawnPrefab("resource_null_lunar_warg_clue")
    if clue ~= nil then
        anchor.resource_null_lunar_warg_clue_done = true
        clue.Transform:SetPosition(x, y, z)
        clue:FacePoint(anchor.Transform:GetWorldPosition())
        clue.resource_null_lunar_warg_spawn_x,
        clue.resource_null_lunar_warg_spawn_y,
        clue.resource_null_lunar_warg_spawn_z = anchor.Transform:GetWorldPosition()
        clue.resource_null_lunar_rift_guid = anchor.GUID
        anchor.resource_null_lunar_warg_clue = clue
        state:MarkLunarWargRift(anchor.GUID, "spawned")

        anchor:ListenForEvent("onremove", function()
            if clue:IsValid() then
                clue:Remove()
            end
            RemoveLiveLunarWargForRift(anchor.GUID)
            state:ClearLunarWargRift(anchor.GUID)
        end)

        clue:ListenForEvent("onremove", function()
            if anchor:IsValid() and anchor.resource_null_lunar_warg_clue == clue then
                anchor.resource_null_lunar_warg_clue = nil
            end
        end)

        state.lunar_warg_clue_spawned_count = (state.lunar_warg_clue_spawned_count or 0) + 1
    end
end

local function SpawnLunarWargClue()
    ForEachLunarRiftPortal(SpawnLunarWargClueNear)
end

AddPrefabPostInit("lunarrift_portal", function(inst)
    if not IsMasterSim() then
        return
    end

    inst:DoTaskInTime(3, function()
        SpawnLunarWargClueNear(inst)
    end)
end)

for _, prefab in ipairs({ "moonrockseed", "rock_moon_shell" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not IsMasterSim() then
            return
        end

        inst:DoTaskInTime(0, OnCelestialOrbEntryExists)
    end)
end

AddPrefabPostInit("meteorspawner", function(inst)
    if IsMasterSim() then
        RememberMeteorSpawner(inst)
    end
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
    if not GetModConfigData("beefalo_hunt_surprise")
        or _G.TheWorld == nil
        or not _G.TheWorld.state.isspring
        or not _G.TheWorld.state.israining
        or math.random() >= GetLightningGoatHuntChance() then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if not IsSavannaPoint(x, y, z) then
        return
    end

    inst:Remove()
    local beefalo = SpawnBeefaloAt(x, y, z)
    if beefalo ~= nil then
        beefalo:PushEvent("spawnedforhunt", data)
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
