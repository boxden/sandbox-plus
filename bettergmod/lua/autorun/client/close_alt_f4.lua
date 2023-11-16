hook.Add(
    "Think",
    "close_alt_f4",
    function()
        if input.IsKeyDown(KEY_LALT) and input.IsKeyDown(KEY_F4) then
            -- render.SetLightingMode( -1 ) -- crashing method
            RunConsoleCommand("gamemenucommand", "quit") -- game menu method
        end
    end
)