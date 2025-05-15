--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "0.0.2b"

getgenv().Changelog = [[
0.0.2b

🍅 Reverted Remove Foods to it's original function

0.0.2a

💰 Sell All Fish no longer tries to sell baby fish
🍓 Drop Food & Drop Fish should no longer go back and forth with equipping
🍉 Buy Food now has a 1 second cooldown incase you can't afford the food
🎣 Pickup Fish now has a 1 second cooldown

0.0.2

🎉 Additions

🔱 Buying -> Merchant Section
💳 Buy from Traveling Merchant
🛒 Items to Buy
-> 🍏 Collecting -> Server Hopping Section
🌀 Server Hop
⏲️ Server Hop Interval
-> 🔇 QOL -> Muting -> Mute Music

🛠️ Changes

🖼️ Changed the feature layout and which tabs they go to
💰 Sell All Fish checks if there are any fish to sell before selling (no sold for $0 spam)
🍎 Remove Foods doesn't break fish movement anymore]]

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
local request: (...any?) -> ...any? = getfenv().request
local queueonteleport: (...any?) -> ...any? = getfenv().queueonteleport

local Player = game:GetService("Players").LocalPlayer

local Net = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RBXUtil"):WaitForChild("Net")

local Plot

for _,v in workspace.Plots:GetChildren() do
	if v.PlotConfig.Owner.Value == Player then
		Plot = v
	end
end

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

-- Features

local Flags: Flags = getgenv().Flags

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Buying", "shopping-basket")

Tab:CreateSection("Fish")

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

Tab:CreateSection("Food")

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
		
		task.wait(1)
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

Tab:CreateSection("Merchant")

local MerchantScroll = Player.PlayerGui.ScreenGui.Frames["Traveling Merchant"].Main.Scroll

Tab:CreateToggle({
	Name = "💳 • Buy from Traveling Merchant",
	CurrentValue = false,
	Flag = "Merchant",
	Looped = true,
	Callback = function()
		for _, v in Flags.Items.CurrentOption do
			if MerchantScroll[v].Stock.Text == "x0 stock" then
				continue
			end

			Net["RE/BuyItem"]:FireServer("Traveling Merchant", v)
		end
	end,
})

local Items = {}

for i,v: Frame in MerchantScroll:GetChildren() do
	if not v:FindFirstChild("Button") then
		continue
	end

	table.insert(Items, v.Name)
end

Tab:CreateDropdown({
	Name = "🛒 • Items to Buy",
	Options = Items,
	MultipleOptions = true,
	Flag = "Items",
})

local Tab: Tab = Window:CreateTab("Dropping", "apple")

local Dropping: any

Tab:CreateSection("Fish")

Tab:CreateToggle({
	Name = "🐟 • Drop Baby Fish",
	CurrentValue = false,
	Flag = "DropFish",
	Looped = true,
	Callback = function()
		if Dropping and Dropping ~= "Fish" then
			return
		end
		
		local Id = GetItemInInventory("Baby")[1]

		if not Id then
			Dropping = nil
			return
		end
		
		Dropping = "Fish"

		if not Player.Character:FindFirstChild(Id) then
			Net["RE/EquipItem"]:FireServer(Id)

			Player.Character:WaitForChild(Id)
		end

		Net["URE/Drop Fish"]:FireServer()
	end,
})

Tab:CreateSection("Food")

Tab:CreateToggle({
	Name = "🍓 • Drop Food",
	CurrentValue = false,
	Flag = "DropFood",
	Looped = true,
	Callback = function()
		if Dropping and Dropping ~= "Food" then
			return
		end
		
		local Id = GetItemInInventory("Bag o'")[1] or GetItemInInventory("Food")[1]

		if not Id then
			Dropping = nil
			return
		end
		
		Dropping = "Food"

		if not Player.Character:FindFirstChild(Id) then
			Net["RE/EquipItem"]:FireServer(Id)

			Player.Character:WaitForChild(Id)
		end
		
		Net["URE/Drop Food"]:FireServer(Vector3.new(-171.23582458496094, 2.619150161743164, -455.3417663574219))
	end,
})

local Tab: Tab = Window:CreateTab("Collecting", "layers")

Tab:CreateSection("Fish")

Tab:CreateToggle({
	Name = "💰 • Sell All Fish",
	CurrentValue = false,
	Flag = "Sell",
	Looped = true,
	Callback = function()
		if not GetItemInInventory("kg")[1] then
			return
		end
		
		Net["RE/Sell Fish"]:FireServer("ALL")
		
		task.wait(1)
	end,
})

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🎣 • Pickup Fish",
	CurrentValue = false,
	Flag = "Pickup",
	Looped = true,
	RequiredValue = fireproximityprompt or false,
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
		
		task.wait(1)
	end,
})

Tab:CreateSection("Server Hopping")

Tab:CreateToggle({
	Name = "🌀 • Server Hop",
	CurrentValue = false,
	Flag = "Server Hop",
	Looped = true,
	RequiredValue = request and queueonteleport or false,
	Callback = function()
		Notify("Server Hop", "Beginning Server Hop, waiting the interval.")
		task.wait(Flags.Interval.CurrentValue)
		
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")
		
		local PlaceId = game.PlaceId
		local JobId = game.JobId
		
		local Servers = {}
		local Result = request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)})
		local Body = HttpService:JSONDecode(Result.Body)

		if Body and Body.data then
			for i, v in next, Body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
					table.insert(Servers, 1, v.id)
				end
			end
		end

		if #Servers > 0 then
			TeleportService:TeleportToPlaceInstance(PlaceId, Servers[math.random(1, #Servers)], Players.LocalPlayer)
		else
			return Notify("Server Hop", "Failed to find a server. Retrying after the set interval.")
		end
		
		queueonteleport('loadstring(game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Initiate.lua"))()')
	end,
})

Tab:CreateSlider({
	Name = "⏲️ • Server Hop Interval",
	Range = {10, 5 * 60},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 60,
	Flag = "Interval",
})

local Tab: Tab = Window:CreateTab("QOL", "leaf")

Tab:CreateSection("Optimization")

local RemovedFoods = {}

Tab:CreateToggle({
	Name = "🍎 • Remove Foods",
	CurrentValue = false,
	Flag = "RemoveFoods",
	Callback = function(Value)
		if Value then
			for _, Part: Part in workspace.Plots:GetDescendants() do
				if not Part.Name:find("Food") then
					continue
				end
				
				if not Part:IsA("Part") then
					continue
				end

				RemovedFoods[Part] = {
					Parent = Part.Parent,
					Destroying = Part.Destroying:Once(function()
						RemovedFoods[Part] = nil
					end)
				}
				Part.Parent = nil
			end
		else
			for Object, Info in RemovedFoods do
				Object.Parent = Info.Parent
				Info.Destroying:Disconnect()
				RemovedFoods[Object] = nil
			end
		end
	end,
})

Tab:CreateSection("Muting")

Tab:CreateToggle({
	Name = "🔇 • Mute Music",
	CurrentValue = false,
	Flag = "Music",
	Callback = function(Value)
		for _, v: Sound in game:GetService("SoundService"):GetChildren() do
			if not v:IsA("Sound") then
				continue
			end
			
			v.Volume = if Value then 0 else 0.25
		end
	end,
})

getgenv().SetupFinished()
