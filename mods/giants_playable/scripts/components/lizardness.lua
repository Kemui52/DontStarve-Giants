local Lizardness = Class(function(self, inst)
    self.inst = inst
	self.max = 100
    self.current = 0
    self.is_lizard = false
end)


function Lizardness:IsLizard()
    return self.is_lizard
end

function Lizardness:OnSave()    
    return 
    {
	current = self.current,
        is_lizard = self.is_lizard
	}
end

function Lizardness:StopTimeEffect()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

function Lizardness:StartTimeEffect(dt, delta_b)
    if self.task then
        self.task:Cancel()
        self.task = nil
    end

    self.task = self.inst:DoPeriodicTask(dt, function() self:DoDelta(delta_b, true) end)

end

function Lizardness:OnLoad(data)
    if data then
        if data.current then
            self.current = data.current
        end

        if data.is_lizard then
            self.is_lizard = data.is_lizard
        end
    end

    if self.is_lizard then
        if self.makelizard then
            self.makelizard(self.inst)
        end
    else
        if self.makeperson then
             self.makeperson(self.inst)
        end
    end

end

function Lizardness:DoDelta(delta, overtime)
    local oldpercent = self.current/self.max
    self.current = self.current + delta
    
    if self.current < 0 then self.current = 0 end
    if self.current > self.max then self.current = self.max end

    self.inst:PushEvent("lizardnessdelta", {oldpercent = oldpercent, newpercent = self.current/self.max, overtime = overtime})
        
        if self.is_lizard then 
--            if self.current > 50 then
--                GetWorld().components.colourcubemanager:SetOverrideColourCube(nil)
            if self.current > 50 then
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_5_cc.tex")
            elseif self.current > 40 then
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_4_cc.tex")
            elseif self.current > 30 then
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_3_cc.tex")
            elseif self.current > 20 then
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_2_cc.tex")
            elseif self.current > 10 then
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_1_cc.tex")
            else
                GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_cc.tex")
            end
        end

    --if delta ~= 0 then
        if self.is_lizard and self.current <= 0 then
            self.is_lizard = false
            
            if self.onbecomeperson then
                self.onbecomeperson(self.inst)
                self.inst:PushEvent("lizardend")
            end

        elseif not self.is_lizard and self.current >= self.max then
            self.is_lizard = true



            if self.onbecomelizard then
                self.onbecomelizard(self.inst)
                self.inst:PushEvent("lizardstart")
            end
        end
    --end
end

function Lizardness:GetPercent()
    return self.current / self.max
end

function Lizardness:GetDebugString()
    return string.format("%2.2f / %2.2f", self.current, self.max)
end

function Lizardness:SetPercent(percent)
    self.current = self.max*percent
    self:DoDelta(0)
end

return Lizardness
