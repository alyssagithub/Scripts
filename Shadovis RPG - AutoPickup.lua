getgenv().AutoPickup = true

while AutoPickup and task.wait() do
	if #workspace.Projectiles:GetChildren() > 0 then
		for i,v in pairs(workspace.Projectiles:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				fireproximityprompt(v)
			end
		end
	end
end
