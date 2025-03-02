local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.0"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local Tab: Tab = Window:CreateTab("Name", "repeat")

local GetClosestChild: (Children: {PVInstance}, Callback: ((Child: PVInstance) -> boolean)?, MaxDistance: number?) -> (PVInstance?) = getgenv().GetClosestChild

local Mouse = Player:GetMouse()

local firesignal: (RBXScriptSignal, any?) -> () = getfenv().firesignal

Tab:CreateToggle({
	Name = "⚔ • Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)
		while Flags.KillAura.CurrentValue and task.wait() do
			local ClosestMob = GetClosestChild(workspace.Alive:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end, Flags.Distance.CurrentValue)
			
			if not ClosestMob then
				continue
			end
			
			firesignal(Mouse.Button1Down)
			firesignal(Mouse.Button1Up)
		end
	end,
})

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

Tab:CreateSlider({
	Name = "📏 • Max Distance",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 20,
	Flag = "Distance",
	Callback = function()end,
})

local Interact: RemoteEvent = game:GetService("Players").LocalPlayer.Character.CharacterHandler.Input.Events.Interact

Tab:CreateToggle({
	Name = "🪓 • Auto Chop Closest Tree",
	CurrentValue = false,
	Flag = "Chop",
	Callback = function(Value)
		while Flags.Chop.CurrentValue and task.wait() do
			local ClosestTree = GetClosestChild(workspace.Harvestable:GetChildren(), function(Child)
				if Child == Player.Character then
					return true
				end
			end, 20)

			if not ClosestTree then
				continue
			end
			
			Interact:FireServer({
				player = Player,
				Object = ClosestTree,
				Action = "Chop"
			})
		end
	end,
})

local Success, Network = pcall(require, game:GetService("ReplicatedStorage").Modules.Network)

Tab:CreateToggle({
	Name = "🍎 • Auto Gather (No Tools Required)",
	CurrentValue = false,
	Flag = "Gather",
	Callback = function(Value)
		while Flags.Gather.CurrentValue and task.wait() do
			local Closest = GetClosestChild(workspace.Harvestable:GetChildren(), function(Child)
				if Child == Player.Character then
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
			task.wait(0.1)
		end
	end,
})

local UserInputService = game:GetService("UserInputService")

local SprintConnection: RBXScriptConnection

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection

local KeyCodes = {
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D
}

Tab:CreateToggle({
	Name = ApplyUnsupportedName("💨 • Auto Sprint", Success),
	CurrentValue = false,
	Flag = "Sprint",
	Callback = function(Value)
		if not Success then
			return
		end
		
		if Value then
			SprintConnection = UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
				if GameProcessedEvent then
					return
				end

				if not table.find(KeyCodes, Input.KeyCode) then
					return
				end
				
				if not Flags.Sprint.CurrentValue then
					return SprintConnection:Disconnect()
				end

				Network.connect("Sprint", "Fire", Player.Character, true)
			end)
			
			HandleConnection(SprintConnection, "SprintConnection")
		elseif SprintConnection then
			SprintConnection:Disconnect()
		end
	end,
})

local hookfunction: (FunctionToHook: () -> (), Hook: () -> ()) -> (() -> ()) = getfenv().hookfunction

local Original

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🩸 • Remove Fall Damage", Success and hookfunction),
	CurrentValue = false,
	Flag = "FallDamage",
	Callback = function(Value)
		if not Success or not hookfunction then
			return
		end

		if Value then
			Original = hookfunction(Network.connect, function(RemoteName, Method, Character, Settings, ...)
				if Settings and typeof(Settings) == "table" and Settings.Config == "FallDamage" then
					return
				end

				return Original(RemoteName, Method, Character, Settings, ...)
			end)
		elseif Original then
			Network.connect = Original
		end
	end,
})

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
					table.insert(FogObjects, v:Clone())
					v:Destroy()
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
