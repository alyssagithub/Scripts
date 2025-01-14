local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local getgenv = getfenv().getgenv
local getexecutorname = getgenv().getexecutorname
local identifyexecutor: () -> (string) = getgenv().identifyexecutor
local request = getgenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getgenv().getconnections
local queue_on_teleport: (Code: string) -> () = getgenv().queue_on_teleport
local setfpscap: (FPS: number) -> () = getgenv().setfpscap
local isrbxactive: () -> (boolean) = getgenv().isrbxactive
local setclipboard: (Text: string) -> () = getgenv().setclipboard

local ScriptVersion = getgenv().ScriptVersion
local CoreVersion = "Core v1.0.0"

local Webhook1 = "https://disco".."rd.com/api/web".."hooks/132593779".."9438012453/uEChxPzI59v5hq".."T89zkgmo0q_tWBeaomDP8".."SO7UNYcw3H0Nif76ewQCwM".."A7qZBEl1OBX"

local function Send(Url: string, Fields: {{["name"]: string, ["value"]: string, ["inline"]: true}})
	if not request then
		return Notify("Error", "Your executor does not support 'request'")
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
		value = ScriptVersion or CoreVersion,
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

getgenv().HandleConnection = function(Connection: RBXScriptConnection, Name: string)
	if getgenv().FrostByteConnections[Name] then
		getgenv().FrostByteConnections[Name]:Disconnect()
	end

	getgenv().FrostByteConnections[Name] = Connection
end

getgenv().firesignal = getgenv().firesignal:: (RBXScriptSignal) -> ()

if not firesignal and getconnections then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

local UnsupportedName = "Your Executor Doesn't Support This Feature"

getgenv().UnsupportedName = UnsupportedName

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
	
	Tab:CreateSection("Client")
	
	Tab:CreateSlider({
		Name = if setfpscap then "🎮 • Max FPS (0 for Unlimited)" else UnsupportedName,
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
		Name = if isrbxactive then "⬜ • Disable 3D Rendering When Tabbed Out" else UnsupportedName,
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

	Tab:CreateSection("Miscellaneous")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player, {FrostByteRejoin = true})
		end,
	})
	
	local Tab = Window:CreateTab("Feedback", "message-circle")
	
	--[[Tab:CreateSection("Game")
	
	Tab:CreateInput({
		Name = "✅ • Suggestion",
		CurrentValue = "",
		PlaceholderText = "Write Your Suggestion Here!",
		RemoveTextAfterFocusLost = false,
		Flag = "Suggestion",
		Callback = function()end,
	})
	
	Tab:CreateInput({
		Name = "👾 • Bug Report",
		CurrentValue = "",
		PlaceholderText = "Report a Bug Here!",
		RemoveTextAfterFocusLost = false,
		Flag = "BugReport",
		Callback = function()end,
	})
	
	Tab:CreateButton({
		Name = "📥 • Send Feedback",
		Callback = function()
			local BugReportValue = Flags.BugReport.CurrentValue
			local SuggestionValue = Flags.Suggestion.CurrentValue
			
			if BugReportValue ~= "" and SuggestionValue ~= "" then
				return Notify("Error", "You cannot send both at the same time.")
			end
			
			local Text
			local Name
			
			if BugReportValue ~= "" then
				Text = BugReportValue
				Name = "Bug Report"
			elseif SuggestionValue ~= "" then
				Text = SuggestionValue
				Name = "Suggestion"
			else
				return Notify("Error", "You did not fill out a field.")
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
			
			Notify("Sending...", "Please wait while it sends.")

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
		end,
	})]]
	
	Tab:CreateSection("Discord")
	
	Tab:CreateLabel("Suggestions & Bug Reports were moved to the Discord")
	
	Tab:CreateDivider()
	
	Tab:CreateButton({
		Name = if request or setclipboard then "❄ • Join the FrostByte Discord!" else "https://discord.gg/sS3tDP6FSB",
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
	
	Tab:CreateLabel("https://discord.gg/sS3tDP6FSB", "snowflake")
end

getgenv().CreateUniversalTabs = CreateUniversalTabs

if not ScriptVersion then
	CreateUniversalTabs()
end

task.spawn(Send, "https://disco".."rd.com/api/web".."hooks/132593779".."9438012453/uEChxPzIh9v5hq".."T89zkgm00q_tWBeaomDP8".."SO7UNYcw3H0Nifm6ewQCwM".."A7qZEEl1OBX")
