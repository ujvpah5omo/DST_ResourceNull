local assets =
{
    Asset("ANIM", "anim/koalefant_tracks.zip"),
    Asset("ANIM", "anim/smoke_puff_small.zip"),
}

local prefabs =
{
    "small_puff",
    "mutatedwarg",
    "resource_null_lunar_warg_claw_track",
}

local WARG_SPAWN_ATTEMPTS = 16
local CLAW_TRACK_COUNT = 4
local CLAW_TRACK_ANGLE_DEVIATION = PI / 7
local DUPLICATE_CLUE_CLEANUP_RADIUS = 36
local LUNAR_RIFT_COLOUR_R = 0.35
local LUNAR_RIFT_COLOUR_G = 0.95
local LUNAR_RIFT_COLOUR_B = 1

local function GetVerb()
    return "INVESTIGATE"
end

local function GetDirectedSpawnPoint(inst)
    if inst.resource_null_lunar_warg_spawn_x ~= nil then
        return Vector3(
            inst.resource_null_lunar_warg_spawn_x,
            inst.resource_null_lunar_warg_spawn_y or 0,
            inst.resource_null_lunar_warg_spawn_z
        )
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local direction = (inst.Transform:GetRotation() + 90) * DEGREES
    local radius = TUNING.HUNT_SPAWN_DIST or 40
    local pt = Vector3(x, y, z)

    for i = 0, WARG_SPAWN_ATTEMPTS - 1 do
        local angle = direction + (i == 0 and 0 or (math.random() * 2 - 1) * PI / 8)
        local offset = FindWalkableOffset(pt, angle, radius, 8, true)
        if offset ~= nil then
            return pt + offset
        end
    end

    return Vector3(
        x + radius * math.cos(direction),
        0,
        z - radius * math.sin(direction)
    )
end

local function TintLunarRift(inst)
    inst.AnimState:SetMultColour(LUNAR_RIFT_COLOUR_R, LUNAR_RIFT_COLOUR_G, LUNAR_RIFT_COLOUR_B, 1)
end

local function RemoveClawTracks(inst)
    local tracks = inst.resource_null_lunar_warg_claw_tracks
    if tracks == nil then
        return
    end

    for _, track in ipairs(tracks) do
        if track ~= nil and track:IsValid() then
            track:Remove()
        end
    end
    inst.resource_null_lunar_warg_claw_tracks = nil
end

local function SpawnClawTracks(inst)
    if inst.Transform == nil then
        return
    end

    RemoveClawTracks(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    local direction = (inst.Transform:GetRotation() + 90) * DEGREES
    local map = TheWorld ~= nil and TheWorld.Map or nil
    local tracks = {}

    for i = 1, CLAW_TRACK_COUNT do
        local track_direction = direction + (math.random() * 2 - 1) * CLAW_TRACK_ANGLE_DEVIATION - PI / 2
        local radius = math.random() + i * 2
        local dx = radius * math.sin(track_direction)
        local dz = radius * math.cos(track_direction)

        if map == nil or map:IsAboveGroundAtPoint(x + dx, y, z + dz) then
            local track = SpawnPrefab("resource_null_lunar_warg_claw_track")
            if track ~= nil then
                track.Transform:SetPosition(x + dx, y, z + dz)
                track.Transform:SetRotation(track_direction / DEGREES)
                track.AnimState:PlayAnimation("clawed" .. math.random(1, 3))
                TintLunarRift(track)
                table.insert(tracks, track)
            end
        end
    end

    inst.resource_null_lunar_warg_claw_tracks = tracks
end

local function RemoveDuplicateClues(inst)
    local x = inst.resource_null_lunar_warg_spawn_x
    local y = inst.resource_null_lunar_warg_spawn_y or 0
    local z = inst.resource_null_lunar_warg_spawn_z
    if x == nil or z == nil then
        x, y, z = inst.Transform:GetWorldPosition()
    end

    local clues = TheSim:FindEntities(
        x,
        y,
        z,
        DUPLICATE_CLUE_CLEANUP_RADIUS,
        { "resource_null_lunar_warg_clue" },
        { "INLIMBO" }
    )
    for _, clue in ipairs(clues) do
        if clue ~= inst and clue:IsValid() then
            clue:Remove()
        end
    end
end

local function OnSave(inst, data)
    data.resource_null_lunar_warg_spawn_x = inst.resource_null_lunar_warg_spawn_x
    data.resource_null_lunar_warg_spawn_y = inst.resource_null_lunar_warg_spawn_y
    data.resource_null_lunar_warg_spawn_z = inst.resource_null_lunar_warg_spawn_z
    data.resource_null_lunar_rift_guid = inst.resource_null_lunar_rift_guid
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end

    inst.resource_null_lunar_warg_spawn_x = data.resource_null_lunar_warg_spawn_x
    inst.resource_null_lunar_warg_spawn_y = data.resource_null_lunar_warg_spawn_y
    inst.resource_null_lunar_warg_spawn_z = data.resource_null_lunar_warg_spawn_z
    inst.resource_null_lunar_rift_guid = data.resource_null_lunar_rift_guid
end

local function OnInvestigated(inst, doer)
    local x, y, z = inst.Transform:GetWorldPosition()
    local spawn_pt = GetDirectedSpawnPoint(inst)

    SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
    RemoveDuplicateClues(inst)
    RemoveClawTracks(inst)
    inst:Remove()

    local warg = SpawnPrefab("mutatedwarg")
    if warg ~= nil then
        if warg.Physics ~= nil then
            warg.Physics:Teleport(spawn_pt:Get())
        else
            warg.Transform:SetPosition(spawn_pt:Get())
        end

        warg:AddTag("resource_null_lunar_warg_fix")
        warg.resource_null_lunar_rift_guid = inst.resource_null_lunar_rift_guid

        if doer ~= nil
            and doer:IsValid()
            and warg.components.combat ~= nil then
            warg.components.combat:SetTarget(doer)
        end
    end

    local worldstate = TheWorld ~= nil and TheWorld.components.resource_null_worldstate or nil
    if worldstate ~= nil then
        worldstate.lunar_warg_clue_used_count = (worldstate.lunar_warg_clue_used_count or 0) + 1
        worldstate:MarkLunarWargRift(inst.resource_null_lunar_rift_guid, "used")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("track")
    inst.AnimState:SetBuild("koalefant_tracks")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:PlayAnimation("idle_pile_tooth")
    TintLunarRift(inst)

    inst:AddTag("dirtpile")
    inst:AddTag("track")
    inst:AddTag("inspectable")
    inst:AddTag("resource_null_lunar_warg_fix")
    inst:AddTag("resource_null_lunar_warg_clue")

    inst.GetActivateVerb = GetVerb

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    local activatable = inst:AddComponent("activatable")
    activatable.OnActivate = OnInvestigated
    activatable.inactive = true

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = RemoveClawTracks
    inst:DoTaskInTime(0, SpawnClawTracks)

    return inst
end

local function clawtrackfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("track")
    inst.AnimState:SetBuild("koalefant_tracks")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:PlayAnimation("clawed1")
    TintLunarRift(inst)

    inst:AddTag("track")
    inst:AddTag("NOCLICK")
    inst:AddTag("resource_null_lunar_warg_fix")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("resource_null_lunar_warg_clue", fn, assets, prefabs),
    Prefab("resource_null_lunar_warg_claw_track", clawtrackfn, assets)
