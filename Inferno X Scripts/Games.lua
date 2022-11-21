local Games = {
	[9264596435] = "", -- Idle Heroes Simulator
	[10925589760] = "", -- Merge Simulator
	[9712123877] = "", -- Super Slime Simulator
	[11189979930] = "", -- Pet Crafting Simulator
	[11102985540] = "", -- Swarm Simulator
	[10404327868] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/test.lua", -- Timber Champions
	[10594623896] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/test.lua", -- Master Punching Simulator
	[9737855826] = "" -- Trade Simulator
}

if Games[game.PlaceId] then
	loadstring(game:HttpGet(Games[game.PlaceId]))()
end
