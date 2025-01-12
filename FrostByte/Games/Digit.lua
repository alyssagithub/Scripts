ScriptVersion = "v1.1.1"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shovels = {}
local OriginalShovelNames = {}

local function AddComma(amount: number)
	local formatted = amount
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

for i,v in ReplicatedStorage.Settings.Items.Shovels:GetChildren() do
	local Success, ItemInfo = pcall(require, v)

	local BuyPrice = 0

	if Success then
		if not ItemInfo.BuyPrice then
			continue
		end
		BuyPrice = ItemInfo.BuyPrice
	end

	local NewName = `{v.Name} (${AddComma(BuyPrice)})`
	
	table.insert(Shovels, NewName)
	OriginalShovelNames[NewName] = {
		Name = v.Name,
		BuyPrice = BuyPrice
	}
end

table.sort(Shovels, function(a,b)
	return OriginalShovelNames[a].BuyPrice < OriginalShovelNames[b].BuyPrice
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local UnsupportedName: string = getfenv().UnsupportedName
local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getfenv().HandleConnection
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector
local Notify: (Title: string, Content: string, Image: string) -> () = getfenv().Notify

local Rayfield = getfenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any}} = Rayfield.Flags

local CollectionService = game:GetService("CollectionService")

local Player = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")

local Window = getfenv().Window

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("AFK Digging")

Tab:CreateToggle({
	Name = "⛏️ • Auto Dig Close Piles (Bypasses Capacity, Faster)",
	CurrentValue = false,
	Flag = "Dig",
	Callback = function(Value)	
		while Flags.Dig.CurrentValue and task.wait() do
			for _, Pile: Model in workspace.Map.TreasurePiles:GetChildren() do
				if (Pile:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude > 30 then
					continue
				end

				RemoteFunctions.Digging:InvokeServer({
					Command = "DigPile",
					TargetPileIndex = tonumber(Pile.Name)
				})
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "🕳️ • Auto Create Piles (Bypasses Capacity, Any Terrain)",
	CurrentValue = false,
	Flag = "CreatePiles",
	Callback = function(Value)	
		while Flags.CreatePiles.CurrentValue and task.wait() do	
			if CollectionService:GetTagged("FrostBytePile")[1] then
				continue
			end
			
			local PileInfo: {["PileIndex"]: number, ["Success"]: boolean} = RemoteFunctions.Digging:InvokeServer({
				Command = "CreatePile"
			})
			
			if PileInfo.Success then
				RemoteEvents.Digging:FireServer({
					Command = "DigIntoSandSound"
				})
				
				workspace.Map.TreasurePiles:WaitForChild(tostring(PileInfo.PileIndex)):AddTag("FrostBytePile")
			end
		end
	end,
})

Tab:CreateSection("OP Digging")

Tab:CreateToggle({
	Name = "⛏️ • Auto Legit Dig (99% Success Rate)",
	CurrentValue = false,
	Flag = "LegitDig",
	Callback = function(Value)	
		while Flags.LegitDig.CurrentValue and task.wait() do
			local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

			if not DigMinigame then
				continue
			end

			DigMinigame.Cursor.Position = DigMinigame.Area.Position
		end
	end,
})

Tab:CreateToggle({
	Name = "🕳 • Auto Legit Create Piles (Needed for Legit Stuff)",
	CurrentValue = false,
	Flag = "LegitPiles",
	Callback = function(Value)	
		while Flags.LegitPiles.CurrentValue and task.wait() do
			if Player.PlayerGui.Main:FindFirstChild("DigMinigame") then
				continue
			end
			
			local VirtualInputManager = game:GetService("VirtualInputManager")
			local X, Y = 0, 0
			VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 1)
			task.wait(1)
		end
	end,
})

Tab:CreateSection("Items")

Tab:CreateToggle({
	Name = "💰 • Auto Sell Inventory at Max Capacity",
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not Value)
		
		while Flags.Sell.CurrentValue and task.wait() do
			local Capacity: TextLabel = Player.PlayerGui.Main.Core.Inventory.Disclaimer.Capacity
			local Current = tonumber(Capacity.Text:split("(")[2]:split("/")[1])
			local Max = tonumber(Capacity.Text:split(")")[1]:split("/")[2])
			
			if Current < Max then
				continue
			end
			
			local Inventory: {[string]: {["Attributes"]: {["Weight"]: number}}} = RemoteFunctions.Player:InvokeServer({
				Command = "GetInventory"
			})
			
			local AnyObjects = false
			
			for _, Object in Inventory do
				if not Object.Attributes.Weight then
					continue
				end
				
				AnyObjects = true
				break
			end
			
			if not AnyObjects then
				task.wait(5)
				continue
			end
			
			for i,v: TextLabel in workspace.Map.Islands:GetDescendants() do
				if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
					continue
				end
				
				local Merchant: Model = v.Parent.Parent
				
				local PreviousPosition = Player.Character:GetPivot()
				
				repeat
					Player.Character:PivotTo(Merchant:GetPivot())
					RemoteEvents.Merchant:FireServer({
						Command = "SellAllTreasures",
						Merchant = Merchant
					})
					task.wait(0.1)
					Current = tonumber(Capacity.Text:split("(")[2]:split("/")[1])
					Max = tonumber(Capacity.Text:split(")")[1]:split("/")[2])
				until Current < Max or not Flags.Sell.CurrentValue
				
				Player.Character:PivotTo(PreviousPosition)
				
				break
			end
		end
	end,
})

local CollectedRewards = {}

Tab:CreateToggle({
	Name = "📦 • Auto Collect Salary Rewards (Will Appear Unclaimed)",
	CurrentValue = false,
	Flag = "Salary",
	Callback = function(Value)	
		while Flags.Salary.CurrentValue and task.wait() do
			local TierTimers = RemoteFunctions.TimeRewards:InvokeServer({
				Command = "GetTierTimers"
			})
			
			for Tier, Timer in TierTimers do
				if Timer ~= 0 then
					CollectedRewards[Tier] = false
					continue
				end
				
				if CollectedRewards[Tier] then
					continue
				end
				
				RemoteFunctions.TimeRewards:InvokeServer({
					Command = "RedeemTier",
					Tier = Tier
				})
				
				CollectedRewards[Tier] = true
			end
			
			task.wait(5)
		end
	end,
})

Tab:CreateDivider()

Tab:CreateSlider({
	Name = "🗃 • Amount of Magnet Boxes to Purchase",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Magnet Box(es)",
	CurrentValue = 1,
	Flag = "MagnetBoxes",
	Callback = function()end,
})

Tab:CreateButton({
	Name = "🧲 • Purchase Magnet Box(es)",
	Callback = function()
		RemoteFunctions.Shop:InvokeServer({
			Command = "Buy",
			Type = "Item",
			Product = "Magnet Box",
			Amount = Flags.MagnetBoxes.CurrentValue
		})
	end,
})

Tab:CreateDivider()

local PurchaseShovel
PurchaseShovel = Tab:CreateDropdown({
	Name = "🧰 • Purchase Shovel",
	Options = Shovels,
	CurrentOption = "",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "" then
			return
		end

		RemoteFunctions.Shop:InvokeServer({
			Command = "Buy",
			Type = "Item",
			Product = OriginalShovelNames[CurrentOption].Name,
			Amount = 1
		})

		PurchaseShovel:Set({""})
	end,
})

Tab:CreateSection("Islands")

local PreviousLocation

local function MeteorIslandTeleport(Meteor: Model?)
	if Meteor.Name ~= "Meteor Island" or not Flags.Meteor.CurrentValue then
		return
	end
	
	local Character = Player.Character
	
	PreviousLocation = Character:GetPivot()
	
	Character:PivotTo(Meteor:GetPivot() + Vector3.yAxis * 100)
end

Tab:CreateToggle({
	Name = "🌠 • Auto Teleport to Meteor Islands",
	CurrentValue = false,
	Flag = "Meteor",
	Callback = function(Value)
		if Value then
			for i,v in workspace.Map.Temporary:GetChildren() do
				MeteorIslandTeleport(v)
			end
		end
	end,
})

HandleConnection(workspace.Map.Temporary.ChildAdded:Connect(MeteorIslandTeleport), "Meteor")
HandleConnection(workspace.Map.Temporary.ChildRemoved:Connect(function(Child: Model?)
	if Child.Name == "Meteor Island" and PreviousLocation then
		Player.Character:PivotTo(PreviousLocation)
	end
end), "MeteorRemoved")

local Islands = {}

for i,v in workspace.Map.Islands:GetChildren() do
	table.insert(Islands, v.Name)
end

for i,v in ReplicatedStorage.Assets.Sounds.Soundtrack.Locations:GetChildren() do
	if v.Name == "Ocean" then
		continue
	end
	
	if not table.find(Islands, v.Name) then
		table.insert(Islands, v.Name)
	end
end

table.sort(Islands)

local TeleporttoIsland

TeleporttoIsland = Tab:CreateDropdown({
	Name = "🏝 • Teleport to Island",
	Options = Islands,
	CurrentOption = "",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]
		
		if CurrentOption == "" then
			return
		end
		
		local Island: Folder = workspace.Map.Islands:FindFirstChild(CurrentOption)
		
		if not Island then
			return Notify("Error", "That island doesn't currently exist.")
		end
		
		if Island:FindFirstChild("LocationSpawn") then
			Player.Character:PivotTo(Island.LocationSpawn.CFrame)
		else
			Player.Character:PivotTo(Island:GetAttribute("Pivot") + Vector3.yAxis * 100)
		end
		
		TeleporttoIsland:Set({""})
	end,
})

getfenv().CreateUniversalTabs()
