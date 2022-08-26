getgenv().AutoPumpkin = true

-- only use if you own the Hallow Greatsword

while AutoPumpkin and task.wait(.25) do
    --game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5063, 700, 4765) -- perfect grinding spot for <300k level
    
    --game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5045, 692, 3401) -- perfect grinding spot for <2m level
    
    --game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5061, 687, 2909) -- perfect grinding spot for rebirth 6+ (aureus)
  
    local args = {
        [1] = "Input",
        [2] = "HallowHallow Greatsword",
        [3] = 4.571428571428571,
        [4] = "Hallows"
    }

    game:GetService("Players").LocalPlayer.Character.Combat.RemoteEvent:FireServer(unpack(args))
end
