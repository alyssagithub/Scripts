local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.7"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector
local hookmetamethod: (Object: Object, Metamethod: string, NewFunction: (Object?, any) -> (any)) -> ((any) -> (any)) = getfenv().hookmetamethod
local getnamecallmethod: () -> (string) = getfenv().getnamecallmethod
local checkcaller: () -> (boolean) = getfenv().checkcaller

local UnsupportedName: string = getgenv().UnsupportedName
local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Rayfield = getgenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes: {[string]: RemoteEvent & RemoteFunction} = ReplicatedStorage:WaitForChild("Universe"):WaitForChild("Network"):WaitForChild("Remotes")

local Window = getgenv().Window

local Tab = Window:CreateTab("Automatics", "repeat")

Tab:CreateSection("Mobs")

Tab:CreateToggle({
	Name = "⚔ • Auto Attack Mobs",
	CurrentValue = false,
	Flag = "Attack",
	Callback = function(Value)	
		while Flags.Attack.CurrentValue and task.wait(0.1) do
			for _, Mob in workspace.World.Mobs:GetChildren() do
				Remotes.DamageFire:FireServer(Mob)
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "🔥 • Auto Use Abilities",
	CurrentValue = false,
	Flag = "Abilities",
	Callback = function(Value)	
		while Flags.Abilities.CurrentValue and task.wait() do
			for _, Ability: Frame in Player.PlayerGui.MainGui.Hotbar:GetChildren() do
				if not Ability:IsA("Frame") or not tonumber(Ability.Name) then
					continue
				end
				
				if not Ability.Visible or Ability.Cooldown.Visible then
					continue
				end
				
				local Image = Ability.Label.Image
				
				for _, Item: Frame in Player.PlayerGui.MainGui.Soul.Main.Items.Scroll:GetChildren() do
					if not Item:IsA("Frame") then
						continue
					end
					
					if Item.MainFrame.BackgroundFrame.Label.Image ~= Image then
						continue
					end
					
					Remotes.PlayerRequestAbility:FireServer(tonumber(Item.Name), {
						["mouseTarget"] = Vector3.new(-598.558349609375, 0.3105278015136719, 348.0400085449219),
						["mouseTargetUsingRange"] = Vector3.new(-598.558349609375, 0.3105278015136719, 348.0400085449219)
					})
					
					print("using ability:", Item.Name)
					
					break
				end
				
				task.wait(Flags.AbilityTime.CurrentValue)
			end
		end
	end,
})

Tab:CreateSlider({
	Name = "🔢 • Time Between Ability Use",
	Range = {0, 5},
	Increment = 0.01,
	Suffix = "",
	CurrentValue = 0,
	Flag = "AbilityTime",
	Callback = function()end,
})

Tab:CreateDivider()

local LastTPLocation

Tab:CreateToggle({
	Name = "🌀 • Teleport to Mobs",
	CurrentValue = false,
	Flag = "Teleport",
	Callback = function(Value)
		while Flags.Teleport.CurrentValue and task.wait() do
			if not workspace.DungeonDirectory:GetChildren()[1] then
				continue
			end
			
			local DidTP = false

			for _, Mob: Model? in workspace.World.Mobs:GetChildren() do
				local Head: Part = Mob:FindFirstChild("Head")
				local MobHumanoidRootPart: Part = Mob:FindFirstChild("HumanoidRootPart")
				
				if not Head or not MobHumanoidRootPart then
					continue
				end
				
				if Head.Transparency == 1 or not MobHumanoidRootPart.Hitbox.Health.Enabled then
					continue
				end
				
				local HumanoidRootPart: Part = Player.Character:FindFirstChild("HumanoidRootPart")
				
				if not HumanoidRootPart then
					continue
				end

				local BodyGyro = HumanoidRootPart:FindFirstChild("BodyGyro")

				if BodyGyro then
					BodyGyro:Destroy()
				end
				
				DidTP = true
				LastTPLocation = MobHumanoidRootPart.CFrame + Vector3.new(Flags.OffsetX.CurrentValue, Flags.OffsetY.CurrentValue, Flags.OffsetZ.CurrentValue)

				Player.Character:PivotTo(LastTPLocation)
				break
			end
			
			if not DidTP and LastTPLocation then
				Player.Character:PivotTo(LastTPLocation)
			end
		end
	end,
})

Tab:CreateSlider({
	Name = "🇽 • Teleport Offset X",
	Range = {-10, 10},
	Increment = 0.1,
	Suffix = "",
	CurrentValue = 0,
	Flag = "OffsetX",
	Callback = function()end,
})

Tab:CreateSlider({
	Name = "🇾 • Teleport Offset Y",
	Range = {-10, 10},
	Increment = 0.1,
	Suffix = "",
	CurrentValue = 0,
	Flag = "OffsetY",
	Callback = function()end,
})

Tab:CreateSlider({
	Name = "🇿 • Teleport Offset Z",
	Range = {-10, 10},
	Increment = 0.1,
	Suffix = "",
	CurrentValue = 0,
	Flag = "OffsetZ",
	Callback = function()end,
})

Tab:CreateSection("Upgrades")

Tab:CreateToggle({
	Name = "🔁 • Auto Spam Rebirth",
	CurrentValue = false,
	Flag = "Rebirth",
	Callback = function(Value)	
		while Flags.Rebirth.CurrentValue and task.wait() do
			local Contents = Player.PlayerGui.MainGui.Rebirth.Main.Contents
			if Contents.CurrentAbsorbedSpirits.Text == Contents.AbsorbedSpirits.Text then
				continue
			end
			
			Remotes.Rebirth:FireServer()
		end
	end,
})

Tab:CreateToggle({
	Name = "🔓 • Auto Unlock Upgrades",
	CurrentValue = false,
	Flag = "Upgrades",
	Callback = function(Value)	
		while Flags.Upgrades.CurrentValue and task.wait(1) do
			for _, Upgrade in Player.PlayerGui.MainGui.Upgrade.Main.Contents.Holder.MovementFrame.Upgrades:GetChildren() do
				if Upgrade.Upgrade.glow.Visible then
					continue
				end
				
				Remotes.UnlockUpgrade:FireServer(tonumber(Upgrade.Name))
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "📜 • Auto Claim Quests",
	CurrentValue = false,
	Flag = "Quests",
	Callback = function(Value)	
		while Flags.Quests.CurrentValue and task.wait(1) do
			for _, Quest: ImageButton? in Player.PlayerGui.MainGui.Quests.Main.Contents.Scroll:GetChildren() do
				if not Quest:IsA("ImageButton") then
					continue
				end
				
				if Quest.Progress.Info.Text ~= "COMPLETE" then
					continue
				end
				
				Remotes.ClaimQuest:FireServer(Quest.Name)
			end
		end
	end,
})

Tab:CreateToggle({
	Name = "📈 • Auto Distribute Stat Points",
	CurrentValue = false,
	Flag = "Distribute",
	Callback = function(Value)	
		while Flags.Distribute.CurrentValue and task.wait(1) do
			local Points = Player.PlayerGui.MainGui.Stats.Main.Available.Text:gsub("%D", "")
			Points = math.floor(tonumber(Points) / 3)
			
			if Points <= 0 then
				continue
			end
			
			local args = {
				[1] = Points,
				[2] = Points,
				[3] = Points
			}

			Remotes:WaitForChild("UpgradeStat"):FireServer(unpack(args))
		end
	end,
})

Tab:CreateSection("Items")

Tab:CreateToggle({
	Name = "🗝 • Auto Open Crate",
	CurrentValue = false,
	Flag = "OpenCrates",
	Callback = function(Value)	
		while Flags.OpenCrates.CurrentValue and task.wait() do
			Remotes.BuyCrate:InvokeServer(Flags.Crate.CurrentOption[1], 1, {})
		end
	end,
})

local Crates = {}

for _, Crate: Model in workspace.World.Crates:GetChildren() do
	table.insert(Crates, Crate.Name)
end

Tab:CreateDropdown({
	Name = "📦 • Crate to Open",
	Options = Crates,
	CurrentOption = "Town Crate I",
	MultipleOptions = false,
	Flag = "Crate",
	Callback = function()end,
})

Tab:CreateToggle({
	Name = "🔨 • Auto Craft Items",
	CurrentValue = false,
	Flag = "Craft",
	Callback = function(Value)	
		while Flags.Craft.CurrentValue and task.wait() do
			for _, Item: string in Flags.Items.CurrentOption do
				Remotes.RequestCraft:FireServer(Item)
			end
		end
	end,
})

local Items = {UnsupportedName}

pcall(function()
	for ItemName, _ in require(ReplicatedStorage.Universe.Items) do
		table.insert(Items, ItemName)
	end
	
	table.remove(Items, 1)

	table.sort(Items)
end)

Tab:CreateDropdown({
	Name = "🔎 • Items to Craft",
	Options = Items,
	CurrentOption = "Empty Bottle",
	MultipleOptions = true,
	Flag = "Items",
	Callback = function()end,
})

Tab:CreateSection("Dungeon")

local Difficulties = {}

for i,v in Player.PlayerGui.MainGui.DungeonInfo.Main.Dungeon.Difficulty:GetChildren() do
	Difficulties[i] = v.Name
end

Tab:CreateToggle({
	Name = "🏰 • Auto Enter Magicbound Castle",
	CurrentValue = false,
	Flag = "Magicbound",
	Callback = function(Value)
		while Flags.Magicbound.CurrentValue and task.wait() do
			if workspace.DungeonDirectory:GetChildren()[1] or not Player.Character or not Player.Character:FindFirstChild("Equipped") then
				continue
			end
			
			Remotes.StartDungeon:FireServer("Magicbound Castle", table.find(Difficulties, Flags.Difficulty.CurrentOption[1]))
			
			repeat
				task.wait()
			until workspace.DungeonDirectory:GetChildren()[1]
		end
	end,
})

Tab:CreateDropdown({
	Name = "📊 • Difficulty Mode",
	Options = Difficulties,
	CurrentOption = "Easy",
	MultipleOptions = false,
	Flag = "Difficulty",
	Callback = function()end,
})

getgenv().CreateUniversalTabs()
