local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v0.0.0"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local GetClosestChild: (Children: {PVInstance}, Callback: ((Child: PVInstance) -> boolean)?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName

local Success, Network = pcall(require, game:GetService("ReplicatedStorage").Modules.Network)

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local Tab: Tab = Window:CreateTab("Combat", "swords")

Tab:CreateSection("Attacking")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("⚔ • Kill Aura", Success),
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)
		if not Success then
			return
		end
		
		while Flags.KillAura.CurrentValue and task.wait() do
			local ClosestMob = GetClosestChild(workspace.Alive:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end, Flags.Distance.CurrentValue)
			
			if not ClosestMob then
				continue
			end
			
			Network.connect("MouseInput", "Fire", Player.Character, {
				["Config"] = "Button1Down"
			})
			Network.connect("MouseInput", "Fire", Player.Character, {
				["Config"] = "Button1Up"
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
			
			local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
			
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
		
		Player.Character.Humanoid.AutoRotate = true
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
			end, 20)

			if not Closest then
				continue
			end
			
			Network.connect("Interact", "FireServer", Player.Character, {
				player = Player,
				Object = Closest,
				Action = "Gather"
			})
		end
	end,
})

Tab:CreateSection("Selling")

Tab:CreateToggle({
	Name = ApplyUnsupportedName("💰 • Auto Sell All Unequipped Items", Success),
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
				
				if Tool:GetAttribute("Equipped") then
					continue
				end
				
				if not Tool:GetAttribute("Rarity") then
					continue
				end
				
				Network.connect("SellEvent", "FireServer", Player.Character, Tool)
			end
		end
	end,
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
			
			Network.connect("Sprint", "Fire", Player.Character, true)
		end
	end,
})

local Tab: Tab = Window:CreateTab("Safety", "shield")

Tab:CreateSection("Falling")

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
