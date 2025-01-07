ScriptVersion = "v1.4.3"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = game:GetService("Players").LocalPlayer

local BinderEvent: RemoteEvent = ReplicatedStorage._Binder_Event
local BinderFunction: RemoteFunction = ReplicatedStorage._Binder_Function

local UpgradeTreeImages = ReplicatedStorage.Assets.UpgradeTreeImages
local InteractZones = ReplicatedStorage.InteractZones

local GiantOreSummary = Player.PlayerGui.GameGui.GiantOreSummary

local OresFolder = workspace:WaitForChild("Ores")

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

for i,v in ReplicatedStorage.DispenserFrames:GetChildren() do
	table.insert(Dispensers, v.Name)
end

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getfenv().HandleConnection
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector

local function CollectDrops(Enabled: boolean)
	if not Enabled then
		return
	end

	for i,v in workspace.Drops:GetChildren() do
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 0)
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 1)
	end
end

local Rayfield = getfenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any}} = Rayfield.Flags

local Window = getfenv().Window

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Ores")

Tab:CreateToggle({
	Name = "⛏ • Auto Mine",
	CurrentValue = false,
	Flag = "Mine",
	Callback = function(Value)	
		while Flags.Mine.CurrentValue and task.wait() do
			local Character: Model? = Player.Character

			if not Character then
				continue
			end

			local HumanoidRootPart: BasePart? = Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			local Ores = OresFolder:GetChildren()

			for _, Ore in Ores do
				if not Ore.Model:GetChildren()[1] then
					continue
				end
				
				if (HumanoidRootPart.Position - Ore.Base.Position).Magnitude > 15 then
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
	Name = "💥 • Critical Strike Ores",
	CurrentValue = false,
	Flag = "Critical",
	Callback = function()end,
})

local LastTPLocation

Tab:CreateToggle({
	Name = "🧱 • Teleport Below Ores",
	CurrentValue = false,
	Flag = "TP",
	Callback = function(Value)
		local PreviousLocation = Player.Character and Player.Character:GetPivot()
		
		while Flags.TP.CurrentValue and task.wait() do
			if QuestTPing then
				continue
			end
			
			local Character = Player.Character

			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			local Ores = OresFolder:GetChildren()
			
			local DidTP = false

			for _, Ore: Model in Ores do
				if not Ore.Model:GetChildren()[1] then
					continue
				end

				local Size = Ore.Base.Size
				
				LastTPLocation = Ore.Base:GetPivot() - Vector3.yAxis * Size.Y * 2
				HumanoidRootPart:PivotTo(LastTPLocation)
				Character.Humanoid.CameraOffset = Vector3.yAxis * 10
				DidTP = true
				break
			end
			
			if not DidTP and LastTPLocation then
				HumanoidRootPart:PivotTo(LastTPLocation)
			end
		end
		
		if Value and PreviousLocation then
			Player.Character:PivotTo(PreviousLocation)
			Player.Character.Humanoid.CameraOffset = Vector3.zero
		end
	end,
})

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "💎 • Auto Collect Drops",
	CurrentValue = false,
	Flag = "Collect",
	Callback = CollectDrops,
})

HandleConnection(workspace.Drops.ChildAdded:Connect(function()
	CollectDrops(Flags.Collect.CurrentValue)
end), "Collect")

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
				
				if not Flags.Marketplace.CurrentValue then
					return
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
				firesignal(Player.PlayerGui.GameGui.OreMarketplace.Refresh.RefreshButton.MouseButton1Click)
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

Tab:CreateSection("Rolling")

local function Roll(Dispenser, Empowered)
	pcall(fireclickdetector, workspace.Map["The Part That Doesn't Do Anything"].ClickDetector)
	BinderFunction:InvokeServer("Roll_RollItem", Dispenser, Empowered)
end

Tab:CreateToggle({
	Name = "🔄 • Auto Roll Equipment",
	CurrentValue = false,
	Flag = "Roll",
	Callback = function(Value)
		while Flags.Roll.CurrentValue and task.wait() do
			Roll(Flags.Dispenser.CurrentOption[1], Flags.Empowered.CurrentValue)
		end

		if Value then
			CollectDrops(true)
		end
	end,
})

Tab:CreateToggle({
	Name = "✨ • Empowered Auto Rolls",
	CurrentValue = false,
	Flag = "Empowered",
	Callback = function()end,
})

Tab:CreateDropdown({
	Name = "⚒ • Equipment Dispenser",
	Options = Dispensers,
	CurrentOption = Dispensers[1],
	MultipleOptions = false,
	Flag = "Dispenser",
	Callback = function()end,
})

Tab:CreateToggle({
	Name = "📖 • Auto Quest Roll",
	CurrentValue = false,
	Flag = "RollQuest",
	Callback = function(Value)
		while Flags.RollQuest.CurrentValue and task.wait() do
			local QuestElem = Player.PlayerGui.StartGui.Quests.Inner:FindFirstChild("QuestElem")

			if QuestElem and not QuestElem.Inner.TextArea.Title.Text:lower():find("complete") then
				for _, Quest: TextLabel in QuestElem.Inner.TextArea:GetChildren() do
					if not Quest:IsA("TextLabel") or Quest.FontFace.Bold then
						continue
					end
					
					for _, Dispenser: string in Dispensers do
						local ItemName = Dispenser:gsub("Dispenser ", "")
						if Quest.Text:find(ItemName) then
							Roll(Dispenser, if Quest.Text:find("Empowered") then true else false)
						end
					end
				end
			end
		end

		if Value then
			CollectDrops(true)
		end
	end,
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
				local CompletedAllQuests = true

				for _, Task: TextLabel in QuestElem.Inner.TextArea:GetChildren() do
					if not Task:IsA("TextLabel") then
						continue
					end
					
					if not Task.FontFace.Bold then
						CompletedAllQuests = false
						break
					end
				end

				if not CompletedAllQuests then
					continue
				end
			end

			QuestTPing = true

			local Mouse = InteractZones.Mouse
			
			if (Player.Character:GetPivot().Position - Mouse.Position).Magnitude > 10 then
				Player.Character:PivotTo(Mouse:GetPivot())
			end

			for _, QuestRemotes in {{"Dialog_Start", "Mouse"}, {"Dialog_Next", "Q11.1"}, {"Dialog_Next", "Q11.2"}, {"Dialog_Next", "Q11.4"}} do
				BinderEvent:FireServer(QuestRemotes[1], QuestRemotes[2])
			end
		end
	end,
})

local Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("UI")

Tab:CreateToggle({
	Name = "📦 • Auto Keep/Replace Equipment (Based on Tiers)",
	CurrentValue = false,
	Flag = "KeepReplace",
	Callback = function()
		while Flags.KeepReplace.CurrentValue and task.wait() do
			local Roll = Player.PlayerGui.StartGui.Roll
			
			if not Roll.Visible or not Roll.Old.Stat:FindFirstChild("Frame") then
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
			local RerollButton = Roll.Reroll.Reroll

			if Combined[NewStats] > Combined[OldStats] then
				print("replace start")
				repeat
					firesignal(NewButton.MouseButton1Click)
					task.wait(0.1)
				until not Roll.Visible
				
				print("replaced")
			elseif RerollButton.Text == "FREE" and RerollButton.Parent.Visible then
				print("reroll start")
				BinderEvent:FireServer("Rolling_Free_Reroll")

				repeat
					task.wait(0.1)
				until RerollButton.Text ~= "FREE" or not RerollButton.Parent.Visible
				print("rerolled")
			else
				print("keep start")
				repeat
					firesignal(OldButton.MouseButton1Click)
					task.wait(0.1)
				until not Roll.Visible
				
				print("kept")
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "❌ • Remove Giant Ore Summary",
	CurrentValue = false,
	Flag = "GiantSummary",
	Callback = function(Value)
		if GiantOreSummary.Visible and not Value then
			GiantOreSummary.Visible = false
		end
	end,
})

HandleConnection(GiantOreSummary:GetPropertyChangedSignal("Visible"):Connect(function()
	if GiantOreSummary.Visible and Flags.GiantSummary.CurrentValue then
		GiantOreSummary.Visible = false
	end
end), "GiantSummary")

getfenv().CreateUniversalTabs()
