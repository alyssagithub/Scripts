-- This script is in development.
-- So far, all this script will do is detect a new item and open up the item's page, could still be useful for quick buying and/or macro buying.

game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Notification.Container.Title:GetPropertyChangedSignal("Text"):Connect(function()
	if game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Notification.Container.Title.Text == "New Item for Sale" then
		game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Notification.Container.Title.Text = ""
		for i,v in next, getconnections(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Notification.Container.Button.MouseButton1Click) do
			v:Fire()
			-- insert item buyer script here
		end
	end
end)
