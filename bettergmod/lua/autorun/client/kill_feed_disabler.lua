hook.Add("DrawDeathNotice", "nodn", function()
	return 0,0
end)

hook.Add("Initialize", "nodn", function()
	GM = GM or GAMEMODE
	function GM:AddDeathNotice()
		return
	end
end)