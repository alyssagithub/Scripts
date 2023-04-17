if not game:IsLoaded() then
	game.Loaded:Wait()
end

pcall(queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport, 'loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Fabled%20Legacy.lua"))()')

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart

Player.CharacterAdded:Connect(function(Char)
	Character = Char
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local UseSpell = ReplicatedStorage:WaitForChild("useSpell")
local Swing = ReplicatedStorage:WaitForChild("Swing")

_G.Enabled = true

while _G.Enabled and task.wait() do
	local Number = math.huge
	local Closest

	for i,v in pairs(workspace.Enemies:GetChildren()) do
		if v and v:FindFirstChild("HumanoidRootPart") and not workspace:FindFirstChild("SpellPart4") then
			local Magnitude = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude

			if Magnitude <= 15 and Magnitude < Number then
				Number = Magnitude
				Closest = v.HumanoidRootPart
			end
		end
	end

	if Closest then
		HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, Vector3.new(Closest.Position.X, HumanoidRootPart.Position.Y, Closest.Position.Z))
		if not Player.PlayerGui.SpellGui.qMainFrame.coverQ.Visible then
			UseSpell:FireServer("Q")
		end
		if not Player.PlayerGui.SpellGui.eMainFrame.coverE.Visible then
			UseSpell:FireServer("E")
		end
		Swing:FireServer()
	end
end
