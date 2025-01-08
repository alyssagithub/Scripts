ScriptVersion = "v1.0.2"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local Rayfield = getfenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

local Player = game:GetService("Players").LocalPlayer

local Remotes: {[string]: RemoteEvent & RemoteFunction} = game:GetService("ReplicatedStorage"):WaitForChild("Universe"):WaitForChild("Network"):WaitForChild("Remotes")

local Window = getfenv().Window

local Tab = Window:CreateTab("Automatics", "repeat")

Tab:CreateSection("Mobs")

Tab:CreateToggle({
	Name = "⚔ • Auto Attack Mobs",
	CurrentValue = false,
	Flag = "Attack",
	Callback = function(Value)	
		while Flags.Attack.CurrentValue and task.wait() do
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
			for _, Ability: Frame? in Player.PlayerGui.MainGui.Soul.Main.Items.Scroll:GetChildren() do
				if not Ability:IsA("Frame") or not Ability.Equipped.Visible then
					continue
				end

				Remotes.PlayerRequestAbility:FireServer(tonumber(Ability.Name), {
					["mouseTarget"] = Vector3.new(-598.558349609375, 0.3105278015136719, 348.0400085449219),
					["mouseTargetUsingRange"] = Vector3.new(-598.558349609375, 0.3105278015136719, 348.0400085449219)
				})
			end
			task.wait(1)
		end
	end,
})

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🌀 • Teleport to Mobs",
	CurrentValue = false,
	Flag = "Teleport",
	Callback = function(Value)
		while Flags.Teleport.CurrentValue and task.wait() do
			if not workspace.DungeonDirectory:GetChildren()[1] then
				continue
			end

			for _, Mob: Model? in workspace.World.Mobs:GetChildren() do
				if not Mob:FindFirstChild("Head") or Mob.Head.Transparency == 1 then
					continue
				end

				local BodyGyro = Player.Character.HumanoidRootPart:FindFirstChild("BodyGyro")

				if BodyGyro then
					BodyGyro:Destroy()
				end

				Player.Character:PivotTo(Mob.HumanoidRootPart.CFrame + Vector3.new(Flags.OffsetX.CurrentValue, Flags.OffsetY.CurrentValue, Flags.OffsetZ.CurrentValue))
				break
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
	CurrentValue = 6,
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
			if Contents.CurrentExpGain.Text == Contents.ExpGain.Text then
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

local Items = {}

for ItemName, _ in require(game:GetService("ReplicatedStorage").Universe.Items) do
	table.insert(Items, ItemName)
end

table.sort(Items)

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

getfenv().CreateUniversalTabs()
