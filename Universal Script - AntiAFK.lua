-- Feel free to put this in your auto execute folder, as this should not affect any game's gameplay nor be detected.

local VirtualUser = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
