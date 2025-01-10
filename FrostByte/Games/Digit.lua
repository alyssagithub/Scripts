ScriptVersion = "v1.0.0"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shovels = {}
local OriginalShovelNames = {}

local function AddComma(amount)
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
	local BuyPrice = require(v).BuyPrice

	if not BuyPrice then
		continue
	end

	local NewName = `{v.Name} (${AddComma(BuyPrice)})`
	table.insert(Shovels, NewName)
	OriginalShovelNames[NewName] = v.Name
end

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
	Name = "⛏️ • Auto Dig Close Piles (Bypasses Capacity)",
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
	Name = "🕳️ • Auto Create Piles",
	CurrentValue = false,
	Flag = "CreatePiles",
	Callback = function(Value)	
		while Flags.CreatePiles.CurrentValue and task.wait() do
			if CollectionService:GetTagged("FrostBytePiles")[1] then
				continue
			end

			local PileInfo: {["PileIndex"]: number, ["Success"]: boolean} = RemoteFunctions.Digging:InvokeServer({
				Command = "CreatePile"
			})
			
			if not PileInfo.Success then
				continue
			end
			
			workspace.Map.TreasurePiles:WaitForChild(tostring(PileInfo.PileIndex)):AddTag("FrostBytePiles")
		end
	end,
})

Tab:CreateSection("Items")

Tab:CreateToggle({
	Name = "💰 • Auto Sell Inventory",
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)	
		while Flags.Sell.CurrentValue and task.wait() do
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
				
				Player.Character:PivotTo(Merchant:GetPivot())
				
				task.wait(0.1)

				RemoteEvents.Merchant:FireServer({
					Command = "SellAllTreasures",
					Merchant = Merchant
				})
				
				task.wait(0.1)
				
				Player.Character:PivotTo(PreviousPosition)
				
				break
			end
		end
	end,
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
			Product = OriginalShovelNames[CurrentOption],
			Amount = 1
		})

		PurchaseShovel:Set({""})
	end,
})

Tab:CreateSection("Islands")

local Islands = {}

for i,v in workspace.Map.Islands:GetChildren() do
	table.insert(Islands, v.Name)
end

for i,v in ReplicatedStorage.Assets.Sounds.Soundtrack.Locations:GetChildren() do
	if not table.find(Islands, v.Name) then
		table.insert(Islands, v.Name)
	end
end

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
