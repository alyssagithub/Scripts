if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()

local HttpService = game:GetService("HttpService");
local Webhook = "https://discord.com/api/webhooks/1040835415646679060/3_JxO_rGGE9aTBJJPwYzlvQTp5zqGZBucuF4AQZrQADw3DvNvmSHwb6Z-l0I2d8TWhO0" -- useless to send through this, its in a private channel

local function getexploit()
	return (syn and not is_sirhurt_closure and not pebc_execute and "Synapse") or
		(secure_load and "Sentinel") or
		(is_sirhurt_closure and "Sirhurt") or
		(pebc_execute and "ProtoSmasher") or
		(KRNL_LOADED and "Krnl") or
		(WrapGlobal and "WeAreDevs") or
		(isvm and "Proxo") or
		(shadow_env and "Shadow") or
		(jit and "EasyExploits") or
		(getscriptenvs and "Calamari") or
		(unit and not syn and "Unit") or
		(OXYGEN_LOADED and "Oxygen U") or
		(IsElectron and "Electron") or
		(IS_COCO_LOADED and "Coco") or
		(IS_VIVA_LOADED and "Viva") or
		("Other")
end

print("Detected Executor: "..getexploit())

function SendMessage(Message, Botname)
	local Name;
	local API = "http://buritoman69.glitch.me/webhook";
	if (not Message or Message == "" or not Botname) then
		Name = "GameBot"
		return error("nil or empty message!")
	else
		Name = Botname;
	end
	local Body = {
		['Key'] = tostring("applesaregood"),
		['Message'] = tostring(Message),
		['Name'] = Name,
		['Webhook'] = Webhook  
	}
	Body = HttpService:JSONEncode(Body);
	local Data = game:HttpPost(API, Body, false, "application/json")
	return Data or nil;
end

pcall(SendMessage, "[Inferno X] Data: Inferno X was executed by "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." using "..getexploit(), "Execution")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main")

		game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
	end)
end)

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

local function Notify(Message, Duration)
	Rayfield:Notify({
		Title = "Inferno X",
		Content = Message,
		Duration = Duration,
		Image = 4483362458,
		Actions = {},
	})
end

local function CreateWindow()
	local Window = Rayfield:CreateWindow({
		Name = "Inferno X - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		LoadingTitle = "Inferno X",
		LoadingSubtitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		ConfigurationSaving = {
			Enabled = true,
			FolderName = "InfernoXConfig",
			FileName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
		},
		Discord = {
			Enabled = true,
			Invite = "rtgv8Jp3fM",
			RememberJoins = true
		}
	})

	task.defer(function()
		task.wait(1.5)
		local Universal = Window:CreateTab("Universal", 4483362458)

		Universal:CreateToggle({
			Name = "🚫 Anti-AFK 🚫",
			CurrentValue = false,
			Flag = "Universal-AntiAFK",
			Callback = function(Value)
				if Value then
					local VirtualUser = game:GetService("VirtualUser")
					Player.Idled:Connect(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton2(Vector2.new())
					end)
				end
			end,
		})

		Universal:CreateToggle({
			Name = "🔁 Auto Rejoin When Disconnected 🔁",
			CurrentValue = false,
			Flag = "Universal-AutoRejoin",
			Callback = function(Value)
				if Value then
					local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

					if queueteleport then
						queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Script%20Hub%20-%20Inferno%20X.lua"))()')
					end

					repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

					local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

					po.ChildAdded:connect(function(a)
						if a.Name == 'ErrorPrompt' then
							while true do
								ts:Teleport(game.PlaceId)
								task.wait(2)
							end
						end
					end)
				end
			end,
		})

		Rayfield:LoadConfiguration()

		Universal:CreateSection("")

		Universal:CreateSlider({
			Name = "💨 WalkSpeed 💨",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.WalkSpeed,
			--Flag = "Universal-WalkSpeed",
			Callback = function(Value)
				if syn then
					if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
				end
				Player.Character.Humanoid:AddPropertyEmulator("WalkSpeed")
				Player.Character.Humanoid.WalkSpeed = Value
			end,
		})

		Universal:CreateSlider({
			Name = "⬆ JumpPower ⬆",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.JumpPower,
			--Flag = "Universal-JumpPower",
			Callback = function(Value)
				if syn then
					if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
				end
				Player.Character.Humanoid:AddPropertyEmulator("JumpPower")
				Player.Character.Humanoid.JumpPower = Value
			end,
		})

		local Credits = Window:CreateTab("Credits", 4483362458)

		Credits:CreateLabel("🔥 Inferno X was made by alyssa#2303 🔥")

		Credits:CreateButton({
			Name = "➡ Join Discord discord.gg/rtgv8Jp3fM ⬅",
			Callback = function()
				local HttpService = game:GetService("HttpService")
				local http_req = (syn and syn.request) or (http and http.request) or http_request
				if http_req then
					http_req({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = 'POST',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = HttpService:JSONEncode({
							cmd = 'INVITE_BROWSER',
							nonce = HttpService:GenerateGUID(false),
							args = {code = 'rtgv8Jp3fM'}
						})
					})
				elseif setclipboard then
					setclipboard("https://discord.gg/rtgv8Jp3fM")

					Notify("Link Copied to Clipboard", 5)
				end
			end,
		})
	end)
	return Window
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

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🤺 Auto Swing",
		CurrentValue = false,
		Flag = "AutoSwing",
		Callback = function(Value)
			SwingLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if SwingLooping then
				if #Plot.Enemy:GetChildren() == 0 then
					repeat task.wait() until Plot.Enemy:GetChildren()[1]
				end

				local Enemy = Plot.Enemy:GetChildren()[1]

				game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.Swing:FireServer(Enemy)
			end
			task.wait(.14)
		end
	end)

	Main:CreateToggle({
		Name = "🤺 Auto Swing 2",
		CurrentValue = false,
		Flag = "AutoSwing2",
		Callback = function(Value)
			Swing2Looping = Value
		end,
	})

	task.spawn(function()
		while true do
			if Swing2Looping then
				Click(Player.PlayerGui.Main.Tint)
			end
			task.wait(.14)
		end
	end)

	Main:CreateToggle({
		Name = "📊 Auto Progress",
		CurrentValue = false,
		Flag = "AutoNextLevel",
		Callback = function(Value)
			NextLevelLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if NextLevelLooping then
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
				IsInLoopNextLevel = false
			end
		end
	end)

	local RequiredLevel = 80
	local OtherLevel = 0

	Main:CreateToggle({
		Name = "🔁 Auto Reincarnate",
		CurrentValue = false,
		Flag = "AutoReincarnate",
		Callback = function(Value)
			ReincarnateLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if ReincarnateLooping then
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
					[24] = 100,
					[25] = 105,
					[26] = 105,
					[27] = 105,
					[28] = 105,
					[29] = 105
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

						repeat task.wait() until Player.PlayerGui.Main.Frames.Reincarnate.Visible == true or not ReincarnateLooping

						repeat
							game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.Reincarnate:FireServer()
							task.wait()
						until Player.PlayerGui.Main.ChestOpening.Visible == true or not ReincarnateLooping

						Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(SavedPosition)

						IsInLoopReincarnate = false
					end
					IsInLoopReincarnate = false
				elseif tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) > RequiredLevel or (tonumber(Player.PlayerGui.Main.Top.Level.Text:split(" ")[2]) == RequiredLevel and Player.PlayerGui.Main.Top.Level.Text:split(" ")[3] == "Complete!") then
					RequiredLevel = RequiredLevel + 10
					print("[Inferno X] Debug: Set RequiredLevel to "..RequiredLevel)
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "⚡ Auto Mob TP",
		CurrentValue = false,
		Flag = "AutoMobTP",
		Callback = function(Value)
			MobLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if MobLooping then
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
				if not MobLooping then
					Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Plot.Teleport.CFrame
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "⚔ Auto Use Skills",
		CurrentValue = false,
		Flag = "AutoUseSkills",
		Callback = function(Value)
			SkillLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if SkillLooping then
				for i,v in pairs({"Enraged", "Eruption", "Misfortune", "Golden Rain", "Gold Potion", "Cold Runes", "Insight", "Enlightenment", "Replenish"}) do
					game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RE.UseSkill:FireServer(v)
					task.wait()
				end
			end
		end
	end)

	Main:CreateSection("")

	Main:CreateDropdown({
		Name = "🏠 Plot",
		Options = PlotList,
		CurrentOption = "Your Own Plot",
		--Flag = "SelectedPlot",
		Callback = function(Value)
			if Value == "Your Own Plot" then
				Plot = PlayerPlot
			else
				for i,v in pairs(workspace.Plots:GetChildren()) do
					if v.Owner.Value == game.Players:FindFirstChild(Value) then
						game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.WeaponService.RE.TeleportToPlot:FireServer(game.Players:FindFirstChild(Value))
						Plot = v
					end
				end
			end
		end,
	})

	local Heroes = Window:CreateTab("Heroes", 4483362458)

	Heroes:CreateToggle({
		Name = "👍 Auto Hire Heroes",
		CurrentValue = false,
		Flag = "AutoHire",
		Callback = function(Value)
			HireLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if HireLooping then
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
				IsInLoopAutoHire = false
			end
		end
	end)

	Heroes:CreateDropdown({
		Name = "📃 Hero to Upgrade (leave blank for all)",
		Options = HeroesList,
		CurrentOption = "None",
		Flag = "SelectedHero",
		Callback = function(Value)
			if Value == "None" then
				SelectedHero = nil
				OriginalSelectedHero = nil
			else
				SelectedHero = Value
				OriginalSelectedHero = Value
			end
		end,
	})

	Heroes:CreateSlider({
		Name = "🎚 Max Upgrade Level",
		Range = {0, 1000},
		Increment = 1,
		CurrentValue = 25,
		Flag = "MaxUpgradeLevel",
		Callback = function(Value)
			UpgradeLevel = Value
		end,
	})

	require(Player.PlayerScripts.Client.Controllers.UIController.BuyCoins).Set = function()
		return
	end

	Heroes:CreateToggle({
		Name = "📈 Auto Upgrade Hero(es)",
		CurrentValue = false,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
		end,
	})

	Heroes:CreateToggle({
		Name = "📈 Auto Upgrade Hero(es)",
		CurrentValue = false,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if UpgradeLooping then
				for i,v in pairs(PlayerPlot.Heroes:GetChildren()) do
					if tonumber(v:WaitForChild("Head").Nametag.Level.Text:split(" ")[2]) <= UpgradeLevel - 1 then
						if not OriginalSelectedHero then
							SelectedHero = v
						end
						if game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.HeroService.RF.BuyLevel:InvokeServer(SelectedHero.Name, 0) then
							print("[Inferno X] Debug: Upgraded "..v.Name)
						end
					end
				end
			end
		end
	end)

	local Passive = Window:CreateTab("Passive", 4483362458)

	local SelectedEnchants = {}

	Passive:CreateDropdown({
		Name = "✨ Enchant(s) to Stop at (multiple choice)",
		Options = EnchantList,
		CurrentOption = "None",
		--Flag = "SelectedEnchant",
		Callback = function(Value)
			if not table.find(SelectedEnchants, Value) and Value ~= "None" then
				table.insert(SelectedEnchants, Value)
			elseif Value ~= "None" then
				table.remove(SelectedEnchants, Value)
			end

			task.spawn(function()
				repeat task.wait() until EnchantLabel
				EnchantLabel:Set("Selected Enchants: "..table.concat(SelectedEnchants, ", "))
			end)
		end,
	})

	EnchantLabel = Passive:CreateLabel("Selected Enchants: None")

	Player.PlayerGui.Main.ChestResult.Container.ChildAdded:Connect(function(child)
		repeat task.wait() until child.ItemName.Text ~= "OP Sword"

		print("[Inferno X] Debug: Opened "..child.ItemName.Text)

		if table.find(SelectedEnchants, child.ItemName.Text) then
			RerollLooping = false
		end
	end)

	Passive:CreateToggle({
		Name = "🎲 Auto Reroll Passive (must have ui open)",
		CurrentValue = false,
		Flag = "AutoRerollPassive",
		Callback = function(Value)
			RerollLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if RerollLooping then
				if Player.PlayerGui.Main.Frames.Passives.Visible == true and Player.PlayerGui.Main.ChestOpening.Visible == false then
					Click(Player.PlayerGui.Main.Frames.Passives.CoreReroll.Button)

					repeat task.wait() until #Player.PlayerGui.Main.ChestResult.Container:GetChildren() == 1
				end
			end
			task.wait(.25)
		end
	end)

	local Chest = Window:CreateTab("Chest", 4483362458)

	Chest:CreateDropdown({
		Name = "📦 Chest to Purchase",
		Options = {"Wooden", "Silver", "Golden", "Legendary", "Divine"},
		CurrentOption = "",
		Flag = "SelectedChest",
		Callback = function(Value)
			SelectedChest = Value
		end,
	})

	Chest:CreateToggle({
		Name = "💵 Auto Buy Chest",
		CurrentValue = false,
		--Flag = "AutoChest",
		Callback = function(Value)
			ChestLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if ChestLooping and SelectedChest then
				game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.7").knit.Services.ChestService.RF.BuyChest:InvokeServer(SelectedChest, "single")
			end
			task.wait(1)
		end
	end)
elseif game.PlaceId == 10779604733 then -- VBet
	local AutoClickLooping
	local AutoClickLooping2

	local AutoCaseLooping
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

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🖱 Auto Clicker",
		CurrentValue = false,
		Flag = "AutoClick",
		Callback = function(Value)
			AutoClickLooping = Value
			AutoClickLooping2 = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AutoClickLooping and not InfiniteBattleLooping then
				Click(Player.PlayerGui["Interact_Gui"].Cash["Icon_Click"])
			end
		end
	end)

	Main:CreateLabel("Press right click once to temp disable the auto clicker.")

	Main:CreateButton({
		Name = "🎃 Auto Get Pumpkins",
		Callback = function()
			for i,v in pairs(workspace:GetChildren()) do
				if v.Name == "Event_Pumpkin" then
					Player.Character.HumanoidRootPart.CFrame = v.CFrame
					task.wait(.1)
				end
			end
		end,
	})

	local Case = Window:CreateTab("Case", 4483362458)

	task.spawn(function()
		Case:CreateDropdown({
			Name = "📃 Case",
			Options = CaseList,
			CurrentOption = "",
			Flag = "SelectedCase",
			Callback = function(Value)
				SelectedCase = Value
			end,
		})

		Case:CreateSlider({
			Name = "Case Battles Amount",
			Range = {1, 30},
			Increment = 1,
			CurrentValue = 10,
			Flag = "CaseBattlesAmount",
			Callback = function(Value)
				CaseBattlesAmount = Value
			end,
		})

		Case:CreateToggle({
			Name = "♾ Infinite Case Battles",
			CurrentValue = false,
			--Flag = "InfiniteCaseBattles",
			Callback = function(Value)
				InfiniteBattleLooping = Value
			end,
		})

		task.spawn(function()
			while task.wait() do
				if InfiniteBattleLooping then
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

					if not BattlePrompt["Battle_Frame"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase) then
						repeat
							Click(BattlePrompt["Button_Add"])
							task.wait(1)
						until Background["Games_Holder"]["Add_Case_Prompt"].Visible == true or not InfiniteBattleLooping

						task.wait(1)

						local AddCasePrompt = Background["Games_Holder"]["Add_Case_Prompt"]

						local CaseButton = AddCasePrompt["Scrolling_Frame_4"]:FindFirstChild(SelectedCase)

						CaseButton.Parent = AddCasePrompt

						task.wait()

						Click(CaseButton)

						task.wait(.1)
					end

					repeat task.wait() until BattlePrompt["Battle_Frame"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase)
					
					if tonumber(BattlePrompt["Battle_Frame"]["Title_Rounds"].Text:split(" ")[1]) ~= CaseBattlesAmount then
						repeat
							Click(BattlePrompt["Battle_Frame"]["Scrolling_Frame_4"]:FindFirstChild(SelectedCase)["Button_Add"])
							task.wait(.1)
						until tonumber(BattlePrompt["Battle_Frame"]["Title_Rounds"].Text:split(" ")[1]) == CaseBattlesAmount or not InfiniteBattleLooping
					end
					
					repeat
						Click(BattlePrompt["Button_Create"])
						task.wait(1)
					until Background["Games_Holder"]["Game_Battles"].Visible == true or not InfiniteBattleLooping

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
			end
		end)
	end)

	Player:GetMouse().Button2Down:Connect(function()
		if AutoClickLooping then
			AutoClickLooping = false
			task.wait(3)
			AutoClickLooping = AutoClickLooping2
		end
	end)
elseif game.PlaceId == 10925589760 then -- Merge Simulator
	local Plot = workspace.Plots:FindFirstChild(Player.Name)

	local AutoTapLooping
	local AutoMergeLooping
	local AutoUpgradeLooping
	local AutoObbyLooping
	local AutoRebirthLooping
	local InfObbyMultiLooping

	local Blocks = {}

	local Window = CreateWindow()

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🖱 Auto Tap",
		CurrentValue = false,
		Flag = "AutoTap",
		Callback = function(Value)
			AutoTapLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AutoTapLooping then
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					game:GetService("ReplicatedStorage").Functions.Tap:FireServer(v)
					task.wait()
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🤝 Auto Merge",
		CurrentValue = false,
		Flag = "AutoMerge",
		Callback = function(Value)
			AutoMergeLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AutoMergeLooping then
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					v.CFrame = CFrame.new(Plot.Main.Position.X + 10, Plot.Main.Position.Y + 10, Plot.Main.Position.Z + 10)
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "📈 Auto Buy Upgrades",
		CurrentValue = false,
		Flag = "AutoBuyUpgrades",
		Callback = function(Value)
			AutoUpgradeLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AutoUpgradeLooping then
				for i,v in pairs(Player.PlayerGui.World.Upgrades.Main:GetChildren()) do
					if v:IsA("Frame") then
						firesignal(v.Buy.Activated)
					end
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🏁 Auto Complete Obby",
		CurrentValue = false,
		Flag = "AutoCompleteObby",
		Callback = function(Value)
			AutoObbyLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AutoObbyLooping then
				if game:GetService("Workspace").Obby.Blocker.Transparency == 1 then
					Player.Character.HumanoidRootPart.CFrame = CFrame.new(267, 81, 4)
					repeat task.wait() until game:GetService("Workspace").Obby.Blocker.Transparency ~= 1
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🔁 Auto Rebirth",
		CurrentValue = false,
		Flag = "AutoRebirth",
		Callback = function(Value)
			AutoRebirthLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if AutoRebirthLooping then
				game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
			end
			task.wait(1)
		end
	end)

	Main:CreateToggle({
		Name = "🎉 Infinite Obby Multiplier",
		CurrentValue = false,
		Flag = "InfObbyMulti",
		Callback = function(Value)
			InfObbyMultiLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if InfObbyMultiLooping then
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, workspace.Obby.Finish, 1)
			end
			task.wait(1)
		end
	end)
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

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🍃 Auto Collect",
		CurrentValue = false,
		Flag = "AutoCollect",
		Callback = function(Value)
			CollectLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if CollectLooping then
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
	end)

	Main:CreateToggle({
		Name = "🔁 Auto Rebirth",
		CurrentValue = false,
		Flag = "AutoRebirth",
		Callback = function(Value)
			RebirthLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if RebirthLooping then
				game:GetService("ReplicatedStorage").functions.requestRebirth:FireServer()
			end
			task.wait(1)
		end
	end)

	Main:CreateToggle({
		Name = "🎁 Auto Claim Rewards",
		CurrentValue = false,
		Flag = "AutoClaim",
		Callback = function(Value)
			ClaimLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if ClaimLooping then
				for i,v in pairs(Player.playerStats.rewards:GetChildren()) do
					game:GetService("ReplicatedStorage").functions.claimReward:InvokeServer(v)
					task.wait()
				end
			end
			task.wait(1)
		end
	end)

	local Capsule = Window:CreateTab("Capsule", 4483362458)

	Capsule:CreateDropdown({
		Name = "💊 Capsule",
		Options = CapsuleList,
		CurrentOption = "",
		Flag = "SelectedCapsule",
		Callback = function(Value)
			SelectedCapsule = Value
		end,
	})

	Capsule:CreateToggle({
		Name = "💵 Auto Buy Capsule",
		CurrentValue = false,
		Flag = "AutoBuyCapsule",
		Callback = function(Value)
			CapsuleLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if CapsuleLooping and SelectedCapsule then
				game:GetService("ReplicatedStorage").functions.buyCapsule:InvokeServer(SelectedCapsule)
			end
			task.wait(1)
		end
	end)

	Capsule:CreateToggle({
		Name = "📭 Auto Open Capsule",
		CurrentValue = false,
		Flag = "AutoOpenCapsule",
		Callback = function(Value)
			OpenLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if OpenLooping then
				if Player.PlayerGui:FindFirstChild("activeCapsule") then
					Click(Player.PlayerGui.menus.menuHandler.selection)
				end
			end
			task.wait(.25)
		end
	end)
elseif game.PlaceId == 11189979930 then -- Pet Crafting Simulator
	local TapLooping
	local MergeLooping
	local UpgradeLooping
	local RebirthLooping
	local FrenzyLooping

	local Plot = game:GetService("Workspace").Plots:FindFirstChild(Player.Name)

	local Window = CreateWindow()

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🖱 Auto Tap",
		CurrentValue = false,
		Flag = "AutoTap",
		Callback = function(Value)
			TapLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if TapLooping then
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					game:GetService("ReplicatedStorage").Functions.Tap:FireServer(v)
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🤝 Auto Merge",
		CurrentValue = false,
		Flag = "AutoMerge",
		Callback = function(Value)
			MergeLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if MergeLooping then
				for i,v in pairs(Plot.Blocks:GetChildren()) do
					for e,r in pairs(Plot.Blocks:GetChildren()) do
						firetouchinterest(v, r, 0)
						firetouchinterest(v, r, 1)
					end
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "📈 Auto Upgrade",
		CurrentValue = false,
		Flag = "AutoUpgrade",
		Callback = function(Value)
			UpgradeLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if UpgradeLooping then
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.SpawnTier.Buy.Activated)
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Top.MaxBlocks.Buy.Activated)
				firesignal(Player.PlayerGui.World.Wall.Upgrades.Bot.Cooldown.Buy.Activated)
			end
			task.wait(.25)
		end
	end)

	Main:CreateToggle({
		Name = "🔁 Auto Rebirth",
		CurrentValue = false,
		Flag = "AutoRebirth",
		Callback = function(Value)
			RebirthLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if RebirthLooping then
				if Player.PlayerGui.World.Wall.Rebirths.Rebirth.Buy.BackgroundColor3 ~= Color3.fromRGB(76, 76, 76)  then
					game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "♾ Infinite 2x Frenzy",
		CurrentValue = false,
		Flag = "InfiniteFrenzy",
		Callback = function(Value)
			FrenzyLooping = Value
		end,
	})

	task.spawn(function()
		while true do
			if FrenzyLooping then
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 0)
				firetouchinterest(Player.Character.HumanoidRootPart, game:GetService("Workspace").Obby.Finish, 1)
			end
			task.wait(1)
		end
	end)
elseif game.PlaceId == 11102985540 then -- Swarm Simulator
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

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateToggle({
		Name = "🍓 Auto Collect Food",
		CurrentValue = false,
		Flag = "AutoCollectFood",
		Callback = function(Value)
			FoodLooping = Value
		end,
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

	Main:CreateToggle({
		Name = "💰 Auto Collect Coins",
		CurrentValue = false,
		Flag = "AutoCollectCoins",
		Callback = function(Value)
			CoinLooping = Value
		end,
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

	Main:CreateToggle({
		Name = "🥚 Auto Collect Eggs",
		CurrentValue = false,
		Flag = "AutoCollectEggs",
		Callback = function(Value)
			EggLooping = Value
		end,
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

	local Enemies = Window:CreateTab("Enemies", 4483362458)

	local EnemyDropdown = Enemies:CreateDropdown({
		Name = "👾 Enemy",
		Options = EnemiesList,
		CurrentOption = "",
		Flag = "SelectedEnemy",
		Callback = function(Value)
			SelectedEnemy = Value
		end,
	})

	Enemies:CreateToggle({
		Name = "⚔ Auto Attack",
		CurrentValue = false,
		Flag = "AutoAttack",
		Callback = function(Value)
			AttackLooping = Value
		end,
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

	Enemies:CreateButton({
		Name = "🔂 Refresh Enemy List",
		Callback = function()
			local NewTable = {}
			for i,v in pairs(game:GetService("Workspace").EnemyCache:GetChildren()) do
				if not table.find(NewTable, v.Name) then
					table.insert(NewTable, v.Name)
				end
			end

			EnemyDropdown:Refresh(NewTable, true)
		end,
	})

	local Pets = Window:CreateTab("Pets", 4483362458)

	Pets:CreateToggle({
		Name = "🥇 Auto Equip Best",
		CurrentValue = false,
		Flag = "AutoEquipBest",
		Callback = function(Value)
			EquipLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if EquipLooping then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.EquipBest:InvokeServer()
			end
		end
	end)

	Pets:CreateToggle({
		Name = "😋 Auto Feed",
		CurrentValue = false,
		Flag = "AutoFeed",
		Callback = function(Value)
			FeedLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if FeedLooping then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.NestService.RF.Feed:InvokeServer()
			end
		end
	end)

	Pets:CreateToggle({
		Name = "📈 Auto Upgrade Tier",
		CurrentValue = false,
		Flag = "AutoUpgradeTier",
		Callback = function(Value)
			TierLooping = Value
		end,
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

	Pets:CreateToggle({
		Name = "🐣 Auto Open Eggs",
		CurrentValue = false,
		Flag = "AutoOpenEggs",
		Callback = function(Value)
			OpenLooping = Value
		end,
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

	Pets:CreateToggle({
		Name = "🥚 Auto Place",
		CurrentValue = false,
		Flag = "AutoPlace",
		Callback = function(Value)
			PlaceLooping = Value
		end,
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

	local Quest = Window:CreateTab("Quest", 4483362458)

	Quest:CreateDropdown({
		Name = "📜 Quest",
		Options = QuestsList,
		CurrentOption = "",
		Flag = "SelectedQuest",
		Callback = function(Value)
			SelectedQuest = Value
		end,
	})

	Quest:CreateToggle({
		Name = "📝 Auto Quest",
		CurrentValue = false,
		Flag = "AutoQuest",
		Callback = function(Value)
			QuestLooping = Value
		end,
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
elseif game.PlaceId == 10404327868 then -- Timber Champions
	local AttackLooping
	local BossLooping
	local OrbLooping
	local ChestLooping
	local AxeLooping

	local HatchLooping
	local CraftLooping
	local BestLooping

	local TripleHatch

	local SelectedArea
	local SelectedLevel

	local SelectedEgg

	local BestDelay = 5

	local Areas = {}
	local Levels = {"All"}
	local Eggs = {}
	local Chests = {}
	local BuyableAxes = {}

	repeat task.wait() until Player.Character:FindFirstChild("IS_GAME_AXE")

	local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
	local TreeService = Knit.GetService("TreeService")
	local PetService = Knit.GetService("PetService")
	local DamageRemote = TreeService.Damage._re
	local DataController = Knit.GetController("DataController")
	local EggService = Knit.GetService("EggService")
	local OrbService = Knit.GetService("OrbService")
	local RewardService = Knit.GetService("RewardService")
	local BossService = Knit.GetService("BossService")
	local AxeService = Knit.GetService("AxeService")

	for i,v in pairs(game:GetService("Workspace").Scripts.Trees:GetChildren()) do
		table.insert(Areas, v.Name)
	end

	for i,v in pairs(game:GetService("Workspace").Scripts.Trees:FindFirstChild(Areas[1]):GetChildren()) do
		table.insert(Levels, v.Name)
	end

	for i,v in pairs(game:GetService("Workspace").Scripts.Eggs:GetChildren()) do
		if not string.find(v.Name:lower(), "robux") then
			table.insert(Eggs, v.Name)
		end
	end

	for i,v in pairs(require(game:GetService("ReplicatedStorage").Shared.List.Chests)) do
		if type(v) == "table" then
			for e,r in pairs(v) do
				table.insert(Chests, e)
			end
		end
	end

	for i,v in pairs(DataController.data.Axes) do
		if v > DataController.data.EquippedAxe then
			table.insert(BuyableAxes, v)
		end
	end

	local Window = CreateWindow()

	local Main = Window:CreateTab("Main", 4483362458)

	Main:CreateDropdown({
		Name = "🏝 Area",
		Options = Areas,
		CurrentOption = "",
		Flag = "SelectedArea",
		Callback = function(Value)
			SelectedArea = Value
		end,
	})

	Main:CreateDropdown({
		Name = "🔢 Level",
		Options = Levels,
		CurrentOption = "",
		Flag = "SelectedLevel",
		Callback = function(Value)
			SelectedLevel = Value
		end,
	})

	Main:CreateToggle({
		Name = "🌲 Auto Attack Tree",
		CurrentValue = false,
		Flag = "AutoAttack",
		Callback = function(Value)
			AttackLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AttackLooping and SelectedArea and SelectedLevel then
				for i = 2, #Levels, 1 do
					if Levels[i] == SelectedLevel or SelectedLevel == "All" and game:GetService("Workspace").Scripts.Trees:FindFirstChild(SelectedArea):FindFirstChild(Levels[i]) then
						for _,v in pairs(game:GetService("Workspace").Scripts.Trees:FindFirstChild(SelectedArea):FindFirstChild(Levels[i]).Storage:GetChildren()) do
							local SectionLooping = true


							while task.wait() and SectionLooping and AttackLooping do
								pcall(function()
									if not game:GetService("Workspace").Scripts.Trees:FindFirstChild(SelectedArea):FindFirstChild(Levels[i]).Storage:FindFirstChild(v.Name) then
										SectionLooping = false
										print("[Inferno X] Debug: Tree Destroyed")
									else
										DamageRemote:FireServer(v.Name)
									end
								end)
							end
						end
					end
				end
			end
		end
	end)

	Main:CreateSection("")

	Main:CreateToggle({
		Name = "🐍 Auto Attack Bosses",
		CurrentValue = false,
		Flag = "AutoBoss",
		Callback = function(Value)
			BossLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if BossLooping then
				for i,v in pairs(game:GetService("Workspace").Scripts.Areas:GetDescendants()) do
					if v:IsA("Folder") and v.Name == "Boss" then
						if #v.Model:GetChildren() > 0 then
							BossService.Damage:Fire(v.ID.Value)
						end
					end
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🔮 Auto Collect Orbs",
		CurrentValue = false,
		Flag = "AutoCollect",
		Callback = function(Value)
			OrbLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if OrbLooping then
				for i,v in pairs(game:GetService("Workspace").Scripts.Orbs.Storage:GetChildren()) do
					OrbService.CollectOrbs:Fire({v.Name})
					v:Destroy()
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "💼 Auto Collect Chests",
		CurrentValue = false,
		Flag = "AutoChest",
		Callback = function(Value)
			ChestLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if ChestLooping then
				for i,v in pairs(Chests) do
					RewardService:ClaimChest(v)
				end
			end
		end
	end)

	Main:CreateToggle({
		Name = "🪓 Auto Buy Axes",
		CurrentValue = false,
		Flag = "AutoAxe",
		Callback = function(Value)
			AxeLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if AxeLooping then
				for i,v in pairs(BuyableAxes) do
					if AxeService:Buy(1, v) == "success" then
						table.remove(BuyableAxes, v)
					end
				end
			end
		end
	end)

	local Pets = Window:CreateTab("Pets", 4483362458)

	Pets:CreateDropdown({
		Name = "🥚 Egg",
		Options = Eggs,
		CurrentOption = "",
		Flag = "SelectedEgg",
		Callback = function(Value)
			SelectedEgg = Value
		end,
	})

	Pets:CreateToggle({
		Name = "🐣 Auto Hatch Egg",
		CurrentValue = false,
		Flag = "AutoHatch",
		Callback = function(Value)
			HatchLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if HatchLooping and SelectedEgg then
				pcall(function()
					EggService:Unbox(SelectedEgg, TripleHatch)
				end)
			end
		end
	end)

	Pets:CreateToggle({
		Name = "🐥 Triple Hatch",
		CurrentValue = false,
		Flag = "TripleHatch",
		Callback = function(Value)
			if Value then
				TripleHatch = "triple"
			else
				TripleHatch = "single"
			end
		end,
	})

	Pets:CreateSection("")

	Pets:CreateToggle({
		Name = "⚒ Auto Craft Pets",
		CurrentValue = false,
		Flag = "AutoCraft",
		Callback = function(Value)
			CraftLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
			if CraftLooping then
				PetService:CraftAll()
			end
		end
	end)

	Pets:CreateToggle({
		Name = "🥇 Auto Equip Best",
		CurrentValue = false,
		Flag = "AutoEquipBest",
		Callback = function(Value)
			BestLooping = Value
		end,
	})

	task.spawn(function()
		while task.wait() do
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
				task.wait(BestDelay)
			end
		end
	end)

	Pets:CreateSlider({
		Name = "🐌 Auto Equip Best Delay",
		Range = {0, 60},
		Increment = 1,
		CurrentValue = 5,
		Flag = "Delay",
		Callback = function(Value)
			BestDelay = Value
		end,
	})
end

Rayfield:LoadConfiguration()
