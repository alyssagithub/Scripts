local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local ScriptVersion = getfenv().ScriptVersion

local getgenv = getfenv().getgenv
local getexecutorname = getfenv().getexecutorname
local identifyexecutor = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections
local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport

local Webhook1 = "https://disco".."rd.com/api/web".."hooks/132593779".."9438012453/uEChxPzI59v5hq".."T89zkgmo0q_tWBeaomDP8".."SO7UNYcw3H0Nif76ewQCwM".."A7qZBEl1OBX"

local function Send(Url: string, Fields: {{["name"]: string, ["value"]: string, ["inline"]: true}})
	if not Fields then
		Fields = {}
	end
	
	local Body = request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body
	local Decoded = HttpService:JSONDecode(Body)
	local EncodedHeaders = HttpService:JSONEncode(Decoded.headers)

	for i,v in Decoded.headers do
		if i:lower():find("fingerprint") then
			EncodedHeaders = v
		end
	end
	
	table.insert(Fields, {
		name = "Script Version",
		value = ScriptVersion,
		inline = true
	})
	
	table.insert(Fields, {
		name = "Executor",
		value = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Hidden",
		inline = true
	})
	
	table.insert(Fields, {
		name = "Identifier",
		value = EncodedHeaders,
		inline = true
	})

	local Data =
		{
			embeds = {
				{            
					title = PlaceName,
					color = tonumber("0x"..Color3.fromRGB(0, 201, 99):ToHex()),
					fields = Fields
				}
			}
		}

	return pcall(request, {
		Url = Url,
		Body = HttpService:JSONEncode(Data),
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"}
	})
end

task.spawn(Send, "https://disco".."rd.com/api/web".."hooks/132593779".."9438012453/uEChxPzIh9v5hq".."T89zkgm00q_tWBeaomDP8".."SO7UNYcw3H0Nifm6ewQCwM".."A7qZEEl1OBX")

function Notify(Title: string, Content: string, Image: string)
	Rayfield:Notify({
		Title = Title,
		Content = Content,
		Duration = 10,
		Image = Image,
	})
end

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
		if not getconnections then
			Notify("Unsupported", "Your executor does not support 'getconnections'", "circle-alert")
			return
		end
		
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

if queue_on_teleport then
	queue_on_teleport([[
	
	local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData()

if TeleportData and typeof(TeleportData) == "table" and TeleportData.FrostByteRejoin then
	return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()
	
	]])
end

Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Flags = Rayfield.Flags

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
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player, {FrostByteRejoin = true})
		end,
	})
	
	local Tab = Window:CreateTab("Feedback", "message-circle")
	
	Tab:CreateSection("Game")
	
	local function HandleInput(Name: string, Text: string)
		if Text == "" then
			return
		end
		
		local Features = ""
		
		for i,v in Flags do
			if v.CurrentValue == true then
				Features ..= `\n✅ - {v.Name}`
			elseif v.CurrentOption then
				Features ..= `\n📃 - {v.Name}: {table.concat(v.CurrentOption, ", ")}`
			elseif v.CurrentValue == false then
				Features ..= `\n❌ - {v.Name}`
			elseif typeof(v.CurrentValue) == "number" then
				Features ..= `\n🔢 - {v.Name}: {v.CurrentValue}`
			else
				Features ..= `\n❓ - {v.Name}`
			end
		end

		local Success = Send("htt".."ps://disc".."ord.com".."/api/w".."ebhooks/13255".."85395395854487/k".."ZHuuilkCzJp5Bcwy0Kt".."1SSshQ3-".."i".."-xgx".."JmtYIG49nqGgj26".."WVnfdCP8OKjK8".."qtyNnDb", {
			{
				name = Name,
				value = Text,
				inline = true
			},
			{
				name = "Features",
				value = Features,
				inline = true
			},
		})

		if Success then
			Notify("Success!", `Successfully sent the {Name}`, "check")
		else
			Notify("Failed!", `Failed to send the {Name}`, "x")
		end
	end
	
	Tab:CreateInput({
		Name = "✅ • Suggestion",
		CurrentValue = "",
		PlaceholderText = "Write Your Suggestion Here!",
		RemoveTextAfterFocusLost = false,
		--Flag = "Suggestion",
		Callback = function(Text)
			HandleInput("Suggestion", Text)
		end,
	})
	
	Tab:CreateInput({
		Name = "👾 • Bug Report",
		CurrentValue = "",
		PlaceholderText = "Report a Bug Here!",
		RemoveTextAfterFocusLost = false,
		--Flag = "BugReport",
		Callback = function(Text)
			HandleInput("Bug Report", Text)
		end,
	})
end
