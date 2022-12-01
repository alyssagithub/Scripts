local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CreateWindow("v1.0.0")

local CollectLooping
local RebirthLooping
local ClaimLooping
local CapsuleLooping
local OpenLooping

local SelectedCapsule

local CapsuleList = {"standardCapsule", "midCapsule", "epicCapsule", "basicBuffCapsule"}

for i,v in pairs(game:GetService("ReplicatedStorage").availableCapsules:GetChildren()) do
	if not table.find(CapsuleList, v.Name) and v.Name ~= "timer" then
		if v.Name == "highlightedCapsule" then
			table.insert(CapsuleList, v.Value)
		else
			table.insert(CapsuleList, v.Name)
		end
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "🍃 Auto Collect",
	CurrentValue = false,
	Flag = "AutoCollect",
	Callback = function(Value)
		CollectLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if CollectLooping then
			for i,v in pairs(game:GetService("Workspace").gardenStage.physicsProps:GetChildren()) do
				if CollectLooping and v:IsA("Model") and v:FindFirstChild("destructable") and v.destructable.Value == true and v.destructable:FindFirstChildOfClass("MeshPart") then
					if not Player.Character:FindFirstChild("HumanoidRootPart") then
						repeat task.wait() until Player.Character:FindFirstChild("HumanoidRootPart")
					end

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = v.destructable:FindFirstChildOfClass("MeshPart").CFrame
					task.wait()
					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace").gardenStage.triggers.hubTrigger.Position)
					task.wait()
				end
			end
		end
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
	while true do
		if RebirthLooping then
			game:GetService("ReplicatedStorage").functions.requestRebirth:FireServer()
		end
		task.wait(1)
	end
end)

Main:CreateToggle({
	Name = "🎁 Auto Claim Rewards",
	CurrentValue = false,
	Flag = "AutoClaim",
	Callback = function(Value)
		ClaimLooping = Value
	end,
})

task.spawn(function()
	while true do
		if ClaimLooping then
			for i,v in pairs(Player.playerStats.rewards:GetChildren()) do
				game:GetService("ReplicatedStorage").functions.claimReward:InvokeServer(v)
				task.wait()
			end
		end
		task.wait(1)
	end
end)

local Capsule = Window:CreateTab("Capsule", 4483362458)

Capsule:CreateDropdown({
	Name = "💊 Capsule",
	Options = CapsuleList,
	CurrentOption = "",
	Flag = "SelectedCapsule",
	Callback = function(Value)
		SelectedCapsule = Value
	end,
})

Capsule:CreateToggle({
	Name = "💵 Auto Buy Capsule",
	CurrentValue = false,
	Flag = "AutoBuyCapsule",
	Callback = function(Value)
		CapsuleLooping = Value
	end,
})

task.spawn(function()
	while true do
		if CapsuleLooping and SelectedCapsule then
			game:GetService("ReplicatedStorage").functions.buyCapsule:InvokeServer(SelectedCapsule)
		end
		task.wait(1)
	end
end)

Capsule:CreateToggle({
	Name = "📭 Auto Open Capsule",
	CurrentValue = false,
	Flag = "AutoOpenCapsule",
	Callback = function(Value)
		OpenLooping = Value
	end,
})

task.spawn(function()
	while true do
		if OpenLooping then
			if Player.PlayerGui:FindFirstChild("activeCapsule") then
				Click(Player.PlayerGui.menus.menuHandler.selection)
			end
		end
		task.wait(.25)
	end
end)
