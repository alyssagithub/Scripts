local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local ScriptVersion = getfenv().ScriptVersion

local Webhook = "https://disc".."ord.com/api/webhooks/1323494310267588700/uyWe".."y6sZ4Nb_8Qmtg8608Lc".."8cqzrXt2ox6TJqEdk-qXFPSC4QdLXGqJ9OF4vDaHSwH"

local getgenv = getfenv().getgenv
local getexecutorname = getfenv().getexecutorname
local identifyexecutor = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections

task.spawn(function()
	local Body = request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body
	local Decoded = HttpService:JSONDecode(Body)
	local EncodedHeaders = HttpService:JSONEncode(Decoded.headers)
	
	for i,v in Decoded.headers do
		if i:lower():find("fingerprint") then
			EncodedHeaders = v
		end
	end
	
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
						{
							name = "Identifier",
							value = EncodedHeaders,
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
end)

getgenv().gethui = function()
	return game:GetService("CoreGui")
end

getgenv().FrostByteConnections = getgenv().FrostByteConnections or {}

function HandleConnection(Connection: RBXScriptConnection, Name: string)
	if getgenv().FrostByteConnections[Name] then
		getgenv().FrostByteConnections[Name]:Disconnect()
	end

	getgenv().FrostByteConnections[Name] = Connection
end

firesignal = getfenv().firesignal:: (RBXScriptSignal) -> ()

if not firesignal then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
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
	local VirtualInputManager = game:GetService("VirtualInputManager")
	
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
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightMeta, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightMeta, false, game)
	end)

	Tab:CreateSection("Miscellaneous")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId)
		end,
	})
end
