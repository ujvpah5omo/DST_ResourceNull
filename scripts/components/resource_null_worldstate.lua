local ResourceNullWorldState = Class(function(self, inst)
    self.inst = inst
    self.celestial_orb_spawned = false
    self.lunar_warg_clue_spawned_count = 0
    self.lunar_warg_clue_used_count = 0
    self.lunar_warg_rifts = {}
end)

local function GetRiftKey(rift_guid)
    return rift_guid ~= nil and tostring(rift_guid) or nil
end

function ResourceNullWorldState:IsLunarWargRiftDone(rift_guid)
    local key = GetRiftKey(rift_guid)
    return key ~= nil and self.lunar_warg_rifts[key] ~= nil
end

function ResourceNullWorldState:MarkLunarWargRift(rift_guid, state)
    local key = GetRiftKey(rift_guid)
    if key ~= nil then
        self.lunar_warg_rifts[key] = state or true
    end
end

function ResourceNullWorldState:ClearLunarWargRift(rift_guid)
    local key = GetRiftKey(rift_guid)
    if key ~= nil then
        self.lunar_warg_rifts[key] = nil
    end
end

function ResourceNullWorldState:OnSave()
    return
    {
        celestial_orb_spawned = self.celestial_orb_spawned,
        lunar_warg_clue_spawned_count = self.lunar_warg_clue_spawned_count,
        lunar_warg_clue_used_count = self.lunar_warg_clue_used_count,
        lunar_warg_rifts = self.lunar_warg_rifts,
    }
end

function ResourceNullWorldState:OnLoad(data)
    if data == nil then
        return
    end

    self.celestial_orb_spawned = data.celestial_orb_spawned or false
    self.lunar_warg_clue_spawned_count = data.lunar_warg_clue_spawned_count or 0
    self.lunar_warg_clue_used_count = data.lunar_warg_clue_used_count or 0
    self.lunar_warg_rifts = data.lunar_warg_rifts or {}
end

return ResourceNullWorldState
