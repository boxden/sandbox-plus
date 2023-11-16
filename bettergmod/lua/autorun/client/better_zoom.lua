print("BetterZoom Loaded On " .. util.DateStamp())
local hide = {
    ["CHudZoom"] = true
}

hook.Add("HUDShouldDraw", "ZoomHudDraw", function(name) if hide[name] then return false end end)