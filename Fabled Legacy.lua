local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UseSpell = ReplicatedStorage:WaitForChild("useSpell", 3)
if not UseSpell then
	return
end
local Swing = ReplicatedStorage.Swing
local HumanoidRootPart = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
_G.Enabled = true

pcall(queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport, 'loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Fabled%20Legacy.lua"))()')

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
		UseSpell:FireServer("Q")
		UseSpell:FireServer("E")
		Swing:FireServer()
	end
end
