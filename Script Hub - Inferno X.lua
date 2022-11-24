local Games = {
	[9264596435] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Idle%20Heroes%20Simulator.lua", -- Idle Heroes Simulator
	[10925589760] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Merge%20Simulator.lua", -- Merge Simulator
	[9712123877] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Super%20Slime%20Simulator.lua", -- Super Slime Simulator
	[11189979930] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Pet%20Crafting%20Simulator.lua", -- Pet Crafting Simulator
	[11102985540] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Swarm%20Simulator.lua", -- Swarm Simulator
	[10404327868] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Timber%20Champions.lua", -- Timber Champions
	[10594623896] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Master%20Punching%20Simulator.lua" -- Master Punching Simulator
}

if Games[game.PlaceId] then
	loadstring(game:HttpGet(Games[game.PlaceId]))()
end
