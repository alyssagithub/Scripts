local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.6"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify
local GetClosestChild: (Children: {PVInstance}, Callback: (Child: PVInstance) -> boolean) -> (PVInstance?) = getgenv().GetClosestChild

local Remotes: Folder & {[string]: RemoteEvent & RemoteFunction} = game:GetService("ReplicatedStorage").Remotes

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local Tab: Tab = Window:CreateTab("Combat", "swords")

Tab:CreateSection("Attacking")

Tab:CreateToggle({
	Name = "⚔ • Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)	
		while Flags.KillAura.CurrentValue and task.wait() do
			local Closest = GetClosestChild(workspace.Characters:GetChildren(), function(Child)
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

Tab:CreateToggle({
	Name = "🔥 • Breath Aura (Needs Breath On)",
	CurrentValue = false,
	Flag = "BreathAura",
	Callback = function(Value)	
		while Flags.BreathAura.CurrentValue and task.wait() do
			local Closest = GetClosestChild(workspace.Characters:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end)

			if not Closest then
				continue
			end

			Remotes.CharactersDamageRemoteBreath:FireServer({Closest})
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
			local Closest = GetClosestChild(workspace.Interactions.Food:GetChildren(), function(Child: PVInstance)
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
			local Closest = GetClosestChild(workspace.Interactions.Lakes:GetChildren(), function(Child)
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
			local Closest = GetClosestChild(workspace.Interactions.Mud:GetChildren())

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

local function GetResourcesTable()
	local DroppedResources = {}

	for _, Resource: PVInstance in workspace.Interactions.DroppedResources:GetChildren() do
		table.insert(DroppedResources, Resource.Name)
	end
	
	return DroppedResources
end

local ResourcesDropdown
ResourcesDropdown = Tab:CreateDropdown({
	Name = "💎 • Quick Pick Up Resources",
	Options = GetResourcesTable(),
	CurrentOption = "",
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
		ResourcesDropdown:Set({""})
	end,
})

Tab:CreateButton({
	Name = "🔃 • Refresh Dropdown",
	Callback = function()
		ResourcesDropdown:Refresh(GetResourcesTable())
	end,
})

local Tab: Tab = Window:CreateTab("Transport", "wind")

Tab:CreateSection("Teleportation")

Tab:CreateButton({
	Name = "🥚 • Teleport to Abandoned Egg",
	Callback = function()
		local Teleported = false
		
		local Character = Player.Character
		
		if not Character then
			return Notify("Error", "You do not have a character, please spawn in first.")
		end
		
		for _, Egg: Model in workspace.Interactions.AbandonedEggs:GetChildren() do
			if not Egg:GetChildren()[1] then
				continue
			end
			
			Character:PivotTo(Egg:GetPivot())
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
		
		local Tablet: MeshPart = workspace.Interactions["Warden Shrines"]:FindFirstChild(CurrentOption, true)
		
		if not Tablet then
			return Notify("Error", "Couldn't find the tablet for the selected Warden Shrine.")
		end

		Player.Character:PivotTo(Tablet:GetPivot() + Tablet:GetPivot().LookVector * 5)
		TeleportWardenShrine:Set({""})
	end,
})

local Tab: Tab = Window:CreateTab("Safety", "shield")

Tab:CreateSection("Damage")

Tab:CreateToggle({
	Name = "🌋 • Delete All Lava Pools",
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
local Toggle
Toggle = Tab:CreateToggle({
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
		
		while Suicide and task.wait() and Player.Character do
			Remotes.LavaSelfDamage:FireServer()
		end
		
		if Suicide then
			Toggle:Set(false)
			Notify("Suicide Disabled", "Detected your death, disabled suicide.")
		end
	end,
})

getgenv().CreateUniversalTabs()
