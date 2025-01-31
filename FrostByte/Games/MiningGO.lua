local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.5.5a"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector
local hookmetamethod: (Object: Object, Metamethod: string, NewFunction: (Object?, any) -> (any)) -> ((any) -> (any)) = getfenv().hookmetamethod
local getnamecallmethod: () -> (string) = getfenv().getnamecallmethod
local checkcaller: () -> (boolean) = getfenv().checkcaller

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = game:GetService("Players").LocalPlayer

local BinderEvent: RemoteEvent = ReplicatedStorage._Binder_Event
local BinderFunction: RemoteFunction = ReplicatedStorage._Binder_Function

local UpgradeTreeImages = ReplicatedStorage.Assets.UpgradeTreeImages
local InteractZones: Folder = ReplicatedStorage.InteractZones

local GiantOreSummary = Player.PlayerGui.GameGui.GiantOreSummary
local Quests: Frame = Player.PlayerGui.InventoryGui.Inventory.Inventory.Inner.Content["2"].Inner

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

local function CollectDrops(Enabled: boolean)
	if not firetouchinterest then
		return
	end
	
	if not Enabled then
		return
	end

	for i,v: BasePart in workspace.Drops:GetChildren() do
		if not v:FindFirstChild("Frame") then -- i fixed it blob are you happy
			continue
		end
		
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 0)
		firetouchinterest(v.Frame, Player.Character.HumanoidRootPart, 1)
	end
end

local Rayfield = getgenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

local Window = getgenv().Window

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
				
				local Speed = Flags.Speed.CurrentValue
				
				BinderEvent:FireServer("Mining_Start")
				task.wait(Speed)
				BinderEvent:FireServer(RemoteName, Ore.Name, Speed, Flags.Critical.CurrentValue)
				break
			end
		end
	end,
})

Tab:CreateSlider({
	Name = "💨 • Auto Mine Speed",
	Range = {0, 1},
	Increment = 0.01,
	Suffix = "Second(s)",
	CurrentValue = 0.7,
	Flag = "Speed",
	Callback = function()end,
})

Tab:CreateDivider()

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
	Name = ApplyUnsupportedName("💎 • Auto Collect Drops", firetouchinterest),
	CurrentValue = false,
	Flag = "Collect",
	Callback = CollectDrops,
})

if firetouchinterest then
	HandleConnection(workspace.Drops.ChildAdded:Connect(function()
		CollectDrops(Flags.Collect.CurrentValue)
	end), "Collect")
end

Tab:CreateSection("Marketplace")

Tab:CreateToggle({
	Name = "💰 • Auto Purchase from Ore Marketplace",
	CurrentValue = false,
	Flag = "Marketplace",
	Callback = function(Value)
		while Flags.Marketplace.CurrentValue and task.wait(1) do
			for _, Element: Frame in Player.PlayerGui.GameGui.OreMarketplace.Content.Deals.Inner:GetChildren() do
				if not Element:IsA("Frame") then
					continue
				end
				
				if not Flags.Marketplace.CurrentValue then
					return
				end
				
				if Flags.Free.CurrentValue then
					if Element.Inner.Cost.Title.Text ~= "0" then
						continue
					end

					if Element.Inner.Center.Purchased2.Visible then
						continue
					end
				end

				BinderFunction:InvokeServer("Marketplace_Purchase", tostring(Element.LayoutOrder))
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
				firesignal(Player.PlayerGui.GameGui.OreMarketplace.Refresh.RefreshButton.MouseButton1Click) -- switch back to remote
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
	pcall(function()
		fireclickdetector(workspace.Map["The Part That Doesn't Do Anything"].ClickDetector)
	end)
	
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

		if Value and firetouchinterest then
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
			for _, SideBarQuestElem: Frame? in Quests:GetChildren() do
				if not SideBarQuestElem:IsA("Frame") then
					continue
				end
				
				local Inner: Frame = SideBarQuestElem:FindFirstChild("Inner")
				
				if not Inner then
					continue
				end
				
				for _, SideBarQuestReq: Frame in Inner.Req:GetChildren() do
					local Title: TextLabel = SideBarQuestReq:FindFirstChild("Title")
					
					if not Title then
						continue
					end
					
					for _, Dispenser: string in Dispensers do
						local ItemName = Dispenser:gsub("Dispenser ", "")
						
						if not Title.Text:find(ItemName) then
							continue
						end
						
						local Start = Title.Text:split("[")[2]
						local Between = Start:split("]")[1]
						
						local Numbers = Between:split("/")
						
						if Numbers[1] == Numbers[2] then
							continue
						end
						
						Roll(Dispenser, if Title.Text:find("Empowered") then true else false)
					end
				end
			end
		end

		if Value and firetouchinterest then
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

local LastCompletedQuest

Tab:CreateToggle({
	Name = "📜 • Auto Quests",
	CurrentValue = false,
	Flag = "Quests",
	Callback = function(Value)
		while Flags.Quests.CurrentValue and task.wait(1) do
			for _, SideBarQuestElem: Frame? in Quests:GetChildren() do
				if not SideBarQuestElem:IsA("Frame") then
					continue
				end
				
				local Top: Frame = SideBarQuestElem.Inner.Req.Top
				local QuestName: TextLabel = Top.QuestName
				local NpcName: TextLabel = Top.NpcName
				
				if not QuestName.Text:find("Completed") then
					if NpcName.Text == LastCompletedQuest or not LastCompletedQuest then
						LastCompletedQuest = nil
						QuestTPing = false
					end
					
					continue
				end
				
				local Zone
				
				for _, CurrentZone: Part in InteractZones:GetChildren() do
					if not NpcName.Text:lower():find(CurrentZone.Name:lower()) then
						continue
					end
					
					Zone = CurrentZone
					break
				end
				
				if not Zone then
					continue
				end
				
				QuestTPing = true
				LastCompletedQuest = NpcName.Text
				
				if Player:DistanceFromCharacter(Zone.Position) >= 15 then
					Player.Character:PivotTo(Zone.CFrame)
				end
				
				for _, QuestRemotes in {{"Dialog_Start", Zone.Name}, {"Dialog_Next", "Q11.1"}, {"Dialog_Next", "Q11.2"}, {"Dialog_Next", "Q11.4"}} do
					BinderEvent:FireServer(QuestRemotes[1], QuestRemotes[2])
				end
			end
		end
	end,
})

local Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("UI")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("📦 • Auto Keep/Replace Equipment (Based on Tiers)", firesignal),
	CurrentValue = false,
	Flag = "KeepReplace",
	Callback = function()
		while Flags.KeepReplace.CurrentValue and task.wait() do
			local Roll: Frame = Player.PlayerGui.StartGui.Roll
			
			if not Roll:FindFirstChild("Old") then
				continue
			end
			
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
	Name = ApplyUnsupportedName("✅ • Auto Keep Equipment", firesignal),
	CurrentValue = false,
	Flag = "Keep",
	Callback = function()
		while Flags.Keep.CurrentValue and task.wait() do
			local Roll: Frame = Player.PlayerGui.StartGui.Roll
			
			if not Roll:FindFirstChild("Old") then
				continue
			end

			if not Roll.Visible or not Roll.Old.Stat:FindFirstChild("Frame") then
				continue
			end

			local OldStats = Roll.Old.Stat.Frame
			local OldButton = Roll.Old.Button

			repeat
				firesignal(OldButton.MouseButton1Click)
				task.wait(0.1)
			until not Roll.Visible
		end
	end,
})

Tab:CreateSection("Transport")

local WasVisible = false

Tab:CreateToggle({
	Name = "🎫 • Auto Purchase Ticket for Fission Flats",
	CurrentValue = false,
	Flag = "Ticket",
	Callback = function(Value)
		while Flags.Ticket.CurrentValue and task.wait() do
			local Mouse = InteractZones.Mouse

			local Distance = (Player.Character:GetPivot().Position - Mouse.Position).Magnitude

			if Distance > 300 then
				QuestTPing = false
				continue
			end
			
			local Purchased = false
			
			for i,v in Player.PlayerGui.GameGui.NotifPickup.Inner:GetChildren() do
				if v.Name ~= "Notif" then
					continue
				end
				
				local Content: TextLabel = v.Inner.TextArea.Content
				
				if not Content.Text:find("Fission") then
					continue
				end
				
				local Numbers = Content.Text:gsub("%D", "")
				
				if tonumber(Numbers) and tonumber(Numbers) <= 5 then
					QuestTPing = true
					Player.Character:PivotTo(InteractZones.Roach2:GetPivot())
					
					repeat
						task.wait()
					until (Player.Character:GetPivot().Position - Mouse.Position).Magnitude >= 300 or not Flags.Ticket.CurrentValue
				end
				
				Purchased = true
				WasVisible = true
				break
			end
			
			if Purchased then
				continue
			end
			
			BinderFunction:InvokeServer("Ticket_Buy", "Fission Flats")
			
			print("purchasing ticket")
		end
	end,
})

getgenv().CreateUniversalTabs()
