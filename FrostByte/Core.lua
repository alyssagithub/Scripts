local StartLoadTime = tick()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

local getgenv: () -> ({[string]: any}) = getfenv().getgenv

local PlaceName: string = getgenv().PlaceName or game:GetService("AssetService"):GetGamePlacesAsync(game.GameId):GetCurrentPage()[1].Name

local getexecutorname = getfenv().getexecutorname
local identifyexecutor: () -> (string) = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections
local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport
local setfpscap: (FPS: number) -> () = getfenv().setfpscap
local isrbxactive: () -> (boolean) = getfenv().isrbxactive
local setclipboard: (Text: string) -> () = getfenv().setclipboard
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal

local ScriptVersion = getgenv().ScriptVersion

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

getgenv().GetClosestChild = function(Children: {PVInstance}, Callback: ((Child: PVInstance) -> boolean)?, MaxDistance: number?)
	for i, Child in Children do
		if Callback and not Callback(Child) then
			continue
		end

		table.remove(Children, i)
	end

	local Character = Player.Character

	if not Character then
		return
	end

	local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local CurrentPosition: Vector3 = HumanoidRootPart.Position

	local ClosestMagnitude = MaxDistance or math.huge
	local ClosestChild

	for _, Child in Children do
		local Magnitude = (Child:GetPivot().Position - CurrentPosition).Magnitude

		if Magnitude < ClosestMagnitude then
			ClosestMagnitude = Magnitude
			ClosestChild = Child
		end
	end

	return ClosestChild
end

if not firesignal and getconnections then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

local UnsupportedName = " (Executor Unsupported)"

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

local OriginalFlags = {}

if getgenv().Flags then
	for FlagName: string, FlagInfo in getgenv().Flags do
		if typeof(FlagInfo.CurrentValue) ~= "boolean" then
			continue
		end

		OriginalFlags[FlagName] = FlagInfo.CurrentValue
		pcall(FlagInfo.Set, FlagInfo, false)
	end
end

if getgenv().Rayfield then
	getgenv().Rayfield:Destroy()
end

local Success, Rayfield = pcall(function()
	return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

local function SendNotification(Title: string, Text: string, Duration: number?, Button1: string?, Button2: string?, Callback: BindableFunction?)
	StarterGui:SetCore("SendNotification", {
		Title = Title,
		Text = Text,
		Duration = Duration or 10,
		Button1 = Button1,
		Button2 = Button2,
		Callback = Callback
	})
end

if not Success or not Rayfield or not Rayfield.CreateWindow then
	SendNotification("Error while loading Rayfield", "Try re-executing or rejoining.")
	return
end

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

getgenv().Flags = Flags

local function Notify(Title: string, Content: string, Image: string)
	if not Rayfield then
		return
	end

	Rayfield:Notify({
		Title = Title,
		Content = Content,
		Duration = 10,
		Image = Image or "info",
	})
end

getgenv().Notify = Notify

task.spawn(function()
	while task.wait(Random.new():NextNumber(5 * 60, 10 * 60)) do
		Notify("Enjoying this script?", "Join the discord at discord.gg/sS3tDP6FSB", "heart")
	end
end)

task.spawn(function()
	if ScriptVersion and ScriptVersion ~= "Universal" then
		local PlaceFileName = getgenv().PlaceFileName

		if not PlaceFileName then
			return
		end

		local BindableFunction = Instance.new("BindableFunction")

		local Response = false

		local Button1 = "✅ Yes" 
		local Button2 = "❌ No"

		local File = `https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Games/{PlaceFileName}.lua`

		BindableFunction.OnInvoke = function(Button: string)
			Response = true

			if Button == Button1 then
				loadstring(game:HttpGet(File))()
			end
		end

		while task.wait(60) do
			local Result = game:HttpGet(File)

			if not Result then
				continue
			end

			Result = Result:split('getgenv().ScriptVersion = "')[2]
			Result = Result:split('"')[1]

			if Result == ScriptVersion then
				continue
			end

			SendNotification(`A new FrostByte version {Result} has been detected!`, "Would you like to load it?", math.huge, Button1, Button2, BindableFunction)

			break
		end
	end
end)

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local Window

pcall(function()
	Window = Rayfield:CreateWindow({
		Name = `FrostByte | {PlaceName} | {ScriptVersion or "Dev Mode"}`,
		Icon = "snowflake",
		LoadingTitle = "❄ Brought to you by FrostByte ❄",
		LoadingSubtitle = PlaceName,
		Theme = "DarkBlue",

		DisableRayfieldPrompts = false,
		DisableBuildWarnings = false,

		ConfigurationSaving = {
			Enabled = true,
			FolderName = "FrostByte",
			FileName = `{getgenv().PlaceFileName or `DevMode-{game.PlaceId}`}-{Player.Name}`
		},

		Discord = {
			Enabled = true,
			Invite = "sS3tDP6FSB",
			RememberJoins = true
		},
	})

	getgenv().Window = Window
end)

function CreateUniversalTabs()
	local VirtualUser = game:GetService("VirtualUser")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local TeleportService = game:GetService("TeleportService")
	local RunService = game:GetService("RunService")

	if not Window then
		return
	end

	local Tab: Tab = Window:CreateTab("Client", "user")

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

	Tab:CreateSection("Statistics")

	local PingLabel = Tab:CreateLabel("Ping: 0 ms", "wifi")
	local FPSLabel = Tab:CreateLabel("FPS: 0/s", "monitor")

	local Stats = game:GetService("Stats")

	task.spawn(function()
		while getgenv().Flags == Flags and task.wait(0.25) do
			pcall(PingLabel.Set, PingLabel, `Ping: {math.floor(Stats.PerformanceStats.Ping:GetValue() * 100)/ 100} ms`)
			pcall(FPSLabel.Set, FPSLabel, `FPS: {math.floor(1 / Stats.FrameTime * 10) / 10}/s`)
		end
	end)

	Tab:CreateSection("AFK")

	Tab:CreateToggle({
		Name = "🔒 • Anti AFK Disconnection",
		CurrentValue = true,
		Flag = "AntiAFK",
		Callback = function()end,
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
		Flag = "MaxFPS",
		Callback = function(Value)
			if not setfpscap then
				return
			end

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

				RunService:Set3dRenderingEnabled(CurrentValue)
			end

			if Value then
				RunService:Set3dRenderingEnabled(true)
			end
		end,
	})

	Tab:CreateSection("Properties")

	local WalkSpeedConnection: RBXScriptConnection
	local ConnectedHumanoid

	local function SetWalkSpeed()
		local Character = Player.Character

		if not Character then
			return
		end

		local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")

		if not Humanoid then
			return
		end

		if Flags.WalkSpeedChanger.CurrentValue then
			Humanoid.WalkSpeed = Flags.WalkSpeed.CurrentValue
		end

		if not WalkSpeedConnection then
			WalkSpeedConnection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(SetWalkSpeed)
			ConnectedHumanoid = Humanoid
			HandleConnection(WalkSpeedConnection, "WalkSpeedConnection")
		end
	end

	HandleConnection(Player.CharacterAdded:Connect(function()
		if WalkSpeedConnection then
			WalkSpeedConnection:Disconnect()
			WalkSpeedConnection = nil
		end

		SetWalkSpeed()
	end), "WalkSpeedCharacterAdded")

	Tab:CreateToggle({
		Name = "⚡ • Enable WalkSpeed Changer",
		CurrentValue = false,
		Flag = "WalkSpeedChanger",
		Callback = function(Value)
			if Player.Character and Value then
				SetWalkSpeed()
			end
		end,
	})

	Tab:CreateSlider({
		Name = "💨 • Set WalkSpeed",
		Range = {0, 300},
		Increment = 1,
		Suffix = "Studs/s",
		CurrentValue = game:GetService("StarterPlayer").CharacterWalkSpeed,
		Flag = "WalkSpeed",
		Callback = function(Value)
			SetWalkSpeed()
		end,
	})

	Tab:CreateSection("Safety")

	local StaffRoleNames = {
		"mod",
		"dev",
		"admin",
		"owner",
		"founder",
		"manag",
	}

	local function IsInGroup(CheckPlayer: Player, GroupId: number)
		local Success, Result = pcall(CheckPlayer.IsInGroup, CheckPlayer, GroupId)

		return Success and Result
	end

	local function GetRoleInGroup(CheckPlayer: Player, GroupId: number)
		local Success, Result = pcall(CheckPlayer.GetRoleInGroup, CheckPlayer, GroupId)

		return if Success then Result else "Guest"
	end

	local function GetRankInGroup(CheckPlayer: Player, GroupId: number)
		local Success, Result = pcall(CheckPlayer.GetRankInGroup, CheckPlayer, GroupId)

		return if Success then Result else 0
	end

	local function GetStaffRole(CheckPlayer: Player)
		local StaffRole

		if IsInGroup(CheckPlayer, 1200769) then
			StaffRole = "Roblox Admin"
		end

		if game.CreatorType ~= Enum.CreatorType.Group then
			return
		end

		local CreatorId = game.CreatorId

		local Role = GetRoleInGroup(CheckPlayer, CreatorId)

		for _, Name in StaffRoleNames do
			if typeof(Role) == "string" and Role:lower():find(Name) then
				StaffRole = Role
			end
		end

		if GetRankInGroup(CheckPlayer, CreatorId) == 255 then
			StaffRole = "Group Owner"
		end

		return StaffRole
	end

	local function CheckIfStaff(CheckPlayer: Player)
		if not Flags.StaffJoin.CurrentValue then
			return
		end

		local StaffRole = GetStaffRole(CheckPlayer)

		if not StaffRole then
			return
		end

		Player:Kick(`The player '{CheckPlayer.Name}' was detected to be a staff member, their role is '{StaffRole}'.\n\nIf you believe this is false, contact the dev of FrostByte.`)
	end

	Tab:CreateToggle({
		Name = "🔔 • Auto Leave When Staff Joins",
		CurrentValue = false,
		Flag = "StaffJoin",
		Callback = function(Value)
			if not Value then
				return
			end

			for _, CheckPlayer in Players:GetPlayers() do
				CheckIfStaff(CheckPlayer)
			end
		end,
	})

	HandleConnection(Players.PlayerAdded:Connect(CheckIfStaff), "StaffJoin")

	getgenv().Role = GetStaffRole(Player)
	
	Tab:CreateDivider()

	local Connections = {}

	local OriginalText = {}

	local function HandleUsernameChange(Object: Instance)
		if not Flags.HideName.CurrentValue then
			return
		end

		if not Object:IsA("TextLabel") and not Object:IsA("TextBox") and not Object:IsA("TextButton") then
			return
		end

		local NameReplacement = Flags.NameReplacement.CurrentValue

		if not Connections[Object] then
			Connections[Object] = Object:GetPropertyChangedSignal("Text"):Connect(function()
				HandleUsernameChange(Object)
			end)
		end

		if Object.Text:find(Player.Name) then
			OriginalText[Object] = Object.Text
			Object.Text = Object.Text:gsub(Player.Name, NameReplacement)
		elseif Object.Text:find(Player.DisplayName) then
			OriginalText[Object] = Object.Text
			Object.Text = Object.Text:gsub(Player.DisplayName, NameReplacement)
		end
	end

	local DescendantAddedConnection

	Tab:CreateToggle({
		Name = "🛡 • Hide Username and Display Name (Client-Sided)",
		CurrentValue = false,
		Flag = "HideName",
		Callback = function(Value)
			if Value and not DescendantAddedConnection then
				for i,v in game:GetDescendants() do
					HandleUsernameChange(v)
				end

				DescendantAddedConnection = game.DescendantAdded:Connect(HandleUsernameChange)

				HandleConnection(DescendantAddedConnection, "HideName")
			elseif DescendantAddedConnection then
				DescendantAddedConnection:Disconnect()
				DescendantAddedConnection = nil

				for Object: TextLabel?, Text in OriginalText do
					Object.Text = Text
				end

				OriginalText = {}
			end
		end,
	})

	Tab:CreateInput({
		Name = "💬 • Name To Replace With",
		CurrentValue = "FrostByte",
		PlaceholderText = "New Name Here",
		RemoveTextAfterFocusLost = false,
		Flag = "NameReplacement",
		Callback = function()end,
	})
	
	Tab:CreateDivider()
	
	Tab:CreateToggle({
		Name = "🌀 • Noclip",
		CurrentValue = false,
		Flag = "Noclip",
		Callback = function(Value)
			local Character = Player.Character or Player.CharacterAdded:Wait()
			
			for _, Part: Part in Character:GetChildren() do
				if not Part:IsA("BasePart") then
					continue
				end
				
				if Value then
					Part:SetAttribute("OriginalCollide", Part.CanCollide)
					Part.CanCollide = false
				else
					Part.CanCollide = Part:GetAttribute("OriginalCollide") or Part.CanCollide
				end
			end
		end,
	})
	
	Tab:CreateSection("Visualizing")
	
	local CoreGui: Folder = game:GetService("CoreGui")
	
	local function ESP(TargetPlayer: Player)
		local TargetCharacter = TargetPlayer.Character or TargetPlayer.CharacterAdded:Wait()
		
		local LocalCharacter = Player.Character
		
		local FolderName = `{TargetPlayer.Name}_ESP`
		
		local Holder = Instance.new("Folder")
		Holder.Name = FolderName
		Holder.Parent = CoreGui

		for _, Part: Part in TargetCharacter:GetChildren() do
			if not Part:IsA("BasePart") then
				continue
			end

			local BoxHandleAdornment = Instance.new("BoxHandleAdornment")
			BoxHandleAdornment.Name = TargetPlayer.Name
			BoxHandleAdornment.Adornee = Part
			BoxHandleAdornment.AlwaysOnTop = true
			BoxHandleAdornment.ZIndex = 10
			BoxHandleAdornment.Size = Part.Size
			BoxHandleAdornment.Transparency = 0.5
			BoxHandleAdornment.Color = BrickColor.White()
			BoxHandleAdornment.Parent = Holder
		end

		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Name = TargetPlayer.Name
		BillboardGui.Adornee = TargetCharacter.Head
		BillboardGui.Size = UDim2.new(0, 100, 0, 150)
		BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Parent = Holder

		local TextLabel = Instance.new("TextLabel")
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0, 0, 0, -50)
		TextLabel.Size = UDim2.new(0, 100, 0, 100)
		TextLabel.Font = Enum.Font.SourceSansSemibold
		TextLabel.TextSize = 20
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextStrokeTransparency = 0
		TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		TextLabel.Text = "Unloaded"
		TextLabel.ZIndex = 10
		TextLabel.Parent = BillboardGui
		
		TargetPlayer.CharacterAdded:Once(function()
			if not Flags.ESP.CurrentValue or not Holder.Parent then
				return
			end
			
			if Holder.Parent then
				Holder:Destroy()
			end
			
			ESP(Player)
		end)
		
		TargetPlayer.CharacterRemoving:Once(function()
			Holder:Destroy()
		end)
		
		local RenderSteppedConnection: RBXScriptConnection
		RenderSteppedConnection = RunService.RenderStepped:Connect(function()
			if not Flags.ESP.CurrentValue then
				RenderSteppedConnection:Disconnect()
				return
			end
			
			if not Holder.Parent then
				RenderSteppedConnection:Disconnect()
				return
			end
			
			if not TargetCharacter or not TargetCharacter:FindFirstChildOfClass("Humanoid") or not LocalCharacter or not LocalCharacter:FindFirstChild("Humanoid") then
				return
			end

			local Distance = math.floor((LocalCharacter:GetPivot().Position - TargetCharacter:GetPivot().Position).Magnitude)
			TextLabel.Text = `Name: {TargetPlayer.Name} | Health: {math.floor(TargetCharacter.Humanoid.Health)} | Studs: {Distance}`
		end)
	end
	
	Tab:CreateToggle({
		Name = "🔍 • Infinite Yield ESP",
		CurrentValue = false,
		Flag = "ESP",
		Callback = function(Value)
			for _, Object: Folder? in pairs(CoreGui:GetChildren()) do
				if not Object.Name:find("_ESP") then
					continue
				end
				
				Object:Destroy()
			end
			
			if Value then
				for _, TargetPlayer in Players:GetPlayers() do
					if TargetPlayer == Player then
						continue
					end
					
					ESP(TargetPlayer)
				end
			end
			
			--[[task.spawn(function()
				for i,v in pairs(COREGUI:GetChildren()) do
					if v.Name == plr.Name..'_ESP' then
						v:Destroy()
					end
				end
				wait()
				if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not COREGUI:FindFirstChild(plr.Name..'_ESP') then
					local ESPholder = Instance.new("Folder")
					ESPholder.Name = plr.Name..'_ESP'
					ESPholder.Parent = COREGUI
					repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
					for b,n in pairs (plr.Character:GetChildren()) do
						if (n:IsA("BasePart")) then
							local a = Instance.new("BoxHandleAdornment")
							a.Name = plr.Name
							a.Parent = ESPholder
							a.Adornee = n
							a.AlwaysOnTop = true
							a.ZIndex = 10
							a.Size = n.Size
							a.Transparency = espTransparency
							a.Color = plr.TeamColor
						end
					end
					if plr.Character and plr.Character:FindFirstChild('Head') then
						local BillboardGui = Instance.new("BillboardGui")
						local TextLabel = Instance.new("TextLabel")
						BillboardGui.Adornee = plr.Character.Head
						BillboardGui.Name = plr.Name
						BillboardGui.Parent = ESPholder
						BillboardGui.Size = UDim2.new(0, 100, 0, 150)
						BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
						BillboardGui.AlwaysOnTop = true
						TextLabel.Parent = BillboardGui
						TextLabel.BackgroundTransparency = 1
						TextLabel.Position = UDim2.new(0, 0, 0, -50)
						TextLabel.Size = UDim2.new(0, 100, 0, 100)
						TextLabel.Font = Enum.Font.SourceSansSemibold
						TextLabel.TextSize = 20
						TextLabel.TextColor3 = Color3.new(1, 1, 1)
						TextLabel.TextStrokeTransparency = 0
						TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
						TextLabel.Text = 'Name: '..plr.Name
						TextLabel.ZIndex = 10
						local espLoopFunc
						local teamChange
						local addedFunc
						addedFunc = plr.CharacterAdded:Connect(function()
							if ESPenabled then
								espLoopFunc:Disconnect()
								teamChange:Disconnect()
								ESPholder:Destroy()
								repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
								ESP(plr)
								addedFunc:Disconnect()
							else
								teamChange:Disconnect()
								addedFunc:Disconnect()
							end
						end)
						teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
							if ESPenabled then
								espLoopFunc:Disconnect()
								addedFunc:Disconnect()
								ESPholder:Destroy()
								repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
								ESP(plr)
								teamChange:Disconnect()
							else
								teamChange:Disconnect()
							end
						end)
						local function espLoop()
							if COREGUI:FindFirstChild(plr.Name..'_ESP') then
								if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
									local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
									TextLabel.Text = 'Name: '..plr.Name..' | Health: '..round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1)..' | Studs: '..pos
								end
							else
								teamChange:Disconnect()
								addedFunc:Disconnect()
								espLoopFunc:Disconnect()
							end
						end
						espLoopFunc = RunService.RenderStepped:Connect(espLoop)
					end
				end
			end)]]
		end,
	})

	Tab:CreateSection("UI")

	local CustomThemes = {
		BlackHistoryMonth = {
			TextColor = Color3.fromRGB(),

			Background = Color3.fromRGB(),
			Topbar = Color3.fromRGB(),
			Shadow = Color3.fromRGB(),

			NotificationBackground = Color3.fromRGB(),
			NotificationActionsBackground = Color3.fromRGB(),

			TabBackground = Color3.fromRGB(),
			TabStroke = Color3.fromRGB(),
			TabBackgroundSelected = Color3.fromRGB(),
			TabTextColor = Color3.fromRGB(),
			SelectedTabTextColor = Color3.fromRGB(),

			ElementBackground = Color3.fromRGB(),
			ElementBackgroundHover = Color3.fromRGB(),
			SecondaryElementBackground = Color3.fromRGB(),
			ElementStroke = Color3.fromRGB(),
			SecondaryElementStroke = Color3.fromRGB(),

			SliderBackground = Color3.fromRGB(),
			SliderProgress = Color3.fromRGB(),
			SliderStroke = Color3.fromRGB(),

			ToggleBackground = Color3.fromRGB(),
			ToggleEnabled = Color3.fromRGB(),
			ToggleDisabled = Color3.fromRGB(),
			ToggleEnabledStroke = Color3.fromRGB(),
			ToggleDisabledStroke = Color3.fromRGB(),
			ToggleEnabledOuterStroke = Color3.fromRGB(),
			ToggleDisabledOuterStroke = Color3.fromRGB(),

			DropdownSelected = Color3.fromRGB(),
			DropdownUnselected = Color3.fromRGB(),

			InputBackground = Color3.fromRGB(),
			InputStroke = Color3.fromRGB(),
			PlaceholderColor = Color3.fromRGB()
		},
		Default = "DarkBlue",
		Dark = "Default"
	}

	Tab:CreateDropdown({
		Name = "🖼 • Change Theme",
		Options = {"BlackHistoryMonth", "Default", "Dark", "AmberGlow", "Amethyst", "Ocean", "Light", "Bloom", "Green", "Serenity"},
		MultipleOptions = false,
		Flag = "Theme",
		Callback = function(CurrentOption)
			CurrentOption = CurrentOption[1]

			if CurrentOption == "" then
				return
			end

			Window.ModifyTheme(CustomThemes[CurrentOption] or CurrentOption)
		end,
	})

	Tab:CreateSection("Development")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			TeleportService:Teleport(game.PlaceId, Player, {FrostByteRejoin = true})
		end,
	})

	task.delay(1, function()
		for FlagName: string, CurrentValue: boolean? in OriginalFlags do
			local FlagInfo = Flags[FlagName]

			if not FlagInfo then
				continue
			end
			
			pcall(FlagInfo.Set, FlagInfo, CurrentValue)
		end
	end)

	Notify("Welcome to FrostByte", `Loaded in {math.floor((tick() - StartLoadTime) * 10) / 10}s`, "loader-circle")
end

getgenv().CreateUniversalTabs = CreateUniversalTabs

if not ScriptVersion or ScriptVersion == "Universal" then
	CreateUniversalTabs()
end

local FrostByteStarted = getgenv().FrostByteStarted

if FrostByteStarted then
	FrostByteStarted()
end
