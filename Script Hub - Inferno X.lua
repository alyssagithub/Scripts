local Games = {
	[9264596435] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Idle%20Heroes%20Simulator.lua", -- Idle Heroes Simulator
	[10925589760] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Merge%20Simulator.lua", -- Merge Simulator
	[9712123877] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Super%20Slime%20Simulator.lua", -- Super Slime Simulator
	[10404327868] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Timber%20Champions.lua", -- Timber Champions
	[10594623896] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Master%20Punching%20Simulator.lua", -- Master Punching Simulator
	[11445923563] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/One%20Fruit%20Simulator.lua" -- One Fruit Simulator
}

if Games[game.PlaceId] then
	loadstring(game:HttpGet(Games[game.PlaceId]))()
end
