local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v0.0.3"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local GetClosestChild: (Children: {PVInstance}, Callback: ((Child: PVInstance) -> boolean)?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Success, Network = pcall(require, game:GetService("ReplicatedStorage").Modules.Network)

local TweenService = game:GetService("TweenService")

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

local function GetInputRemote(RemoteName: string): RemoteEvent
	local Character = Player.Character

	if not Character then
		return
	end

	local CharacterHandler: LocalScript = Character:FindFirstChild("CharacterHandler")

	if not CharacterHandler then
		return
	end

	local Input: Folder = CharacterHandler:FindFirstChild("Input")

	if not Input then
		return
	end

	local Events: Folder = Input:FindFirstChild("Events")

	if not Events then
		return
	end

	return Events:FindFirstChild(RemoteName)
end

local function TeleportLocalCharacter(NewLocation: CFrame)
	local Character = Player.Character

	if not Character then
		return
	end

	local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")

	if not Humanoid then
		return
	end

	Humanoid.Health = 0

	Player.CharacterAdded:Once(function(NewCharacter)
		task.wait(1.5)

		NewCharacter:PivotTo(NewLocation)
	end)
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

Tab:CreateSection("Tweening")

local MobTween: Tween

Tab:CreateToggle({
	Name = "🦌 • Tween to Mobs",
	CurrentValue = false,
	Flag = "TweenMobs",
	Callback = function(Value)
		if not Value and MobTween then
			MobTween:Cancel()
			MobTween = nil
		end

		while Flags.TweenMobs.CurrentValue and task.wait() do
			local Closest = GetClosestChild(workspace.Alive:GetChildren(), function(Child)
				local Species = Child:FindFirstChild("Species")
				
				if not Species then
					return true
				end
				
				if not table.find(Flags.Mobs.CurrentOption, Species.Value) then
					return true
				end
			end)

			if not Closest then
				Notify("Failed", "Couldn't find anything, try getting closer to it so it can load.")
				task.wait(5)
				continue
			end

			local HumanoidRootPart: Part = Player.Character.HumanoidRootPart

			local GoTo = CFrame.new(Closest:GetPivot().Position)

			local Distance = (HumanoidRootPart.Position - GoTo.Position).Magnitude

			if Distance <= 5 then
				continue
			end

			MobTween = TweenService:Create(HumanoidRootPart, TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear), {CFrame = GoTo})
			MobTween:Play()
			MobTween.Completed:Wait()
			MobTween = nil
		end
	end,
})

local Mobs = {}

for _, Object: Model in game:GetService("ReplicatedStorage").Storage.Mobs:GetChildren() do
	table.insert(Mobs, Object.Name)
end

table.sort(Mobs)

Tab:CreateDropdown({
	Name = "🐔 • Mobs",
	Options = Mobs,
	MultipleOptions = true,
	Flag = "Mobs",
	Callback = function()end,
})

local Tab: Tab = Window:CreateTab("Resources", "apple")

Tab:CreateSection("Gathering")

Tab:CreateToggle({
	Name = "🍎 • Auto Gather (No Tools Required)",
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

			local Interact = GetInputRemote("Interact")

			if not Interact then
				continue
			end

			Interact:FireServer({
				player = Player,
				Object = Closest,
				Action = "Gather"
			})
		end
	end,
})

Tab:CreateToggle({
	Name = "🥚 • Auto Pick Up Items",
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

				local Interact = GetInputRemote("Interact")

				if not Interact then
					continue
				end

				Interact:FireServer({
					player = Player,
					Object = Item,
					Action = "Pick Up"
				})
			end
		end
	end,
})

Tab:CreateSection("Tweening")

local ResourceTween: Tween

Tab:CreateToggle({
	Name = "⛏ • Tween to Resources",
	CurrentValue = false,
	Flag = "TweenResources",
	Callback = function(Value)
		if not Value and ResourceTween then
			ResourceTween:Cancel()
			ResourceTween = nil
		end

		while Flags.TweenResources.CurrentValue and task.wait() do
			local Closest = GetClosestChild(workspace.Harvestable:GetChildren(), function(Child)
				if not table.find(Flags.Resources.CurrentOption, Child.Name) then
					return true
				end

				if Child:GetAttribute("SetRespawn") then
					return true
				end
			end)

			if not Closest then
				Notify("Failed", "Couldn't find anything, try getting closer to it so it can load.")
				task.wait(5)
				continue
			end

			local HumanoidRootPart: Part = Player.Character.HumanoidRootPart

			local GoTo = CFrame.new(Closest:GetPivot().Position + Vector3.one * 5)

			local Distance = (HumanoidRootPart.Position - GoTo.Position).Magnitude

			if Distance <= 5 then
				continue
			end

			ResourceTween = TweenService:Create(HumanoidRootPart, TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear), {CFrame = GoTo})
			ResourceTween:Play()
			ResourceTween.Completed:Wait()
			ResourceTween = nil
		end
	end,
})

local Resources = {}

for _, Object: PVInstance in workspace.Harvestable:GetChildren() do
	if table.find(Resources, Object.Name) then
		continue
	end

	table.insert(Resources, Object.Name)
end

table.sort(Resources)

Tab:CreateDropdown({
	Name = "💎 • Resources",
	Options = Resources,
	MultipleOptions = true,
	Flag = "Resources",
	Callback = function()end,
})

Tab:CreateSection("Selling")

Tab:CreateToggle({
	Name = "💰 • Auto Sell Resources",
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)
		if not Success then
			return
		end

		while Flags.Sell.CurrentValue and task.wait() do
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

				local SellEvent = GetInputRemote("SellEvent")

				if not SellEvent then
					continue
				end

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

Tab:CreateSection("Teleporting")

local WorldAreas = game:GetService("ReplicatedStorage").WorldModel.Areas

local Areas = {}

for _, Object: Part in WorldAreas:GetChildren() do
	if table.find(Areas, Object.Name) then
		continue
	end
	
	table.insert(Areas, Object.Name)
end

local Dropdown
Dropdown = Tab:CreateDropdown({
	Name = "🌄 • Suicide Teleport to Area",
	Options = Areas,
	CurrentOption = "",
	MultipleOptions = false,
	Callback = function(CurrentOption)
		local Success = pcall(function()
			CurrentOption = CurrentOption[1]

			if CurrentOption == "" then
				return
			end

			local SelectedArea: Part = WorldAreas[CurrentOption]

			local Result = workspace:Raycast(SelectedArea.Position, Vector3.yAxis * -10000)

			if not Result then
				return Notify("Failed", "Failed to raycast in this area.")
			end

			local GoTo = CFrame.new(Result.Position)

			TeleportLocalCharacter(GoTo)

			Dropdown:Set({""})
		end)
		
		if not Success then
			return Notify("Error", "Failed to teleport.")
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

Tab:CreateSection("Healing")

Tab:CreateButton({
	Name = "💤 • Quick Sleep Anywhere (Heal)",
	Callback = function()
		if not Success then
			return
		end

		local Bed = workspace.Map:FindFirstChild("Bed", true)

		if not Bed then
			return Notify("Error", "Could not find a bed to sleep in.")
		end

		local Interact = GetInputRemote("Interact")

		if not Interact then
			return
		end

		Interact:FireServer({
			player = Player,
			Object = Bed,
			Action = "Sleep"
		})
	end,
})

Tab:CreateButton({
	Name = "💔 • Suicide Heal",
	Callback = function()
		local Character = Player.Character
		
		if not Character then
			return
		end
		
		local PreviousLocation = Character:GetPivot()
		
		TeleportLocalCharacter(PreviousLocation)
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
