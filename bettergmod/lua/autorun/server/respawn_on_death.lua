LastPos = {}
IsDead = {}
RespawnLast = {}
Toggle = true
concommand.Add(
    "respawn_on_death",
    function(ply, cmd, args)
        if ply:IsSuperAdmin() then
            Toggle = not Toggle
        else
            print("You are not allowed to use this command.")
        end

        print(Toggle)
    end
)

hook.Add(
    "KeyPress",
    "keypress",
    function(ply, key)
        local ID = ply:UserID()
        if key == IN_ATTACK2 then
            if IsDead[ID] and LastPos[ID] ~= nil and Toggle then
                RespawnLast[ID] = true
                ply:Spawn()
            end
        end
    end
)

hook.Add(
    "PlayerDeath",
    "Death",
    function(victim, inflictor, attacker)
        local ID = victim:UserID()
        IsDead[ID] = true
    end
)

hook.Add(
    "PlayerSpawn",
    "Spawn",
    function(player, transition)
        local ID = player:UserID()
        if RespawnLast[ID] and Toggle then player:SetPos(LastPos[ID]) end
        IsDead[ID] = false
        RespawnLast[ID] = false
    end
)

timer.Create(
    "UpdatePos",
    0.5,
    0,
    function()
        for k, v in pairs(player.GetAll()) do
            LastPos[v:UserID()] = v:GetPos()
        end
    end
)