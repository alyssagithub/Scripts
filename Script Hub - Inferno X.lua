if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()

Player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local function Credits(Window)
	local Credits = Window:MakeTab({
		Name = "Credits",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Credits:AddLabel("🔥 Inferno X was made by alyssa#2303 🔥")

	Credits:AddLabel("➡ discord.gg/rtgv8Jp3fM ⬅")
end

local function Click(v)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,true,v,1)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,false,v,1)
end

local function comma(amount)
	local formatted = amount
	local k
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local function CreateWindow()
	return OrionLib:MakeWindow({Name = "Inferno X - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})
end

if game.PlaceId == 9264596435 then -- Idle Heroes Simulator
	local Plot
	local PlayerPlot

	local SavedPosition

	local SelectedHero
	local SelectedChest

	local OriginalSelectedHero

	local UpgradeLevel
	local SwingLooping
	local Swing2Looping
	local NextLevelLooping
	local HireLooping
	local UpgradeLooping
	local ChestLooping
	local ReincarnateLooping
	local MobLooping
	local SkillLooping
	local RerollLooping

	local IsInLoopReincarnate
	local IsInLoopNextLevel
	local IsInLoopAutoHire

	local HeadPosition

	local CurrentPage

	local HeroesList = {"None"}
	local PlotList = {"Your Own Plot"}
	local EnchantList = {"None", "Sharp I", "Hero I", "Rich I", "Sharp II", "Hero II", "Rich II", "Luck I", "Sharp III", "Hero III", "Immortal I", "Rich III", "Luck II", "Sharp IV", "Hero IV", "Immortal II", "Rich IV", "Luck III", "Team Player", "Lifeless"}

	local RarityBackgrounds = {
		["0 0.803922 0.803922 0.803922 0 1 0.803922 0.803922 0.803922 0 "] = "Common",
		["0 0.211765 0.513726 1 0 1 0.211765 0.513726 1 0 "] = "Rare",
		["0 0.411765 0.113725 1 0 1 0.411765 0.113725 1 0 "] = "Epic",
		["0 1 0.807843 0.180392 0 1 1 0.807843 0.180392 0 "] = "Legendary",
		["0 1 0 0.984314 0 1 1 1 0 0 "] = "Mythical",
		["0 0.796078 0.564706 1 0 1 0.796078 0.564706 1 0 "] = "Demonic",
		["0 0.835294 0.713726 0.231373 0 1 0.835294 0.713726 0.231373 0 "] = "Godly",
		["0 1 0.47451 0.47451 0 1 1 0.47451 0.47451 0 "] = "Celestial"
	}

	for i,v in pairs(workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player then
			Plot = v
			PlayerPlot = v
		end
	end

	for i,v in pairs(workspace.Plots:GetChildren()) do
		if v.Owner.Value and v.Owner.Value ~= Player then
			table.insert(PlotList, v.Owner.Value.Name)
		else
			v.Owner.Changed:Connect(function()
				if v.Owner.Value then
					table.insert(PlotList, v.Owner.Value.Name)
				end
			end)
		end
	end

	repeat task.wait() until Plot
	repeat task.wait() until Plot:FindFirstChild("Heroes")

	for i,v in pairs(Plot.Heroes:GetChildren()) do
		table.insert(HeroesList, v.Name)
	end

	Plot.Heroes.ChildAdded:Connect(function(child)
		if not table.find(HeroesList, child.Name) then
			table.insert(HeroesList, child.Name)
		end
	end)

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🤺 Auto Swing",
		Default = false,
		Save = true,
		Flag = "AutoSwing",
		Callback = function(Value)
			SwingLooping = Value
			while SwingLooping do
				if #Plot.Enemy:GetChildren() == 0 then
					repeat task.wait() until Plot.Enemy:GetChildren()[1]
				end

				local Enemy = Plot.Enemy:GetChildren()[1]

				game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.Swing:FireServer(Enemy)

				task.wait(0.14)
			end
		end
	})

	Main:AddToggle({
		Name = "🤺 Auto Swing 2",
		Default = false,
		Save = true,
		Flag = "AutoSwing2",
		Callback = function(Value)
			Swing2Looping = Value
			while Swing2Looping do
				Click(Player.PlayerGui.Main.Tint)
				task.wait(0.14)
			end
		end
	})

	Main:AddToggle({
		Name = "📊 Auto Progress",
		Default = false,
		Save = true,
		Flag = "AutoNextLevel",
		Callback = function(Value)
			NextLevelLooping = Value
			while NextLevelLooping and task.wait() do
				if Plot.Buttons:FindFirstChild("NextLevel") then
					IsInLoopNextLevel = true

					if IsInLoopReincarnate then
						repeat task.wait() until not IsInLoopReincarnate
					elseif IsInLoopAutoHire then
						repeat task.wait() until not IsInLoopAutoHire
					end

					SavedPosition = Player.Character:WaitForChild("HumanoidRootPart").Position

					repeat task.wait() until Plot.Buttons:FindFirstChild("NextLevel"):FindFirstChild("Touch")

					repeat
						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(Plot.Buttons:FindFirstChild("NextLevel").Touch.Position)
						task.wait()
					until not Plot.Buttons:FindFirstChild("NextLevel") or not NextLevelLooping

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)

					IsInLoopNextLevel = false
				end
			end
			IsInLoopNextLevel = false
		end    
	})

	local RequiredLevel = 80
	local OtherLevel = 0

	Main:AddToggle({
		Name = "🔁 Auto Reincarnate",
		Default = false,
		Save = true,
		Flag = "AutoReincarnate",
		Callback = function(Value)
			ReincarnateLooping = Value
			while ReincarnateLooping and task.wait(.25) do
				local ReincarnationsAmount = tonumber(Player.PlayerGui.Main.Frames.Achievements.Container.Stats.Container.Reincarnations.Label.Text:split(" ")[2])
				local ReincarnationsTable = {
					[1] = 80,
					[2] = 80,
					[3] = 80,
					[4] = 80,
					[5] = 85,
					[6] = 85,
					[7] = 85,
					[8] = 85,
					[9] = 85,
					[10] = 90,
					[11] = 90,
					[12] = 90,
					[13] = 90,
					[14] = 90,
					[15] = 95,
					[16] = 95,
					[17] = 95,
					[18] = 95,
					[19] = 95,
					[20] = 100,
					[21] = 100,
					[22] = 100,
					[23] = 100,
					[24] = 100
				}

				if ReincarnationsTable[ReincarnationsAmount] and tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) >= ReincarnationsTable[ReincarnationsAmount] then
					OtherLevel = ReincarnationsTable[ReincarnationsAmount]
				elseif ReincarnationsTable[ReincarnationsAmount] then
					OtherLevel = 0
				end

				if Player.PlayerGui.Main.Top.Wave.Wave.Text == "1/1" and (tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) == RequiredLevel and Player.PlayerGui.Main.Top.Level.Text:split(" ")[3] ~= "Complete!") or OtherLevel ~= 0 then
					if Player.PlayerGui.Main.Top.Wave.Wave.Text == "1/1" then
						IsInLoopReincarnate = true

						if IsInLoopNextLevel then
							repeat task.wait() until not IsInLoopNextLevel
						elseif IsInLoopAutoHire then
							repeat task.wait() until not IsInLoopAutoHire
						end

						SavedPosition = Player.Character:WaitForChild("HumanoidRootPart").Position

						task.wait()

						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2041, 59, -26)

						repeat task.wait() until Player.PlayerGui.Main.Frames.Reincarnate.Visible == true

						repeat
							game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.Reincarnate:FireServer()
							task.wait()
						until Player.PlayerGui.Main.ChestOpening.Visible == true

						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)

						IsInLoopReincarnate = false
					end
				elseif tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) > RequiredLevel or (tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) == RequiredLevel and Player.PlayerGui.Main.Top.Level.Text:split(" ")[3] == "Complete!") then
					RequiredLevel = RequiredLevel + 10
					print("Set RequiredLevel to "..RequiredLevel)
				end
			end
			IsInLoopReincarnate = false
		end
	})

	Main:AddToggle({
		Name = "⚡ Auto Mob TP",
		Default = false,
		Save = true,
		Flag = "AutoMobTP",
		Callback = function(Value)
			MobLooping = Value
			while MobLooping and task.wait() do
				if #Plot.Enemy:GetChildren() == 0 then
					repeat task.wait() until Plot.Enemy:GetChildren()[1]
				end

				local Enemy = Plot.Enemy:GetChildren()[1]

				if IsInLoopReincarnate then
					repeat task.wait() until not IsInLoopReincarnate
				elseif IsInLoopNextLevel then
					repeat task.wait() until not IsInLoopNextLevel
				elseif IsInLoopAutoHire then
					repeat task.wait() until not IsInLoopAutoHire
				end

				if not Player.Character:FindFirstChild("HumanoidRootPart") then
					repeat task.wait() until Player.Character:FindFirstChild("HumanoidRootPart") or not MobLooping
				end

				Player.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Enemy.Position.X, Enemy.Position.Y, Enemy.Position.Z + 5)
			end
			Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Plot.Teleport.CFrame
		end
	})

	Main:AddToggle({
		Name = "⚔ Auto Use Skills",
		Default = false,
		Save = true,
		Flag = "AutoUseSkills",
		Callback = function(Value)
			SkillLooping = Value
			while SkillLooping and task.wait() do
				for i,v in pairs({"Enraged", "Eruption", "Misfortune", "Golden Rain", "Gold Potion", "Cold Runes", "Insight", "Enlightenment", "Replenish"}) do
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.UseSkill:FireServer(v)
					task.wait()
				end
			end
		end
	})

	local Misc = Main:AddSection({
		Name = "",
	})

	Misc:AddDropdown({
		Name = "🏠 Plot",
		Default = "Your Own Plot",
		Options = PlotList,
		Callback = function(Value)
			if Value == "Your Own Plot" then
				Plot = PlayerPlot
			else
				for i,v in pairs(workspace.Plots:GetChildren()) do
					if v.Owner.Value == game.Players:FindFirstChild(Value) then
						game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToPlot:FireServer(game.Players:FindFirstChild(Value))
						Plot = v
						print(v, Plot)
					end
				end
			end
		end
	})

	local Heroes = Window:MakeTab({
		Name = "Heroes",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Heroes:AddToggle({
		Name = "👍 Auto Hire Heroes",
		Default = false,
		Save = true,
		Flag = "AutoHire",
		Callback = function(Value)
			HireLooping = Value
			while HireLooping and task.wait() do
				if game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") and not Plot.Heroes:FindFirstChild("The Reaper") then
					if tostring(game:GetService("Workspace").Main.Hire["_displayHero"].Highlight.OutlineColor) == "0.215686, 1, 0.266667" then
						IsInLoopAutoHire = true

						if IsInLoopReincarnate then
							repeat task.wait() until not IsInLoopReincarnate
						elseif IsInLoopNextLevel then
							repeat task.wait() until not IsInLoopNextLevel
						end

						SavedPosition = Player.Character:WaitForChild("HumanoidRootPart").Position

						task.wait()

						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-1886, 61, -92)

						task.wait(.25)

						game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.HireHero:FireServer(game:GetService("Workspace").Main.Hire["_displayHero"].Head.Nametag.Subject.Text)

						task.wait(.25)

						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)

						IsInLoopAutoHire = false

						task.wait(1)
					end
				elseif not game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") and not Plot.Heroes:FindFirstChild("The Reaper") then
					IsInLoopAutoHire = true

					if IsInLoopReincarnate then
						repeat task.wait() until not IsInLoopReincarnate
					elseif IsInLoopNextLevel then
						repeat task.wait() until not IsInLoopNextLevel
					end

					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToMain:FireServer()

					repeat task.wait() until game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") or Plot.Heroes:FindFirstChild("The Reaper")

					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToPlot:FireServer(Plot.Owner.Value)

					IsInLoopAutoHire = false
				end
			end
			IsInLoopAutoHire = false
		end
	})

	Heroes:AddDropdown({
		Name = "📃 Hero to Upgrade (leave blank for all)",
		Default = "None",
		Options = HeroesList,
		Save = true,
		Flag = "SelectedHero",
		Callback = function(Value)
			if Value == "None" then
				SelectedHero = nil
				OriginalSelectedHero = nil
			else
				SelectedHero = Value
				OriginalSelectedHero = Value
			end
		end    
	})

	Heroes:AddSlider({
		Name = "🎚 Max Upgrade Level",
		Min = 0,
		Max = 1000,
		Default = 25,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		Save = true,
		Flag = "MaxUpgradeLevel",
		Callback = function(Value)
			UpgradeLevel = Value
		end    
	})

	require(Player.PlayerScripts.Client.Controllers.UIController.BuyCoins).Set = function()
		return
	end

	Heroes:AddToggle({
		Name = "📈 Auto Upgrade Hero(es)",
		Default = false,
		Save = true,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
			while UpgradeLooping and task.wait() do
				for i,v in pairs(PlayerPlot.Heroes:GetChildren()) do
					if tonumber(v:WaitForChild("Head").Nametag.Level.Text:split(" ")[2]) <= UpgradeLevel - 1 then
						if not OriginalSelectedHero then
							SelectedHero = v
						end
						if game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RF.BuyLevel:InvokeServer(SelectedHero.Name, 0) then
							print("Upgraded "..v.Name)
						end
					end
				end
			end
		end
	})

	local Passive = Window:MakeTab({
		Name = "Passive",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local SelectedEnchants = {}

	Passive:AddDropdown({
		Name = "Enchant(s) to Stop at (multiple choice)",
		Default = "None",
		Options = EnchantList,
		Callback = function(Value)
			if not table.find(SelectedEnchants, Value) and Value ~= "None" then
				table.insert(SelectedEnchants, Value)
			elseif Value ~= "None" then
				table.remove(SelectedEnchants, Value)
			end

			task.spawn(function()
				repeat task.wait() until EnchantLabel
				EnchantLabel:Set(table.concat(SelectedEnchants, ", "))
			end)
		end
	})

	EnchantLabel = Passive:AddParagraph("Selected Enchants","None")

	Player.PlayerGui.Main.ChestResult.Container.ChildAdded:Connect(function(child)
		repeat task.wait() until child.ItemName.Text ~= "OP Sword"

		print(child.ItemName.Text)

		if table.find(SelectedEnchants, child.ItemName.Text) then
			RerollLooping = false
		end
	end)

	Passive:AddToggle({
		Name = "🎲 Auto Reroll Passive (must have ui open)",
		Save = true,
		Flag = "AutoRerollPassive",
		Callback = function(Value)
			RerollLooping = Value
			while RerollLooping and task.wait(.25) do
				if Player.PlayerGui.Main.Frames.Passives.Visible == true and Player.PlayerGui.Main.ChestOpening.Visible == false then
					Click(Player.PlayerGui.Main.Frames.Passives.CoreReroll.Button)

					repeat task.wait() until #Player.PlayerGui.Main.ChestResult.Container:GetChildren() == 1
				end
			end
		end
	})

	local Chest = Window:MakeTab({
		Name = "Chest",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Chest:AddDropdown({
		Name = "📦 Chest to Purchase",
		Options = {"Wooden", "Silver", "Golden", "Legendary", "Divine"},
		Save = true,
		Flag = "SelectedChest",
		Callback = function(Value)
			SelectedChest = Value
		end
	})

	Chest:AddToggle({
		Name = "💵 Auto Buy Chest",
		Default = false,
		Callback = function(Value)
			ChestLooping = Value
			if SelectedChest and Value then
				while ChestLooping and task.wait(1) do
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.ChestService.RF.BuyChest:InvokeServer(SelectedChest, "single")
				end
			end
		end
	})

	Credits(Window)
elseif game.PlaceId == 10779604733 then -- VBet
	local AutoClickLooping
	local AutoCaseLooping
	local MouseButton2Looping
	local InfiniteBattleLooping

	local OriginalAutoClickLooping

	local CaseBattlesAmount

	local CaseList = {}
	local DoneList = {}

	local SelectedCase

	local Background = Player.PlayerGui["Interact_Gui"]["Background_Frame"]
	local BattlePrompt = Background["Games_Holder"]["Battle_Prompt"]

	local function SetCaseList()
		for i,v in pairs(Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:GetChildren()) do
			if v:IsA("Frame") then
				table.insert(CaseList, v.Name)
			end
		end

		Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"].ChildAdded:Connect(function(v)
			table.insert(CaseList, v.Name)
		end)

		table.sort(CaseList, function(a, b)
			return a < b
		end)
	end

	if #Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:GetChildren() == 2 then
		if Background.Visible == false then
			Click(Player.PlayerGui["Interact_Gui"]["Frame_Switch"])

			task.wait(.25)
		end

		if Background["Game_Selection"].Visible == false then
			Click(Background["Top_Bar"]["Holding_Frame"]["Button_Games"])

			task.wait(.25)
		end

		Click(Background["Game_Selection"]["Game_Category_1"]["Game_Cases"]["Icon_Game"])

		task.wait(1)
	end

	task.spawn(SetCaseList)

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🖱 Auto Clicker",
		Default = false,
		Save = true,
		Flag = "AutoClick",
		Callback = function(Value)
			AutoClickLooping = Value
			OriginalAutoClickLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if AutoClickLooping then
				Click(Player.PlayerGui["Interact_Gui"].Cash["Icon_Click"])
			end
		end
	end)

	Main:AddLabel("Press right click once to temp disable the auto clicker.")

	Main:AddButton({
		Name = "🎃 Auto Get Pumpkins",
		Callback = function()
			for i,v in pairs(workspace:GetChildren()) do
				if v.Name == "Event_Pumpkin" then
					Player.Character.HumanoidRootPart.CFrame = v.CFrame
					task.wait(.1)
				end
			end
		end    
	})

	local Case = Window:MakeTab({
		Name = "Case",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	task.spawn(function()
		Case:AddDropdown({
			Name = "📃 Case",
			Options = CaseList,
			Save = true,
			Flag = "SelectedCase",
			Callback = function(Value)
				SelectedCase = Value
			end
		})

		Case:AddSlider({
			Name = "Case Battles Amount",
			Min = 1,
			Max = 30,
			Default = 1,
			Color = Color3.fromRGB(255,255,255),
			Increment = 1,
			Save = true,
			Flag = "CaseBattlesAmount",
			Callback = function(Value)
				CaseBattlesAmount = Value
			end    
		})

		Case:AddToggle({
			Name = "♾ Infinite Case Battles",
			Default = false,
			Callback = function(Value)
				InfiniteBattleLooping = Value
				while InfiniteBattleLooping and task.wait() do
					AutoClickLooping = false

					if Background["Game_Selection"].Visible == false and Background["Games_Holder"]["Game_Battles"].Visible == false then
						Click(Background["Top_Bar"]["Holding_Frame"]["Button_Games"])

						repeat task.wait() until Background["Game_Selection"].Visible == true

						Click(Background["Game_Selection"]["Game_Category_1"]["Game_Battles"]["Icon_Game"])
					end

					repeat task.wait() until Background["Games_Holder"]["Game_Battles"].Visible == true

					Click(Background["Games_Holder"]["Game_Battles"]["Button_Create"])

					repeat task.wait() until BattlePrompt.Visible == true

					if BattlePrompt["Button_Mode"].Text ~= "1v1v1" then
						repeat
							Click(BattlePrompt["Button_Mode"])
							task.wait(.25)
						until BattlePrompt["Button_Mode"].Text == "1v1v1"
					end

					if BattlePrompt["Button_Crazy"].Text ~= "Crazy On" then
						Click(BattlePrompt["Button_Crazy"])
					end

					task.wait()

					local LoopAmount = 0

					if not BattlePrompt["Battle_Frame"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase) then
						repeat
							LoopAmount = LoopAmount + 1
							repeat
								Click(BattlePrompt["Button_Add"])
								task.wait(1)
							until Background["Games_Holder"]["Add_Case_Prompt"].Visible == true

							task.wait(1)

							local CaseButton = Background["Games_Holder"]["Add_Case_Prompt"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase)

							CaseButton.Parent = Background["Games_Holder"]["Add_Case_Prompt"]

							task.wait()

							Click(CaseButton)

							task.wait(.1)
						until LoopAmount == CaseBattlesAmount
					end

					repeat
						Click(BattlePrompt["Button_Create"])
						task.wait(1)
					until Background["Games_Holder"]["Game_Battles"].Visible == true

					for i,v in pairs(Background["Games_Holder"]["Game_Battles"]["Scrolling_Frame_4"]:GetChildren()) do
						if v:IsA("Frame") and v["Title_Host"].Text:split(" - ")[2] == Player.Name and not table.find(DoneList, v.Name) then
							local HolderFrame = Background["Games_Holder"]:FindFirstChild(v.Name)
							local Player2 = HolderFrame["Player_List"]["Player_2"]["Button_Call"]
							local Player3 = HolderFrame["Player_List"]["Player_3"]["Button_Call"]
							table.insert(DoneList, v.Name)

							v.Parent = Background["Games_Holder"]["Game_Battles"]

							task.wait()

							Click(v["Button_View"])

							v.Parent = Background["Games_Holder"]["Game_Battles"]["Scrolling_Frame_4"]

							repeat task.wait() until HolderFrame.Visible == true

							repeat
								Click(Player2)
								task.wait(.1)
							until Player2.Visible == false or HolderFrame.Visible == false

							if HolderFrame["Player_List"]:FindFirstChild("Player_3") then
								repeat
									Click(Player3)
									task.wait(.1)
								until Player3.Visible == false or HolderFrame.Visible == false
							end

							repeat
								Click(Background["Games_Holder"]:FindFirstChild(v.Name)["Button_Games_List"])
								task.wait(1)
							until Background["Games_Holder"]["Game_Battles"].Visible == true
						end
					end
				end
				AutoClickLooping = OriginalAutoClickLooping
			end
		})
	end)

	Player:GetMouse().Button2Down:Connect(function()
		MouseButton2Looping = true
		AutoClickLooping = false
		task.wait(3)
		AutoClickLooping = OriginalAutoClickLooping
		MouseButton2Looping = false
	end)

	Credits(Window)
elseif game.PlaceId == 10925589760 then -- Merge Simulator
	local Plot = workspace.Plots:FindFirstChild(Player.Name)

	local AutoTapLooping
	local AutoMergeLooping
	local AutoUpgradeLooping
	local AutoObbyLooping
	local AutoRebirthLooping
	local InfObbyMultiLooping

	local OriginalAutoMergeLooping

	local Blocks = {}

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🖱 Auto Tap",
		Default = false,
		Save = true,
		Flag = "AutoTap",
		Callback = function(Value)
			AutoTapLooping = Value
			while AutoTapLooping and task.wait() do
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					game:GetService("ReplicatedStorage").Functions.Tap:FireServer(v)
					task.wait()
				end
			end
		end
	})

	Main:AddToggle({
		Name = "🤝 Auto Merge",
		Default = false,
		Save = true,
		Flag = "AutoMerge",
		Callback = function(Value)
			AutoMergeLooping = Value
			OriginalAutoMergeLooping = Value
			while AutoMergeLooping and task.wait() do
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					v.CFrame = CFrame.new(Plot.Main.Position.X + 10, Plot.Main.Position.Y + 10, Plot.Main.Position.Z + 10)
				end
			end
		end
	})

	Main:AddToggle({
		Name = "📈 Auto Buy Upgrades",
		Default = false,
		Save = true,
		Flag = "AutoBuyUpgrades",
		Callback = function(Value)
			AutoUpgradeLooping = Value
			while AutoUpgradeLooping and task.wait() do
				for i,v in pairs(Player.PlayerGui.World.Upgrades.Main:GetChildren()) do
					if v:IsA("Frame") then
						firesignal(v.Buy.Activated)
					end
				end
			end
		end
	})

	Main:AddToggle({
		Name = "🏁 Auto Complete Obby",
		Default = false,
		Save = true,
		Flag = "AutoCompleteObby",
		Callback = function(Value)
			AutoObbyLooping = Value
			while AutoObbyLooping and task.wait() do
				if game:GetService("Workspace").Obby.Blocker.Transparency == 1 then
					Player.Character.HumanoidRootPart.CFrame = CFrame.new(267, 81, 4)
					repeat task.wait() until game:GetService("Workspace").Obby.Blocker.Transparency ~= 1
				end
			end
		end
	})

	Main:AddToggle({
		Name = "🔁 Auto Rebirth",
		Default = false,
		Save = true,
		Flag = "AutoRebirth",
		Callback = function(Value)
			AutoRebirthLooping = Value
			while AutoRebirthLooping do
				game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
				task.wait(1)
			end
		end
	})

	Main:AddToggle({
		Name = "🎉 Infinite Obby Multiplier",
		Default = false,
		Save = true,
		Flag = "InfObbyMulti",
		Callback = function(Value)
			InfObbyMultiLooping = Value
			while InfObbyMultiLooping do
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 1)
				task.wait(1)
			end
		end
	})

	Credits(Window)
elseif game.PlaceId == 9712123877 then -- Super Slime Simulator
	local CollectLooping
	local RebirthLooping
	local ClaimLooping
	local CapsuleLooping
	local OpenLooping

	local SelectedCapsule

	local CapsuleList = {"standardCapsule", "midCapsule", "epicCapsule", "basicBuffCapsule"}

	for i,v in pairs(game:GetService("ReplicatedStorage").availableCapsules:GetChildren()) do
		if not table.find(CapsuleList, v.Name) and v.Name ~= "timer" then
			if v.Name == "highlightedCapsule" then
				table.insert(CapsuleList, v.Value)
			else
				table.insert(CapsuleList, v.Name)
			end
		end
	end

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🍃 Auto Collect",
		Default = false,
		Save = true,
		Flag = "AutoCollect",
		Callback = function(Value)
			CollectLooping = Value
			while CollectLooping and task.wait() do
				Player.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace").gardenStage.triggers.hubTrigger.Position)
				task.wait(.1)
				for i,v in pairs(game:GetService("Workspace").gardenStage.physicsProps:GetChildren()) do
					if CollectLooping and Player.Character:FindFirstChild("HumanoidRootPart") and v:IsA("Model") and v:FindFirstChild("destructable") and v.destructable.Value == true and v.destructable:FindFirstChildOfClass("MeshPart") then
						Player.Character.HumanoidRootPart.CFrame = CFrame.new(v.destructable:FindFirstChildOfClass("MeshPart").Position)
						task.wait()
					end
				end
			end
		end
	})

	Main:AddToggle({
		Name = "🔁 Auto Rebirth",
		Default = false,
		Save = true,
		Flag = "AutoRebirth",
		Callback = function(Value)
			RebirthLooping = Value
			while RebirthLooping and task.wait(1) do
				game:GetService("ReplicatedStorage").functions.requestRebirth:FireServer()
			end
		end
	})

	Main:AddToggle({
		Name = "🎁 Auto Claim Rewards",
		Default = false,
		Save = true,
		Flag = "AutoClaim",
		Callback = function(Value)
			ClaimLooping = Value
			while ClaimLooping and task.wait(1) do
				for i,v in pairs(Player.playerStats.rewards:GetChildren()) do
					game:GetService("ReplicatedStorage").functions.claimReward:InvokeServer(v)
					task.wait()
				end
			end
		end
	})

	local Capsule = Window:MakeTab({
		Name = "Capsule",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Capsule:AddDropdown({
		Name = "💊 Capsule",
		Options = CapsuleList,
		Save = true,
		Flag = "SelectedCapsule",
		Callback = function(Value)
			SelectedCapsule = Value
		end
	})

	Capsule:AddToggle({
		Name = "💵 Auto Buy Capsule",
		Default = false,
		Save = true,
		Flag = "AutoBuyCapsule",
		Callback = function(Value)
			CapsuleLooping = Value
			while CapsuleLooping and task.wait(1) do
				game:GetService("ReplicatedStorage").functions.buyCapsule:InvokeServer(SelectedCapsule)
			end
		end
	})

	Capsule:AddToggle({
		Name = "📭 Auto Open Capsule",
		Default = false,
		Save = true,
		Flag = "AutoBuyCapsule",
		Callback = function(Value)
			OpenLooping = Value
			while OpenLooping and task.wait(.25) do
				if Player.PlayerGui:FindFirstChild("activeCapsule") then
					Click(Player.PlayerGui.menus.menuHandler.selection)
				end
			end
		end
	})

	Credits(Window)
elseif game.PlaceId == 11189979930 then -- Pet Crafting Simulator
	local TapLooping
	local MergeLooping
	local UpgradeLooping
	local RebirthLooping
	local FrenzyLooping

	local Plot = game:GetService("Workspace").Plots:FindFirstChild(Player.Name)

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🖱 Auto Tap",
		Default = false,
		Save = true,
		Flag = "AutoTap",
		Callback = function(Value)
			TapLooping = Value
			while TapLooping and task.wait() do
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					game:GetService("ReplicatedStorage").Functions.Tap:FireServer(v)
				end
			end
		end
	})

	Main:AddToggle({
		Name = "🤝 Auto Merge",
		Default = false,
		Save = true,
		Flag = "AutoMerge",
		Callback = function(Value)
			MergeLooping = Value
			while MergeLooping and task.wait() do
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					for e,r in pairs(Plot.Blocks:GetChildren()) do
						firetouchinterest(v, r, 0)
						firetouchinterest(v, r, 1)
					end
				end
			end
		end
	})

	Main:AddToggle({
		Name = "📈 Auto Upgrade",
		Default = false,
		Save = true,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
			while UpgradeLooping and task.wait(.25) do
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.SpawnTier.Buy.Activated)
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.MaxBlocks.Buy.Activated)
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Bot.Cooldown.Buy.Activated)
			end
		end
	})

	Main:AddToggle({
		Name = "🔁 Auto Rebirth",
		Default = false,
		Save = true,
		Flag = "AutoRebirth",
		Callback = function(Value)
			RebirthLooping = Value
			while RebirthLooping and task.wait() do
				if Player.PlayerGui.World.Wall.Rebirths.Rebirth.Buy.BackgroundColor3 ~= Color3.fromRGB(76, 76, 76)  then
					game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
				end
			end
		end
	})

	Main:AddToggle({
		Name = "♾ Infinite 2x Frenzy",
		Default = false,
		Save = true,
		Flag = "InfiniteFrenzy",
		Callback = function(Value)
			FrenzyLooping = Value
			while FrenzyLooping and task.wait(1) do
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 1)
			end
		end
	})

	Credits(Window)
elseif game.PlaceId == 11102985540 then -- Pet Hive Simulator
	local FoodLooping
	local CoinLooping
	local EggLooping
	local QuestLooping

	local AttackLooping

	local EquipLooping
	local FeedLooping
	local TierLooping
	local OpenLooping
	local PlaceLooping

	local SelectedEnemy
	local SelectedQuest

	local EnemiesList = {}
	local QuestsList = {}

	table.sort(EnemiesList, function(a, b)
		return a > b
	end)

	for i,v in pairs(game:GetService("Workspace").EnemyCache:GetChildren()) do
		if not table.find(EnemiesList, v.Name) then
			table.insert(EnemiesList, v.Name)
		end
	end

	for i,v in pairs(game:GetService("ReplicatedStorage").Assets.Models.Npcs:GetChildren()) do
		table.insert(QuestsList, v.Name)
	end

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "🍓 Auto Collect Food",
		Default = false,
		Save = true,
		Flag = "AutoCollectFood",
		Callback = function(Value)
			FoodLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if FoodLooping then
				for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
					if v:GetAttribute("Type") == "Food" then
						game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectDrop:InvokeServer("Food")
						v:Destroy()
					end
				end
			end
		end
	end)

	Main:AddToggle({
		Name = "💰 Auto Collect Coins",
		Default = false,
		Save = true,
		Flag = "AutoCollectCoins",
		Callback = function(Value)
			CoinLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if CoinLooping then
				for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
					if v:GetAttribute("Type") == "Coins" then
						game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectDrop:InvokeServer("Coins")
						v:Destroy()
					end
				end
			end
		end
	end)

	Main:AddToggle({
		Name = "🥚 Auto Collect Eggs",
		Default = false,
		Save = true,
		Flag = "AutoCollectEggs",
		Callback = function(Value)
			EggLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if EggLooping then
				for i,v in pairs(game:GetService("Workspace").Drops:GetChildren()) do
					if v:GetAttribute("IsEgg") then
						game:GetService("ReplicatedStorage").Packages.Knit.Services.DropService.RF.CollectEgg:InvokeServer({["isShiny"] = v:GetAttribute("isShiny"), ["Type"] = v:GetAttribute("Type")})
						v:Destroy()
					end
				end
			end
		end
	end)

	local Enemies = Window:MakeTab({
		Name = "Enemies",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local EnemyDropdown = Enemies:AddDropdown({
		Name = "👾 Enemy",
		Options = EnemiesList,
		Save = true,
		Flag = "SelectedEnemy",
		Callback = function(Value)
			SelectedEnemy = Value
		end
	})

	Enemies:AddToggle({
		Name = "⚔ Auto Attack",
		Default = false,
		Save = true,
		Flag = "AutoAttack",
		Callback = function(Value)
			AttackLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if AttackLooping and SelectedEnemy then
				local CurrentNumber1 = math.huge
				local SelectedEnemy1

				for i,v in pairs(Player.PlayerGui.Billboards:GetChildren()) do
					if v.Adornee and v.Name == SelectedEnemy.." Health Tag" and v.Adornee:FindFirstChild("Spawn") and (Player.Character.HumanoidRootPart.Position - v.Adornee:FindFirstChildOfClass("MeshPart").Position).Magnitude < CurrentNumber1 then
						CurrentNumber1 = (Player.Character.HumanoidRootPart.Position - v.Adornee:FindFirstChildOfClass("MeshPart").Position).Magnitude
						SelectedEnemy1 = v
					end
				end

				if SelectedEnemy1 then
					game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.Attack:InvokeServer(SelectedEnemy1.Adornee.Spawn.Value)

					repeat task.wait() until not SelectedEnemy1:FindFirstChild("Health") or not AttackLooping
				end
			end
		end
	end)

	Enemies:AddButton({
		Name = "🔂 Refresh Enemy List",
		Callback = function()
			local NewTable = {}
			for i,v in pairs(game:GetService("Workspace").EnemyCache:GetChildren()) do
				if not table.find(NewTable, v.Name) then
					table.insert(NewTable, v.Name)
				end
			end

			EnemyDropdown:Refresh(NewTable, true)
		end    
	})

	local Pets = Window:MakeTab({
		Name = "Pets",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Pets:AddToggle({
		Name = "🥇 Auto Equip Best",
		Default = false,
		Save = true,
		Flag = "AutoEquipBest",
		Callback = function(Value)
			EquipLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if EquipLooping then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.EquipBest:InvokeServer()
			end
		end
	end)

	Pets:AddToggle({
		Name = "😋 Auto Feed",
		Default = false,
		Save = true,
		Flag = "AutoFeed",
		Callback = function(Value)
			FeedLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if FeedLooping then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.NestService.RF.Feed:InvokeServer()
			end
		end
	end)

	Pets:AddToggle({
		Name = "📈 Auto Upgrade Tier",
		Default = false,
		Save = true,
		Flag = "AutoUpgradeTier",
		Callback = function(Value)
			TierLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if TierLooping then
				for i,v in pairs(Player.PlayerGui.Main.backpack.ScrollingFrame:GetChildren()) do
					if v:IsA("ImageButton") then
						pcall(function()
							game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.TierPet:InvokeServer(v.Name)
						end)
					end
				end
			end
		end
	end)

	Pets:AddToggle({
		Name = "🐣 Auto Open Eggs",
		Default = false,
		Save = true,
		Flag = "AutoOpenEggs",
		Callback = function(Value)
			OpenLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if OpenLooping then
				for i,v in pairs(game:GetService("Workspace").Nests:FindFirstChild(Player.Name).Stands:GetChildren()) do
					if v:GetAttribute("Id") then
						game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.OpenEgg:InvokeServer(v:GetAttribute("Id"))
					end
				end
			end
		end
	end)

	Pets:AddToggle({
		Name = "🥚 Auto Place",
		Default = false,
		Save = true,
		Flag = "AutoPlace",
		Callback = function(Value)
			PlaceLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if PlaceLooping then
				for i,v in pairs(game:GetService("Workspace").Nests:FindFirstChild(Player.Name).Stands:GetChildren()) do
					if not v:GetAttribute("Egg") and not v:FindFirstChild("Lock") then
						local Button = Player.PlayerGui.Main.EggSelect.ScrollingFrame:FindFirstChildOfClass("ImageButton")
						if Button then
							game:GetService("ReplicatedStorage").Packages.Knit.Services.NestService.RF.PlaceEgg:InvokeServer(v, {["isShiny"] = Button.shinyIcon.Visible, ["Type"] = Button.Name:split("Shiny")[1]})
						end
					end
				end
			end
		end
	end)

	local Quest = Window:MakeTab({
		Name = "Quest",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Quest:AddDropdown({
		Name = "📜 Quest",
		Options = QuestsList,
		Save = true,
		Flag = "SelectedEnemy",
		Callback = function(Value)
			SelectedQuest = Value
		end
	})

	Quest:AddToggle({
		Name = "📝 Auto Quest",
		Default = false,
		Save = true,
		Flag = "AutoQuest",
		Callback = function(Value)
			QuestLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if QuestLooping and SelectedQuest then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.GiveQuest:InvokeServer(SelectedQuest)
				task.wait(1)
				game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.RedeemQuest:InvokeServer(SelectedQuest)
			end
		end
	end)

	Credits(Window)
elseif game.PlaceId == 10404327868 then
	local AttackLooping
	local OrbLooping
	local ChestLooping
	
	local CraftLooping
	local BestLooping

	local SelectedArea
	local SelectedLevel

	local BestDelay = 5

	local Areas = {}
	local Levels = {}

	repeat task.wait() until Player.Character:FindFirstChild("IS_GAME_AXE")

	local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
	local TreeService = Knit.GetService("TreeService")
	local PetService = Knit.GetService("PetService")
	local DamageRemote = TreeService.Damage._re
	local DataController = Knit.GetController("DataController")

	for i,v in pairs(game:GetService("Workspace").Scripts.Trees:GetChildren()) do
		table.insert(Areas, v.Name)
	end

	for i,v in pairs(game:GetService("Workspace").Scripts.Trees:FindFirstChild(Areas[1]):GetChildren()) do
		table.insert(Levels, v.Name)
	end

	local Window = CreateWindow()

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddDropdown({
		Name = "🏝 Area",
		Options = Areas,
		Save = true,
		Flag = "SelectedArea",
		Callback = function(Value)
			SelectedArea = Value
		end
	})

	Main:AddDropdown({
		Name = "🔢 Level",
		Options = Levels,
		Save = true,
		Flag = "SelectedLevel",
		Callback = function(Value)
			SelectedLevel = Value
		end
	})

	Main:AddToggle({
		Name = "🌲 Auto Attack Tree",
		Default = false,
		Save = true,
		Flag = "AutoAttack",
		Callback = function(Value)
			AttackLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if AttackLooping and SelectedArea and SelectedLevel then
				local CurrentTree = game:GetService("Workspace").Scripts.Trees:FindFirstChild(SelectedArea):FindFirstChild(SelectedLevel).Storage:GetChildren()[1]
				local SectionLooping = true

				while task.wait() and SectionLooping and AttackLooping do
					DamageRemote:FireServer(CurrentTree.Name)
					task.wait()
					pcall(function()
						if not game:GetService("Workspace").Scripts.Trees:FindFirstChild(SelectedArea):FindFirstChild(SelectedLevel).Storage:FindFirstChild(CurrentTree.Name) then
							SectionLooping = false
							print("gone")
						end
					end)
				end
			end
		end
	end)

	Main:AddToggle({
		Name = "🔮 Auto Collect Orbs",
		Default = false,
		Save = true,
		Flag = "AutoCollect",
		Callback = function(Value)
			OrbLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if OrbLooping then
				for i,v in pairs(game:GetService("Workspace").Scripts.Orbs.Storage:GetChildren()) do
					if v then
						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(v.Position)
						task.wait()
					end
				end
			end
		end
	end)
	
	Main:AddToggle({
		Name = "🧰 Auto Collect Chests",
		Default = false,
		Save = true,
		Flag = "AutoChest",
		Callback = function(Value)
			ChestLooping = Value
		end
	})
	
	task.spawn(function()
		while task.wait() do
			if ChestLooping and Player:IsInGroup(5522949) then
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Spawn.Spawn.Touch, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Spawn.Spawn.Touch, 1)
				
				if game:GetService("Workspace").Scripts.Areas.Atlantis.AtlantisChest:FindFirstChild("Touch") then
					firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Atlantis.AtlantisChest.Touch, 0)
					firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Atlantis.AtlantisChest.Touch, 1)
				end
				
				if game:GetService("Workspace").Scripts.Areas.Pixel.PixelChest:FindFirstChild("Touch") then
					firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Pixel.PixelChest.Touch, 0)
					firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Scripts.Areas.Pixel.PixelChest.Touch, 1)
				end
			end
		end
	end)

	local Pets = Window:MakeTab({
		Name = "Pets",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Pets:AddToggle({
		Name = "⚒ Auto Craft Pets",
		Default = false,
		Save = true,
		Flag = "AutoCraft",
		Callback = function(Value)
			CraftLooping = Value
		end
	})

	task.spawn(function()
		while task.wait() do
			if CraftLooping then
				PetService:CraftAll()
			end
		end
	end)

	Pets:AddToggle({
		Name = "🥇 Auto Equip Best",
		Default = false,
		Save = true,
		Flag = "AutoEquipBest",
		Callback = function(Value)
			BestLooping = Value
		end
	})

	task.spawn(function()
		while true do
			if BestLooping then
				local CurrentNumber1 = 0
				local CurrentNumber2 = 0
				local CurrentNumber3 = 0
				local CurrentPet1
				local CurrentPet2
				local CurrentPet3

				local PetData = DataController.data.Pets

				for i,v in pairs(PetData) do
					if v.multiplier > CurrentNumber1 then
						CurrentNumber1 = v.multiplier
						CurrentPet1 = i
					end
				end

				for i,v in pairs(PetData) do
					if v.multiplier > CurrentNumber2 and i ~= CurrentPet1 then
						CurrentNumber2 = v.multiplier
						CurrentPet2 = i
					end
				end

				for i,v in pairs(PetData) do
					if v.multiplier > CurrentNumber3 and i ~= CurrentPet1 and  i ~= CurrentPet2 then
						CurrentNumber3 = v.multiplier
						CurrentPet3 = i
					end
				end

				for i,v in pairs(PetData) do
					if v.equipped == true then
						PetService:Unequip(i)
					end
				end

				pcall(function()
					PetService:Equip(CurrentPet1)
					PetService:Equip(CurrentPet2)
					PetService:Equip(CurrentPet3)
				end)
			end
			task.wait(BestDelay)
		end
	end)

	Pets:AddSlider({
		Name = "🐌 Auto Equip Best Delay",
		Min = 0,
		Max = 60,
		Default = 5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		Save = true,
		Flag = "Delay",
		Callback = function(Value)
			BestDelay = Value
		end    
	})

	Credits(Window)
end

OrionLib:Init()
