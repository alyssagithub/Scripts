local getgenv: () -> ({[string]: any}) = getfenv().getgenv

local function Notify(Text)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FrostByte Notification",
		Text = Text,
		Duration = 10
	})
end

local function FormatPlaceName(PlaceName: string)
	getgenv().PlaceName = PlaceName

	PlaceName = PlaceName:gsub("%b[]", "")
	PlaceName = PlaceName:gsub("[^%a]", "")
	
	return PlaceName
end

local RanPlaces = false

local function GetCode(PlaceName)
	local Success, Code: string = pcall(game.HttpGet, game, `https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Games/{PlaceName}.luau`)

	if Success and Code:find("ScriptVersion = ") then
		Notify("Game found, the script is loading.")
		getgenv().PlaceFileName = PlaceName
	elseif not RanPlaces then
		RanPlaces = true
		return GetCode(FormatPlaceName(game:GetService("AssetService"):GetGamePlacesAsync(game.GameId):GetCurrentPage()[1].Name))
	else
		Notify("Game not found, loading universal.")
		Code = game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Games/Universal.luau")
	end
	
	return Code
end

loadstring(game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Analytics.luau"))()

local Code = GetCode(FormatPlaceName(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name))

getgenv().FrostByteHandleFunction(loadstring(Code), "Game")
