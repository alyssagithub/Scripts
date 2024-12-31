local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local ScriptVersion = getfenv().ScriptVersion

local Webhook = "https://disc".."ord.com/api/webhooks/1323494310267588700/uyWe".."y6sZ4Nb_8Qmtg8608Lc".."8cqzrXt2ox6TJqEdk-qXFPSC4QdLXGqJ9OF4vDaHSwH"

local getgenv = getfenv().getgenv
local getexecutorname = getfenv().getexecutorname
local identifyexecutor = getfenv().identifyexecutor
local request = getfenv().request

local Data =
	{
		embeds = {
			{            
				title = PlaceName,
				color = tonumber("0x"..Color3.fromRGB(0, 201, 99):ToHex()),
				fields = {
					{
						name = "Executor",
						value = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Hidden",
						inline = true
					},
					{
						name = "Script Version",
						value = ScriptVersion,
						inline = true
					},
				}
			}
		}
	}

pcall(request, {
	Url = "https://disc".."ord.com/api/webhooks/1323494310267588700/uyWe".."y6sZ4Nb_7Qmtg8608Lc".."8cqzrXt2ox6TJqEydk-qXFP6C4QdLXGqJ9OFL4vDaHSwH",
	Body = HttpService:JSONEncode(Data),
	Method = "POST",
	Headers = {["Content-Type"] = "application/json"}
})

getgenv().gethui = function()
	return game:GetService("CoreGui")
end

Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
Flags = Rayfield.Flags

Window = Rayfield:CreateWindow({
	Name = `FrostByte | {PlaceName} | {ScriptVersion}`,
	Icon = "snowflake",
	LoadingTitle = "❄ Brought to you by FrostByte ❄",
	LoadingSubtitle = PlaceName,
	Theme = "DarkBlue",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = `FrostByte-{game.PlaceId}`
	},

	Discord = {
		Enabled = true,
		Invite = "sS3tDP6FSB",
		RememberJoins = true
	},
})

function CreateUniversalTabs()
	local VirtualUser = game:GetService("VirtualUser")
	
	local getgenv = getfenv().getgenv
	local firetouchinterest = getgenv().firetouchinterest
	local queue_on_teleport = getgenv().queue_on_teleport
	
	local Tab = Window:CreateTab("Universal", "earth")

	Tab:CreateSection("AFK")

	Tab:CreateToggle({
		Name = "🔒 • Anti AFK Disconnection",
		CurrentValue = true,
		Flag = "AntiAFK",
		Callback = function(Value)
		end,
	})

	if getgenv().IdledConnection then
		getgenv().IdledConnection:Disconnect()
	end

	getgenv().IdledConnection = Player.Idled:Connect(function()
		if not Flags.AntiAFK.CurrentValue then
			return
		end

		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
	end)

	Tab:CreateToggle({
		Name = "✅ • Auto Re-Execute on Teleport",
		CurrentValue = true,
		Flag = "ReExecute",
		Callback = function(Value)
			if Value and queue_on_teleport then
				queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()')
			end
		end,
	})

	if Flags.ReExecute.CurrentValue and queue_on_teleport then
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()')
	end

	Tab:CreateSection("Miscellaneous")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId)
		end,
	})
end
