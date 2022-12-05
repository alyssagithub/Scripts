local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.0.0")

local SkateLooping
local RampLooping

local Areas = {}

for i,v in pairs(game:GetService("Workspace").Teleports:GetChildren()) do
	table.insert(Areas, v.Name)
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "🛹 Auto Ride Skateboard",
	CurrentValue = false,
	Flag = "AutoSkate",
	Callback = function(Value)
		SkateLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if SkateLooping and Player.serverstats.onboard.Value == false then
			local HighestWheels = 0
			local HighestReward = 0
			local BestSkateboard

			for i,v in pairs(game:GetService("Workspace").Skateboards:GetDescendants()) do
				if v:IsA("NumberValue") and v.Name == "Wheels" and v.Value <= Player.leaderstats.Wheels.Value and v.Value >= HighestWheels then
					HighestWheels = v.Value
					BestSkateboard = v
				end
			end

			for i,v in pairs(game:GetService("Workspace").Skateboards:GetDescendants()) do
				if v:IsA("NumberValue") and v.Name == "Reward" and v.Parent.Wheels.Value == HighestWheels and v.Value >= HighestReward then
					HighestReward = v.Value
					BestSkateboard = v
				end
			end
			
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(BestSkateboard.Parent.Position)
			repeat
				fireproximityprompt(BestSkateboard.Parent.Prompt)
				task.wait()
			until Player.serverstats.onboard.Value == true
		end
	end
end)

Main:CreateToggle({
	Name = "🗻 Auto Ride Ramp",
	CurrentValue = false,
	Flag = "AutoRamp",
	Callback = function(Value)
		RampLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if RampLooping and Player.serverstats.onramp.Value == false then
			local CurrentNumber = 0
			local BestRamp

			for i,v in pairs(game:GetService("Workspace").Ramps:GetChildren()) do
				for e,r in pairs(v:GetChildren()) do
					if r.Name == "Text" and r.BillboardInfo.BillboardText.Text:split("x")[2] and tonumber(r.BillboardInfo.BillboardText.Text:split("x")[2]:split(" ")[1]) > CurrentNumber then
						CurrentNumber = tonumber(r.BillboardInfo.BillboardText.Text:split("x")[2]:split(" ")[1])
						BestRamp = v
					end
				end
			end

			for i,v in pairs(BestRamp:GetChildren()) do
				if v.Name:match("Ramp") and v.IsRampInUse.Value == false then
					Player.Character.HumanoidRootPart.CFrame = CFrame.new(v.floor.Position.X + 10, v.floor.Position.Y, v.floor.Position.Z)
					
					repeat
						fireproximityprompt(v.Attachment.Prompt)
						task.wait()
					until Player.serverstats.onramp.Value == true
					
					break
				end
			end
		end
	end
end)

Main:CreateDropdown({
	Name = "Teleport to Area",
	Options = Areas,
	CurrentOption = "",
	Flag = "SelectedIsland",
	Callback = function(Option)
		Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Teleports:FindFirstChild(Option).CFrame
	end,
})
