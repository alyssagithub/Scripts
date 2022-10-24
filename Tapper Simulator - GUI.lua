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

	Credits:AddLabel("🔥 This script was made by alyssa#2303 🔥")

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

local AutoTapLooping
local AutoHatchLooping
local AutoWheelLooping
local AutoRebirthLooping
local AutoEquipLooping
local AutoShinyLooping
local AutoRainbowLooping
local AutoEvolveLooping

local RemoveNotifLooping
local RemoveEggAnimLooping

local SelectedEgg

local EggsToOpen

local EggList = {}
local IslandList = {"Main Island"}

local Max

local Network = require(game:GetService("ReplicatedStorage").Modules.Utils.Network)
local Abbreviation = require(game:GetService("ReplicatedStorage").Modules.Utils.Abbreviation)
local HatchingAnimation = require(Player.PlayerScripts.Client.ClientManager.PlayerController.Visualizations.Hatching)
local Notifications = require(Player.PlayerScripts.Client.ClientManager.PlayerController.UI.Notifications)

local PreviousFunction = Abbreviation.Abbreviate
local PreviousFunction2 = HatchingAnimation.HatchEgg
local PreviousFunction3 = Notifications.Notify

for i,v in pairs(game:GetService("Workspace").GameAssets.Capsules:GetChildren()) do
	if not string.find(v.Name, "Robux") then
		table.insert(EggList, v.Name)
	end
end

for i,v in pairs(game:GetService("Workspace").GameAssets.Portals.Spawns:GetChildren()) do
	if v:IsA("BasePart") then
		table.insert(IslandList, v.Name)
	end
end

table.sort(EggList, function(a, b)
	return a > b
end)

repeat task.wait() until Player.PlayerGui.ScreenGui.Updates.TextLabel.Text ~= "v0.0.0"

local Window = OrionLib:MakeWindow({Name = "Tapper Simulator GUI", HidePremium = true, SaveConfig = true, ConfigFolder = "InfernoXConfig", IntroEnabled = true, IntroText = "Thank you for using Inferno X."})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Automatics = Main:AddSection({
	Name = "Automatics"
})

Automatics:AddToggle({
	Name = "🖱 Auto Tap",
	Default = false,
	Save = true,
	Flag = "AutoTap",
	Callback = function(Value)
		AutoTapLooping = Value
		while AutoTapLooping and task.wait() do
			Network:FireServer("ClickDetect")
		end
	end
})

Automatics:AddToggle({
	Name = "🍀 Auto Claim Wheel",
	Default = false,
	Save = true,
	Flag = "AutoClaimWheel",
	Callback = function(Value)
		AutoWheelLooping = Value
		while AutoWheelLooping and task.wait() do
			for i,v in pairs({1, 2, 3, 4, 5, 6}) do
				Network:FireServer("AttemptSpin", v)
				task.wait(1)
			end
		end
	end
})

Automatics:AddToggle({
	Name = "🔁 Auto Rebirth (Infinite)",
	Default = false,
	Save = true,
	Flag = "AutoRebirth",
	Callback = function(Value)
		AutoRebirthLooping = Value
		if AutoRebirthLooping then
			Abbreviation.Abbreviate = function(e, number)
				return tostring(number)
			end

			Network:FireServer("ClickDetect")
		else
			Abbreviation.Abbreviate = PreviousFunction

			Network:FireServer("ClickDetect")
		end

		while AutoRebirthLooping and task.wait() do
			if tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) and tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) >= 800 then
				Network:FireServer("Rebirth", math.floor(tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) / tonumber(Player.PlayerGui.ScreenGui.Menus.Rebirths.Menu.Holder["1"].Cost.Text:split(" ")[1])))
				task.wait(5)
			end
		end
	end
})

Automatics:AddToggle({
	Name = "⚔ Auto Equip Best",
	Default = false,
	Save = true,
	Flag = "AutoEquip",
	Callback = function(Value)
		AutoEquipLooping = Value
		while AutoEquipLooping do
			Network:FireServer("EquipBest")
			task.wait(2.5)
		end
	end
})

Automatics:AddButton({
	Name = "🏝 Unlock All Islands",
	Callback = function()
		for i,v in pairs(game:GetService("Workspace").GameAssets.Portals.Spawns:GetChildren()) do
			if v:IsA("BasePart") then
				Player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position.X, v.Position.Y + 50, v.Position.Z)
				task.wait(1)
			end
		end
	end    
})

local Pets = Main:AddSection({
	Name = "Pets"
})

Pets:AddDropdown({
	Name = "🥚 Egg",
	Options = EggList,
	Save = true,
	Flag = "SelectedEgg",
	Callback = function(Value)
		SelectedEgg = Value
	end
})

Pets:AddToggle({
	Name = "🐤 Auto Hatch Egg (must be near)",
	Default = false,
	Save = true,
	Flag = "AutoHatch",
	Callback = function(Value)
		AutoHatchLooping = Value
		if Player:IsInGroup(13994786) then
			Max = 3
		else
			Max = 1
		end

		while AutoHatchLooping and task.wait() do
			Network:FireServer("OpenCapsules", SelectedEgg, Max)
		end
	end
})

local CompletedMerge = {}

local function Convert(Convertion)
	local Data = Network:InvokeServer("RequestData", Player, true)
	local ConvertionTable = {["Rainbow"] = 2, ["Shiny"] = 1}
	for __,t in pairs(Data.PetsInfo.PetStorage) do
		if t.Tier == ConvertionTable[Convertion] and t.Locked == false then
			local PlayerData = Network:InvokeServer("RequestData", Player, true)
			local Merging = {}

			local Counter = 0
			local Counter2 = 0

			for i,v in pairs(PlayerData.PetsInfo.AmountOfPet) do
				if v >= 5 then
					for e,r in pairs(PlayerData.PetsInfo.PetStorage) do
						if r.Name == i and r.Tier == ConvertionTable[Convertion] and Counter < 5 and r.Locked == false then
							Counter = Counter + 1
							Merging[e] = true
						end
					end
				end
			end

			if Counter == 5 then
				print(Counter)
				for i,v in pairs(Merging) do
					print(i,v)
					if Counter2 < 1 and not CompletedMerge[i] then
						Counter2 = Counter2 + 1
						Network:FireServer(Convertion.."Crafting", i, Merging)
					end
					table.insert(CompletedMerge, i)
				end

				print("divider")
			end
		end
	end
end

Pets:AddButton({
	Name = "✨ Convert All Pets To Shiny",
	Callback = function()
		Convert("Shiny")
	end    
})

Pets:AddButton({
	Name = "🌈 Convert All Pets To Rainbow",
	Callback = function()
		Convert("Rainbow")
	end    
})

local Misc = Main:AddSection({
	Name = "Misc"
})

Misc:AddToggle({
	Name = "🐣 Remove Egg Animation",
	Default = false,
	Save = true,
	Flag = "RemoveEggAnim",
	Callback = function(Value)
		RemoveEggAnimLooping = Value
		if RemoveEggAnimLooping then
			HatchingAnimation.HatchEgg = function()
				return
			end
		else
			HatchingAnimation.HatchEgg = PreviousFunction2
		end
	end
})

Misc:AddToggle({
	Name = "❗ Remove Notifications",
	Default = false,
	Save = true,
	Flag = "RemoveNotif",
	Callback = function(Value)
		RemoveNotifLooping = Value
		if RemoveNotifLooping then
			Notifications.Notify = function()
				return
			end
		else
			Notifications.Notify = PreviousFunction3
		end
	end
})

Misc:AddButton({
	Name = "🔢 Check Rebirth Amount",
	Callback = function()
		Abbreviation.Abbreviate = function(e, number)
			return tostring(number)
		end

		Network:FireServer("ClickDetect")

		repeat task.wait() until tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) and tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) >= 800

		RebirthLabel:Set("Rebirth Amount: "..comma(math.floor(tonumber(Player.PlayerGui.ScreenGui.Currencies.Currency1.Amount.Text) / tonumber(Player.PlayerGui.ScreenGui.Menus.Rebirths.Menu.Holder["1"].Cost.Text:split(" ")[1]))))

		Abbreviation.Abbreviate = PreviousFunction

		Network:FireServer("ClickDetect")
	end    
})

RebirthLabel = Misc:AddLabel("Rebirth Amount: nil")

Misc:AddButton({
	Name = "🕊 Redeem All Codes",
	Callback = function()
		for i,v in pairs({"1m", "tooslow", "gems plz", "launch day!", "fire"}) do
			Network:InvokeServer("RedeemCode", v)
		end
	end    
})

Misc:AddDropdown({
	Name = "🏝 Teleport To Island",
	Options = IslandList,
	Save = true,
	Flag = "SelectedIsland",
	Callback = function(Value)
		local Island
		if Value == "Main Island" then
			Island = game:GetService("Workspace").Spawns:FindFirstChild("SpawnLocation")
		else
			Island = game:GetService("Workspace").GameAssets.Portals.Spawns[Value]
		end
		Player.Character.HumanoidRootPart.CFrame = CFrame.new(Island.Position.X, Island.Position.Y + 50, Island.Position.Z)
	end
})

Credits(Window)

OrionLib:Init()
