local Version = "v1.3.4"

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = MarketplaceService:GetProductInfo(game.PlaceId).Name

local BinderEvent: RemoteEvent = ReplicatedStorage._Binder_Event
local BinderFunction: RemoteFunction = ReplicatedStorage._Binder_Function

local UpgradeTreeImages = ReplicatedStorage.Assets.UpgradeTreeImages
local InteractZones = ReplicatedStorage.InteractZones

local GiantOreSummary = Player.PlayerGui.GameGui.GiantOreSummary

local OresFolder = workspace.Ores

local BoughtUpgrades = {}
local QuestTPing = false
local TierValues = {
	C = 1,
	B = 2,
	A = 3,
	S = 4,
	X = 5
}

local Dispensers = {}

for i,v in InteractZones:GetChildren() do
	if v.Name:lower():find("dispenser") then
		table.insert(Dispensers, v.Name)
	end
end

local function CollectDrops(Enabled: boolean)
	if not Enabled then
		return
	end

	for i,v in workspace.Drops:GetChildren() do
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 0)
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 1)
	end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Flags = Rayfield.Flags

local Window = Rayfield:CreateWindow({
	Name = `FrostByte | {PlaceName} | {Version}`,
	Icon = "snowflake",
	LoadingTitle = "❄ Presented to you by FrostByte ❄",
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

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Ores")

Tab:CreateToggle({
	Name = "⛏ • Auto Mine",
	CurrentValue = false,
	Flag = "Mine",
	Callback = function(Value)
		while Flags.Mine.CurrentValue and task.wait() do
			local Character = Player.Character

			if not Character then
				continue
			end

			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			local Ores = OresFolder:GetChildren()

			local CharacterPosition = HumanoidRootPart.Position

			for _, Ore in Ores do
				if not Ore.Model:GetChildren()[1] then
					continue
				end

				local RemoteName = "Mining_MineOre"

				if Ore:FindFirstChild("OreTipGiant") then
					RemoteName ..= "P"
				end
				
				BinderEvent:FireServer("Mining_Start")
				BinderEvent:FireServer(RemoteName, Ore.Name, Random.new():NextNumber(0.8, 0.9), Flags.Critical.CurrentValue)
				break
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "💥 • Auto Critical Strike Ores",
	CurrentValue = false,
	Flag = "Critical",
	Callback = function(Value)
	end,
})

Tab:CreateLabel("Will Not Work Without a Crit Zone", "arrow-up")

Tab:CreateToggle({
	Name = "💎 • Auto Collect Drops",
	CurrentValue = false,
	Flag = "Collect",
	Callback = CollectDrops,
})

if CollectConnection then
	CollectConnection:Disconnect()
end

getgenv().CollectConnection = workspace.Drops.ChildAdded:Connect(function()
	CollectDrops(Flags.Collect.CurrentValue)
end)

Tab:CreateToggle({
	Name = "🧱 • Auto TP to Ores",
	CurrentValue = false,
	Flag = "TP",
	Callback = function(Value)
		while Flags.TP.CurrentValue and task.wait() do
			if QuestTPing then
				continue
			end

			local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			local Ores = OresFolder:GetChildren()

			for i,v in Ores do
				if not v.Model:GetChildren()[1] then
					continue
				end

				local Size = v:GetExtentsSize()

				HumanoidRootPart:PivotTo(v.Base:GetPivot() + Vector3.new(Size.X / 3, 4, 0))
				break
			end
		end
	end,
})

Tab:CreateLabel("Only Use with Ore Pulse", "arrow-up")

Tab:CreateSection("Marketplace")

Tab:CreateToggle({
	Name = "💰 • Auto Purchase from Ore Marketplace",
	CurrentValue = false,
	Flag = "Marketplace",
	Callback = function(Value)
		while Flags.Marketplace.CurrentValue and task.wait(1) do
			local ElementNumber = 0

			for i,v in Player.PlayerGui.GameGui.OreMarketplace.Content.Deals.Inner:GetChildren() do
				if not v:IsA("Frame") then
					continue
				end

				ElementNumber += 1

				if Flags.Free.CurrentValue and v.Inner.Cost.Title.Text ~= "0" then
					continue
				end

				BinderFunction:InvokeServer("Marketplace_Purchase", tostring(ElementNumber))
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "💹 • Only Purchase Free Listings",
	CurrentValue = false,
	Flag = "Free",
	Callback = function()end,
})

Tab:CreateToggle({
	Name = "🔁 • Auto Refresh Ore Marketplace",
	CurrentValue = false,
	Flag = "Refresh",
	Callback = function(Value)
		while Flags.Refresh.CurrentValue and task.wait(1) do
			local Title = Player.PlayerGui.GameGui.OreMarketplace.Refresh.RefreshButton.Cost.Title
			local Numbers = Title.Text:gsub("%D", "")

			if Title.Text:find("k") then
				Numbers ..= "000"
			end

			if tonumber(Numbers) > Flags.MaxRefresh.CurrentValue then
				continue
			end

			local ElementNumber = 0
			local SuccessfulPurchases = 0

			for _, Deal in Player.PlayerGui.GameGui.OreMarketplace.Content.Deals.Inner:GetChildren() do
				if not Deal:IsA("Frame") then
					continue
				end

				ElementNumber += 1

				if Deal.Inner.Center.Purchased2.Visible then
					SuccessfulPurchases += 1
				end
			end

			if SuccessfulPurchases == ElementNumber then
				BinderFunction:InvokeServer("Marketplace_Refresh")
				task.wait(5)
			end
		end
	end,
})

Tab:CreateSlider({
	Name = "💵 • Max Refresh Price",
	Range = {5, 10000},
	Increment = 5,
	Suffix = "Ores",
	CurrentValue = 5,
	Flag = "MaxRefresh",
	Callback = function()end,
})

Tab:CreateSection("Dispensers")

Tab:CreateToggle({
	Name = "🔄 • Auto Roll Equipment",
	CurrentValue = false,
	Flag = "Roll",
	Callback = function(Value)
		while Flags.Roll.CurrentValue and task.wait() do
			BinderFunction:InvokeServer("Roll_RollItem", Flags.Dispenser.CurrentOption[1])
		end

		if Value then
			CollectDrops(true)
		end
	end,
})

Tab:CreateLabel("Disable Collect Drops for Easier/AFK Use", "arrow-up")

Tab:CreateDropdown({
	Name = "⚒ • Equipment Dispenser",
	Options = Dispensers,
	CurrentOption = Dispensers[1],
	MultipleOptions = false,
	Flag = "Dispenser",
	Callback = function()end,
})

Tab:CreateSection("Upgrades")

Tab:CreateToggle({
	Name = "📈 • Auto Upgrade",
	CurrentValue = false,
	Flag = "Upgrade",
	Callback = function(Value)
		while Flags.Upgrade.CurrentValue and task.wait(1) do
			for _, Upgrade in UpgradeTreeImages:GetChildren() do
				if BoughtUpgrades[Upgrade.Name] then
					continue
				end

				task.spawn(function()
					if BinderFunction:InvokeServer("Tree_Upgrade", Upgrade.Name) then
						BoughtUpgrades[Upgrade.Name] = true

						Rayfield:Notify({
							Title = Upgrade.Name,
							Content = "Bought by Auto Upgrade!",
							Duration = 10,
							Image = "book-plus",
						})
					end
				end)
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "📜 • Auto Quests",
	CurrentValue = false,
	Flag = "Quests",
	Callback = function(Value)
		while Flags.Quests.CurrentValue and task.wait(1) do
			local QuestElem = Player.PlayerGui.StartGui.Quests.Inner:FindFirstChild("QuestElem")

			QuestTPing = false

			if QuestElem and not QuestElem.Inner.TextArea.Title.Text:lower():find("complete") then
				local CompletedTasks = 0
				local TotalTasks = 0

				for _, Task: TextLabel in QuestElem.Inner.TextArea:GetChildren() do
					if not Task:IsA("TextLabel") then
						continue
					end

					TotalTasks += 1

					if Task.FontFace.Bold then
						CompletedTasks += 1
					end
				end

				if CompletedTasks ~= TotalTasks then
					continue
				end
			end

			QuestTPing = true

			local MouseHumanoidRootPart = workspace.Map.Mouse.HumanoidRootPart

			if (Player.Character:GetPivot().Position - MouseHumanoidRootPart.Position).Magnitude > 10 then
				Player.Character:PivotTo(MouseHumanoidRootPart:GetPivot())
			end

			for _, QuestRemotes in {{"Dialog_Start", "Mouse"}, {"Dialog_Next", "Q11.1"}, {"Dialog_Next", "Q11.2"}, {"Dialog_Next", "Q11.4"}} do
				BinderEvent:FireServer(QuestRemotes[1], QuestRemotes[2])
			end
		end
	end,
})

local Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("UI")

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 5

Tab:CreateToggle({
	Name = "📦 • Highlight Best Keep/Replace Choice (Based on Tier)",
	CurrentValue = false,
	Flag = "KeepReplace",
	Callback = function(Value)
		while Flags.KeepReplace.CurrentValue and task.wait() do
			local Roll = Player.PlayerGui.StartGui.Roll

			if not Roll.Visible or not Roll.Old.Visible then
				UIStroke.Parent = nil
				continue
			end

			local NewStats = Roll.New.Stat.Frame
			local OldStats = Roll.Old.Stat.Frame

			local Combined = {
				[NewStats] = 0,
				[OldStats] = 0
			}

			for _, Stats in {NewStats, OldStats} do
				for _, Stat in Stats:GetChildren() do
					if Stat.Name ~= "Stat" then
						continue
					end

					Combined[Stats] += TierValues[Stat.Tier.Text]
				end
			end

			local NewButton = Roll.New.Button
			local OldButton = Roll.Old.Button

			local NewUIStroke = NewButton:FindFirstChild("UIStroke")
			local OldUIStroke = OldButton:FindFirstChild("UIStroke")

			if NewUIStroke then
				NewUIStroke.Parent = nil
			end

			if OldUIStroke then
				OldUIStroke.Parent = nil
			end

			if Combined[NewStats] > Combined[OldStats] then
				UIStroke.Parent = NewButton
			else
				UIStroke.Parent = OldButton
			end
		end

		UIStroke.Parent = nil
	end,
})

Tab:CreateToggle({
	Name = "❌ • Remove Giant Ore Summary",
	CurrentValue = false,
	Flag = "GiantSummary",
	Callback = function(Value)
		GiantOreSummary.Visible = not Value
	end,
})

if SummaryConnection then
	SummaryConnection:Disconnect()
end

getgenv().SummaryConnection = GiantOreSummary:GetPropertyChangedSignal("Visible"):Connect(function()
	if GiantOreSummary.Visible and Flags.GiantSummary.CurrentValue then
		GiantOreSummary.Visible = false
	end
end)

Tab:CreateSection("Safety")

local Part

local function GenerateRandomPos(Min, Max, Negative)
	local Positive = Random.new():NextNumber(Min, Max)

	if not Negative then
		return Positive
	end

	return if math.random(2) == 1 then Random.new():NextNumber(Min, Max) else Random.new():NextNumber(-Min, -Max)
end

Tab:CreateToggle({
	Name = "🔑 • Teleport to Safe Location",
	CurrentValue = false,
	Flag = "Safe",
	Callback = function(Value)
		if Value and not Part then
			Part = Instance.new("Part")
			Part.Anchored = true
			Part.Position = Vector3.new(GenerateRandomPos(800, 1000, true), GenerateRandomPos(800, 1000), GenerateRandomPos(800, 1000, true))
			Part.Size = Vector3.new(10, 2, 10)
			Part.Parent = workspace
		end

		local PreviousLocation = Player.Character and Player.Character:GetPivot()

		while Flags.Safe.CurrentValue and task.wait() do
			local Character = Player.Character

			if not Character or (Character:GetPivot().Position - Part.Position).Magnitude < 15 then
				continue
			end

			if QuestTPing then
				continue
			end

			Character:PivotTo(Part:GetPivot() + Vector3.yAxis * 5)
		end

		if Value then
			Player.Character:PivotTo(PreviousLocation)
		end
	end,
})

local Tab = Window:CreateTab("Universal", "earth")

Tab:CreateSection("AFK")

Tab:CreateToggle({
	Name = "🔒 • Anti AFK Disconnection",
	CurrentValue = true,
	Flag = "AntiAFK",
	Callback = function(Value)
	end,
})

if IdledConnection then
	IdledConnection:Disconnect()
end

getgenv().IdledConnection = Player.Idled:Connect(function()
	if not Flags.AntiAFK.CurrentValue then
		return
	end

	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.zero)
end)

Tab:CreateSection("Miscellaneous")

Tab:CreateButton({
	Name = "⚙️ • Rejoin",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId)
	end,
})
