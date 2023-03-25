local Games = {
	[9264596435] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Idle%20Heroes%20Simulator.lua", -- Idle Heroes Simulator
	[10925589760] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Merge%20Simulator.lua", -- Merge Simulator
	[10404327868] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Timber%20Champions.lua", -- Timber Champions
	[11445923563] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/One%20Fruit%20Simulator.lua", -- One Fruit Simulator
	[10821317529] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Pickaxe%20Mining%20Simulator.lua", -- Pickaxe Mining Simulator
	[11040063484] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Sword%20Fighters%20Simulator.lua", -- Sword Fighters Simulator
	[11448052802] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Pet%20Rift.lua", -- Pet Rift
	[12413786484] = "https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Games/Anime%20Lost%20Simulator.lua" -- Anime Lost Simulator
}

local function GetExecutor()
	return
		(secure_load and "Sentinel") or
		(is_sirhurt_closure and "Sirhurt") or
		(pebc_execute and "ProtoSmasher") or
		(KRNL_LOADED and "Krnl") or
		(WrapGlobal and "WeAreDevs") or
		(isvm and "Proxo") or
		(shadow_env and "Shadow") or
		(jit and "EasyExploits") or
		(getscriptenvs and "Calamari") or
		(unit and not syn and "Unit") or
		(OXYGEN_LOADED and "Oxygen U") or
		(IsElectron and "Electron") or
		(IS_COCO_LOADED and "Coco") or
		(IS_VIVA_LOADED and "Viva") or
		(fluxus and "Fluxus") or
		(syn and is_synapse_function and "Synapse") or
		("Other")
end

local StarterGui = game:GetService("StarterGui")

local function Notification(Message)
	StarterGui:SetCore("SendNotification", {
		Title = "Inferno X Notification",
		Text = Message,
		Duration = 60
	})
end

if Games[game.PlaceId] then
	loadstring(game:HttpGet(Games[game.PlaceId]))()
else
	Notification("The current game is not supported")
end

local CurrentExecutor = GetExecutor()

if CurrentExecutor ~= "Synapse" and CurrentExecutor ~= "Fluxus" then
	Notification("The recommended executor is Synapse X or Fluxus")
end
