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

getgenv().PlaceFileName = PlaceName

local Code: string = game:HttpGet(`https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Games/{PlaceName}.lua`)

if Code ~= "404: Not Found" then
	Notify("Game found, the script is loading.")
	loadstring(Code)()
else
	Notify("Game not found, loading universal.")
	getgenv().ScriptVersion = "Universal"
	loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()
end
