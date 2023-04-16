local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local workspace = workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

local SelectedAreas = {}
local SelectedLevels = {}

local Areas = {}
local Levels = {}
local Eggs = {}

local Loaded = false

repeat
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v.Name:match("Axe") then
			Loaded = true
		end
	end
	task.wait()
until Loaded

local Services = ReplicatedStorage.Packages.Knit.Services

local Trees = workspace.Scripts.Trees

for i,v in pairs(Trees:GetChildren()) do
	table.insert(Areas, v.Name)
end

for i,v in pairs(Trees:GetChildren()) do
	for i,v in pairs(v:GetChildren()) do
		if v.Name:match("level") and not table.find(Levels, v.Name) then
			table.insert(Levels, v.Name)
		end
	end
end

for i,v in pairs(workspace.Scripts.Eggs:GetChildren()) do
	if not v.Name:match("Robux") then
		table.insert(Eggs, v.Name)
	end
end

local Window = CreateWindow("v1.3.3")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Chopping")

local AreaLabel = Main:CreateLabel("Selected Areas: nil", Section)
local LevelLabel = Main:CreateLabel("Selected Levels: nil", Section)

Main:CreateDropdown({
	Name = "🏝 Area",
	SectionParent = Section,
	Options = Areas,
	CurrentOption = "",
	Flag = "Area",
	Callback = function(Value)
		if Value ~= "" then
			if table.find(SelectedAreas, Value[1]) then
				table.remove(SelectedAreas, table.find(SelectedAreas, Value[1]))
			else
				table.insert(SelectedAreas, Value[1])
			end

			AreaLabel:Set("Selected Areas: "..table.concat(SelectedAreas, ", "))
		end
	end,
})

Main:CreateDropdown({
	Name = "🔢 Level",
	SectionParent = Section,
	Options = Levels,
	CurrentOption = "",
	Flag = "Level",
	Callback = function(Value)
		if Value ~= "" then
			if table.find(SelectedLevels, Value[1]) then
				table.remove(SelectedLevels, table.find(SelectedLevels, Value[1]))
			else
				table.insert(SelectedLevels, Value[1])
			end

			LevelLabel:Set("Selected Levels: "..table.concat(SelectedLevels, ", "))
		end
	end,
})

Main:CreateToggle({
	Name = "🪓 Auto Chop",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Chop",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Chop.CurrentValue then
			for i,v in pairs(SelectedAreas) do
				local Area = Trees:FindFirstChild(v)
				if Area then
					for e,r in pairs(SelectedLevels) do
						local Storage = Area:FindFirstChild(r):FindFirstChild("Storage")
						if Storage and #Storage:GetChildren() > 0 then
							Services:FindFirstChild("TreeComboChanged", true).Parent.Damage:FireServer(Storage:GetChildren()[1].Name)
						end
					end
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🐍 Auto Boss",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Boss",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Boss.CurrentValue then
			for i,v in pairs(game:GetService("Workspace").Scripts.Areas:GetDescendants()) do
				if v:IsA("Folder") and v.Name:match("Boss") then
					Services:FindFirstChild("BossDied", true).Parent.Damage:FireServer(v.ID.Value)
				end
			end
		end
	end
end)

local Section = Main:CreateSection("Collecting")

Main:CreateToggle({
	Name = "💰 Auto Collect",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Collect",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Collect.CurrentValue then
			for i,v in pairs(workspace.Scripts.Orbs.Storage:GetChildren()) do
				v.CFrame = HumanoidRootPart.CFrame
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💼 Auto Claim Chests",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Chests",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Chests.CurrentValue then
			for i,v in pairs(workspace.Maps:GetChildren()) do
				if v:FindFirstChild("CHEST1") then
					Services:FindFirstChild("ClaimChest", true):InvokeServer(v.Name:split("] ")[2] or v.Name)
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🎁 Auto Claim Rewards",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Rewards",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Rewards.CurrentValue then
			for i = 1, 12 do
				Services:FindFirstChild("ClaimPlaytimeReward", true):InvokeServer(i)
			end
		end
	end
end)

local Section = Main:CreateSection("Inventory")

Main:CreateDropdown({
	Name = "🥚 Egg",
	SectionParent = Section,
	Options = Areas,
	CurrentOption = "Basic",
	Flag = "Egg",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "3️⃣ Triple Hatch",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Triple",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🐣 Auto Hatch",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Hatch.CurrentValue then
			Services:FindFirstChild("Unbox", true):InvokeServer(Rayfield.Flags.Egg.CurrentOption[1], (Rayfield.Flags.Triple.CurrentValue and "triple" or "single"))
		end
	end
end)

Main:CreateToggle({
	Name = "🛠 Auto Craft",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Craft",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Craft.CurrentValue then
			Services:FindFirstChild("CraftAll", true):InvokeServer()
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

local PetsFrame = Player.PlayerGui.MainUI.PetsFrame

PetsFrame.Main.Top.Holder.ChildAdded:Connect(function(Child)
	if Rayfield.Flags.Best.CurrentValue then
		firesignal(PetsFrame.Additional.EquipBest.Click.MouseButton1Up)
	end
end)
