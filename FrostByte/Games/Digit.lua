ScriptVersion = "v1.2.1"

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

	if Success then
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

Tab:CreateSection("Digging")

Tab:CreateToggle({
	Name = "⛏️ • Auto Dig Close Piles (Faster)",
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
			local Adornee = Player.Character.Shovel.Highlight.Adornee
			
			if not Adornee then
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

Tab:CreateToggle({
	Name = "🔄 • Auto Move While Digging\n| UNFINISHED",
	CurrentValue = false,
	Flag = "Move",
	Callback = function(Value)	
		--[[while Flags.Move.CurrentValue and task.wait() do	
			
		end]]
	end,
})

Tab:CreateSection("Autoclicker")

Tab:CreateToggle({
	Name = "🕹️ • Auto Enter Pile Minigame\n| 100% Dig Success Rate, BUGGY",
	CurrentValue = false,
	Flag = "PileMinigame",
	Callback = function(Value)	
		while Flags.PileMinigame.CurrentValue and task.wait() do
			local Adornee: Model = Player.Character.Shovel.Highlight.Adornee
			
			if not Adornee or Adornee:GetAttribute("Completed") or Adornee:GetAttribute("Destroying") or Adornee:GetAttribute("Progress") >= Adornee:GetAttribute("MaxProgress") then
				continue
			end
			
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

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🌟 • Auto Enchant Shovel\n| UNFINISHED",
	CurrentValue = false,
	Flag = "Enchant",
	Callback = function(Value)
		--[[while Flags.Enchant.CurrentValue and task.wait() do
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

		end]]
	end,
})

Tab:CreateDropdown({
	Name = "🏝 • Enchantment to Stop at",
	Options = Enchantments,
	CurrentOption = "",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function()end,
})

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

Player:SetAttribute("OriginalMaxInventorySize", Player:GetAttribute("MaxInventorySize"))

Tab:CreateToggle({
	Name = "♾ • Infinite Backpack Capacity",
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

Tab:CreateButton({
	Name = "💰 • Quick Sell Inventory",
	Callback = function()
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
			until Capacity.Text ~= PreviousText

			Player.Character:PivotTo(PreviousPosition)

			break
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

getfenv().CreateUniversalTabs()
