local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.5.4")

local good = false

local Islands = {}
local Interactions = {}
local Quests = {}
local Mobs = {"Closest Mob", "None"}

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__SpawnLocations"]:GetChildren()) do
	table.insert(Islands, v.Name)
end

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Interactions"]:GetChildren()) do
	if not table.find(Interactions, v.Name) then
		table.insert(Interactions, v.Name)
	end
end

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Quests"]:GetChildren()) do
	table.insert(Quests, v.Head.Icon.TextLabel.Text:split("QUEST ")[2])
end

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Mobs"]:GetDescendants()) do
	if v:IsA("Model") and v:FindFirstChild("NpcHealth") and not table.find(Mobs, v.NpcHealth.ViewerFrame.TName.Text) then
		table.insert(Mobs, v.NpcHealth.ViewerFrame.TName.Text)
	end
end

for e,r in pairs(game:GetService("Workspace")["__GAME"]["__Mobs"]:GetChildren()) do
	if not r.Name:match("__") then
		local ExistingOfMob = {}
		local CurrentNumber = 0
		local BestMob

		for i,v in pairs(r:GetChildren()) do
			if v:FindFirstChild("NpcHealth") and not ExistingOfMob[v.NpcHealth.ViewerFrame.TName.Text] then
				ExistingOfMob[v.NpcHealth.ViewerFrame.TName.Text] = 1
			elseif v:FindFirstChild("NpcHealth") then
				ExistingOfMob[v.NpcHealth.ViewerFrame.TName.Text] = ExistingOfMob[v.NpcHealth.ViewerFrame.TName.Text] + 1
			end
		end

		for i,v in pairs(ExistingOfMob) do
			if v > CurrentNumber then
				CurrentNumber = v
				BestMob = i
			end
		end

		if BestMob then
			table.insert(Mobs, r.Name.." ("..BestMob.."'s Island)")
		end
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateSection("Weapons")

Main:CreateToggle({
	Name = "🛠 Equip all Tools",
	Info = "Equips all the tools in your backpack",
	CurrentValue = false,
	Flag = "EquipTools",
	Callback = function(Value)
		if not Value then
			for i,v in pairs(Player.Character:GetChildren()) do
				if v:IsA("Tool") then
					v.Parent = Player.Backpack
				end
			end
		end
	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.EquipTools.CurrentValue then
			for i,v in pairs(Player.Backpack:GetChildren()) do
				v.Parent = Player.Character
			end
		end
	end
end)

Main:CreateToggle({
	Name = "⚔ Auto Train",
	Info = "Automatically trains with your current items",
	CurrentValue = false,
	Flag = "AutoTrain",
	Callback = function(Value) end,
})

Player:WaitForChild("PlayerGui"):WaitForChild("Warn").ChildAdded:Connect(function()
	if Rayfield.Flags.AutoTrain.CurrentValue then
		good = true
	end
end)

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoTrain.CurrentValue and Player.Backpack:FindFirstChildOfClass("Tool") then
			for i,Tool in pairs(Player.Backpack:GetChildren()) do
				if Tool.Parent == Player.Backpack then
					Tool.Parent = Player.Character
					repeat
						game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "Combat", 1, false, Tool, Tool:GetAttribute("Type")}})
						task.wait()
					until good or not Rayfield.Flags.AutoTrain.CurrentValue or Tool.Parent ~= Player.Character
					good = false
					if Tool.Parent == Player.Character then
						Tool.Parent = Player.Backpack
					end
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💨 Auto Skills",
	Info = "Automatically uses your weapon(s)' skills (Z-B)",
	CurrentValue = false,
	Flag = "AutoSkills",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoSkills.CurrentValue and Player.Character:FindFirstChildOfClass("Tool") then
			for _,r in pairs(Player.Character:GetChildren()) do
				if r:IsA("Tool") and r.Name ~= "Defence" then
					for i,v in pairs({"Z", "X", "C", "V", "B"}) do
						if Player.Character:FindFirstChild("HumanoidRootPart") then
							game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "skillsControl", r.Name, v, "Release", require(game:GetService("ReplicatedStorage").SharedModules.ExtraFunctions).GetCurrentMouse(Player, true, 1200)[1]}})
							task.wait()
						end
					end
				end
			end
		end
	end
end)

Main:CreateSection("Collecting")

Main:CreateToggle({
	Name = "💼 Auto Collect Chests",
	Info = "Automatically collects chests that spawn",
	CurrentValue = false,
	Flag = "AutoChests",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoChests.CurrentValue then
			for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
				if v:FindFirstChild("ChestInteract") then
					local PreviousPosition = Player.Character.HumanoidRootPart.CFrame
					repeat
						Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
						fireproximityprompt(v.ChestInteract)
						task.wait()
					until not v or not v:FindFirstChild("ChestInteract") or not Rayfield.Flags.AutoChests.CurrentValue
					Player.Character.HumanoidRootPart.CFrame = PreviousPosition
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🥭 Auto Collect Fruit",
	Info = "Automatically collects fruit that spawn",
	CurrentValue = false,
	Flag = "AutoFruit",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoFruit.CurrentValue then
			for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
				if v:FindFirstChild("Eat") or (not v:IsA("Folder") and v.Name:lower():match("fruit")) then
					local PreviousPosition = Player.Character.HumanoidRootPart.CFrame
					repeat
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildWhichIsA("BasePart").CFrame
						fireproximityprompt(v.Eat)
						task.wait()
					until not v or not v:FindFirstChild("Eat") or not Rayfield.Flags.AutoFruit.CurrentValue
					Player.Character.HumanoidRootPart.CFrame = PreviousPosition
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "✅ Remove Name Tag",
	Info = "Removes your name tag from others and yourself",
	CurrentValue = false,
	Flag = "RemoveNameTag",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.RemoveNameTag.CurrentValue and Player.Character:WaitForChild("Head"):FindFirstChild("PlayerHealth") then
			for i,v in pairs(Player.Character:GetDescendants())do
				if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
					v:Destroy()
				end
			end
		end
	end
end)

Main:CreateSection("Effects")

Main:CreateToggle({
	Name = "💥 Disable Effects",
	Info = "Disable effects from skills (must rejoin to reverse)",
	CurrentValue = false,
	Flag = "DisableEffects",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.DisableEffects.CurrentValue and #game:GetService("ReplicatedStorage").Game["__Extra"].Modules.Skills:GetChildren() > 0 then
			for i,v in pairs(game:GetService("ReplicatedStorage").Game["__Extra"].Modules.Skills:GetChildren()) do
				v:Destroy()
			end

			for i,v in pairs(game:GetService("ReplicatedStorage").Game["__SkillsModules"]:GetChildren()) do
				v:Destroy()
			end
		end
	end
end)

local Misc = Window:CreateTab("Misc", 4483362458)

Misc:CreateSection("Teleports")

Misc:CreateDropdown({
	Name = "👾 Mob (Priority)",
	Options = Mobs,
	CurrentOption = "None",
	Flag = "SelectedMob",
	Callback = function(Option)	end,
})

Misc:CreateDropdown({
	Name = "👾 Mob 2",
	Options = Mobs,
	CurrentOption = "None",
	Flag = "SelectedMob2",
	Callback = function(Option)	end,
})

Misc:CreateToggle({
	Name = "⚡ Teleport to Mob",
	CurrentValue = false,
	Flag = "MobTeleport",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.MobTeleport.CurrentValue and Rayfield.Flags.MobTeleport.CurrentValue ~= "None" and Player.Character:FindFirstChild("HumanoidRootPart") then
			local CurrentNumber = math.huge
			local Mob
			
			for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Mobs"]:GetDescendants()) do
				if v:IsA("Model") and v.Name == "NpcModel" and v.Parent:FindFirstChild("NpcHealth") and v.Parent.NpcHealth.ViewerFrame.Frame.HealthText.Text:split("/")[1] ~= "0" then
					local Magnitude = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude

					if (v.Parent.NpcHealth.ViewerFrame.TName.Text == Rayfield.Flags.SelectedMob.CurrentOption or Rayfield.Flags.SelectedMob.CurrentOption == "Closest Mob" or (Rayfield.Flags.SelectedMob.CurrentOption:match("_") and v.Parent.Parent.Name == Rayfield.Flags.SelectedMob.CurrentOption:split(" ")[1])) and Magnitude < CurrentNumber then
						CurrentNumber = Magnitude
						Mob = v.HumanoidRootPart
					elseif (v.Parent.NpcHealth.ViewerFrame.TName.Text == Rayfield.Flags.SelectedMob2.CurrentOption or Rayfield.Flags.SelectedMob2.CurrentOption == "Closest Mob" or (Rayfield.Flags.SelectedMob2.CurrentOption:match("_") and v.Parent.Parent.Name == Rayfield.Flags.SelectedMob2.CurrentOption:split(" ")[1])) and Magnitude < CurrentNumber then
						CurrentNumber = Magnitude
						Mob = v.HumanoidRootPart
					end
				end
			end
			
			if Mob then
				Player.Character.HumanoidRootPart.CFrame = Mob.CFrame + Mob.CFrame.LookVector * 20
			end
		end
	end
end)

Misc:CreateDropdown({
	Name = "🏝 Teleport to Island",
	Options = Islands,
	CurrentOption = "",
	--Flag = "SelectedIsland",
	Callback = function(Option)
		Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["__GAME"]["__SpawnLocations"]:FindFirstChild(Option).CFrame
	end,
})

Misc:CreateDropdown({
	Name = "🛡 Teleport to Interaction",
	Options = Interactions,
	CurrentOption = "",
	--Flag = "SelectedIsland",
	Callback = function(Option)
		Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["__GAME"]["__Interactions"]:FindFirstChild(Option).PrimaryPart.CFrame
	end,
})

Misc:CreateSection("Quests")

Misc:CreateDropdown({
	Name = "📰 Quest",
	Options = Quests,
	CurrentOption = "",
	Flag = "SelectedQuest",
	Callback = function(Option) end,
})

Misc:CreateToggle({
	Name = "📜 Auto Start Quest",
	CurrentValue = false,
	Flag = "Quest",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Quest.CurrentValue and Rayfield.Flags.SelectedQuest.CurrentOption ~= "" and tostring(Player.PlayerGui.Quests.CurrentQuestContainer.Position):split(",")[1] == "{1.5" then
			for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Quests"]:GetChildren()) do
				if v.Head.Icon.TextLabel.Text:split("QUEST ")[2] == Rayfield.Flags.SelectedQuest.CurrentOption then
					local PreviousPosition = Player.Character:WaitForChild("HumanoidRootPart").CFrame
					repeat
						Player.Character:WaitForChild("HumanoidRootPart").CFrame = v.HumanoidRootPart.CFrame
						task.wait()
						game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\7", "GetQuest", v:GetAttribute("QuestID")}})
					until tostring(Player.PlayerGui.Quests.CurrentQuestContainer.Position):split(",")[1] ~= "{1.5" or not Rayfield.Flags.Quest.CurrentValue
					Player.Character:WaitForChild("HumanoidRootPart").CFrame = PreviousPosition
				end
			end
		end
	end
end)

Misc:CreateSection("Other")

Misc:CreateToggle({
	Name = "🍐 Auto Store Fruit",
	CurrentValue = false,
	Flag = "StoreFruit",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.StoreFruit.CurrentValue then
			for i,v in pairs(Player.Backpack:GetChildren()) do
				if v.Name:lower():match("fruit") and v:FindFirstChildWhichIsA("BasePart") then
					v.Parent = Player.Character
					game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "EatFruit", v, "Storage"}})
				end
			end
		end
	end
end)

Misc:CreateToggle({
	Name = "🔥 Auto Enable Haki",
	CurrentValue = false,
	Flag = "Haki",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Haki.CurrentValue and (not Player.Character:FindFirstChild("BusoH") or Player.Character:FindFirstChild("BusoH"):FindFirstChildWhichIsA("BasePart").Transparency ~= 0) then
			game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "BusoHaki"}})
		end
	end
end)
