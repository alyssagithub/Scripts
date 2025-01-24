-- loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()

local getgenv: () -> ({[string]: any}) = getfenv().getgenv

local function Notify(Text)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FrostByte Notification",
		Text = Text,
		Duration = 10
	})
end

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

PlaceName = PlaceName:gsub("%b[]", "")
PlaceName = PlaceName:gsub("[^%a]", "")

local Code = game:HttpGet(`https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Games/{PlaceName}.lua`)

if Code then
	Notify("Game found, the script is loading")
	loadstring(Code)()
else
	Notify("Could not find a script for this game, loading the universal")
	getgenv().PlaceName = "Universal"
	loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()
end
