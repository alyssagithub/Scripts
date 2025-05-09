--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "0.0.1a"

getgenv().Changelog = [[
0.0.1a
🛠️ Changes
🦈 Renamed 'Pickup Closest Fish' to 'Pickup Fish'
🎣 Made Pickup Fish just try to pick up all the fish instead of specifically the closest one
0.0.1
🛠️ Changes
🐟 Renamed "Drop Fish" to "Drop Baby Fish"
🐠 Made Drop Baby Fish and Drop Food automatically equip the items before dropping.]]

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
local Net = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RBXUtil"):WaitForChild("Net")

local Plot

for _,v in workspace.Plots:GetChildren() do
	if v.PlotConfig.Owner.Value == Player then
		Plot = v
	end
end

-- Features

local Flags: Flags = getgenv().Flags

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Fish", "fish")

Tab:CreateSection("Selling")

Tab:CreateToggle({
	Name = "💰 • Sell All Fish",
	CurrentValue = false,
	Flag = "Sell",
	Looped = true,
	Callback = function()
		Net["RE/Sell Fish"]:FireServer("ALL")
		task.wait(1)
	end,
})

Tab:CreateSection("Dropping")

local function GetItemInInventory(FilterName: string)
	local IDs = {}
	
	for _,v: Frame in Player.PlayerGui.ScreenGui.HUD.Hotbar.Hotbar:GetChildren() do
		local Item = v:GetAttribute("Item")
		
		local ItemLabel = v:FindFirstChild("Item") :: TextLabel
		
		if not Item or not ItemLabel.Text:find(FilterName) then
			continue
		end
		
		table.insert(IDs, Item)
	end
	
	for _, v: Frame in Player.PlayerGui.ScreenGui.HUD.Inventory.Scroll:GetChildren() do
		if not v:IsA("Frame") then
			continue
		end
		
		local Item = v:FindFirstChild("Template"):FindFirstChild("Item") :: TextLabel
		
		if not Item.Text:find(FilterName) then
			continue
		end
		
		table.insert(IDs, v.Name)
	end
	
	return IDs
end

Tab:CreateToggle({
	Name = "🐟 • Drop Baby Fish",
	CurrentValue = false,
	Flag = "DropFish",
	Looped = true,
	Callback = function()
		local Id = GetItemInInventory("Baby")[1]
		
		if not Id then
			return
		end
		
		if not Player.Character:FindFirstChild(Id) then
			Net["RE/EquipItem"]:FireServer(Id)

			Player.Character:WaitForChild(Id)
		end
		
		Net["URE/Drop Fish"]:FireServer()
	end,
})

Tab:CreateSection("Collecting")

Tab:CreateToggle({
	Name = "🎣 • Pickup Fish",
	CurrentValue = false,
	Flag = "Pickup",
	Looped = true,
	RequiredValue = fireproximityprompt,
	Callback = function()
		for _, Fish in Plot.Scripted.Fishes:GetChildren() do
			if Fish:GetAttribute("Stage") < 5 then
				continue
			end
			
			local FishGrabPrompt = Fish:FindFirstChild("FishGrabPrompt") :: ProximityPrompt

			if not FishGrabPrompt then
				return
			end

			fireproximityprompt(FishGrabPrompt)
		end
	end,
})

Tab:CreateSection("Buying")

local FishStoreScroll = Player.PlayerGui.ScreenGui.Frames["Fish Store"].Main.Scroll

Tab:CreateToggle({
	Name = "🦈 • Buy Fish",
	CurrentValue = false,
	Flag = "BuyFish",
	Looped = true,
	Callback = function()
		for _,v in Flags.Fish.CurrentOption do
			if FishStoreScroll[v].Price.Text == "NO STOCK" then
				continue
			end
			
			Net["RE/BuyItem"]:FireServer("Fish", v)
		end
	end,
})

local Fish = {}

for _,v: Frame in FishStoreScroll:GetChildren() do
	if not v:FindFirstChild("Button") then
		continue
	end
	
	table.insert(Fish, v.Name)
end

Tab:CreateDropdown({
	Name = "💵 • Fish to Buy",
	Options = Fish,
	MultipleOptions = true,
	Flag = "Fish",
})


local Tab: Tab = Window:CreateTab("Food", "apple")

Tab:CreateSection("Dropping")

Tab:CreateToggle({
	Name = "🍓 • Drop Food",
	CurrentValue = false,
	Flag = "DropFood",
	Looped = true,
	Callback = function()
		local Id = GetItemInInventory("Bag o'")[1]

		if not Id then
			return
		end

		if not Player.Character:FindFirstChild(Id) then
			Net["RE/EquipItem"]:FireServer(Id)

			Player.Character:WaitForChild(Id)
		end
		
		Net["URE/Drop Food"]:FireServer(Vector3.new(-171.23582458496094, 2.619150161743164, -455.3417663574219))
	end,
})

Tab:CreateSection("Buying")

local FoodStoreScroll = Player.PlayerGui.ScreenGui.Frames["Food Store"].Main.Scroll

Tab:CreateToggle({
	Name = "🍉 • Buy Food",
	CurrentValue = false,
	Flag = "BuyFood",
	Looped = true,
	Callback = function()
		for _,v in Flags.Food.CurrentOption do
			if FoodStoreScroll[v].Price.Text == "NO STOCK" then
				continue
			end

			Net["RE/BuyItem"]:FireServer("Food", v)
		end
	end,
})

local Food = {}

for _,v: Frame in FoodStoreScroll:GetChildren() do
	if not v:FindFirstChild("Button") then
		continue
	end

	table.insert(Food, v.Name)
end

Tab:CreateDropdown({
	Name = "🍇 • Food to Buy",
	Options = Food,
	MultipleOptions = true,
	Flag = "Food",
})

Tab:CreateSection("Optimization")

local RemovedFolders = {}

Tab:CreateToggle({
	Name = "🍎 • Remove Foods",
	CurrentValue = false,
	Flag = "RemoveFoods",
	Callback = function(Value)
		if Value then
			for _, FoodFolder: Folder in workspace.Plots:GetDescendants() do
				if FoodFolder.Name ~= "Food" then
					continue
				end

				RemovedFolders[FoodFolder] = FoodFolder.Parent
				FoodFolder.Parent = nil
			end
		else
			for FoodFolder, Parent in RemovedFolders do
				FoodFolder.Parent = Parent
				RemovedFolders[FoodFolder] = nil
			end
		end
	end,
})

getgenv().CreateUniversalTabs()
