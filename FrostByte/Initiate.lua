local Link = game:HttpGet(`https://github.com/alyssagithub/Scripts/blob/main/FrostByte/Games/{game.PlaceId}.lua`)

if Link then
  game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FrostByte Notification",
		Text = "Game found, the script is loading.",
		Duration = 10
	})
	loadstring(Link)()
end
