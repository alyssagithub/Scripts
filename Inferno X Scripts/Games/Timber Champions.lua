local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local BossLooping
local OrbLooping
local ChestLooping

local CraftLooping
local BestLooping

local BestDelay = 5

local Chests = {}

local Loading = true

while Loading and task.wait() do
	for i,v in pairs(Player.Character:GetChildren()) do
		if v.Name:match("gameAxe") then
			Loading = false
		end
	end
end

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local TreeService = Knit.GetService("TreeService")
local PetService = Knit.GetService("PetService")
local DamageRemote = TreeService.Damage._re
local DataController = Knit.GetController("DataController")
local EggService = Knit.GetService("EggService")
local OrbService = Knit.GetService("OrbService")
local RewardService = Knit.GetService("RewardService")
local BossService = Knit.GetService("BossService")
local AxeService = Knit.GetService("AxeService")

for i,v in pairs(require(game:GetService("ReplicatedStorage").Shared.List.Chests)) do
	if type(v) == "table" then
		for e,r in pairs(v) do
			table.insert(Chests, e)
		end
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

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
				if v:IsA("Folder") and v.Name == "Boss" then
					if #v.Model:GetChildren() > 0 then
						BossService.Damage:Fire(v.ID.Value)
					end
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
