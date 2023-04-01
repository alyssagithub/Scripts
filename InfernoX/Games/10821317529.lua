local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local Services = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.4.7"].knit.Services
local workspace = workspace

local Folders = {}
local Areas = {}
local Ores = {"Ore1", "Ore2", "Ore3", "Ore4", "MegaOre", "All"}
local Eggs = {}

for i,v in pairs(workspace:GetChildren()) do
	if v.Name == "Drops" then
		table.insert(Folders, v)
	end
end

if #Folders == 2 then
	Folders[1]:Destroy()
end

for i,v in pairs(workspace.WorldBox:GetChildren()) do
	if not table.find(Areas, v.Name) then
		table.insert(Areas, v.Name)
	end
end

for i,v in pairs(workspace.Eggs:GetChildren()) do
	table.insert(Eggs, v.Name)
end

local Window = CreateWindow("v2")

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateSection("Mining")

Main:CreateDropdown({
	Name = "🌋 Area",
	Options = Areas,
	CurrentOption = "",
	Flag = "Area",
	Callback = function(Option)	end,
})

Main:CreateDropdown({
	Name = "🔱 Ore",
	Options = Ores,
	CurrentOption = "",
	Flag = "Ore",
	Callback = function(Option)	end,
})

Main:CreateToggle({
	Name = "⛏ Auto Mine",
	CurrentValue = false,
	Flag = "Mine",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Mine.CurrentValue and Rayfield.Flags.Area.CurrentOption ~= "" and Rayfield.Flags.Ore.CurrentOption ~= "" then
			for i,v in pairs(workspace.SpawnedMineables:FindFirstChild(Rayfield.Flags.Area.CurrentOption):GetChildren()) do
				if v and (v:FindFirstChild("Type") and v.Type.Value:find(Rayfield.Flags.Ore.CurrentOption)) or Rayfield.Flags.Ore.CurrentOption == "All" and Rayfield.Flags.Mine.CurrentValue then
					for e,r in pairs(workspace.PickaxeStorage[Player.Name]:GetChildren()) do
						Services.MineableService.RF.StartMining:InvokeServer({["Mineable"] = v, ["PickaxeId"] = r.Name})
					end
					
					local Start = tick()
					
					repeat task.wait() until not v or not workspace.SpawnedMineables:FindFirstChild(Rayfield.Flags.Area.CurrentOption):FindFirstChild(v.Name) or tick() - Start > 1 and Player.PlayerGui.HUD.Bottom.ClickButton.Visual.DPSLabel.Text == "DPS:0" or not Rayfield.Flags.Mine.CurrentValue
					
					print("[Inferno X] Debug: Mined an ore")
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🖱 Auto Click",
	CurrentValue = false,
	Flag = "Click",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Click.CurrentValue then
			Services.MineableService.RE.MineableRemote:FireServer("Click")
		end
	end
end)

Main:CreateToggle({
	Name = "💎 Auto Collect Drops",
	CurrentValue = false,
	Flag = "Drops",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Drops.CurrentValue then
			for i,v in pairs(workspace.Drops:GetChildren()) do
				v.Drop.CFrame = Player.Character.HumanoidRootPart.CFrame
			end
		end
	end
end)

Main:CreateSection("Other")

Main:CreateToggle({
	Name = "🎁 Auto Claim Rewards",
	CurrentValue = false,
	Flag = "Rewards",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Rewards.CurrentValue then
			for i,v in pairs(Player.PlayerGui.Rewards.Frame.Contents:GetChildren()) do
				if v.ClassName == "ImageButton" and v.Timer.Text == "CLAIM" then
					Services.RewardService.RF.RequestCompletion:InvokeServer({["Id"] = v.Name})
					v.Timer.Text = "CLAIMED"
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🏆 Auto Claim Quests",
	CurrentValue = false,
	Flag = "Quests",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Quests.CurrentValue then
			for _,v in pairs(Player.PlayerGui.Achievements.Frame.ScrollingFrame:GetChildren()) do
				if v.ClassName == "Frame" and v.Completed.Visible then
					Services.AchievementService.RF.RequestCompletion:InvokeServer({["Id"] = v.Name})
					v.Completed.Visible = false
				end
			end
		end
	end
end)

local Teleport

Teleport = Main:CreateDropdown({
	Name = "🏔 Teleport to Area",
	Options = Areas,
	CurrentOption = "",
	--Flag = "Teleport",
	Callback = function(Option)
		pcall(function()
			Player.Character.HumanoidRootPart.CFrame = workspace.WorldBox[Option].CFrame

			Teleport:Set("")
		end)
	end,
})

local Items = Window:CreateTab("Inventory", 4483362458)

Items:CreateSection("Hatching")

Items:CreateDropdown({
	Name = "🥚 Egg",
	Options = Eggs,
	CurrentOption = "",
	Flag = "Egg",
	Callback = function(Option)	end,
})

Items:CreateToggle({
	Name = "🐣 Auto Hatch",
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Hatch.CurrentValue and Rayfield.Flags.Egg.CurrentOption ~= "" then
			Services.EggService.RF.OpenEgg:InvokeServer({["UpdateType"] = "Open", ["EggType"] = Rayfield.Flags.Egg.CurrentOption, ["Auto"] = false, ["Amount"] = 1})
		end
	end
end)

Items:CreateSection("Items")

Items:CreateToggle({
	Name = "👍 Auto Equip Best",
	CurrentValue = false,
	Flag = "EquipBest",
	Callback = function(Value)	end,
})

Player.PlayerGui.Pickaxes.Frame.ScrollingFrame.ChildAdded:Connect(function(Child)
	if Rayfield.Flags.EquipBest.CurrentValue and Child.ClassName == "TextButton" then
		firesignal(Player.PlayerGui.Pickaxes.Frame.RightButtons.EquipBestButton.Activated)
	end
end)

Player.PlayerGui.Pets.Frame.ScrollingFrame.ChildAdded:Connect(function(Child)
	if Rayfield.Flags.EquipBest.CurrentValue and Child.ClassName == "TextButton" then
		firesignal(Player.PlayerGui.Pets.Frame.RightButtons.EquipBestButton.Activated)
	end
end)
