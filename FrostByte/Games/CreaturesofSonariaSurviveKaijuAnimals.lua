local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.0"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Remotes: Folder & {[string]: RemoteEvent & RemoteFunction} = game:GetService("ReplicatedStorage").Remotes

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local Tab: Tab = Window:CreateTab("Combat", "swords")

Tab:CreateSection("Attacking")

local function GetClosestChildCallback(Children: {PVInstance}, Callback: (Child: PVInstance) -> (boolean))
	for i, Child in Children do
		if Callback and not Callback(Child) then
			continue
		end
		
		table.remove(Children, i)
	end
	
	local Character = Player.Character
	
	if not Character then
		return
	end
	
	local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")
	
	if not HumanoidRootPart then
		return
	end
	
	local CurrentPosition: Vector3 = HumanoidRootPart.Position

	table.sort(Children, function(a: Model, b: Model)
		return (a:GetPivot().Position - CurrentPosition).Magnitude < (b:GetPivot().Position - CurrentPosition).Magnitude
	end)

	local Closest = Children[1]
	
	return Closest
end

Tab:CreateToggle({
	Name = "⚔ • Killaura",
	CurrentValue = false,
	Flag = "Killaura",
	Callback = function(Value)	
		while Flags.Killaura.CurrentValue and task.wait() do
			local Closest = GetClosestChildCallback(workspace.Characters:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end)
			
			if not Closest then
				continue
			end
			
			Remotes.CharactersDamageRemote:FireServer({Closest})
		end
	end,
})

local Tab: Tab = Window:CreateTab("Consumption", "apple")

Tab:CreateSection("Food/Drinks")

Tab:CreateToggle({
	Name = "🍴 • Auto Eat Closest Food",
	CurrentValue = false,
	Flag = "Eat",
	Callback = function(Value)	
		while Flags.Eat.CurrentValue and task.wait() do
			local Closest = GetClosestChildCallback(workspace.Interactions.Food:GetChildren(), function(Child: PVInstance)
				if not Child:GetChildren()[1] then
					return true
				end

				local Value = Child:GetAttribute("Value")

				if not Value or Value <= 0 then
					return true
				end
			end)
			
			if not Closest then
				continue
			end
			
			Remotes.Food:FireServer(Closest)
		end
	end,
})

Tab:CreateToggle({
	Name =  "💧 • Auto Drink on Closest Lake",
	CurrentValue = false,
	Flag = "Drink",
	Callback = function(Value)	
		while Flags.Drink.CurrentValue and task.wait() do
			local Closest = GetClosestChildCallback(workspace.Interactions.Lakes:GetChildren(), function(Child)
				if Child:GetAttribute("Sickly") then
					return true
				end
			end)

			if not Closest then
				continue
			end
			
			Remotes.DrinkRemote:FireServer(Closest)
		end
	end,
})

Tab:CreateSection("Ailments")

Tab:CreateToggle({
	Name = "💨 • Auto Use Closest Mud Pile",
	CurrentValue = false,
	Flag = "Mud",
	Callback = function(Value)	
		while Flags.Mud.CurrentValue and task.wait() do
			local Closest = GetClosestChildCallback(workspace.Interactions.Mud:GetChildren())

			if not Closest then
				continue
			end

			Remotes.Mud:FireServer(Closest)
			task.wait(1)
		end
	end,
})

Tab:CreateSection("Items")

Tab:CreateToggle({
	Name = "💊 • Auto Collect Spawned Tokens",
	CurrentValue = false,
	Flag = "Tokens",
	Callback = function(Value)	
		while Flags.Tokens.CurrentValue and task.wait() do
			local Token: MeshPart? = workspace.Interactions.SpawnedTokens:GetChildren()[1]

			if not Token then
				continue
			end

			if Remotes.GetSpawnedTokenRemote:InvokeServer() then
				Token:Destroy()
			end
		end
	end,
})

local DroppedResources = {}

for _, Resource: PVInstance in workspace.Interactions.DroppedResources:GetChildren() do
	table.insert(DroppedResources, Resource.Name)
end

local Resources = Tab:CreateDropdown({
	Name = "💎 • Quick Pick Up Resources",
	Options = DroppedResources,
	MultipleOptions = false,
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "" then
			return
		end
		
		local Resource = workspace.Interactions.DroppedResources:FindFirstChild(CurrentOption)
		
		if not Resource then
			return
		end
		
		Remotes.PickupResource:FireServer(Resource)
	end,
})

HandleConnection(workspace.Interactions.DroppedResources.ChildAdded:Connect(function(Child: PVInstance)
	table.insert(DroppedResources, Child.Name)
	Resources:Refresh(DroppedResources)
end), "ResourceAdded")

HandleConnection(workspace.Interactions.DroppedResources.ChildRemoved:Connect(function(Child: PVInstance)
	local Index = table.find(DroppedResources, Child.Name)
	
	if not Index then
		return
	end
	
	table.remove(DroppedResources, Index)
	Resources:Refresh(DroppedResources)
end), "ResourceRemoved")

local Tab: Tab = Window:CreateTab("Transport", "wind")

Tab:CreateSection("Teleportation")

Tab:CreateButton({
	Name = "🥚 • Teleport to Abandoned Egg",
	Callback = function()
		local Teleported = false
		
		for _, Egg: Model in workspace.Interactions.AbandonedEggs:GetChildren() do
			if not Egg:GetChildren()[1] then
				continue
			end
			
			Player.Character:PivotTo(Egg:GetPivot())
			Teleported = true
			break
		end
		
		if not Teleported then
			Notify("Failed", "Couldn't find an Abandoned Egg")
		end
	end,
})

local WardenShrines = {}

for _, Shrine: Folder in workspace.Interactions["Warden Shrines"]:GetChildren() do
	for _, Tablet: MeshPart in Shrine:GetChildren() do
		table.insert(WardenShrines, Tablet.Name)
	end
end

local TeleportWardenShrine
TeleportWardenShrine = Tab:CreateDropdown({
	Name = "⛩ • Teleport to Warden Shrine",
	Options = WardenShrines,
	CurrentOption = "",
	MultipleOptions = false,
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "" then
			return
		end
		
		if not CurrentOption then
			return
		end
		
		local Tablet: MeshPart = workspace.Interactions["Warden Shrines"]:FindFirstChild(CurrentOption, true)
		
		if not Tablet then
			return Notify("Error", "Couldn't find the tablet for the selected Warden Shrine.")
		end

		Player.Character:PivotTo(Tablet:GetPivot() + Tablet:GetPivot().LookVector * 5)
		TeleportWardenShrine:Set("")
	end,
})

local Tab: Tab = Window:CreateTab("Safety", "shield")

Tab:CreateSection("Shelter")

Tab:CreateButton({
	Name = "🧱 • Quick Fake Shelter",
	Callback = function()
		Remotes.Sheltered:FireServer(true)
	end,
})

Tab:CreateSection("Damage")

Tab:CreateToggle({
	Name = "🔥 • Delete All Lava Pools",
	CurrentValue = false,
	Flag = "DeleteLava",
	Callback = function(Value)	
		if not Value then
			return
		end
		
		workspace.Interactions.LavaPools:ClearAllChildren()
	end,
})

Tab:CreateSection("Location")

Tab:CreateToggle({
	Name = "🛡 • Auto Hide Scent",
	CurrentValue = false,
	Flag = "Scent",
	Callback = function(Value)
		while Flags.Scent.CurrentValue and task.wait() do
			Remotes.HideScent:FireServer()
			
			task.wait(5)
		end
	end,
})

local Tab: Tab = Window:CreateTab("Reset", "rotate-ccw")

Tab:CreateSection("Suicide")

local Suicide = false

Tab:CreateToggle({
	Name = "🩸 • Suicide (KILLS YOUR CREATURE)",
	CurrentValue = false,
	Callback = function(Value)
		Suicide = Value
		
		if Value then
			for i = 5, 1, -1 do
				if not Suicide then
					Notify("Cancel", "Canceled the suicide.")
					break
				end
				
				Notify("Suicide", `Killing your creature in {i} second(s), disable to cancel.`)
				task.wait(1)
			end
		end
		
		while Suicide and task.wait() do
			Remotes.LavaSelfDamage:FireServer()
		end
	end,
})

getgenv().CreateUniversalTabs()
