hook.Add("HUDShouldDraw", "RemoveThatShit", function(name) if name == "CHudDamageIndicator" then return false end end)
--[[ Okay you got me, this addon isn't super advanced. It's actually very simple, so why don't creators who make deathscreens include this by default?
It's just straight up annoying. If you're one of those people making a deathscreen addon looking in here to see how I did it then please
steal my code for your addon. No one likes a deathscreen with the stupid default red overlay. Thank you for reading, it's getting late, I'm going to bed. ]]