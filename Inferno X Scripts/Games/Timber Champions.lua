local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.0.1")

local ChopLooping
local BossLooping
local OrbLooping
local ChestLooping

local HatchLooping

local CraftLooping
local BestLooping

local BestDelay = 5

local SelectedAreas = {}
local SelectedLevels = {}

local SelectedEgg
local TripleHatch

local Areas = {}
local Levels = {}
local Chests = {}
local Eggs = {}

local Loading = true

while Loading and task.wait() do
	for i,v in pairs(Player.Character:GetChildren()) do
		if v.Name:match("Axe") then
			Loading = false
		end
	end
end

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local TreeService = Knit.GetService("TreeService")
local PetService = Knit.GetService("PetService")
local Damage = TreeService.Damage
local DataController = Knit.GetController("DataController")
local EggService = Knit.GetService("EggService")
local OrbService = Knit.GetService("OrbService")
local RewardService = Knit.GetService("RewardService")
local BossService = Knit.GetService("BossService")
local AxeService = Knit.GetService("AxeService")

local Trees = game:GetService("Workspace").Scripts.Trees

for i,v in pairs(Trees:GetChildren()) do
	table.insert(Areas, v.Name)
end

for i,v in pairs(Trees:GetDescendants()) do
	if v.Name:match("level") and not table.find(Levels, v.Name) then
		table.insert(Levels, v.Name)
	end
end

for i,v in pairs(require(game:GetService("ReplicatedStorage").Shared.List.Chests)) do
	if type(v) == "table" then
		for e,r in pairs(v) do
			table.insert(Chests, e)
		end
	end
end

for i,v in pairs(game:GetService("Workspace").Scripts.Eggs:GetChildren()) do
	if not v.Name:match("Robux") then
		table.insert(Eggs, v.Name)
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

local AreaLabel = Main:CreateLabel("Selected Areas: ")
local LevelLabel = Main:CreateLabel("Selected Levels: ")

AreaDropdown = Main:CreateDropdown({
	Name = "🏝 Area",
	Options = Areas,
	CurrentOption = "",
	--Flag = "SelectedArea",
	Callback = function(Value)
		if Value ~= "" then
			if table.find(SelectedAreas, Value) then
				table.remove(SelectedAreas, table.find(SelectedAreas, Value))
			else
				table.insert(SelectedAreas, Value)
			end

			AreaLabel:Set("Selected Areas: "..table.concat(SelectedAreas, ", "))
			AreaDropdown:Set("")
		end
	end,
})

LevelDropdown = Main:CreateDropdown({
	Name = "🔢 Level",
	Options = Levels,
	CurrentOption = "",
	--Flag = "SelectedLevel",
	Callback = function(Value)
		if Value ~= "" then
			if table.find(SelectedLevels, Value) then
				table.remove(SelectedLevels, table.find(SelectedLevels, Value))
			else
				table.insert(SelectedLevels, Value)
			end

			LevelLabel:Set("Selected Levels: "..table.concat(SelectedLevels, ", "))
			LevelDropdown:Set("")
		end
	end,
})

Main:CreateToggle({
	Name = "🌲 Auto Chop",
	CurrentValue = false,
	Flag = "AutoChop",
	Callback = function(Value)
		ChopLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if ChopLooping and #SelectedAreas > 0 and #SelectedLevels > 0 then
			for i,v in pairs(SelectedAreas) do
				for e,r in pairs(SelectedLevels) do
					if Trees:FindFirstChild(v):FindFirstChild(r) then
						if Trees:FindFirstChild(v):FindFirstChild(r).Storage:FindFirstChildOfClass("Model") then
							Damage:Fire(Trees:FindFirstChild(v):FindFirstChild(r).Storage:FindFirstChildOfClass("Model").Name)
						end
					end
				end
			end
		end
	end
end)

Main:CreateSection("")

Main:CreateToggle({
	Name = "🐍 Auto Attack Bosses",
	CurrentValue = false,
	Flag = "AutoBoss",
	Callback = function(Value)
		BossLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if BossLooping then
			for i,v in pairs(game:GetService("Workspace").Scripts.Areas:GetDescendants()) do
				if v:IsA("Folder") and v.Name:match("Boss") then
					BossService.Damage:Fire(v.ID.Value)
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🔮 Auto Collect Orbs",
	CurrentValue = false,
	Flag = "AutoCollect",
	Callback = function(Value)
		OrbLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if OrbLooping then
			for i,v in pairs(game:GetService("Workspace").Scripts.Orbs.Storage:GetChildren()) do
				OrbService.CollectOrbs:Fire({v.Name})
				v:Destroy()
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💼 Auto Collect Chests",
	CurrentValue = false,
	Flag = "AutoChest",
	Callback = function(Value)
		ChestLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if ChestLooping then
			for i,v in pairs(Chests) do
				RewardService:ClaimChest(v)
			end
		end
	end
end)

local Pets = Window:CreateTab("Pets", 4483362458)

Pets:CreateDropdown({
	Name = "🥚 Egg",
	Options = Eggs,
	CurrentOption = "",
	Flag = "SelectedEgg",
	Callback = function(Value)
		SelectedEgg = Value
	end,
})

Pets:CreateToggle({
	Name = "3️⃣ Triple Hatch",
	CurrentValue = false,
	Flag = "TripleHatch",
	Callback = function(Value)
		if Value then
			TripleHatch = "triple"
		else
			TripleHatch = "single"
		end
	end,
})

Pets:CreateToggle({
	Name = "🐣 Auto Hatch Egg",
	CurrentValue = false,
	Flag = "AutoHatch",
	Callback = function(Value)
		HatchLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if HatchLooping and SelectedEgg then
			EggService:Unbox(SelectedEgg, TripleHatch)
		end
	end
end)

Pets:CreateSection("")

Pets:CreateToggle({
	Name = "⚒ Auto Craft Pets",
	CurrentValue = false,
	Flag = "AutoCraft",
	Callback = function(Value)
		CraftLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if CraftLooping then
			PetService:CraftAll()
		end
	end
end)

Pets:CreateToggle({
	Name = "🥇 Auto Equip Best",
	CurrentValue = false,
	Flag = "AutoEquipBest",
	Callback = function(Value)
		BestLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if BestLooping then
			local CurrentNumber1 = 0
			local CurrentNumber2 = 0
			local CurrentNumber3 = 0
			local CurrentPet1
			local CurrentPet2
			local CurrentPet3

			local PetData = DataController.data.Pets

			for i,v in pairs(PetData) do
				if v.multiplier > CurrentNumber1 then
					CurrentNumber1 = v.multiplier
					CurrentPet1 = i
				end
			end

			for i,v in pairs(PetData) do
				if v.multiplier > CurrentNumber2 and i ~= CurrentPet1 then
					CurrentNumber2 = v.multiplier
					CurrentPet2 = i
				end
			end

			for i,v in pairs(PetData) do
				if v.multiplier > CurrentNumber3 and i ~= CurrentPet1 and  i ~= CurrentPet2 then
					CurrentNumber3 = v.multiplier
					CurrentPet3 = i
				end
			end

			for i,v in pairs(PetData) do
				if v.equipped == true then
					PetService:Unequip(i)
				end
			end

			pcall(function()
				PetService:Equip(CurrentPet1)
				PetService:Equip(CurrentPet2)
				PetService:Equip(CurrentPet3)
			end)
			task.wait(BestDelay)
		end
	end
end)

Pets:CreateSlider({
	Name = "🐌 Auto Equip Best Delay",
	Range = {0, 60},
	Increment = 1,
	CurrentValue = 5,
	Flag = "Delay",
	Callback = function(Value)
		BestDelay = Value
	end,
})
