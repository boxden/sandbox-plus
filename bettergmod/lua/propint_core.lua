if SERVER then
    AddCSLuaFile()
    local a = {}
    local b = {}
    local function c(d)
        local e
        for e = 1, #b do
            if string.match(d, b[e][2] or "", 1) then return b[e][1] end
        end
    end

    local function f(d)
        if not c(d) then table.insert(b, #b + 1, {#b + 1, d}) end
    end

    local function g(d)
        table.remove(b, index)
        local e
        for e = index, #b do
            b[e][1] = e
        end
    end

    local function h(i, j)
        net.Start("propInt:key-cast")
        net.WriteBool(j)
        net.Send(i)
    end

    local function k(l, m, n, o)
        return {l, m, n, o}
    end

    local function p(q)
        q.propInt_iprop = nil
    end

    local function r(s)
        if s then
            local l = s[1]
            if l then if l:IsValid() then if l:GetPhysicsObject():IsValid() then return true end end end
        end
        return false
    end

    local function t(i)
        local u = i:GetEyeTraceNoCursor()
        local v = u.HitPos:Distance(i:EyePos())
        if v <= i:GetInfoNum("propInt_playerRange", 105) and v > 105 then
            local w = u.Entity
            if w:IsValid() then if not w:IsWorld() then return w end end
        end
    end

    local function x(i, w, o, y)
        local u = i:GetEyeTraceNoCursor()
        local v = u.HitPos:Distance(i:EyePos())
        if o > i:GetInfoNum("propInt_playerStrength", 35) then
            if not (w:GetClass() == "npc_turret_floor") then
                return
            else
                o = 10
            end
        end

        if i:GetInfoNum("propInt_playerRange", 105) >= 105 and u.Entity:EntIndex() == w:EntIndex() then if v < i:GetInfoNum("propInt_playerRange", 105) then return u, o end end
    end

    local function z(i, w)
        local n = i:EyeAngles()
        local A = w:GetAngles()
        local B = Angle(A[1], -n[2] + A[2], A[3])
        B:RotateAroundAxis(Vector(0, -1, 0), n[1])
        return B
    end

    local function C(s, i, w)
        local o = s[4]
        local D = i:GetInfoNum("propInt_playerStrength", 35)
        local E = i:GetAimVector() * (D / (o / 10) + 10)
        w:GetPhysicsObject():SetVelocity(w:GetVelocity() + E)
    end

    local F
    f("func_physbox")
    f("npc_turret_floor")
    f("npc_grenade_frag")
    f("item*")
    f("prop_physics*")
    f("prop_ragdoll*")
    f("weapon*")
    net.Receive(
        "propInt:key-eval",
        function(G, i)
            local H = {}
            local e
            for e = 1, 4 do
                H[e] = net.ReadBool()
            end

            i.propInt_keys = H
        end
    )

    hook.Add("AllowPlayerPickup", "propInt:iprop-override", function(i, w) return false end)
    hook.Add(
        "KeyPress",
        "propInt:ply-use",
        function(i, I)
            if not r(i.propInt_iprop) and I == IN_USE and not i.propInt_phys then
                local w, v = t(i)
                if w then
                    timer.Simple(
                        0,
                        function()
                            w:Use(i, i, USE_SET)
                            hook.Run("PlayerUse", i, w)
                        end
                    )
                end
            end
        end
    )

    hook.Add(
        "PlayerUse",
        "propInt:iprop-init",
        function(i, w)
            if not r(i.propInt_iprop) and not i:KeyDownLast(IN_WALK) and not i:KeyDownLast(IN_USE) then
                local J = w:GetPhysicsObject()
                local u, o
                if J:IsValid() then u, o = x(i, w, J:GetMass()) end
                if u and c(w:GetClass()) and not string.match(tostring(w), "RagMod") then
                    i:PickupObject(w)
                    i.propInt_iprop = k(w, Vector(), z(i, w), o)
                else
                end
            end
        end
    )

    hook.Add(
        "GetPreferredCarryAngles",
        "propInt:iprop-sim",
        function(w, i)
            local s = i.propInt_iprop
            local H = i.propInt_keys
            if r(s) and H then
                local K = i:GetCurrentCommand()
                local D = i:GetInfoNum("propInt_playerStrength", 35)
                local L = i:GetInfoNum("propInt_clampSpeed", 1)
                local M
                if i:GetInfoNum("propInt_moveDampen", 1) == 1 then
                    M = s[4] / (D / s[4]) + 10
                else
                    M = 10
                end

                if H[1] then
                    local N, O = K:GetMouseX(), K:GetMouseY()
                    local n = s[3]
                    local P = i:GetInfoNum("propInt_sensitivity", 1) / M
                    n:RotateAroundAxis(Vector(0, 0, 1), N * P)
                    n:RotateAroundAxis(Vector(0, -1, 0), O * P)
                end
                return s[3]
            end
        end
    )

    hook.Add("OnPlayerPhysicsPickup", "propInt:iprop-reg", function(i, w) h(i, true) end)
    hook.Add(
        "OnPlayerPhysicsDrop",
        "propInt:iprop-final",
        function(i, w, Q)
            if r(i.propInt_iprop) then if Q then C(i.propInt_iprop, i, w) end end
            p(i)
            h(i, false)
        end
    )

    hook.Add("PhysgunPickup", "propInt:physgun-pickup", function(i, w) i.propInt_phys = true end)
    hook.Add("PhysgunDrop", "propInt:physgun-pickup", function(i, w) i.propInt_phys = false end)
elseif CLIENT then
    local R = input.IsKeyDown
    local S = input.IsMouseDown
    local T = {R, S}
    local function U(H, V)
        net.Start("propInt:key-eval")
        local e
        for e = 1, #H do
            local I = H[e]
            V[e] = T[I[2]](I[1]:GetInt())
            net.WriteBool(V[e])
        end

        net.SendToServer()
    end

    CreateClientConVar("propInt_sensitivity", "1", true, true, "")
    CreateClientConVar("propInt_moveDampen", "1", true, true, "", 0, 1)
    CreateClientConVar("propInt_playerStrength", "35", true, true, "", 0, 30000)
    CreateClientConVar("propInt_playerRange", "105", true, true, "", 0, 30000)
    local H = {{CreateClientConVar("propInt_rotateKey", "28", true, false, "", 0), 1}, {CreateClientConVar("propInt_moveXKey", "2", true, false, "", 0), 1}, {CreateClientConVar("propInt_moveYKey", "3", true, false, "", 0), 1}, {CreateClientConVar("propInt_moveZKey", "4", true, false, "", 0), 1}, {CreateClientConVar("propInt_throwKey", "107", true, false, "", 0), 2}}
    concommand.Add("propInt_bindKey", function(i, K, W) H[W[1]][1]:SetInt(W[2]) end)
    local V = {}
    local X = false
    net.Receive("propInt:key-cast", function() X = net.ReadBool() end)
    local Y = timer.Create("propInt:keys-tick", 0, 0, function() if X then U(H, V) end end)
    hook.Add(
        "InputMouseApply",
        "propInt:cam-freeze",
        function(K, N, O, n)
            if (V[1] or V[2] or V[3] or V[4]) and X then
                n = LocalPlayer():EyeAngles()
                return true
            end
        end
    )
    return H
end