-- Instructions: To enable the triggerbot, press E, to change the keybind go down to instruction 2.

-- // Variables \\ --

_G.triggerbot = false

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local Clicked = false

-- // Side Scripts \\ --

game:GetService("UserInputService").InputBegan:connect(function(Input, GameProcessedEvent)
	if GameProcessedEvent then
		return
	end

	if Input.KeyCode == Enum.KeyCode.E then -- Instruction 2: To change the keybind, change the "Enum.KeyCode.E" to "Enum.KeyCode.(TheKey)" for changing your keybind.
		_G.triggerbot = not _G.triggerbot
	end
end)

-- // Main Scripts \\ --

game:GetService("RunService").RenderStepped:Connect(function()
	if (mouse.Target.Parent:FindFirstChildOfClass("Humanoid") or mouse.Target.Parent.Parent:FindFirstChildOfClass("Humanoid")) and _G.triggerbot and mouse.Target.Parent.Name ~= player.Name then
		local humanoid = mouse.Target.Parent:FindFirstChildOfClass("Humanoid") or mouse.Target.Parent.Parent:FindFirstChildOfClass("Humanoid")
		
		if humanoid.Health >= 1 then
			local name = mouse.Target.Parent.Name

			mouse1press()
			Clicked = false
		end
	elseif _G.triggerbot and not Clicked then
		mouse1release()
	elseif not _G.triggerbot and (mouse.Target.Parent:FindFirstChildOfClass("Humanoid") or mouse.Target.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
		Clicked = true
	end
end)
