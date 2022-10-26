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

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

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
	print("Clicked "..v.Name)
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

	local IsInLoopReincarnate
	local IsInLoopNextLevel
	local IsInLoopAutoHire

	local HeadPosition

	local CurrentPage

	local HeroesList = {"None"}
	local PlotList = {"Your Own Plot"}

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
		Flag = "AutoSwing2",
		Callback = function(Value)
			Swing2Looping = Value
			while Swing2Looping do
				VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 1)
				VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 1)
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
						Player.Character:WaitForChild("HumanoidRootPart").CFrame = Plot.Buttons:FindFirstChild("NextLevel").Touch.CFrame
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

	Main:AddToggle({
		Name = "🔁 Auto Reincarnate",
		Default = false,
		Save = true,
		Flag = "AutoReincarnate",
		Callback = function(Value)
			ReincarnateLooping = Value
			while ReincarnateLooping and task.wait() do
				if Player.PlayerGui.Main.Top.Wave.Wave.Text == "1/1" and tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) == RequiredLevel and Player.PlayerGui.Main.Top.Level.Text:split(" ")[3] ~= "Complete!" then
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
						task.wait(.1)
					until Player.PlayerGui.Main.ChestOpening.Visible == true

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)

					IsInLoopReincarnate = false
				elseif tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) > RequiredLevel or tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) == RequiredLevel and Player.PlayerGui.Main.Top.Level.Text:split(" ")[3] == "Complete!" then
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
					task.wait(.5)
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
				if game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") then
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

						task.wait(.5)

						game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.HireHero:FireServer(game:GetService("Workspace").Main.Hire["_displayHero"].Head.Nametag.Subject.Text)

						task.wait(.5)

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

					repeat task.wait() until game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero")

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

	local Chest = Window:MakeTab({
		Name = "Chest",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Chest:AddDropdown({
		Name = "📦 Chest to Purchase",
		Options = {"Wooden", "Silver", "Golden", "Legendary"},
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
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.ChestService.RF.BuyChest:InvokeServer(SelectedChest)
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

		task.spawn(SetCaseList)
	else
		task.spawn(SetCaseList)
	end

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
			Name = "💼 Auto Case Open",
			Default = false,
			Save = true,
			Flag = "AutoCaseOpen",
			Callback = function(Value)
				AutoCaseLooping = Value
				if AutoCaseLooping then
					while AutoCaseLooping and SelectedCase and task.wait() do
						local CaseMoney = Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:FindFirstChild(SelectedCase):FindFirstChild("Title_Price").Text:gsub("%p", "")
						local PlayerMoney = Background["Robux_Amount"].Text:gsub("%p", "")
						if tonumber(CaseMoney) <= tonumber(PlayerMoney) then
							AutoClickLooping = false
							while not Background["Games_Holder"]["Case_Prompt"].Visible do
								Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:FindFirstChild(SelectedCase).Parent = Background["Games_Holder"]["Game_Cases"]
								task.wait()
								Click(Background["Games_Holder"]["Game_Cases"]:FindFirstChild(SelectedCase):FindFirstChild("Icon_Case"))
								task.wait()
								Background["Games_Holder"]["Game_Cases"]:FindFirstChild(SelectedCase).Parent = Background["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]
							end

							while Background["Games_Holder"]["Case_Prompt"].Visible and task.wait() do
								Click(Background["Games_Holder"]["Case_Prompt"]["Button_Buy"])
							end

							AutoClickLooping = OriginalAutoClickLooping

							repeat task.wait() until Background["Unboxing_Frame"]["Button_Claim"].Visible == true

							AutoClickLooping = false

							while Background["Unboxing_Frame"].Visible and task.wait() do
								Click(Background["Unboxing_Frame"]["Button_Claim"])
							end
						elseif OriginalAutoClickLooping and not AutoClickLooping and not MouseButton2Looping then
							AutoClickLooping = OriginalAutoClickLooping
						end
					end
				elseif AutoClickLooping == false then
					AutoClickLooping = OriginalAutoClickLooping
				end
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
end

OrionLib:Init()
