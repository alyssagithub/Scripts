local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.0.0")

local TapLooping
local MergeLooping
local UpgradeLooping
local RebirthLooping
local FrenzyLooping
local MultiplierLooping

local SelectedMultiplier

local Plot = game:GetService("Workspace").Plots:FindFirstChild(Player.Name)

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "🖱 Auto Tap",
	CurrentValue = false,
	Flag = "AutoTap",
	Callback = function(Value)
		TapLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if TapLooping then
			for i,v in pairs(Plot.Blocks:GetChildren()) do
				game:GetService("ReplicatedStorage").Functions.Tap:FireServer(v)
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🤝 Auto Merge",
	CurrentValue = false,
	Flag = "AutoMerge",
	Callback = function(Value)
		MergeLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if MergeLooping then
			for i,v in pairs(Plot.Blocks:GetChildren()) do
				for e,r in pairs(Plot.Blocks:GetChildren()) do
					firetouchinterest(v, r, 0)
					firetouchinterest(v, r, 1)
					task.wait()
				end
				task.wait()
			end
		end
	end
end)

Main:CreateToggle({
	Name = "📈 Auto Upgrade",
	CurrentValue = false,
	Flag = "AutoUpgrade",
	Callback = function(Value)
		UpgradeLooping = Value
	end,
})

task.spawn(function()
	while true do
		if UpgradeLooping then
			firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.SpawnTier.Buy.Activated)
			firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.MaxBlocks.Buy.Activated)
			firesignal(Player.PlayerGui.World.Wall.Upgrades.Bot.Cooldown.Buy.Activated)
		end
		task.wait(.25)
	end
end)

Main:CreateToggle({
	Name = "🔁 Auto Rebirth",
	CurrentValue = false,
	Flag = "AutoRebirth",
	Callback = function(Value)
		RebirthLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if RebirthLooping then
			if Player.PlayerGui.World.Wall.Rebirths.Rebirth.Buy.BackgroundColor3 ~= Color3.fromRGB(76, 76, 76)  then
				game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
			end
		end
	end
end)

Main:CreateToggle({
	Name = "♾ Infinite 2x Frenzy",
	CurrentValue = false,
	Flag = "InfiniteFrenzy",
	Callback = function(Value)
		FrenzyLooping = Value
	end,
})

task.spawn(function()
	while true do
		if FrenzyLooping then
			firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 0)
			firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 1)
		end
		task.wait(1)
	end
end)

Main:CreateDropdown({
	Name = "💎 Multiplier",
	Options = {"CashMultiplier", "GemsMultiplier"},
	CurrentOption = "",
	Flag = "SelectedMultiplier",
	Callback = function(Value)
		SelectedMultiplier = Value
	end,
})

Main:CreateToggle({
	Name = "💰 Auto Upgrade Multiplier",
	CurrentValue = false,
	Flag = "AutoUpgradeMultiplier",
	Callback = function(Value)
		MultiplierLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if MultiplierLooping and SelectedMultiplier then
			game:GetService("ReplicatedStorage").Functions.GemUpgrade:FireServer(SelectedMultiplier)
		end
	end
end)
