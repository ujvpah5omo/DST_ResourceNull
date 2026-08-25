local ResourceNullWorldState = Class(function(self, inst)
    self.inst = inst
    self.celestial_orb_spawned = false
    self.lunar_warg_clue_spawned_count = 0
    self.lunar_warg_clue_used_count = 0
end)

function ResourceNullWorldState:OnSave()
    return
    {
        celestial_orb_spawned = self.celestial_orb_spawned,
        lunar_warg_clue_spawned_count = self.lunar_warg_clue_spawned_count,
        lunar_warg_clue_used_count = self.lunar_warg_clue_used_count,
    }
end

function ResourceNullWorldState:OnLoad(data)
    if data == nil then
        return
    end

    self.celestial_orb_spawned = data.celestial_orb_spawned or false
    self.lunar_warg_clue_spawned_count = data.lunar_warg_clue_spawned_count or 0
    self.lunar_warg_clue_used_count = data.lunar_warg_clue_used_count or 0
end

return ResourceNullWorldState
