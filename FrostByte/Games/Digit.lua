local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.3.9"

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
	
	local NewName

	if Success and ItemInfo then
		if not ItemInfo.BuyPrice then
			continue
		end
		
		BuyPrice = ItemInfo.BuyPrice
		
		NewName = `{v.Name} (${AddComma(BuyPrice)})`
	else
		NewName = `{v.Name} (Can't See Price)`
	end
	
	table.insert(Shovels, NewName)
	OriginalShovelNames[NewName] = {
		Name = v.Name,
		BuyPrice = BuyPrice
	}
end

local Enchantments = {"Your executor does not support this."}

local Success, EnchantModule = pcall(require, ReplicatedStorage.Settings.Enchantments)

if Success then
	table.remove(Enchantments, 1)
	
	for Enchant, Info in EnchantModule.EnchantmentsList do
		for Tier, _ in Info.Tiers do
			table.insert(Enchantments, `{Enchant} {Tier}`)
		end
	end
	
	table.sort(Enchantments)
end

table.sort(Shovels, function(a,b)
	return OriginalShovelNames[a].BuyPrice < OriginalShovelNames[b].BuyPrice
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local UnsupportedName: string = getgenv().UnsupportedName
local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getgenv().firetouchinterest
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local firesignal: (RBXScriptSignal) -> () = getgenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getgenv().fireclickdetector
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Rayfield = getgenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any}} = Rayfield.Flags

local CollectionService = game:GetService("CollectionService")

local Player = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")

local Window = getgenv().Window

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Digging")

Tab:CreateToggle({
	Name = "⛏️ • Auto Fast Dig",
	CurrentValue = false,
	Flag = "Dig",
	Callback = function(Value)
		task.spawn(function()
			while Flags.Dig.CurrentValue and task.wait() do
				local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

				if not DigMinigame then
					continue
				end
				
				DigMinigame.Cursor.Position = DigMinigame.Area.Position
			end
		end)
		
		while Flags.Dig.CurrentValue and task.wait() do
			if not Player.Character:FindFirstChildOfClass("Tool") then
				continue
			end
			
			local Adornee = Player.Character.Shovel.Highlight.Adornee
			
			if not Adornee or Adornee.Parent ~= workspace.Map.TreasurePiles then
				continue
			end
			
			RemoteFunctions.Digging:InvokeServer({
				Command = "DigPile",
				TargetPileIndex = Adornee:GetAttribute("PileIndex")
			})
		end
	end,
})

Tab:CreateToggle({
	Name = "🕳️ • Auto Create Piles (Any Terrain)",
	CurrentValue = false,
	Flag = "CreatePiles",
	Callback = function(Value)	
		while Flags.CreatePiles.CurrentValue and task.wait() do	
			if Player:GetAttribute("PileCount") ~= 0 then
				continue
			end
			
			local PileInfo: {["PileIndex"]: number, ["Success"]: boolean} = RemoteFunctions.Digging:InvokeServer({
				Command = "CreatePile"
			})
			
			if PileInfo.Success then
				RemoteEvents.Digging:FireServer({
					Command = "DigIntoSandSound"
				})
			end
		end
	end,
})

Tab:CreateDivider()

local function RandomVector(Size: Vector3, Position: Vector3)

	local X = Position.X + math.random(-Size.X / 2, Size.X / 2)
	local Z = Position.Z + math.random(-Size.Z / 2, Size.Z / 2)

	return Vector3.new(X, Position.Y, Z)
end

local CanWalk = true

Tab:CreateToggle({
	Name = "🔄 • Auto Walk After Dig",
	CurrentValue = false,
	Flag = "DigWalk",
	Callback = function(Value)
		local Visualizer = workspace:FindFirstChild("FrostByteVisualizer")
		
		while Flags.DigWalk.CurrentValue and task.wait() do	
			if Player:GetAttribute("IsDigging") then
				continue
			end
			
			local Character = Player.Character
			
			local WalkZoneSizeFlag = Flags.ZoneSize.CurrentValue
			
			local ZoneSize = Vector3.new(WalkZoneSizeFlag, 1, WalkZoneSizeFlag)
			
			local Visualizer = workspace:FindFirstChild("FrostByteVisualizer")
			
			if not Visualizer then
				Visualizer = Instance.new("Part")
				Visualizer.Size = ZoneSize
				Visualizer.Position = Character:GetPivot().Position - Vector3.yAxis * Character:GetExtentsSize().Y / 1.05
				Visualizer.Anchored = true
				Visualizer.Color = Color3.fromRGB(75, 255, 75)
				Visualizer.CanCollide = false
				Visualizer.CanQuery = false
				Visualizer.Material = Enum.Material.SmoothPlastic
				Visualizer.Transparency = 0.4
				Visualizer.CastShadow = false
				Visualizer.Name = "FrostByteVisualizer"
				Visualizer.Parent = workspace
			end
			
			local Humanoid: Humanoid = Character.Humanoid
			
			local FoundPile = false

			for _, Pile: Model in workspace.Map.TreasurePiles:GetChildren() do
				if Pile:GetAttribute("Owner") ~= Player.UserId then
					continue
				end
				
				FoundPile = true
				
				for _, Descendant: BasePart in Pile:GetDescendants() do
					if not Descendant:IsA("BasePart") then
						continue
					end
					
					Descendant.CanCollide = false
				end

				Humanoid:MoveTo(Pile:GetPivot().Position)
				break
			end
			
			if FoundPile then
				continue
			end
			
			if CanWalk then
				Humanoid:MoveTo(RandomVector(ZoneSize, Visualizer.Position))
				CanWalk = false

				Humanoid.MoveToFinished:Once(function()
					CanWalk = true
				end)
			end
		end
		
		local Visualizer = workspace:FindFirstChild("FrostByteVisualizer")
		
		if Visualizer then
			Visualizer:Destroy()
		end
	end,
})

Tab:CreateSlider({
	Name = "🟩 • Auto Walk Zone Size",
	Range = {5, 100},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 20,
	Flag = "ZoneSize",
	Callback = function()end,
})

Tab:CreateSection("Legit Digging")

local function LegitDig()
	if not Flags.LegitDig.CurrentValue then
		return
	end

	local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

	if not DigMinigame then
		return
	end

	local Connection: RBXScriptConnection
	Connection = game:GetService("RunService").Heartbeat:Connect(function()
		if not Player.PlayerGui.Main:FindFirstChild("DigMinigame") or not Flags.LegitDig.CurrentValue then
			return Connection:Disconnect()
		end

		DigMinigame.Cursor.Position = DigMinigame.Area.Position
	end)

	HandleConnection(Connection, "LegitDigHeartbeat")
end

Tab:CreateToggle({
	Name = "⛏️ • Auto Legit Dig",
	CurrentValue = false,
	Flag = "LegitDig",
	Callback = function(Value)
		if Value then
			LegitDig()
		end
	end,
})

HandleConnection(Player.PlayerGui.Main.ChildAdded:Connect(LegitDig), "LegitDig")

Tab:CreateToggle({
	Name = "🕳️ • Auto Legit Create Piles",
	CurrentValue = false,
	Flag = "LegitPiles",
	Callback = function(Value)	
		while Flags.LegitPiles.CurrentValue and task.wait() do	
			local Tool = Player.Character:FindFirstChildOfClass("Tool")
			
			if not Tool or Tool:GetAttribute("Type") ~= "Shovel" then
				continue
			end
			
			Tool:Activate()
		end
	end,
})

Tab:CreateSection("Items")

local function PinMoles(Tool: Tool)
	if not Flags.PinMoles.CurrentValue then
		return
	end
	
	if not Tool.Name:find("Mole") then
		return
	end
	
	if Tool:GetAttribute("Pinned") then
		return
	end

	RemoteFunctions.Inventory:InvokeServer({
		Command = "ToggleSlotPin",
		UID = Tool:GetAttribute("ID")
	})
end

Tab:CreateToggle({
	Name = "📌 • Auto Pin Moles",
	CurrentValue = false,
	Flag = "PinMoles",
	Callback = function(Value)
		if Value then
			for _, Tool: Tool in Player.Backpack:GetChildren() do
				PinMoles(Tool)
			end
		end
	end,
})

HandleConnection(Player.Backpack.ChildAdded:Connect(PinMoles), "PinMoles")

Tab:CreateToggle({
	Name = "💸 • Auto Open Magnet Boxes",
	CurrentValue = false,
	Flag = "OpenMagnet",
	Callback = function(Value)
		while Flags.OpenMagnet.CurrentValue and task.wait() do
			for _, Tool: Tool in Player.Backpack:GetChildren() do
				if not Tool.Name:find("Magnet Box") then
					continue
				end
				
				RemoteEvents.Treasure:FireServer({
					Command = "RedeemContainer",
					Container = Tool
				})
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
				Command = "GetSessionTimers"
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

--[[Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🌟 • Auto Enchant Shovel\n| NOT USABLE",
	CurrentValue = false,
	Flag = "Enchant",
	Callback = function(Value)
		while Flags.Enchant.CurrentValue and task.wait() do
			local args = {
				[1] = {
					["Command"] = "OfferEnchant",
					["ID"] = "f2db00f37b"
				}
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Network"):WaitForChild("RemoteFunctions"):WaitForChild("MolePit"):InvokeServer(unpack(args))
			
			local args = {
				[1] = {
					["Command"] = "OfferShovel",
					["ID"] = "f963514648"
				}
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Network"):WaitForChild("RemoteFunctions"):WaitForChild("MolePit"):InvokeServer(unpack(args))

		end
	end,
})

Tab:CreateDropdown({
	Name = "🏝 • Enchantment to Stop at",
	Options = Enchantments,
	CurrentOption = "",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function()end,
})]]

Tab:CreateSection("Islands")

local PreviousLocation

local function MeteorIslandTeleport(Meteor: Model?)
	if Meteor.Name ~= "Meteor Island" or not Flags.Meteor.CurrentValue then
		return
	end
	
	local Character = Player.Character
	
	PreviousLocation = Character:GetPivot()
	
	Character:PivotTo(Meteor:GetPivot() + Vector3.yAxis * Meteor:GetExtentsSize().Y / 2)
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
		elseif PreviousLocation then
			Player.Character:PivotTo(PreviousLocation)
		end
	end,
})

HandleConnection(workspace.Map.Temporary.ChildAdded:Connect(MeteorIslandTeleport), "Meteor")
HandleConnection(workspace.Map.Temporary.ChildRemoved:Connect(function(Child: Model?)
	if Child.Name == "Meteor Island" and PreviousLocation then
		Player.Character:PivotTo(PreviousLocation)
	end
end), "MeteorRemoved")

local PreviousLocation

local function LunarCloudsTeleport(Lunar: Model?)
	if Lunar.Name ~= "Lunar Clouds" or not Flags.LunarClouds.CurrentValue then
		return
	end

	local Character = Player.Character

	PreviousLocation = Character:GetPivot()

	Character:PivotTo(Lunar:GetPivot() + Vector3.yAxis * Lunar:GetExtentsSize().Y / 2)
end

Tab:CreateToggle({
	Name = "✨ • Auto Teleport to Lunar Clouds",
	CurrentValue = false,
	Flag = "LunarClouds",
	Callback = function(Value)
		if Value then
			for i,v in workspace.Map.Islands:GetChildren() do
				LunarCloudsTeleport(v)
			end
		elseif PreviousLocation then
			Player.Character:PivotTo(PreviousLocation)
		end
	end,
})

HandleConnection(workspace.Map.Islands.ChildAdded:Connect(LunarCloudsTeleport), "LunarClouds")
HandleConnection(workspace.Map.Islands.ChildRemoved:Connect(function(Child: Model)
	if Child.Name == "Lunar Clouds" and PreviousLocation then
		Player.Character:PivotTo(PreviousLocation)
	end
end), "LunarCloudsRemoved")

local Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("Inventory")

if not Player:GetAttribute("OriginalMaxInventorySize") then
	Player:SetAttribute("OriginalMaxInventorySize", Player:GetAttribute("MaxInventorySize"))
end

Tab:CreateToggle({
	Name = "♾ • Infinite Backpack Capacity (PATCHED)",
	CurrentValue = false,
	Flag = "InfiniteCap",
	Callback = function(Value)
		if Value then
			Player:SetAttribute("MaxInventorySize", 1e5)
		else
			Player:SetAttribute("MaxInventorySize", Player:GetAttribute("OriginalMaxInventorySize"))
		end
	end,
})

Tab:CreateSection("Shop")

local function SellInventory()
	local SellEnabled = Flags.Sell.CurrentValue
	Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

	local Capacity: TextLabel = Player.PlayerGui.Main.Core.Inventory.Disclaimer.Capacity

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
		return
	end

	for i,v: TextLabel in workspace.Map.Islands:GetDescendants() do
		if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
			continue
		end

		local Merchant: Model = v.Parent.Parent

		local PreviousPosition = Player.Character:GetPivot()

		local PreviousText = Capacity.Text

		repeat
			Player.Character:PivotTo(Merchant:GetPivot())

			RemoteEvents.Merchant:FireServer({
				Command = "SellAllTreasures",
				Merchant = Merchant
			})

			task.wait(0.1)
		until Capacity.Text ~= PreviousText or Flags.Sell.CurrentValue ~= SellEnabled

		Player.Character:PivotTo(PreviousPosition)

		break
	end
end

Tab:CreateButton({
	Name = "💰 • Quick Sell Inventory",
	Callback = SellInventory,
})

Tab:CreateToggle({
	Name = "💰 • Auto Sell Inventory at Max Capacity",
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)	
		while Flags.Sell.CurrentValue and task.wait() do
			local Capacity: TextLabel = Player.PlayerGui.Main.Core.Inventory.Disclaimer.Capacity
			local Current = tonumber(Capacity.Text:split("(")[2]:split("/")[1])
			local Max = tonumber(Capacity.Text:split(")")[1]:split("/")[2])

			if Current < Max then
				continue
			end
			
			SellInventory()
		end
	end,
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

Tab:CreateSlider({
	Name = "🗃 • Amount of Magnet Boxes to Purchase",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Magnet Box(es)",
	CurrentValue = 1,
	Flag = "MagnetBoxes",
	Callback = function()end,
})

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

Tab:CreateSection("Transport")

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
			Player.Character:PivotTo(Island:GetAttribute("Pivot") + Vector3.yAxis * Island:GetAttribute("Size") / 2)
		end

		TeleporttoIsland:Set({""})
	end,
})

getgenv().CreateUniversalTabs()
