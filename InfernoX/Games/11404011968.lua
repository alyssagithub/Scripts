local Player, Rayfield, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local workspace = workspace
local huge = math.huge
local task = task

local Remotes = game:GetService("ReplicatedStorage").Remotes

local Character = Player.Character or Player.CharacterAdded:Wait()

local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(NewCharacter)
	Character = NewCharacter
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local ChildAdded = false

local Modes = {"Mode: Closest"}

for i,v in pairs(workspace.Maps:GetChildren()) do
	for i,v in pairs(v.Enemies:GetChildren()) do
		if not table.find(Modes, v.Name) then
			table.insert(Modes, v.Name)
		end
	end
end

local Window = CreateWindow("v1.1.1")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Farming")

Main:CreateDropdown({
	Name = "🗡 Mode",
	SectionParent = Section,
	Options = Modes,
	CurrentOption = "Mode: Closest",
	Flag = "Mode",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "👊 Auto Attack",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Attack",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Attack.CurrentValue then
			local Number = huge
			local Closest
			
			for i,v in pairs(workspace.Maps:GetChildren()) do
				for i,v in pairs(v.Enemies:GetChildren()) do
					local Mode = Rayfield.Flags.Mode.CurrentOption[1]
					if Mode == "Mode: Closest" or v.Name == Mode and v:FindFirstChild("Torso") and v.PrimaryPart and v.Torso.Transparency == 0 then
						local Magnitude = (HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
						if Magnitude < Number then
							Number = Magnitude
							Closest = v
						end
					end
				end
			end
			
			if Closest then
				Remotes.EnemyRemotes.AttackEnemy:FireServer(Closest)
				
				repeat
					HumanoidRootPart.CFrame = Closest.PrimaryPart.CFrame + Closest.PrimaryPart.CFrame.LookVector * -5
					task.wait() 
				until not Closest or not Closest.Parent or not Closest:FindFirstChild("Torso") --[[or Closest.Torso.Transparency ~= 0]] or not Rayfield.Flags.Attack.CurrentValue or ChildAdded
				
				if ChildAdded then
					ChildAdded = false
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🖱 Auto Click",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Click",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Click.CurrentValue then
			Remotes.EnemyRemotes.AttackClick:InvokeServer()
		end
	end
end)

Main:CreateToggle({
	Name = "💴 Auto Collect",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Collect",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Collect.CurrentValue then
			for i,v in pairs(workspace.Drops:GetChildren()) do
				if v.ClassName == "Model" and v.PrimaryPart then
					v.PrimaryPart.CFrame = HumanoidRootPart.CFrame
				end
			end
		end
	end
end)

local Section = Main:CreateSection("Heroes")

Main:CreateToggle({
	Name = "💎 Auto Open Crystal",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Open",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Open.CurrentValue then
			Remotes.InventoryRemotes.HeroRoll:InvokeServer()
		end
	end
end)

Main:CreateToggle({
	Name = "🥇 Auto Equip Best",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Best",
	Callback = function()end,
})

Main:CreateSlider({
	Name = "🔢 Hero to Fuse",
	SectionParent = Section,
	Range = {1, tonumber(Player.PlayerGui.InventoryUI.MainFrame.Outline.InnerFrame.EquippedCount.Text:split("/")[2]) or 3},
	Increment = 1,
	Suffix = "Best",
	CurrentValue = 1,
	Flag = "Hero",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🧬 Auto Fuse",
	Info = "Upon new hero, fuses heroes to the best hero",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Fuse",
	Callback = function()end,
})

Player.PlayerGui.InventoryUI.MainFrame.Outline.InnerFrame.InventoryScroll.InventoryNest.ChildAdded:Connect(function(Child)
	if Child.ClassName == "Frame" then 
		if Rayfield.Flags.Best.CurrentValue then
			Remotes.HeroRemotes.EquipBest:FireServer()
			ChildAdded = true
		end
		
		if Rayfield.Flags.Fuse.CurrentValue then
			local IDs = {}

			for i,v in pairs(Player.PlayerGui.InventoryUI.MainFrame.Outline.InnerFrame.InventoryScroll.InventoryNest:GetChildren()) do
				if v.ClassName == "Frame" and i > tonumber(Player.PlayerGui.InventoryUI.MainFrame.Outline.InnerFrame.EquippedCount.Text:split("/")[2]) then
					table.insert(IDs, i)
				end
			end

			Remotes.InventoryRemotes.FuseHeroes:FireServer(Rayfield.Flags.Hero.CurrentValue, IDs)
		end
	end
end)

local Section = Main:CreateSection("Progression")

Main:CreateToggle({
	Name = "📜 Auto Claim Quests",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Quest",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Quest.CurrentValue then
			for i,v in pairs(workspace.Maps:GetChildren()) do
				Remotes.QuestRemotes.RequestQuest:FireServer(v.Name)
				Remotes.QuestRemotes.ClaimQuestReward:InvokeServer(v.Name)
			end
			task.wait(1)
		end
	end
end)

Main:CreateToggle({
	Name = "🔼 Auto Claim Upgrades",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Claim",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Claim.CurrentValue then
			for i,v in pairs(Player.PlayerGui.UpgradesUI.MainFrame.BlueOutline.MainFrame.UpgradesScroll:GetChildren()) do
				if v.ClassName == "Frame" then
					Remotes.UpgradesRemotes.ClaimUpgrade:InvokeServer(v.Name.." "..v.Frame.Button.UpgradeName.Text:split(" ")[2])
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🏝 Auto Buy Areas",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Area",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Area.CurrentValue then
			for i,v in pairs(workspace.Maps:GetChildren()) do
				Remotes.LocationRemotes.LocationPurchase:InvokeServer(v.Name)
			end
		end
	end
end)
