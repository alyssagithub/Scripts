local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Version = "v1.0.0"

local Flags = Rayfield.Flags

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name

local BinderEvent: RemoteEvent = ReplicatedStorage._Binder_Event
local BinderFunction: RemoteFunction = ReplicatedStorage._Binder_Function

local UpgradeTreeImages = ReplicatedStorage.Assets.UpgradeTreeImages

local OresFolder = workspace.Ores

local BoughtUpgrades = {}
local QuestTPing = false

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
		FileName = "FrostByte Settings"
	},

	Discord = {
		Enabled = true,
		Invite = "sS3tDP6FSB",
		RememberJoins = true
	},
})

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Mining")

Tab:CreateToggle({
	Name = "⛏ Auto Mine",
	CurrentValue = false,
	Flag = "Mine",
	Callback = function(Value)
		while Flags.Mine.CurrentValue and task.wait() do
			local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			local Ores = OresFolder:GetChildren()

			local CharacterPosition = HumanoidRootPart.Position

			table.sort(Ores, function(a, b)
				return (CharacterPosition - a.Base.Position).Magnitude < (CharacterPosition - b.Base.Position).Magnitude
			end)

			local ClosestOre = Ores[1]

			if not ClosestOre then
				continue
			end

			local RemoteName = "Mining_MineOre"

			if ClosestOre:FindFirstChild("OreTipGiant") then
				RemoteName ..= "P"
			end

			BinderEvent:FireServer(RemoteName, ClosestOre.Name, 0.90812974927491, Flags.Critical.CurrentValue)
		end
	end,
})

Tab:CreateToggle({
	Name = "💥 Auto Critical Strike Ores (only works on ores with a crit zone)",
	CurrentValue = false,
	Flag = "Critical",
	Callback = function(Value)
	end,
})

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "💎 Auto TP to Ores",
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
					--continue
				end

				local Size = v:GetExtentsSize()

				HumanoidRootPart:PivotTo(v.Base:GetPivot() + Vector3.new(Size.X / 3, 4, 0))
				break
			end
		end
	end,
})

Tab:CreateSection("Upgrades")

Tab:CreateToggle({
	Name = "💰 Auto Purchase from Ore Marketplace",
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
				
				BinderFunction:InvokeServer("Marketplace_Purchase", tostring(ElementNumber))
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "🔁 Auto Refresh Ore Marketplace",
	CurrentValue = false,
	Flag = "Refresh",
	Callback = function(Value)
		while Flags.Refresh.CurrentValue and task.wait(1) do
			local ElementNumber = 0
			local SuccessfulPurchases = 0

			for i,v in Player.PlayerGui.GameGui.OreMarketplace.Content.Deals.Inner:GetChildren() do
				if not v:IsA("Frame") then
					continue
				end

				ElementNumber += 1
				
				if v.Inner.Center.Purchased2.Visible then
					SuccessfulPurchases += 1
				end

				if SuccessfulPurchases == ElementNumber then
					BinderFunction:InvokeServer("Marketplace_Refresh")
				end
			end
		end
	end,
})

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "📈 Auto Upgrade",
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
						print("Bought Upgrade:", Upgrade.Name)
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
	Name = "📜 Auto Quests",
	CurrentValue = false,
	Flag = "Quests",
	Callback = function(Value)
		while Flags.Quests.CurrentValue and task.wait(1) do
			local QuestElem = Player.PlayerGui.StartGui.Quests.Inner:FindFirstChild("QuestElem")

			QuestTPing = false

			if QuestElem and not QuestElem.Inner.TextArea.Title.Text:lower():find("complete") then
				continue
			end

			QuestTPing = true

			Player.Character:PivotTo(workspace.Map.Mouse.HumanoidRootPart:GetPivot())

			for _, QuestRemotes in {{"Dialog_Start", "Mouse"}, {"Dialog_Next", "Q11.1"}, {"Dialog_Next", "Q11.2"}, {"Dialog_Next", "Q11.4"}} do
				BinderEvent:FireServer(QuestRemotes[1], QuestRemotes[2])
			end
		end
	end,
})
