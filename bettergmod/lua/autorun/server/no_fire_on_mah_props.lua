local NextMainThink = 0
local function DeleteThisBetch(v)
    if v:IsOnFire() then
        local phys = v:GetPhysicsObject()
        if IsValid(phys) then
            local mat = phys:GetMaterial()
            if (mat:find("metal") or mat:find("concrete") or mat:find("rock") or mat:find("plaster")) and not (mat:find("barrel") or mat:find("wood")) then v:Extinguish() end
        end
    end
end

hook.Add(
    "Think",
    "RemoveOurFires",
    function()
        local Time = CurTime()
        if NextMainThink > Time then return end
        NextMainThink = Time + 0.5
        for k, v in pairs(ents.FindByClass("prop_*")) do
            DeleteThisBetch(v)
        end
    end
)

hook.Add(
    "PlayerSpawn",
    "Fckin_Gbombs",
    function(v)
        v:Extinguish()
        timer.Simple(
            0,
            function()
                if not IsValid(v) then return end
                v:Extinguish()
            end
        )
    end
)
--[[ -- fire keeps pulsing with this
hook.Add( "EntityTakeDamage", "RemoveOurFires", function(v,dmginfo)
	if v:GetClass() == "prop_physics" then
		DeleteThisBetch(v)
	end
end)
]]