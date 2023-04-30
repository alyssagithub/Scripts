local Player, Rayfield, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local workspace = workspace
local huge = math.huge
local task = task

local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
local Services = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services")

RemoteEvent:FireServer({{"!", "EnemyRender", 500}})

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

local Enemies = {"Closest Enemy"}

local function EnemyTable(v)
	local HealthBar = v:FindFirstChild("EnemyHealthBar", true)
	if HealthBar then
		local EnemyName = HealthBar.Title.Text
		if not table.find(Enemies, EnemyName) then
			table.insert(Enemies, EnemyName)
			return EnemyName
		end
	end
end

for i,v in pairs(workspace.ClientEnemies:GetChildren()) do
	EnemyTable(v)
end

local Window = CreateWindow("v1.1")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Attacking")

local EnemyDropdown = Main:CreateDropdown({
	Name = "👾 Enemy",
	SectionParent = Section,
	Options = Enemies,
	CurrentOption = "Closest Enemy",
	Flag = "Enemy",
	Callback = function()end,
})

--[[task.spawn(function()
	while task.wait() do
		for i,v in pairs(workspace.ClientEnemies:GetChildren()) do
			local EnemyName = EnemyTable(v)
			if EnemyName then
				EnemyDropdown:Add(EnemyName)
			end
		end
	end
end)]]

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
			local Number = huge
			local Enemy

			if EnemyDropdown.CurrentOption[1] ~= "Closest Enemy" then
				for i,v in pairs(workspace.ClientEnemies:GetChildren()) do
					if v and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("EnemyHealthBar") and v.HumanoidRootPart.EnemyHealthBar.Title.Text:match(EnemyDropdown.CurrentOption[1]) then
						local Magnitude = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
						if Magnitude < Number then
							Number = Magnitude
							Enemy = v
						end
					end
				end
			end

			if not Enemy then
				for i,v in pairs(workspace.ClientEnemies:GetChildren()) do
					if v and v:FindFirstChild("HumanoidRootPart") then
						local Magnitude = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
						if Magnitude < Number then
							Number = Magnitude
							Enemy = v
						end
					end
				end
			end

			if Enemy then
				if Rayfield.Flags.Teleport.CurrentValue then
					HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame
				end
				
				RemoteEvent:FireServer({{"&", Enemy.Name, true}})

				repeat task.wait() until not Enemy or not Enemy.Parent or not Rayfield.Flags.Attack.CurrentValue
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💨 Teleport to Enemy",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Teleport",
	Callback = function()end,
})

local Section = Main:CreateSection("Farming")

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
			RemoteEvent:FireServer({{"'"}})
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
				v.CFrame = HumanoidRootPart.CFrame
			end
		end
	end
end)

Main:CreateToggle({
	Name = "📜 Auto Quest",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Quest",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Quest.CurrentValue then
			for i,v in pairs(workspace.Maps:GetChildren()) do
				RemoteEvent:FireServer({{"@", v.Components:FindFirstChild("NPC", true).Parent.Name}})
			end
		end
	end
end)

local Section = Main:CreateSection("Warriors")

Main:CreateToggle({
	Name = "🐣 Auto Open",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Open",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Open.CurrentValue then
			local Number = huge
			local Egg

			for i,v in pairs(workspace.Maps:GetChildren()) do
				for i,v in pairs(v.Eggs:GetChildren()) do
					if v.PrimaryPart and v.Egg:FindFirstChild("PriceBillboard") and v.Egg.PriceBillboard.Yen.Icon.Image ~= "rbxassetid://9126788621" then
						local Magnitude = (HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
						if Magnitude < Number then
							Number = Magnitude
							Egg = v
						end
					end
				end
			end

			if Egg then
				local EggCFrame = Egg.PrimaryPart.CFrame

				if (HumanoidRootPart.Position - EggCFrame.Position).Magnitude > 4 then
					HumanoidRootPart.CFrame = EggCFrame + EggCFrame.LookVector * 3
				end

				Services.EggService.RF.Open:InvokeServer(Egg.Name, (Egg:FindFirstChild("Bottom") and 2 or false))
			end
		end
	end
end)
