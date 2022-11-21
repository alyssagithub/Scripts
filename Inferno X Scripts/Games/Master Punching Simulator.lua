local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local PunchLooping
local AttackLooping
local TPLooping

local RewardsLooping
local RankupLooping
local AreaLooping
local UpgradeLooping

local EggLooping

local HatchLooping
local EquipLooping

local Minions = {}
local Pads = {}
local Worlds = {"Spawn Area, World-1"}

for i,v in pairs(game:GetService("Workspace")["_GAME"]["_MINIONS"]:GetDescendants()) do
	if v:IsA("Model") and not table.find(Minions, v.Name) then
		table.insert(Minions, v.Name)
	end
end

for i,v in pairs(game:GetService("Workspace")["_GAME"]["_INTERACTIONS"]:GetChildren()) do
	if not table.find(Pads, v.Name) then
		table.insert(Pads, v.Name)
	end
end

for i,v in pairs(game:GetService("Workspace")["_GAME"]["_AREAS"]:GetChildren()) do
	table.insert(Worlds, v.Data.Zone.Value..", "..v.Data.World.Value)
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "👊 Auto Punch",
	CurrentValue = false,
	Flag = "AutoPunch",
	Callback = function(Value)
		PunchLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if PunchLooping then
			game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\5", "Tapping"}})
		end
	end
end)

Main:CreateToggle({
	Name = "⚔ Auto Attack Closest Minion",
	CurrentValue = false,
	Flag = "AutoAttackMinion",
	Callback = function(Value)
		AttackLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if AttackLooping then
			local CurrentMinion
			local CurrentNumber = math.huge

			for i,v in pairs(game:GetService("Workspace")["_GAME"]["_MINIONS"]:GetDescendants()) do
				if v:IsA("Model") and v:FindFirstChild("IsMob") and v:FindFirstChild("IsMob").Value == true and v.Stats.Health.Value >= 0 and (Player.Character:WaitForChild("HumanoidRootPart").Position - v.HumanoidRootPart.Position).Magnitude < CurrentNumber then
					CurrentNumber = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
					CurrentMinion = v
				end
			end

			if TPLooping then
				Player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(CurrentMinion.HumanoidRootPart.Position.X + 2.5, CurrentMinion.HumanoidRootPart.Position.Y, CurrentMinion.HumanoidRootPart.Position.Z))
			end

			game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\13", "Attack", CurrentMinion}})
		end
	end
end)

Main:CreateToggle({
	Name = "👾 Auto TP to Minion",
	CurrentValue = false,
	Flag = "AutoAttackMinion",
	Callback = function(Value)
		TPLooping = Value
	end,
})

Main:CreateSection("")

Main:CreateToggle({
	Name = "💼 Auto Claim Rewards",
	CurrentValue = false,
	Flag = "AutoClaimRewards",
	Callback = function(Value)
		RewardsLooping = Value
	end,
})

task.spawn(function()
	while true do
		if RewardsLooping then
			for i = 1, 6 do
				game:GetService("ReplicatedStorage").Remotes.Function:InvokeServer("Gifts", "Gift-"..i)
				task.wait()
			end
		end
		task.wait(1)
	end
end)

Main:CreateToggle({
	Name = "🔁 Auto Rankup",
	CurrentValue = false,
	Flag = "AutoRankup",
	Callback = function(Value)
		RankupLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if RankupLooping and Player.PlayerGui.Interface.CenterFrame.RankUp.Rank.Visible == true then
			game:GetService("ReplicatedStorage").Remotes.Function:InvokeServer("RankUp")
		end
	end
end)

Main:CreateToggle({
	Name = "💵 Auto Buy Areas",
	CurrentValue = false,
	Flag = "AutoBuyAreas",
	Callback = function(Value)
		AreaLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if AreaLooping then
			for i,v in pairs(game:GetService("Workspace")["_GAME"]["_MINIONS"]:GetChildren()) do
				if v.Name ~= "World-1" and game:GetService("Workspace")["_GAME"]["_WORLDS"]:FindFirstChild(v.Name:gsub("World", "WORLD")) and game:GetService("Workspace")["_GAME"]["_WORLDS"]:FindFirstChild(v.Name:gsub("World", "WORLD")).Gate.GateBlock.Transparency ~= 1 then
					game:GetService("ReplicatedStorage").Remotes.Function:InvokeServer("Area", {true, v.Name, v.Name})
					task.wait()
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "📈 Auto Buy Upgrades",
	CurrentValue = false,
	Flag = "AutoBuyUpgrades",
	Callback = function(Value)
		UpgradeLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if UpgradeLooping then
			for i,v in pairs(Player.PlayerGui.Interface.CenterFrame.Upgrades.MainFrame.List:GetChildren()) do
				if v:IsA("ImageLabel") then
					game:GetService("ReplicatedStorage").Remotes.Function:InvokeServer("Upgrade", v.Name)
					task.wait()
				end
			end
		end
	end
end)

Main:CreateSection("")

Main:CreateToggle({
	Name = "❗ Remove Notifications",
	CurrentValue = false,
	Flag = "RemoveNotifications",
	Callback = function(Value)
		Player.PlayerGui.Interface.ErrorFrame.Visible = not Value
	end,
})

Main:CreateToggle({
	Name = "🎴 Remove Card Animation",
	CurrentValue = false,
	Flag = "RemoveCardAnimation",
	Callback = function(Value)
		EggLooping = Value
		Player.PlayerGui.EggAnimation.Enabled = not EggLooping
	end,
})

Player.PlayerGui.Interface:GetPropertyChangedSignal("Enabled"):Connect(function()
	if EggLooping and not Player.PlayerGui.Interface.Enabled then
		Player.PlayerGui.Interface.Enabled = true
	end
end)

game:GetService("Lighting").Blur:GetPropertyChangedSignal("Size"):Connect(function()
	if EggLooping and game:GetService("Lighting").Blur.Size ~= 1 then
		game:GetService("Lighting").Blur.Size = 1
	end
end)

Main:CreateToggle({
	Name = "✅ Free Premium Boost",
	CurrentValue = false,
	Flag = "FreePremiumBoosst",
	Callback = function(Value)
		local CreateHookIndex
		if Value and hookmetamethod then
			CreateHookIndex = hookmetamethod(game.Players.LocalPlayer, "__index", function(self, method)
				if method == "MembershipType" then
					return Enum.MembershipType.Premium
				end

				return CreateHookIndex(self, method)
			end)
		elseif Value then
			Notify("Your executor does not support 'hookmetamethod'", 5)
		else
			CreateHookIndex = hookmetamethod(game.Players.LocalPlayer, "__index", function(self, method)
				if method == "MembershipType" then
					return Enum.MembershipType.None
				end

				return CreateHookIndex(self, method)
			end)
		end
	end,
})

local Pets = Window:CreateTab("Pets", 4483362458)

Pets:CreateToggle({
	Name = "🃏 Auto Open Closest Card",
	CurrentValue = false,
	Flag = "AutoHatch",
	Callback = function(Value)
		HatchLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if HatchLooping then
			local ClosestCard
			local CurrentNumber = math.huge

			for i,v in pairs(game:GetService("Workspace")["_GAME"]["_CARDS"]:GetChildren()) do
				if v.Name:match("Normal") and (Player.Character.HumanoidRootPart.Position - v.Main.Position).Magnitude < CurrentNumber then
					CurrentNumber = (Player.Character.HumanoidRootPart.Position - v.Main.Position).Magnitude
					ClosestCard = v
				end
			end

			local World = ClosestCard.Name:split(" Normal")[1]:gsub(" ", "-"):split(" ")[1]

			if tonumber(World:split("-")[2]) == 14 or tonumber(World:split("-")[2]) == 15 then
				World = "World-"..tostring(tonumber(World:split("-")[2]) + 1)
			end

			if tonumber(World:split("-")[2]) >= 19 then
				World = "World-"..tostring(tonumber(World:split("-")[2]) - 1)
			end

			game:GetService("ReplicatedStorage").Remotes.Function:InvokeServer("BuyEgg", {["Egg"] = "NormalEgg", ["Type"] = "Single", ["World"] = World})
		end
	end
end)

Pets:CreateToggle({
	Name = "👍 Auto Equip Best",
	CurrentValue = false,
	Flag = "AutoEquip",
	Callback = function(Value)
		EquipLooping = Value
	end,
})

task.spawn(function()
	while true do
		if EquipLooping then
			if getconnections then
				for i,v in next, getconnections(Player.PlayerGui.Interface.CenterFrame.Pets.Buttons.EquipBest.MouseButton1Click) do
					v.Function()
				end
			else
				Notify("Your executor does not support 'getconnections'", 5)
			end
		end
		task.wait(5)
	end
end)

local Teleports = Window:CreateTab("Teleports", 4483362458)

Interactable = Teleports:CreateDropdown({
	Name = "🔼 Teleport to Interactable",
	Options = Pads,
	CurrentOption = "",
	--Flag = "SelectedInteractable",
	Callback = function(Value)
		if Value ~= "" then
			local Part = game:GetService("Workspace")["_GAME"]["_INTERACTIONS"]:FindFirstChild(Value)
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(Part.Position.X, Part.Position.Y + 5, Part.Position.Z)
			Interactable:Set("")
		end
	end,
})

World = Teleports:CreateDropdown({
	Name = "🏝 Teleport to World",
	Options = Worlds,
	CurrentOption = "",
	--Flag = "SelectedWorld",
	Callback = function(Value)
		if Value ~= "" then
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Workspace")["_GAME"]["_TPs"]:FindFirstChild(Value:split("-")[2]).Position)
			World:Set("")
		end
	end,
})

Teleports:CreateButton({
	Name = "🌺 Teleport to Your Best Training Zone",
	Callback = function()
		local BestNumber = 0
		local CurrentZone

		for i,v in pairs(game:GetService("Workspace")["_GAME"]["_WORKSPACE"]:GetDescendants()) do
			if v:FindFirstChild("UID") and tonumber(v.UID.Gui.Multiplier.Text:split(" ")[3]) >= BestNumber and tonumber(Player.PlayerGui.Interface.StatsFrame.Rank.UID.Text:split(" ")[2]) >= tonumber(v.UID.Gui.Multiplier.Text:split(" ")[3]) then
				BestNumber = tonumber(v.UID.Gui.Multiplier.Text:split(" ")[3])
				CurrentZone = v.UID
			end
		end

		Player.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentZone.Position.X, CurrentZone.Position.Y, CurrentZone.Position.Z - 5)
	end,
})

Teleports:CreateButton({
	Name = "💨 Teleport to Your Best Area",
	Callback = function()
		local BestNumber = 0
		local CurrentArea

		for i,v in pairs(game:GetService("Workspace")["_GAME"]["_WORLDS"]:GetDescendants()) do
			if v:FindFirstChild("GateBlock") and v:FindFirstChild("GateBlock").Transparency == 1 and i > BestNumber then
				BestNumber = i
				CurrentArea = v.GateBlock
			end
		end

		if CurrentArea then
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentArea.Position.X, CurrentArea.Position.Y, CurrentArea.Position.Z)
		end
	end,
})
