-- // Game Check for Auto Execute \\ --

if not game:IsLoaded() then
	game.Loaded:Wait()
end

if game.PlaceId ~= 9285238704 then
	return
end

-- // Variables \\ --

local delay1 = 0.845
local delay2 = 0.1

local Removed = false

local CurrentPosition

getgenv().Enabled = true

-- // Main Functions \\ --

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(chara)
	CurrentPosition = chara:WaitForChild("HumanoidRootPart").CFrame
end)

spawn(function()
	while task.wait() and Enabled do
		pcall(function()
			if game:GetService("Workspace").Lobby.Door.Gate.Transparency == 1 then
				for i,v in pairs(game:GetService("Workspace").Environment:GetDescendants()) do
					if v:FindFirstChildOfClass("TouchTransmitter") then
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
							game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CurrentPosition
						end)
						firetouchinterest(v, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, 0)
						task.wait((v.Parent.Name == 'Stage1K' and delay1) or delay2)
					end
				end
			end
		end)
	end
end)
