local Player, Rayfield, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local workspace = workspace
local huge = math.huge
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(Character)
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local Modes = {"Mode: Closest", "Mode: Killaura"}

for i,v in pairs(ReplicatedStorage.NPCs:GetChildren()) do
	if not table.find(Modes, v.Name) then
		table.insert(Modes, v.Name)
	end
end

local Window = CreateWindow("v1")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Combat")

Main:CreateDropdown({
	Name = "☣ Mode",
	SectionParent = Section,
	Options = Modes,
	CurrentOption = "Mode: Closest",
	Flag = "Mode",
	Callback = function()end,
})

Main:CreateSlider({
	Name = "🔢 Distance",
	Info = "Set the studs offset from where u teleport/killaura distance",
	SectionParent = Section,
	Range = {-15, 15},
	Increment = .1,
	Suffix = "Studs",
	CurrentValue = 8,
	Flag = "Distance",
	Callback = function()end,
})

Main:CreateSlider({
	Name = "🔃 Direction Offset",
	Info = "Set the studs offset from where u face",
	SectionParent = Section,
	Range = {-3, 3},
	Increment = .1,
	Suffix = "Studs",
	CurrentValue = -1.8,
	Flag = "Direction",
	Callback = function()end,
})

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
			local Mode = Rayfield.Flags.Mode.CurrentOption[1]
			local Number = (Mode == "Mode: Killaura" and Rayfield.Flags.Distance.CurrentValue or huge)
			local Closest

			for i,v in pairs(workspace.NPCS:GetChildren()) do
				if not Mode:match("Mode: ") and v.Name:gsub("%d", ""):split(" ")[1] == Mode or Mode:match("Mode: ") and v:FindFirstChild("LinkedModel") then
					local Magnitude = (HumanoidRootPart.Position - v.Position).Magnitude
					if Magnitude <= Number then
						if Mode ~= "Mode: Killaura" then
							Number = Magnitude
						end
						Closest = v
					end
				end
			end

			if Closest then
				if Mode ~= "Mode: Killaura" then
					HumanoidRootPart.CFrame = Closest.CFrame * CFrame.Angles(Rayfield.Flags.Direction.CurrentValue, 0, 0) + Vector3.new(0, Rayfield.Flags.Distance.CurrentValue, 0)
				else
					HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, Vector3.new(Closest.Position.X, HumanoidRootPart.Position.Y, Closest.Position.Z))
				end
				Events.SwingSword:FireServer("L")
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🛡 Auto Block",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Block",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Block.CurrentValue then
			local Number = huge
			local Closest

			for i,v in pairs(workspace.NPCS:GetChildren()) do
				local Magnitude = (HumanoidRootPart.Position - v.Position).Magnitude
				if Magnitude <= Number then
					Number = Magnitude
					Closest = v
				end
			end

			if Closest then
				local Humanoid = Closest:FindFirstChild("Humanoid", true)
				if Humanoid then
					for i,v in pairs(Closest:FindFirstChild("Humanoid", true):GetPlayingAnimationTracks()) do
						if not table.find({"Stun1", "Stun2", "Stun3", "Idle", "Walk"}, tostring(v)) then
							local Start = tick()
							Events.Block:FireServer(true)
							repeat task.wait() until not v or not v.IsPlaying or not Rayfield.Flags.Block.CurrentValue or tick() - Start >= v.Length
							Events.Block:FireServer(false)
						end
					end
				end
			end
		end
	end
end)

local Section = Main:CreateSection("Skills")

Main:CreateToggle({
	Name = "💨 Auto Weapon Art",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Art",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Art.CurrentValue then
			Events.WeaponArt:FireServer()
		end
	end
end)

Main:CreateToggle({
	Name = "💎 Auto Rune",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Rune",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Rune.CurrentValue then
			Events.Rune:FireServer()
		end
	end
end)
