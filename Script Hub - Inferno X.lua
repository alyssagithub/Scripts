if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()

repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

local promptOverlay = game:GetService("CoreGui").RobloxPromptGui.promptOverlay

promptOverlay.ChildAdded:connect(function(a)
	if a.Name == "ErrorPrompt" then
		while true do
			game:GetService("TeleportService"):Teleport(game.PlaceId)
			task.wait(2)
		end
	end
end)

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

if game.PlaceId == 9757510382 then
	local Sniping

	local Window = OrionLib:MakeWindow({Name = "Inferno X - Trade Simulator", HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Main:AddToggle({
		Name = "📈 New Item Sniper",
		Default = false,
		Save = true,
		Flag = "NewItemSniper",
		Callback = function(Value)
			Sniping = Value
			game.ReplicatedStorage.show.OnClientEvent:Connect(function(e, r, t, AssetId)
				print("new item remote called")
				if Sniping then
					print("sniping is true")
					for i = 1, 5 do
						print("buying new item")
						game:GetService("ReplicatedStorage").event:FireServer("buy", AssetId, 0, 0)
						print("bought new item")
						repeat task.wait() until Player.PlayerGui.gui.Frame.Message.BackgroundColor3 == Color3.fromRGB(0, 176, 111)
						repeat task.wait() until Player.PlayerGui.gui.Frame.Message.Text == "Purchase was successful!"
						print("waited until banner showed successful, redoing loop, "..tostring(i))
					end
				end
			end)
		end
	})

	Credits(Window)
elseif game.PlaceId == 9264596435 then
	local Plot
	local PlayerPlot

	local SavedPosition

	local SelectedHero
	local SelectedChest

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
	local IsInLoopMobTP
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
				repeat task.wait() until PlotDropdown ~= {"Your Own Plot"}
				PlotDropdown:Refresh(PlotList, true)
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
			repeat task.wait() until Dropdown
			Dropdown:Refresh({child.Name}, false)
		end
	end)

	local Window = OrionLib:MakeWindow({Name = "Inferno X - Idle Heroes Simulator", HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local Automatics = Main:AddSection({
		Name = "Misc Automatics"
	})

	Automatics:AddToggle({
		Name = "🤺 Auto Swing",
		Default = false,
		Save = true,
		Flag = "AutoSwing",
		Callback = function(Value)
			SwingLooping = Value
			while SwingLooping and task.wait(0.14) do
				repeat task.wait() until Player.Character:FindFirstChild("HumanoidRootPart")
				repeat task.wait() until Plot.Enemy:GetChildren()[1]

				if (Player.Character:FindFirstChild("HumanoidRootPart").Position - Plot.Enemy:GetChildren()[1].Position).Magnitude <= 13 then
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.Swing:FireServer(Plot.Enemy:GetChildren()[1])
				end
			end
		end
	})

	Automatics:AddToggle({
		Name = "🤺 Auto Swing 2",
		Default = false,
		Save = true,
		Flag = "AutoSwing2",
		Callback = function(Value)
			Swing2Looping = Value
			while Swing2Looping and task.wait(0.14) do
				repeat task.wait() until Player.Character:FindFirstChild("HumanoidRootPart")
				repeat task.wait() until Plot.Enemy:GetChildren()[1]

				if (Player.Character:FindFirstChild("HumanoidRootPart").Position - Plot.Enemy:GetChildren()[1].Position).Magnitude <= 13 then
					VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
					VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
				end
			end
		end
	})

	Automatics:AddToggle({
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
					elseif IsInLoopMobTP then
						repeat task.wait() until not IsInLoopMobTP
					elseif IsInLoopAutoHire then
						repeat task.wait() until not IsInLoopAutoHire
					end
					SavedPosition = Player.Character:WaitForChild("HumanoidRootPart").Position

					repeat task.wait() until Plot.Buttons:FindFirstChild("NextLevel"):FindFirstChild("Touch")

					local Pos = Plot.Buttons:FindFirstChild("NextLevel").Touch.Position
					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(Vector3.new(Pos.X, Pos.Y + 5, Pos.Z))

					repeat task.wait() until not Plot.Buttons:FindFirstChild("NextLevel")

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)
					IsInLoopNextLevel = false
				end
			end
		end    
	})

	Automatics:AddToggle({
		Name = "🔁 Auto Reincarnate",
		Default = false,
		Save = true,
		Flag = "AutoReincarnate",
		Callback = function(Value)
			ReincarnateLooping = Value
			while ReincarnateLooping and task.wait() do
				if Player.PlayerGui.Main.Top.Wave.Wave.Text == "1/1" and Player.PlayerGui.Main.Top.Level.Text == "Level 100" then
					IsInLoopReincarnate = true
					if IsInLoopNextLevel then
						repeat task.wait() until not IsInLoopNextLevel
					elseif IsInLoopMobTP then
						repeat task.wait() until not IsInLoopMobTP
					elseif IsInLoopAutoHire then
						repeat task.wait() until not IsInLoopAutoHire
					end
					SavedPosition = Player.Character:WaitForChild("HumanoidRootPart").Position
					task.wait()
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToMain:FireServer()

					task.wait(1)

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2041, 59, -26)

					repeat task.wait() until Player.PlayerGui.Main.Frames.Reincarnate.Visible == true

					repeat
						game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.Reincarnate:FireServer()
						task.wait(1)
					until Player.PlayerGui.Main.ChestOpening.Visible == true

					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToPlot:FireServer(Plot.Owner.Value)

					Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)
					IsInLoopReincarnate = false
				end
			end
		end
	})

	Automatics:AddToggle({
		Name = "⚡ Auto Mob TP",
		Default = false,
		Save = true,
		Flag = "AutoMobTP",
		Callback = function(Value)
			MobLooping = Value
			while MobLooping and task.wait() do
				repeat task.wait() until Plot.Enemy:GetChildren()[1]
				local Enemy = Plot.Enemy:GetChildren()[1]
				IsInLoopMobTP = true
				if IsInLoopReincarnate then
					repeat task.wait() until not IsInLoopReincarnate
				elseif IsInLoopNextLevel then
					repeat task.wait() until not IsInLoopNextLevel
				elseif IsInLoopAutoHire then
					repeat task.wait() until not IsInLoopAutoHire
				end
				Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(Enemy.Position.X, Enemy.Position.Y, Enemy.Position.Z + 5)
				IsInLoopMobTP = false
			end
		end
	})

	Automatics:AddToggle({
		Name = "⚔ Auto Use Skills",
		Default = false,
		Save = true,
		Flag = "AutoUseSkills",
		Callback = function(Value)
			SkillLooping = Value
			while SkillLooping and task.wait() do
				for i,v in pairs({"Enraged", "Eruption", "Misfortune", "Golden Rain", "Gold Potion", "Cold Runes", "Enlightenment", "Insight", "Replenish"}) do
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.UseSkill:FireServer(v)
					task.wait(.5)
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
				if not game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") and not Plot.Heroes:FindFirstChild("The Reaper") then
					IsInLoopAutoHire = true
					if IsInLoopMobTP then
						repeat task.wait() until not IsInLoopMobTP
					elseif IsInLoopReincarnate then
						repeat task.wait() until not IsInLoopReincarnate
					elseif IsInLoopNextLevel then
						repeat task.wait() until not IsInLoopNextLevel
					end
					IsInLoopAutoHire = true
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToMain:FireServer()

					repeat task.wait() until game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") or Plot.Heroes:FindFirstChild("The Reaper")

					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToPlot:FireServer(Plot.Owner.Value)
					IsInLoopAutoHire = false
				end

				if game:GetService("Workspace").Main.Hire:FindFirstChild("_displayHero") then
					if tostring(game:GetService("Workspace").Main.Hire["_displayHero"].Highlight.OutlineColor) == "0.215686, 1, 0.266667" then
						IsInLoopAutoHire = true
						if IsInLoopMobTP then
							repeat task.wait() until not IsInLoopMobTP
						elseif IsInLoopReincarnate then
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
				end
			end
		end
	})

	Dropdown = Heroes:AddDropdown({
		Name = "📃 Hero to Upgrade (leave blank for all)",
		Default = "None",
		Options = HeroesList,
		Save = true,
		Flag = "SelectedHero",
		Callback = function(Value)
			if Value == "None" then
				SelectedHero = nil
			else
				SelectedHero = Value
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

	local function Upgrade(Hero)
		if tonumber(Hero:WaitForChild("Head").Nametag.Level.Text:split("Level ")[2]) <= UpgradeLevel - 1 then
			if game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RF.BuyLevel:InvokeServer(Hero.Name, 0) then
				print("Upgraded "..Hero.Name)
			end
		end
	end

	Heroes:AddToggle({
		Name = "📈 Auto Upgrade Hero(es)",
		Default = false,
		Save = true,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
			if UpgradeLooping then
				while UpgradeLooping and task.wait() do
					if #Plot.Heroes:GetChildren() > 0 then
						if SelectedHero and Plot.Heroes:FindFirstChild(SelectedHero) then
							Upgrade(Plot.Heroes:FindFirstChild(SelectedHero))
						else
							for i,v in pairs(Plot.Heroes:GetChildren()) do
								Upgrade(v)
							end
						end
					end
				end
			end
		end
	})

	local Chests = Main:AddSection({
		Name = "Chests"
	})


	Chests:AddDropdown({
		Name = "📦 Chest to Purchase",
		Options = {"Wooden", "Silver", "Golden", "Legendary"},
		Save = true,
		Flag = "SelectedChest",
		Callback = function(Value)
			SelectedChest = Value
		end
	})

	Chests:AddToggle({
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

	local Misc = Window:MakeTab({
		Name = "Misc",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	PlotDropdown = Misc:AddDropdown({
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

	Credits(Window)
elseif game.PlaceId == 10779604733 then
	local AutoClickLooping
	local AutoCaseLooping
	local MouseButton2Looping
	local AutoBattleLooping

	local OriginalAutoClickLooping

	local CaseBattlesAmount

	local CaseList = {}
	local DoneList = {}

	local SelectedCase

	local function SetCaseList()
		for i,v in pairs(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:GetChildren()) do
			if v:IsA("Frame") then
				table.insert(CaseList, v.Name)
			end
		end

		Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"].ChildAdded:Connect(function(v)
			table.insert(CaseList, v.Name)
		end)
		table.sort(CaseList, function(a, b)
			return a < b
		end)
	end

	if #Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:GetChildren() == 2 then
		if Player.PlayerGui["Interact_Gui"]["Background_Frame"].Visible == false then
			Click(Player.PlayerGui["Interact_Gui"]["Frame_Switch"])

			task.wait(.25)
		end

		if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"].Visible == false then
			Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Top_Bar"]["Holding_Frame"]["Button_Games"])

			task.wait(.25)
		end

		Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"]["Game_Category_1"]["Game_Cases"]["Icon_Game"])

		task.wait(1)

		task.spawn(SetCaseList)
	else
		task.spawn(SetCaseList)
	end

	local Window = OrionLib:MakeWindow({Name = "Inferno X - VBet", HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})

	local Main = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local function StartClicking()
		AutoClickLooping = OriginalAutoClickLooping
		task.spawn(function()
			while AutoClickLooping and task.wait() do
				Click(Player.PlayerGui["Interact_Gui"].Cash["Icon_Click"])
			end
		end)
	end

	Main:AddToggle({
		Name = "🖱 Auto Clicker",
		Default = false,
		Save = true,
		Flag = "AutoClick",
		Callback = function(Value)
			AutoClickLooping = Value
			OriginalAutoClickLooping = Value
			StartClicking()
		end
	})

	Main:AddLabel("Press right click once to temp disable the auto clicker.")

	task.spawn(function()
		Main:AddDropdown({
			Name = "📃 Case",
			Options = CaseList,
			Save = true,
			Flag = "SelectedCase",
			Callback = function(Value)
				SelectedCase = Value
			end
		})

		Main:AddSlider({
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

		Main:AddToggle({
			Name = "💼 Auto Case Open",
			Default = false,
			Save = true,
			Flag = "AutoCaseOpen",
			Callback = function(Value)
				AutoCaseLooping = Value
				if AutoCaseLooping then
					while AutoCaseLooping and SelectedCase and task.wait() do
						local CaseMoney = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:FindFirstChild(SelectedCase):FindFirstChild("Title_Price").Text:gsub("%p", "")
						local PlayerMoney = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Robux_Amount"].Text:gsub("%p", "")
						if tonumber(CaseMoney) <= tonumber(PlayerMoney) then
							AutoClickLooping = false
							while not Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Case_Prompt"].Visible do
								Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]
								task.wait()
								Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]:FindFirstChild(SelectedCase):FindFirstChild("Icon_Case"))
								task.wait()
								Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Cases"]["Scrolling_Frame_1"]
							end

							while Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Case_Prompt"].Visible and task.wait() do
								Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Case_Prompt"]["Button_Buy"])
							end

							StartClicking()
							repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Unboxing_Frame"]["Button_Claim"].Visible == true
							AutoClickLooping = false
							while Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Unboxing_Frame"].Visible and task.wait() do
								Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Unboxing_Frame"]["Button_Claim"])
							end
						elseif OriginalAutoClickLooping and not AutoClickLooping and not MouseButton2Looping then
							StartClicking()
						end
					end
				elseif AutoClickLooping == false then
					StartClicking()
				end
			end
		})

		Main:AddToggle({
			Name = "🤖 Auto Case Battle",
			Default = false,
			Save = true,
			Flag = "AutoCaseBattle",
			Callback = function(Value)
				AutoBattleLooping = Value
				while AutoBattleLooping and task.wait() do
					AutoClickLooping = false
					if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"].Visible == false then
						if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"].Visible == false then
							Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Top_Bar"]["Holding_Frame"]["Button_Games"])

							task.wait(.25)
						end

						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"]["Game_Category_1"]["Game_Battles"])

						repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"].Visible == true
					end

					Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]["Button_Create"])

					repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"].Visible == true

					repeat
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Add"])

						repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"].Visible == true

						Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]

						task.wait()

						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]:FindFirstChild(SelectedCase))

						task.wait()

						Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]["Scrolling_Frame_4"]					
					until #Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Battle_Frame"]["Scrolling_Frame_4"]:GetChildren() >= CaseBattlesAmount

					repeat task.wait(1) until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"].Visible == false

					repeat
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Create"])
						task.wait(1)
					until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"].Visible == false

					for i,v in pairs(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]["Scrolling_Frame_4"]:GetChildren()) do
						if v:IsA("Frame") and v.Host.Value == game.Players.LocalPlayer.Name then
							Click(v["Button_View"])

							repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name).Visible == true

							Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name)["Player_List"]["Player_2"]["Button_Call"])

							repeat task.wait() until not Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name)

							Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"].Visible = true
						end
					end

					StartClicking()
				end
			end
		})

		Main:AddToggle({
			Name = "🛑 (Experimental) Infinite Battles",
			Default = false,
			--Save = true,
			--Flag = "AutoCaseBattle",
			Callback = function(Value)
				AutoBattleLooping = Value
				while AutoBattleLooping and task.wait() do
					AutoClickLooping = false
					if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"].Visible == false then
						if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"].Visible == false then
							Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Top_Bar"]["Holding_Frame"]["Button_Games"])

							task.wait(.25)
						end

						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Game_Selection"]["Game_Category_1"]["Game_Battles"])

						repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"].Visible == true
					end

					Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]["Button_Create"])

					repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"].Visible == true

					if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Mode"].Text ~= "1v1v1" then
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Mode"])
						task.wait(.25)
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Mode"])
						task.wait(.25)
					end
					if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Crazy"].Text ~= "Crazy On" then
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Crazy"])
					end

					repeat
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Add"])
						task.wait(1)
					until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"].Visible == true or not AutoBattleLooping

					Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]

					task.wait()

					Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]:FindFirstChild(SelectedCase))

					task.wait()

					Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]:FindFirstChild(SelectedCase).Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"]["Scrolling_Frame_4"]			

					repeat
						if Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Battle_Frame"]["Scrolling_Frame_4"]:GetChildren()[2] then
							Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Battle_Frame"]["Scrolling_Frame_4"]:GetChildren()[2]["Button_Add"])
						end
						task.wait()
					until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"].Rounds.Value >= CaseBattlesAmount

					repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Add_Case_Prompt"].Visible == false

					repeat
						Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"]["Button_Create"])
						task.wait(.3)
					until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Battle_Prompt"].Visible == false or not AutoBattleLooping

					for i,v in pairs(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]["Scrolling_Frame_4"]:GetChildren()) do
						if v:IsA("Frame") and v.Host.Value == game.Players.LocalPlayer.Name and not table.find(DoneList, v.Name) and AutoBattleLooping then
							v.Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]
							task.wait(.5)
							Click(v["Button_View"])
							task.wait(.5)
							v.Parent = Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]["Game_Battles"]["Scrolling_Frame_4"]

							repeat task.wait() until Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name).Visible == true

							for i,v in pairs(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name)["Player_List"]:GetChildren()) do
								if v:IsA("Frame") and v:FindFirstChild("Button_Call") then
									Click(v["Button_Call"])
									task.wait(.25)
								end
							end

							Click(Player.PlayerGui["Interact_Gui"]["Background_Frame"]["Games_Holder"]:FindFirstChild(v.Name)["Button_Games_List"])

							task.wait(.25)

							table.insert(DoneList, v.Name)
						end
					end
				end
			end
		})

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
	end)

	Player:GetMouse().Button2Down:Connect(function()
		MouseButton2Looping = true
		AutoClickLooping = false
		task.wait(3)
		if not AutoCaseLooping then
			StartClicking()
		end
		MouseButton2Looping = false
	end)

	Credits(Window)
elseif game.PlaceId == 10925589760 then
	local Plot = workspace.Plots:FindFirstChild(Player.Name)

	local AutoTapLooping
	local AutoMergeLooping
	local AutoUpgradeLooping
	local AutoObbyLooping
	local AutoRebirthLooping
	local InfObbyMultiLooping

	local OriginalAutoMergeLooping

	local Blocks = {}

	local Window = OrionLib:MakeWindow({Name = "Inferno X - Merge Simulator", HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})

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
				firesignal(Player.PlayerGui.World.Wall.Upgrades.SpawnTier.Buy.Activated)
				task.wait()
				firesignal(Player.PlayerGui.World.Wall.Upgrades.MaxBlocks.Buy.Activated)
				task.wait()
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Cooldown.Buy.Activated)
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
			while AutoRebirthLooping and task.wait(1) do
				game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
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
			while InfObbyMultiLooping and task.wait(1) do
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 1)
			end
		end
	})

	Credits(Window)
end

OrionLib:Init()
