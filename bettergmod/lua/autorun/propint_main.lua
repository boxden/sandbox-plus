if SERVER then
    util.AddNetworkString("propInt:key-eval")
    util.AddNetworkString("propInt:key-cast")
end

local a = include("propint_core.lua")
if CLIENT then
    local b = Color(0, 130, 255, 255)
    local c = Color(0, 90, 195, 195)
    local d = LocalPlayer()
    local function e(f, g, h)
        local i = vgui.Create("DLabel", h)
        if f == 1 then
            i:SetFont("DermaDefaultBold")
            i:SetTextColor(b)
        end

        i:SetText(g)
        i:SetDark(true)
        return i
    end

    local function j(k, h)
        local l = vgui.Create("DBinder", pnl)
        l:SetSelectedNumber(a[k][1]:GetInt())
        function l:OnChange(m)
            concommand.Run(d, "propInt_bindKey", {k, m}, k .. " " .. m)
        end
        return l
    end

    local n
    concommand.Add(
        "propInt_setDefaults",
        function(d)
            a[1][1]:SetInt(28)
            a[2][1]:SetInt(2)
            a[3][1]:SetInt(3)
            a[4][1]:SetInt(4)
            a[5][1]:SetInt(107)
            n:SetValue(28)
            GetConVar("propInt_sensitivity"):SetBool(true)
            GetConVar("propInt_moveDampen"):SetBool(true)
            GetConVar("propInt_playerStrength"):SetFloat(35.0)
            GetConVar("propInt_playerRange"):SetFloat(105.0)
        end
    )

    hook.Add(
        "PopulateToolMenu",
        "propInt:set-cfg",
        function()
            spawnmenu.AddToolMenuOption(
                "Utilities",
                "User",
                "propInt:user-cfg",
                "Prop Interaction",
                "",
                "",
                function(pnl)
                    pnl:ClearControls()
                    pnl:Button("Reset to Defaults", "propInt_setDefaults")
                    pnl:AddItem(e(1, "General", pnl))
                    pnl:NumSlider("Sensitivity", "propInt_sensitivity", 0, 1, 2)
                    pnl:Help("Sets the sensitivity for prop interaction movement. It is a multiplier for current mouse sensitivity, and negative values are allowed."):SetTextColor(c)
                    pnl:CheckBox("Dampen Movement", "propInt_moveDampen")
                    pnl:Help("Dynamically dampen movement with player strength. Larger carriable props are harder to move."):SetTextColor(c)
                    pnl:AddItem(e(1, "Player-Specific", pnl))
                    pnl:NumSlider("Strength", "propInt_playerStrength", 0, 1500, 2)
                    pnl:Help("Strength determines how big carriable props can be and how far the player can throw them."):SetTextColor(c)
                    pnl:NumSlider("Reach", "propInt_playerRange", 0, 1500, 2)
                    pnl:Help("Reach determines how far away props can be to interact with."):SetTextColor(c)
                    pnl:AddItem(e(1, "Rotation", pnl))
                    pnl:AddItem(e(0, "Rotate", pnl))
                    n = j(1, pnl)
                    pnl:AddItem(n)
                end
            )
        end
    )
end