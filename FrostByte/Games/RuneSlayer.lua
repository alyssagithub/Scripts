local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v0.0.2"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local GetClosestChild: (Children: {PVInstance}, Callback: ((Child: PVInstance) -> boolean)?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Success, Network = pcall(require, game:GetService("ReplicatedStorage").Modules.Network)

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local function GetChildInCharacter(ChildName: string)
	local Character = Player.Character
	
	if not Character then
		return
	end
	
	local Child = Character:FindFirstChild(ChildName)
	
	return Child
end

local Tab: Tab = Window:CreateTab("Combat", "swords")

Tab:CreateSection("Attacking")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("⚔ • Auto Attack", Success),
	CurrentValue = false,
	Flag = "Attack",
	Callback = function(Value)
		if not Success then
			return
		end
		
		while Flags.Attack.CurrentValue and task.wait() do
			local ClosestMob = GetClosestChild(workspace.Alive:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end, Flags.Distance.CurrentValue)
			
			if not ClosestMob then
				continue
			end
			
			Network.connect("MouseInput", "Fire", Player.Character, {
				Config = "Button1Down"
			})
			Network.connect("MouseInput", "Fire", Player.Character, {
				Config = "Button1Up"
			})
		end
	end,
})

Tab:CreateSection("Aiming")

Tab:CreateToggle({
	Name = "🎯 • Look At Closest Enemy",
	CurrentValue = false,
	Flag = "LookAt",
	Callback = function(Value)
		while Flags.LookAt.CurrentValue and task.wait() do
			local ClosestMob = GetClosestChild(workspace.Alive:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end, Flags.Distance.CurrentValue)
			
			local Character = Player.Character
			
			if not Character then
				continue
			end
			
			local Humanoid: Humanoid = GetChildInCharacter("Humanoid")
			
			if not Humanoid then
				continue
			end

			if not ClosestMob then
				Humanoid.AutoRotate = true
				continue
			end
			
			local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")
			
			if not HumanoidRootPart then
				continue
			end
			
			Humanoid.AutoRotate = false

			local Position = HumanoidRootPart.Position
			local ClosestPosition = ClosestMob:GetPivot().Position

			HumanoidRootPart.CFrame = CFrame.lookAt(Position, Vector3.new(ClosestPosition.X, Position.Y, ClosestPosition.Z))
		end
		
		local Humanoid: Humanoid = GetChildInCharacter("Humanoid")
		
		if Humanoid then
			Humanoid.AutoRotate = true
		end
	end,
})

Tab:CreateSection("Configuration")

Tab:CreateSlider({
	Name = "📏 • Max Distance",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 20,
	Flag = "Distance",
	Callback = function()end,
})

local Tab: Tab = Window:CreateTab("Resources", "apple")

Tab:CreateSection("Gathering")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🍎 • Auto Gather (No Tools Required)", Success),
	CurrentValue = false,
	Flag = "Gather",
	Callback = function(Value)
		if not Success then
			return
		end
		
		while Flags.Gather.CurrentValue and task.wait(0.1) do
			local Closest = GetClosestChild(workspace.Harvestable:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
				
				if Child:GetAttribute("SetRespawn") then
					return true
				end
			end)

			if not Closest then
				continue
			end
			
			local Interact: RemoteEvent = Player.Character.CharacterHandler.Input.Events.Interact
			
			Interact:FireServer({
				player = Player,
				Object = Closest,
				Action = "Gather"
			})
		end
	end,
})

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🥚 • Auto Pick Up Items", Success),
	CurrentValue = false,
	Flag = "PickUp",
	Callback = function(Value)
		if not Success then
			return
		end

		while Flags.PickUp.CurrentValue and task.wait(0.1) do
			for _, Item: Model? in workspace.Effects:GetChildren() do
				if not Item:FindFirstChild("InteractPrompt") then
					continue
				end
				
				local Interact: RemoteEvent = Player.Character.CharacterHandler.Input.Events.Interact
				
				Interact:FireServer({
					player = Player,
					Object = Item,
					Action = "Pick Up"
				})
			end
		end
	end,
})

Tab:CreateSection("Selling")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("💰 • Auto Sell Unequipped Items", Success),
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)
		if not Success then
			return
		end
		
		while Flags.Sell.CurrentValue and task.wait(0.1) do
			for _, Tool in Player.Backpack:GetChildren() do
				if not Tool:IsA("Tool") then
					continue
				end
				
				if table.find(Flags.Blacklist.CurrentOption, Tool.Name) then
					continue
				end
				
				if Tool:GetAttribute("Equipped") then
					continue
				end
				
				if not Tool:GetAttribute("Rarity") then
					continue
				end
				
				local SellEvent: RemoteEvent = Player.Character.CharacterHandler.Input.Events.SellEvent
				
				SellEvent:FireServer(Tool)
			end
		end
	end,
})

local Items = {}

for _, Tool: Tool in game:GetService("ReplicatedStorage").Storage.Tools:GetChildren() do
	if not Tool:FindFirstChild("SellValue") then
		continue
	end

	table.insert(Items, Tool.Name)
end

table.sort(Items)

Tab:CreateDropdown({
	Name = "📃 • Sell Blacklist",
	Options = Items,
	MultipleOptions = true,
	Flag = "Blacklist",
	Callback = function()end,
})

Tab:CreateSection("Crafting")

local Dropdown
Dropdown = Tab:CreateDropdown({
	Name = "🛠 • Craft Item",
	Options = Items,
	CurrentOption = "",
	MultipleOptions = false,
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]
		
		if CurrentOption == "" then
			return
		end
		
		Player.PlayerGui.CraftingGui.LocalScript.RemoteEvent:FireServer({
			AmountToCraft = Flags.Quantity.CurrentValue,
			SelectedItem = {
				ToolTip = "",
				Station = "Buy",
				Name = CurrentOption
			}
		})

		Dropdown:Set({""})
	end,
})

Tab:CreateSlider({
	Name = "🔢 • Quantity",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Items",
	CurrentValue = 1,
	Flag = "Quantity",
	Callback = function()end,
})

local Tab: Tab = Window:CreateTab("Movement", "keyboard")

Tab:CreateSection("Sprinting")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("⚡ • Auto Sprint", Success),
	CurrentValue = false,
	Flag = "Sprint",
	Callback = function(Value)
		if not Success then
			return
		end
		
		while Flags.Sprint.CurrentValue and task.wait() do
			local Character = Player.Character
			
			if not Character then
				continue
			end
			
			local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
			
			if not Humanoid then
				continue
			end
			
			if Humanoid.MoveDirection.Magnitude == Vector3.zero then
				continue
			end
			
			Network.connect("Sprint", "Fire", Character, true)
		end
	end,
})

local Tab: Tab = Window:CreateTab("Safety", "shield")

Tab:CreateSection("Damage")

local Original

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🩸 • Remove Fall Damage", Success),
	CurrentValue = false,
	Flag = "FallDamage",
	Callback = function(Value)
		if not Success then
			return
		end

		if Value then
			Original = Network.connect
			Network.connect = function(RemoteName, Method, Character, Settings, ...)
				if Settings and typeof(Settings) == "table" and Settings.Config == "FallDamage" then
					return
				end

				return Original(RemoteName, Method, Character, Settings, ...)
			end
		elseif Original then
			Network.connect = Original
		end
	end,
})

local LavaParts = {}

Tab:CreateToggle({
	Name = "🌋 • Remove Lava",
	CurrentValue = false,
	Flag = "Lava",
	Callback = function(Value)
		if Value then
			for _, Part: Part in workspace:GetDescendants() do
				if Part.Name ~= "lava" then
					continue
				end
				
				LavaParts[Part] = Part.Parent
				Part.Parent = nil
			end
		else
			for Part: Part, Parent: Part in LavaParts do
				Part.Parent = Parent
			end
			
			LavaParts = {}
		end
	end,
})

Tab:CreateSection("Regeneration")

Tab:CreateButton({
	Name = ApplyUnsupportedName("💤 • Quick Sleep Anywhere (Heal)", Success),
	Callback = function()
		if not Success then
			return
		end
		
		local Bed = workspace.Map:FindFirstChild("Bed")
		
		if not Bed then
			return Notify("Error", "Could not find a bed to sleep in.")
		end
		
		local Interact: RemoteEvent = Player.Character.CharacterHandler.Input.Events.Interact
		
		Interact:FireServer({
			player = Player,
			Object = Bed,
			Action = "Sleep"
		})
	end,
})

local Tab: Tab = Window:CreateTab("Effects", "sparkles")

Tab:CreateSection("Fog")

local Lighting = game:GetService("Lighting")

local FogEnd
local FogObjects = {}

Tab:CreateToggle({
	Name = "🌫 • Remove Fog",
	CurrentValue = false,
	Flag = "Fog",
	Callback = function(Value)
		if Value then
			FogEnd = Lighting.FogEnd
			
			Lighting.FogEnd = 100000
			
			for _,v in Lighting:GetDescendants() do
				if v:IsA("Atmosphere") then
					table.insert(FogObjects, v)
					v.Parent = nil
				end
			end
		elseif FogEnd then
			Lighting.FogEnd = FogEnd
			
			for _,v in FogObjects do
				v.Parent = Lighting
			end
			
			FogObjects = {}
		end
	end,
})

getgenv().CreateUniversalTabs()
