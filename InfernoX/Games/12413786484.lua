local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("LBConnection"):WaitForChild("Remotes")
local NormalRemotes = ReplicatedStorage:WaitForChild("Remotes")

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

local Enemies = {}
local Worlds = {}

for i,v in pairs(ReplicatedStorage.Enemies:GetChildren()) do
	for e,r in pairs(v:GetChildren()) do
		table.insert(Enemies, r:GetChildren()[1].Name)
	end
end

for i,v in pairs(workspace.TouchParts:GetChildren()) do
	if v.Name:find("Portal") and not table.find(Worlds, tostring(v.Name:split("Portal")[1])) then
		table.insert(Worlds, tostring(v.Name:split("Portal")[1]))
	end
end

local Window = CreateWindow("v1")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Combat")

Main:CreateToggle({
	Name = "🗡 Auto Attack",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Attack",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Attack.CurrentValue then
			Remotes.attackFunc:FireServer()
		end
	end
end)

Main:CreateToggle({
	Name = "💥 Auto Skills",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Skills",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Skills.CurrentValue then
			for i,v in pairs(Player.PlayerGui.MainGUI["Down Bar"]:GetChildren()) do
				if v.Name:lower():find("slot") and not v.Name:lower():find("lock") and not v.Parent:FindFirstChild(v.Name.."Lock") and v.Cooldownframe.BackgroundTransparency == 1 then
					NormalRemotes["Send Information"]:FireServer(v.Name)
				end
			end
		end
	end
end)

local Section = Main:CreateSection("Farming")

Main:CreateDropdown({
	Name = "👾 Enemy",
	SectionParent = Section,
	Options = Enemies,
	CurrentOption = "",
	Flag = "Enemy",
	Callback = function(Option)
		Rayfield.Flags.Enemy.CurrentOption = Option
	end,
})

Main:CreateSlider({
	Name = "🔢 Teleport Offset",
	Info = "Set the studs offset from where u teleport",
	SectionParent = Section,
	Range = {-10, 10},
	Increment = .1,
	Suffix = "Studs",
	CurrentValue = -2,
	Flag = "Offset",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🔪 Teleport to Enemy",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "TPEnemy",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		local Enemy = workspace.EnemyNPCs:FindFirstChild(Rayfield.Flags.Enemy.CurrentOption, true)
		if Rayfield.Flags.TPEnemy.CurrentValue and Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
			HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame + Enemy.HumanoidRootPart.CFrame.LookVector * Rayfield.Flags.Offset.CurrentValue
		end
	end
end)

local Section = Main:CreateSection("Progression")

Main:CreateToggle({
	Name = "🐣 Auto Hatch",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Hatch.CurrentValue and workspace.TouchParts:FindFirstChild(workspace.Maps:GetChildren()[1].Name.."Egg") then
			HumanoidRootPart.CFrame = workspace.TouchParts[workspace.Maps:GetChildren()[1].Name.."Egg"].CFrame + Vector3.new(0, 10, 0)
			Remotes.Egg_Spin.Sent:FireServer(1, "Open_1")
		end
	end
end)

Main:CreateToggle({
	Name = "❌ Disable Hatch Animation",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Animation",
	Callback = function(Value)
		Player:WaitForChild("PlayerScripts"):WaitForChild("eggOpeningAnim").Disabled = Value
	end,
})

Main:CreateToggle({
	Name = "🔁 Auto Ascend",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Ascend",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Ascend.CurrentValue and Player.PlayerGui.MainGUI.MainFrames.Ascend.MainFrame.Progress.UID.Text == "100%" then
			Remotes.RebirthRem:FireServer()
			task.wait(1)
		end
	end
end)

local Section = Main:CreateSection("Inventory")

Main:CreateToggle({
	Name = "⚔ Auto Equip Best",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Best",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Best.CurrentValue then
			Remotes.EquipBest:FireServer("Swords")
			task.wait(2)
			Remotes.EquipBest:FireServer("Pets")
			task.wait(1)
		end
	end
end)

local Section = Main:CreateSection("Transportation")

Main:CreateDropdown({
	Name = "🏝 Teleport to World",
	SectionParent = Section,
	Options = Worlds,
	CurrentOption = "",
	Flag = "World",
	Callback = function(Option)
		NormalRemotes.portalTeleport:FireServer(Option)
	end,
})

Main:CreateSlider({
	Name = "💨 WalkSpeed Modifier",
	SectionParent = Section,
	Range = {0, 128},
	Increment = 1,
	Suffix = "",
	CurrentValue = 32,
	Flag = "Walkspeed",
	Callback = function(Value)
		Player.Character.Humanoid.WalkSpeed = Value
	end,
})
