local StarterGui = game:GetService("StarterGui")
local link = game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Games/"..game.PlaceId..".lua")

if Games[game.PlaceId] then
  StarterGui:SetCore("SendNotification", {
		Title = "Inferno X Notification",
		Text = "Welcome. Loading script.",
		Duration = 10
	})
	loadstring(game:HttpGet(Games[game.PlaceId]))()
end
