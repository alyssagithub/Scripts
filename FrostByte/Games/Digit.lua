local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.26.43"

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

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getgenv().firetouchinterest
local firesignal: (RBXScriptSignal) -> () = getgenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getgenv().fireclickdetector
local hookmetamethod: (Object: Object, Metamethod: string, NewFunction: (Object?, any) -> (any)) -> ((any) -> (any)) = getgenv().hookmetamethod
local getnamecallmethod: () -> (string) = getgenv().getnamecallmethod
local checkcaller: () -> (boolean) = getgenv().checkcaller

local UnsupportedName: string = getgenv().UnsupportedName
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Rayfield = getgenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

local CollectionService = game:GetService("CollectionService")

local Player = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")

local Window = getgenv().Window

local Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Digging")

HandleConnection(game:GetService("ScriptContext").Error:Connect(function(Message, StackTrace, CallingScript)
	if CallingScript.Name == "Shovel" and Message:find("attempt to index nil with 'GetAttribute'") then
		local Character = Player.Character

		local Tool = Character:FindFirstChildOfClass("Tool")
		
		if not Tool then
			return
		end

		local Humanoid: Humanoid = Character.Humanoid

		Humanoid:UnequipTools()
		Humanoid:EquipTool(Tool)
	end
end), "ShovelError")

Tab:CreateToggle({
	Name = "⛏️ • Auto Fast Dig (Combinable with Legit)",
	CurrentValue = false,
	Flag = "Dig",
	Callback = function(Value)
		while Flags.Dig.CurrentValue and task.wait() do
			if not Player.Character:FindFirstChildOfClass("Tool") then
				continue
			end
			
			local Adornee: Model? = Player.Character.Shovel.Highlight.Adornee
			
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
	Name = "⛏️ • Auto Legit Dig (100% Success Rate)",
	CurrentValue = false,
	Flag = "LegitDig",
	Callback = function(Value)
		if Value then
			LegitDig()
		end
	end,
})

HandleConnection(Player.PlayerGui.Main.ChildAdded:Connect(LegitDig), "LegitDig")

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🕳️ • Auto Create Piles on Any Terrain",
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
	Name = "🕳️ • Auto Legit Create Piles (Needed for Legit Dig)",
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

Tab:CreateDivider()

local function RandomVector(Size: Vector3, Position: Vector3)

	local X = Position.X + math.random(-Size.X / 2, Size.X / 2)
	local Z = Position.Z + math.random(-Size.Z / 2, Size.Z / 2)

	return Vector3.new(X, Position.Y, Z)
end

local ChosenPosition

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
				Visualizer.Position = Character:GetPivot().Position - Vector3.yAxis * Character.HumanoidRootPart.Size.Y
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

			if not ChosenPosition then
				ChosenPosition = RandomVector(ZoneSize, Visualizer.Position)

				Humanoid.MoveToFinished:Once(function()
					ChosenPosition = nil
				end)
			end

			Humanoid:MoveTo(ChosenPosition)
		end

		if Value then
			ChosenPosition = nil
			Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
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

Tab:CreateSection("Items")

local Treasures = ReplicatedStorage.Settings.Items.Treasures

local function OpenContainer(Tool: Tool)
	if not Flags.OpenContainers.CurrentValue then
		return
	end
	
	local Module: ModuleScript? = Treasures:FindFirstChild(Tool.Name)

	if not Module then
		return
	end

	local Info = require(Module)

	if not Info.ContainerType then
		return
	end

	RemoteEvents.Treasure:FireServer({
		Command = "RedeemContainer",
		Container = Tool
	})
end

Tab:CreateToggle({
	Name = if pcall(require, Treasures:FindFirstChildOfClass("ModuleScript")) then "💸 • Auto Open Containers" else UnsupportedName,
	CurrentValue = false,
	Flag = "OpenContainers",
	Callback = function(Value)
		for _, Tool: Tool in Player.Backpack:GetChildren() do
			OpenContainer(Tool)
		end
	end,
})

HandleConnection(Player.Backpack.ChildAdded:Connect(OpenContainer), "OpenContainers")

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

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🏧 • Auto Bank Certain Items",
	CurrentValue = false,
	Flag = "BankItems",
	Callback = function(Value)
		while Flags.BankItems.CurrentValue and task.wait() do	
			for _, Item: string in Flags.Items.CurrentOption do
				local Tool = Player.Backpack:FindFirstChild(Item)
				
				if not Tool then
					continue
				end
				
				RemoteFunctions.Inventory:InvokeServer({
					Command = "MoveToBank",
					UID = Tool:GetAttribute("ID")
				})
			end
		end
	end,
})

local Items = {}

for i,v in ReplicatedStorage.Settings.Items.Treasures:GetChildren() do
	table.insert(Items, v.Name)
end

table.sort(Items)

Tab:CreateDropdown({
	Name = "🏧 • Items to Bank",
	Options = Items,
	MultipleOptions = true,
	Flag = "ItemsToBank",
	Callback = function()end,
})

Tab:CreateDivider()

local function PinItems(Tool: Tool)
	if not Flags.PinItems.CurrentValue then
		return
	end
	
	if not table.find(Flags.ItemsToPin.CurrentOption, Tool.Name) then
		return
	end
	
	if Tool:GetAttribute("Pinned") then
		return
	end

	local Result = RemoteFunctions.Inventory:InvokeServer({
		Command = "ToggleSlotPin",
		UID = Tool:GetAttribute("ID")
	})

	if Result then
		Tool:SetAttribute("Pinned", not Tool:GetAttribute("Pinned"))
	end
end

Tab:CreateToggle({
	Name = "📌 • Auto Pin Items",
	CurrentValue = false,
	Flag = "PinItems",
	Callback = function(Value)
		if Value then
			for _, Tool: Tool in Player.Backpack:GetChildren() do
				PinItems(Tool)
			end
		end
	end,
})

HandleConnection(Player.Backpack.ChildAdded:Connect(PinItems), "PinItems")

Tab:CreateDropdown({
	Name = "📌 • Items to Pin",
	Options = Items,
	MultipleOptions = true,
	Flag = "ItemsToPin",
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

Tab:CreateSection("Items")

Tab:CreateButton({
	Name = `🔍 • Quick Appraise Held Item [${RemoteFunctions.LootPit:InvokeServer({Command = "GetPlayerPrice"})}]`,
	Callback = function()
		RemoteFunctions.LootPit:InvokeServer({
			Command = "AppraiseItem"
		})
	end,
})

Tab:CreateButton({
	Name = "🌟 • Quick Enchant Shovel",
	Callback = function()
		local Backpack = Player.Backpack

		local Mole = Backpack:FindFirstChild("Mole") or Backpack:FindFirstChild("Royal Mole")

		if not Mole then
			return Notify("Missing Item", "You do not have a mole or royal mole.")
		end

		for _, Item: Tool in Backpack:GetChildren() do
			if Item:GetAttribute("Type") ~= "Shovel" then
				continue
			end

			local Result = RemoteFunctions.MolePit:InvokeServer({
				Command = "OfferEnchant",
				ID = Mole:GetAttribute("ID")
			})

			if Result ~= true then
				return Notify("Error", "Failed to offer the mole")
			end

			local Result = RemoteFunctions.MolePit:InvokeServer({
				Command = "OfferShovel",
				ID = Item:GetAttribute("ID")
			})

			if Result ~= true then
				return Notify("Error", "Failed to offer the shovel")
			end

			return Notify("Success", "Successfully enchanted your shovel!")
		end
	end,
})

Tab:CreateSection("Inventory")

local OpenBankHook
local MoveToBankHook
local AlreadyWaiting = false

Tab:CreateToggle({
	Name = if hookmetamethod and getnamecallmethod and checkcaller then "🏦 • Bank Anywhere" else UnsupportedName,
	CurrentValue = false,
	Flag = "Bank",
	Callback = function(Value)
		if Value and not OpenBankHook then
			OpenBankHook = hookmetamethod(RemoteFunctions.Marketplace, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				local args = {...}
				
				if not checkcaller() and method == "InvokeServer" and args[1].Command == "OwnsProduct" and args[1].Product == "Store Anywhere" and Flags.Bank.CurrentValue then
					return true
				end
				
				return OpenBankHook(self, ...)
			end)
		end
		
		if Value and not MoveToBankHook then
			MoveToBankHook = hookmetamethod(RemoteFunctions.Inventory, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				local args = {...}

				if method == "InvokeServer" and args[1].Command == "MoveToBank" and Flags.Bank.CurrentValue and not AlreadyWaiting then
					local Result: {["Status"]: boolean}

					AlreadyWaiting = true
					
					local Character = Player.Character
					
					local PreviousPosition = Character:GetPivot()

					repeat
						Character:PivotTo(workspace.Map.Islands.Nookville.BackpackIsland.Ronald:GetPivot())
						Result = self:InvokeServer(args[1])
					until (Result and Result.Status) or not Flags.Bank.CurrentValue

					AlreadyWaiting = false
					
					Character:PivotTo(PreviousPosition)
				end
				
				local Success, Result = pcall(MoveToBankHook, self, ...)
				
				return if Success then Result else {Status = true}
			end)
		end
	end,
})

Tab:CreateSection("Shop")

function SellInventory()
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

Tab:CreateSection("UI")

local AFKHook

Tab:CreateToggle({
	Name = if hookmetamethod and getnamecallmethod and checkcaller then "🏷️ • Disable [AFK] Tag" else UnsupportedName,
	CurrentValue = false,
	Flag = "AFKTag",
	Callback = function(Value)
		if Value and not AFKHook then
			AFKHook = hookmetamethod(RemoteEvents.Player, "__namecall", function(self, ...)
				local Method = getnamecallmethod()
				local Args = {...}
				
				if not checkcaller() and Method == "FireServer" and Args[1].Command == "SetAFK" and Args[1].State and Flags.AFKTag.CurrentValue then
					local NewArgs = {}
					NewArgs.Command = Args[1].Command
					NewArgs.State = false
					self:FireServer(NewArgs)
					return
				end
				
				return AFKHook(self, ...)
			end)
		end
	end,
})

Tab:CreateSection("Miscellaneous")

local Codes = {
	"PLSMOLE",
	"LUNARV2",
	"TWITTER_DIGITRBLX",
	"5MILLION",
}

Tab:CreateButton({
	Name = "🐦 • Redeem Known Codes",
	Callback = function()
		for _, Code: string in Codes do
			local Result = RemoteFunctions.Codes:InvokeServer({
				Command = "Redeem",
				Code = Code
			})
			
			if Result.Status then
				continue
			elseif Result.AlreadyRedeemed then
				Notify("Failed!", `The code '{Code}' has already been redeemed.`)
			elseif Result.NotValid then
				Notify("Failed!", `The code '{Code}' is not valid anymore.`)
			else
				Notify("Error", `The code '{Code}' has had an internal error while redeeming.`)
			end
		end
	end,
})

getgenv().CreateUniversalTabs()
