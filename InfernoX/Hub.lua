local StarterGui = game:GetService("StarterGui")
local Link = game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Games/"..game.PlaceId..".lua")

if Link then
  StarterGui:SetCore("SendNotification", {
		Title = "Inferno X Notification",
		Text = "Welcome. Loading script.",
		Duration = 10
	})
	loadstring(Link)()
end
