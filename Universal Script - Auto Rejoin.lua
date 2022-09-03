-- Feel free to put this in your auto execute folder, as this should not affect any game's gameplay nor be detected.

repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')
 
local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')
 
po.ChildAdded:connect(function(a)
    if a.Name == 'ErrorPrompt' then
        while true do
            ts:Teleport(game.PlaceId)
            task.wait(2)
        end
    end
end)
