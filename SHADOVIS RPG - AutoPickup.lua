getgenv().AutoPickup = truee

local Blacklist = {"ItemName", "ItemName", "ItemName"} -- Replace ItemName with the item's name that you don't want to pick up, to add more slots create a new string and seperate with a comma

while AutoPickup and task.wait() do
	if #workspace.Projectiles:GetChildren() > 0 then
		for i,v in pairs(workspace.Projectiles:GetDescendants()) do
			if v:IsA("ProximityPrompt") and not table.find(Blacklist, v.Parent.Name) then
				fireproximityprompt(v)
			end
		end
	end
end
