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

getgenv().PlaceName = PlaceName

PlaceName = PlaceName:gsub("%b[]", "")
PlaceName = PlaceName:gsub("[^%a]", "")

local UniverseIds = {
	[3764534614] = "RuneSlayer"
}

local JSONUniverseId = game:HttpGet(`https://apis.roproxy.com/universes/v1/places/{game.PlaceId}/universe`)

local CurrentUniverseId = game:GetService("HttpService"):JSONDecode(JSONUniverseId).universeId

local Universe = UniverseIds[CurrentUniverseId]

if Universe then
	PlaceName = Universe
	getgenv().PlaceName = PlaceName
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Analytics.lua"))()

local Success, Code: string = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Games/{PlaceName}.lua`)

if Success and Code:find("ScriptVersion = ") then
	Notify("Game found, the script is loading.")
	getgenv().PlaceFileName = PlaceName
else
	Notify("Game not found, loading universal.")
	getgenv().ScriptVersion = "Universal"
	Code = game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua")
end

getgenv().FrostByteHandleFunction(loadstring(Code))
