-- // Variables \\ --

_G.GemTeleporter = true

local virtualInput = game:GetService("VirtualInputManager")

local Collecting = false

local Crystal = false

-- // Functions \\ --

function Check(Model)
	if Model:FindFirstChild("Part") then
		TeleportToGem(Model)
		repeat task.wait() until not Model:FindFirstChild("Part")
	end
end

function StartUpKey(Model)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(Model.PrimaryPart.Position.X, Model.PrimaryPart.Position.Y + 5, Model.PrimaryPart.Position.Z))
	Collecting = true
	while task.wait() and Collecting do
		virtualInput:SendKeyEvent(true, "E", false, nil)
		repeat task.wait() until not Model:FindFirstChild("Part") or not _G.GemTeleporter or Model.PrimaryPart.Position.Y < 4.8 or not Collecting
		virtualInput:SendKeyEvent(false, "E", false, nil)
		Collecting = false
	end
end

function TeleportToGem(Model)
	if _G.GemTeleporter and Model:IsA("Model") then
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if Model.PrimaryPart and Model.PrimaryPart.Position.Y >= 4.8 then
				StartUpKey(Model)
			elseif Model.PrimaryPart then
				spawn(function()
					print("Waiting for part to reach Y position 4.8+, current Y position is "..Model.PrimaryPart.Position.Y)

					repeat task.wait() until not Collecting
					repeat task.wait() until Model.PrimaryPart.Position.Y >= 4.8

					StartUpKey(Model)
				end)
			end
		else
			repeat task.wait() until game.Players.LocalPlayer.Character
		end
	end
end

-- // Startup \\ --

spawn(function()
	while task.wait() do
		if game:GetService("Workspace").ActiveMecahnicPrompts.CrystalRent.BillboardGui.State.Text == "READY!" and not Crystal and _G.GemTeleporter then
			Crystal = true
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(228, 7, 276))
			
			while task.wait() and Crystal do
				virtualInput:SendKeyEvent(true, "E", false, nil)
				repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.ActiveMechanic.PullOutCrystalizer:GetPropertyChangedSignal("Visible") or not Crystal or not _G.GemTeleporter
				virtualInput:SendKeyEvent(false, "E", false, nil)
				Crystal = false
			end
			
			task.wait(0.5)

			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(43, 7, 87))

			task.wait(0.5)

			game:GetService("ReplicatedStorage").Events.PlaceCrystaliser:InvokeServer()
		end
	end
end)

while task.wait() do
	for i,v in pairs(workspace.GemsSpawned:GetChildren()) do
		task.wait(0.5)
		Check(v)
	end
end
