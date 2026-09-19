local assets =
{
    Asset("ANIM", "anim/koalefant_tracks.zip"),
    Asset("ANIM", "anim/smoke_puff_small.zip"),
}

local prefabs =
{
    "small_puff",
    "mutatedwarg",
}

local WARG_SPAWN_ATTEMPTS = 16
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
    inst.AnimState:SetMultColour(LUNAR_RIFT_COLOUR_R, LUNAR_RIFT_COLOUR_G, LUNAR_RIFT_COLOUR_B, 1)

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

    return inst
end

return Prefab("resource_null_lunar_warg_clue", fn, assets, prefabs)
