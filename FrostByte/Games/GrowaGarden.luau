--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v0.0.0"

getgenv().Changelog = [[released]]

do
	repeat
		local Core = loadstring(game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Core.luau"))

		if Core then
			Core()
		else
			warn("[FrostByte]: Failed to load the Core, retrying")
		end

		task.wait()
	until Core
end

-- Types

type Element = {
	CurrentValue: any,
	CurrentOption: {string},
	Set: (self: Element, any) -> ()
}

type Flags = {
	[string]: Element
}

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Element,
	CreateDivider: (self: Tab) -> Element,
	CreateToggle: (self: Tab, any) -> Element,
	CreateSlider: (self: Tab, any) -> Element,
	CreateDropdown: (self: Tab, any) -> Element,
	CreateButton: (self: Tab, any) -> Element,
	CreateLabel: (self: Tab, any, any?) -> Element,
	CreateParagraph: (self: Tab, any) -> Element,
	CreateInput: (self: Tab, any) -> Element,
}

-- Variables

local HandleConnection: (Connection: RBXScriptConnection?, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string?) -> () = getgenv().Notify
local GetClosestChild: (Children: {PVInstance}, (Child: PVInstance) -> ()?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local CreateFeature: (Tab: Tab, FeatureName: string) -> () = getgenv().CreateFeature

local fireproximityprompt: (ProximityPrompt: ProximityPrompt) -> () = getfenv().fireproximityprompt

local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

local function GetHoldableItems()
	local HoldableItems = {}
	
	for _, Tool: Tool in Player.Backpack:GetChildren() do
		if Tool:GetAttribute("ItemType") ~= "Holdable" or Tool:GetAttribute("Favorite") then
			continue
		end
		
		table.insert(HoldableItems, Tool)
	end
	
	return HoldableItems
end

local function RandomVector(Size: Vector3, Position: Vector3)
	local X = Position.X + math.random(-Size.X / 2, Size.X / 2)
	local Z = Position.Z + math.random(-Size.Z / 2, Size.Z / 2)

	return Vector3.new(X, Position.Y, Z)
end

local Farm

for _, CurrentFarm in workspace.Farm:GetChildren() do
	if CurrentFarm.Important.Data.Owner.Value ~= Player.Name then
		continue
	end

	Farm = CurrentFarm
end

-- Features

local Flags: Flags = getgenv().Flags

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Fruits", "apple")

Tab:CreateSection("Collecting")

local CooldownAttribute = "FrostByteCooldown"

Tab:CreateToggle({
	Name = "🧺 • Collect Fruits",
	CurrentValue = false,
	Flag = "Flag",
	Looped = true,
	RequiredValue = fireproximityprompt,
	Callback = function(Value)
		for _, ProximityPrompt: ProximityPrompt in Farm.Important.Plants_Physical:GetDescendants() do
			if not ProximityPrompt:IsA("ProximityPrompt") or not ProximityPrompt.Enabled then
				continue
			end
			
			if ProximityPrompt:GetAttribute(CooldownAttribute) then
				continue
			end

			fireproximityprompt(ProximityPrompt)
			
			ProximityPrompt:SetAttribute(CooldownAttribute, true)
			
			task.delay(0.2, function()
				ProximityPrompt:SetAttribute(CooldownAttribute, nil)
			end)
		end
	end,
})

local CanTeleportFruits = true

Tab:CreateToggle({
	Name = "🌀 • Teleport to Fruits",
	CurrentValue = false,
	Flag = "TeleportFruits",
	Looped = true,
	Callback = function()
		if not CanTeleportFruits then
			return
		end
		
		local Character = Player.Character
		
		if not Character then
			return
		end
		
		for _, ProximityPrompt in Farm.Important.Plants_Physical:GetDescendants() do
			if not ProximityPrompt:IsA("ProximityPrompt") or not ProximityPrompt.Enabled then
				continue
			end
			
			local Position: Vector3 = ProximityPrompt.Parent:GetPivot().Position
			
			if Position.Y < 0 then
				continue
			end
			
			Character:PivotTo(CFrame.new(Position.X, 3, Position.Z))

			break
		end
	end,
})

Tab:CreateSection("Selling")

Tab:CreateToggle({
	Name = "💰 • Sell Inventory",
	CurrentValue = false,
	Flag = "SellInventory",
	Looped = true,
	Callback = function()
		local HoldableItems = GetHoldableItems()
		
		if #HoldableItems == 0 then
			return
		end
		
		local Character = Player.Character
		
		if not Character then
			return
		end
		
		CanTeleportFruits = false
		
		local PreviousLocation = Character:GetPivot()
		
		local NPCPivot = workspace.NPCS.Steven.HumanoidRootPart:GetPivot()
		
		repeat
			if (Character:GetPivot().Position - NPCPivot.Position).Magnitude > 15 then
				Character:PivotTo(CFrame.lookAt(NPCPivot.Position + NPCPivot.LookVector * 5, NPCPivot.Position))
			end
			
			GameEvents.Sell_Inventory:FireServer()
			task.wait()
		until #GetHoldableItems() == 0 or not Flags.SellInventory.CurrentValue or Player.Character ~= Character
		
		Character:PivotTo(PreviousLocation)
		
		CanTeleportFruits = true
		
		task.wait(1)
	end,
})

local Tab: Tab = Window:CreateTab("Seeds", "sprout")

Tab:CreateSection("Buying")

Tab:CreateToggle({
	Name = "🛒 • Buy Seeds",
	CurrentValue = false,
	Flag = "BuySeeds",
	Looped = true,
	Callback = function()
		for _, Seed: string in Flags.Seeds.CurrentOption do
			local UISeed = Player.PlayerGui.Seed_Shop.Frame.ScrollingFrame:FindFirstChild(Seed)
			
			if not UISeed then
				continue
			end
			
			if UISeed.Main_Frame.Cost_Text.Text == "NO STOCK" then
				continue
			end
			
			GameEvents.BuySeedStock:FireServer(Seed)
		end
	end,
})

local Seeds = {}

for _, Seed: Part in ReplicatedStorage.Seed_Models:GetChildren() do
	table.insert(Seeds, Seed.Name)
end

table.sort(Seeds)

Tab:CreateDropdown({
	Name = "🌱 • Seeds",
	Options = Seeds,
	MultipleOptions = true,
	Flag = "Seeds",
})

Tab:CreateSection("Planting")

Tab:CreateToggle({
	Name = "🌿 • Plant Seeds",
	CurrentValue = false,
	Flag = "PlantSeeds",
	Looped = true,
	Callback = function()
		local Character = Player.Character

		if not Character then
			return
		end

		local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")

		if not Humanoid then
			return
		end

		local Tool = Character:FindFirstChildWhichIsA("Tool")

		if not Tool or Tool:GetAttribute("ItemType") ~= "Seed" then
			Humanoid:UnequipTools()

			for _, CurrentTool: Tool in Player.Backpack:GetChildren() do
				if CurrentTool:GetAttribute("ItemType") ~= "Seed" then
					continue
				end

				Humanoid:EquipTool(CurrentTool)
			end

			return
		end

		local PlantArea = Farm.Important.Plant_Locations:GetChildren()[math.random(2)]

		GameEvents.Plant_RE:FireServer(RandomVector(PlantArea.Size, PlantArea.Position), Tool:GetAttribute("ItemName"))
	end,
})

local Tab: Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("Teleporting")

local TeleportButtons = Player.PlayerGui.Teleport_UI.Frame

Tab:CreateToggle({
	Name = "⏹️ • Enable Gear & Pets Teleport Buttons",
	CurrentValue = false,
	Flag = "TeleportButtons",
	Callback = function(Value)
		TeleportButtons.Gear.Visible = Value
		TeleportButtons.Pets.Visible = Value
	end,
})

getgenv().SetupFinished()
