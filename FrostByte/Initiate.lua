local getgenv: () -> ({[string]: any}) = getfenv().getgenv

local function Notify(Text)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FrostByte Notification",
		Text = Text,
		Duration = 10
	})
end

local PlaceName = game:GetService("AssetService"):GetGamePlacesAsync(game.GameId):GetCurrentPage()[1].Name

getgenv().PlaceName = PlaceName

PlaceName = PlaceName:gsub("%b[]", "")
PlaceName = PlaceName:gsub("[^%a]", "")

loadstring(game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Analytics.luau"))()

local Success, Code: string = pcall(game.HttpGet, game, `https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Games/{PlaceName}.luau`)

if Success and Code:find("ScriptVersion = ") then
	Notify("Game found, the script is loading.")
	getgenv().PlaceFileName = PlaceName
else
	Notify("Game not found, loading universal.")
	Code = game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Games/Universal.luau")
end

getgenv().FrostByteHandleFunction(loadstring(Code))
