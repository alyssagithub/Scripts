-- loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()
local Link = game:HttpGet(`https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Games/{game.PlaceId}.lua`)

if Link then
  game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FrostByte Notification",
		Text = "Game found, the script is loading.",
		Duration = 10
	})
	loadstring(Link)()
end
