local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local FoodLooping
local CoinLooping
local EggLooping
local QuestLooping

local AttackLooping

local EquipLooping
local FeedLooping
local TierLooping
local OpenLooping
local PlaceLooping

local SelectedEnemy
local SelectedQuest

local EnemiesList = {}
local QuestsList = {}

table.sort(EnemiesList, function(a, b)
	return a > b
end)

for i,v in pairs(game:GetService("Workspace").EnemyCache:GetChildren()) do
	if not table.find(EnemiesList, v.Name) then
		table.insert(EnemiesList, v.Name)
	end
end

for i,v in pairs(game:GetService("ReplicatedStorage").Assets.Models.Npcs:GetChildren()) do
	table.insert(QuestsList, v.Name)
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "🍓 Auto Collect Food",
	CurrentValue = false,
	Flag = "AutoCollectFood",
	Callback = function(Value)
		FoodLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if FoodLooping then
			for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
				if v:GetAttribute("Type") == "Food" then
					game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectDrop:InvokeServer("Food")
					v:Destroy()
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💰 Auto Collect Coins",
	CurrentValue = false,
	Flag = "AutoCollectCoins",
	Callback = function(Value)
		CoinLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if CoinLooping then
			for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
				if v:GetAttribute("Type") == "Coins" then
					game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectDrop:InvokeServer("Coins")
					v:Destroy()
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🥚 Auto Collect Eggs",
	CurrentValue = false,
	Flag = "AutoCollectEggs",
	Callback = function(Value)
		EggLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if EggLooping then
			for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
				if v:GetAttribute("IsEgg") then
					game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectEgg:InvokeServer({["isShiny"] = v:GetAttribute("isShiny"), ["Type"] = v:GetAttribute("Type")})
					v:Destroy()
				end
			end
		end
	end
end)

local Enemies = Window:CreateTab("Enemies", 4483362458)

local EnemyDropdown = Enemies:CreateDropdown({
	Name = "👾 Enemy",
	Options = EnemiesList,
	CurrentOption = "",
	Flag = "SelectedEnemy",
	Callback = function(Value)
		SelectedEnemy = Value
	end,
})

Enemies:CreateToggle({
	Name = "⚔ Auto Attack",
	CurrentValue = false,
	Flag = "AutoAttack",
	Callback = function(Value)
		AttackLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if AttackLooping and SelectedEnemy then
			local CurrentNumber1 = math.huge
			local SelectedEnemy1

			for i,v in pairs(Player.PlayerGui.Billboards:GetChildren()) do
				if v.Adornee and v.Name == SelectedEnemy.." Health Tag" and v.Adornee:FindFirstChild("Spawn") and (Player.Character.HumanoidRootPart.Position - v.Adornee:FindFirstChildOfClass("MeshPart").Position).Magnitude < CurrentNumber1 then
					CurrentNumber1 = (Player.Character.HumanoidRootPart.Position - v.Adornee:FindFirstChildOfClass("MeshPart").Position).Magnitude
					SelectedEnemy1 = v
				end
			end

			if SelectedEnemy1 then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.Attack:InvokeServer(SelectedEnemy1.Adornee.Spawn.Value)

				repeat task.wait() until not SelectedEnemy1:FindFirstChild("Health") or not AttackLooping
			end
		end
	end
end)

Enemies:CreateButton({
	Name = "🔂 Refresh Enemy List",
	Callback = function()
		local NewTable = {}
		for i,v in pairs(game:GetService("Workspace").EnemyCache:GetChildren()) do
			if not table.find(NewTable, v.Name) then
				table.insert(NewTable, v.Name)
			end
		end

		EnemyDropdown:Refresh(NewTable, true)
	end,
})

local Pets = Window:CreateTab("Pets", 4483362458)

Pets:CreateToggle({
	Name = "🥇 Auto Equip Best",
	CurrentValue = false,
	Flag = "AutoEquipBest",
	Callback = function(Value)
		EquipLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if EquipLooping then
			game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.EquipBest:InvokeServer()
		end
	end
end)

Pets:CreateToggle({
	Name = "😋 Auto Feed",
	CurrentValue = false,
	Flag = "AutoFeed",
	Callback = function(Value)
		FeedLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if FeedLooping then
			game:GetService("ReplicatedStorage").Packages.Knit.Services.NestService.RF.Feed:InvokeServer()
		end
	end
end)

Pets:CreateToggle({
	Name = "📈 Auto Upgrade Tier",
	CurrentValue = false,
	Flag = "AutoUpgradeTier",
	Callback = function(Value)
		TierLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if TierLooping then
			for i,v in pairs(Player.PlayerGui.Main.backpack.ScrollingFrame:GetChildren()) do
				if v:IsA("ImageButton") then
					pcall(function()
						game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.TierPet:InvokeServer(v.Name)
					end)
				end
			end
		end
	end
end)

Pets:CreateToggle({
	Name = "🐣 Auto Open Eggs",
	CurrentValue = false,
	Flag = "AutoOpenEggs",
	Callback = function(Value)
		OpenLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if OpenLooping then
			for i,v in pairs(game:GetService("Workspace").Nests:FindFirstChild(Player.Name).Stands:GetChildren()) do
				if v:GetAttribute("Id") then
					game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.OpenEgg:InvokeServer(v:GetAttribute("Id"))
				end
			end
		end
	end
end)

Pets:CreateToggle({
	Name = "🥚 Auto Place",
	CurrentValue = false,
	Flag = "AutoPlace",
	Callback = function(Value)
		PlaceLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if PlaceLooping then
			for i,v in pairs(game:GetService("Workspace").Nests:FindFirstChild(Player.Name).Stands:GetChildren()) do
				if not v:GetAttribute("Egg") and not v:FindFirstChild("Lock") then
					local Button = Player.PlayerGui.Main.EggSelect.ScrollingFrame:FindFirstChildOfClass("ImageButton")
					if Button then
						game:GetService("ReplicatedStorage").Packages.Knit.Services.NestService.RF.PlaceEgg:InvokeServer(v, {["isShiny"] = Button.shinyIcon.Visible, ["Type"] = Button.Name:split("Shiny")[1]})
					end
				end
			end
		end
	end
end)

local Quest = Window:CreateTab("Quest", 4483362458)

Quest:CreateDropdown({
	Name = "📜 Quest",
	Options = QuestsList,
	CurrentOption = "",
	Flag = "SelectedQuest",
	Callback = function(Value)
		SelectedQuest = Value
	end,
})

Quest:CreateToggle({
	Name = "📝 Auto Quest",
	CurrentValue = false,
	Flag = "AutoQuest",
	Callback = function(Value)
		QuestLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if QuestLooping and SelectedQuest then
			game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.GiveQuest:InvokeServer(SelectedQuest)
			task.wait(1)
			game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.RedeemQuest:InvokeServer(SelectedQuest)
		end
	end
end)
