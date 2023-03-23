local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local Services = game:GetService("ReplicatedStorage").Packages.Knit.Services
local virtualInput = game:GetService("VirtualInputManager")

local Up10 = Vector3.new(0, 10, 0)
local huge = math.huge
local workspace = workspace
local tick = tick
local task = task
local pairs = pairs
local table = table

local PlayerGui = Player:WaitForChild("PlayerGui")

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(NewCharacter)
	HumanoidRootPart = NewCharacter:WaitForChild("HumanoidRootPart")
end)

local Quests = {}
local Eggs = {}
local EggsTP = {}
local Portals = {"None"}
local NPCs = {"Closest NPC"}

local function ClosestEgg(v)
	local Number = huge
	local Egg

	for e,r in pairs(workspace.Live.FloatingEggs:GetChildren()) do
		local Magnitude = (v.Position - r.PrimaryPart.Position).Magnitude
		if Magnitude < Number then
			Number = Magnitude
			Egg = r
		end
	end

	EggsTP[Egg.Name] = v

	return Egg
end

for i,v in pairs(PlayerGui.Index.Background.ImageFrame.Window.Frames.WeaponFrame.WeaponHolder.WeaponScrolling:GetChildren()) do
	if v:IsA("Frame") then
		table.insert(NPCs, v.Name)
	end
end

for i,v in pairs(workspace.Resources.Eggs:GetChildren()) do
	ClosestEgg(v)
end

for i,v in pairs(workspace.Resources.QuestDummy:GetChildren()) do
	table.insert(Quests, v.Name)
end

for i,v in pairs(workspace.Live.FloatingEggs:GetChildren()) do
	if not table.find(Eggs, v.Name) then
		table.insert(Eggs, v.Name)
	end
end

for i,v in pairs(PlayerGui:GetChildren()) do
	if v.Name == "Portal" then
		table.insert(Portals, v.Text1.Text)
	end
end

local Window = CreateWindow("v1")

local Main = Window:CreateTab("Main", 4483362458)

local Combat = Main:CreateSection("Combat")

Main:CreateToggle({
	Name = "🖱 Auto Swing",
	Info = "Automatically gains power & attacks the closest NPC",
	SectionParent = Combat,
	CurrentValue = false,
	Flag = "Swing",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Swing.CurrentValue then
			local Mob
			local Number = huge

			for i,v in pairs(workspace.Live.NPCs.Client:GetChildren()) do
				local Magnitude = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
				if Magnitude < Number then
					Mob = v.Name
					Number = Magnitude
				end
			end

			Services.ClickService.RF.Click:InvokeServer(Mob)
		end
	end
end)

Main:CreateDropdown({
	Name = "🏅 NPC",
	SectionParent = Combat,
	Options = NPCs,
	CurrentOption = "",
	Flag = "NPC",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🗡 Teleport to NPC",
	SectionParent = Combat,
	CurrentValue = false,
	Flag = "TPNPC",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.TPNPC.CurrentValue then
			local Number = huge
			local ClosestNPC

			for i,v in pairs(workspace.Live.NPCs.Client:GetChildren()) do
				if v and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("NPCTag") and (Rayfield.Flags.NPC.CurrentOption == v.HumanoidRootPart.NPCTag.NameLabel.Text or Rayfield.Flags.NPC.CurrentOption == "Closest NPC") and (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < Number then
					Number = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
					ClosestNPC = v
				end
			end

			if ClosestNPC then
				repeat
					local CFrame = ClosestNPC.HumanoidRootPart.CFrame
					HumanoidRootPart.CFrame = CFrame + Up10 + CFrame.LookVector * 5
					task.wait()
				until not ClosestNPC or not workspace.Live.NPCs.Client:FindFirstChild(ClosestNPC.Name) or not Rayfield.Flags.TPNPC.CurrentValue
			end
		end
	end
end)

local Farming = Main:CreateSection("Farming")

Main:CreateToggle({
	Name = "💎 Auto Collect Drops",
	SectionParent = Farming,
	CurrentValue = false,
	Flag = "Drops",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Drops.CurrentValue then
			for i,v in pairs(workspace.Live.Pickups:GetChildren()) do
				if v then
					v.CFrame = HumanoidRootPart.CFrame
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💸 Auto Ascend",
	SectionParent = Farming,
	CurrentValue = false,
	Flag = "Ascend",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Ascend.CurrentValue and PlayerGui.LeftSidebar.Background.Frame.BottomButtons.Ascend.ReadyLabel.Visible then
			Services.AscendService.RF.Ascend:InvokeServer()
		end
	end
end)

Main:CreateToggle({
	Name = "📜 Auto Quest",
	Info = "Automatically starts & completes quests.",
	SectionParent = Farming,
	CurrentValue = false,
	Flag = "AutoQuest",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoQuest.CurrentValue then
			for i,v in pairs(Quests) do
				Services.QuestService.RF.ActionQuest:InvokeServer(v)
			end
			task.wait(1)
		end
	end
end)

local Hatching = Main:CreateSection("Hatching")

local EggDropdown = Main:CreateDropdown({
	Name = "🥚 Egg",
	SectionParent = Hatching,
	Options = Eggs,
	CurrentOption = "",
	Flag = "Egg",
	Callback = function()end,
})

workspace.Resources.Eggs.ChildAdded:Connect(function(Child)
	local Egg = ClosestEgg(Child)

	EggDropdown:Add(Egg.Name)
end)

Main:CreateToggle({
	Name = "🐣 Auto Hatch",
	SectionParent = Hatching,
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Hatch.CurrentValue and EggsTP[Rayfield.Flags.Egg.CurrentOption] then
			HumanoidRootPart.CFrame = EggsTP[Rayfield.Flags.Egg.CurrentOption].CFrame
			Services.EggService.RF.BuyEgg:InvokeServer({["eggName"] = EggsTP[Rayfield.Flags.Egg.CurrentOption].Name, ["auto"] = false, ["amount"] = 1})
		end
	end
end)

local Inventory = Main:CreateSection("Inventory")

Main:CreateToggle({
	Name = "🔪 Equip Best",
	SectionParent = Inventory,
	CurrentValue = false,
	Flag = "EquipBest",
	Callback = function()end,
})

PlayerGui.PetInv.Background.ImageFrame.Window.PetHolder.PetScrolling.ChildAdded:Connect(function()
	if Rayfield.Flags.EquipBest.CurrentValue then
		Services.PetInvService.RF.EquipBest:InvokeServer()
	end
end)

Main:CreateToggle({
	Name = "🛠 Auto Forge",
	SectionParent = Inventory,
	Info = "Forge your weapons into divine/godly!",
	CurrentValue = false,
	Flag = "Forge",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🌟 Auto Star",
	SectionParent = Inventory,
	Info = "Automatically adds stars to your godly weapons!",
	CurrentValue = false,
	Flag = "Star",
	Callback = function()end,
})

PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling.ChildAdded:Connect(function(Child)
	if Rayfield.Flags.EquipBest.CurrentValue then
		Services.WeaponInvService.RF.EquipBest:InvokeServer()
	end

	if Rayfield.Flags.Forge.CurrentValue then
		Services.ForgeService.RF.Forge:InvokeServer(Child.Name)
	end

	if Rayfield.Flags.Star.CurrentValue then
		for i,v in pairs(PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling:GetChildren()) do
			if v:IsA("Frame") and v:FindFirstChild("Frame") and v.Frame.Tier.Visible and tostring(v.Frame.Tier.BackgroundColor3) == "0.988235, 0.843137, 0.141176" then
				Services.WeaponStarService.RF.AddStar:InvokeServer(v.Name)
			end
		end
	end
end)

local Transport = Main:CreateSection("Transportation")

Main:CreateDropdown({
	Name = "🌊 Teleport to Area",
	SectionParent = Transport,
	Options = Portals,
	CurrentOption = "None",
	Flag = "Area",
	Callback = function(Option)
		for i,v in pairs(PlayerGui:GetChildren()) do
			if v.Name == "Portal" and v.Text1.Text == Option then
				HumanoidRootPart.CFrame = v.Adornee.CFrame
				local Start = tick()

				repeat
					virtualInput:SendKeyEvent(true, "E", false, nil)
					task.wait()
				until PlayerGui.Transition.Background.Visible == true or tick() - Start > 1
				break
			end
		end
	end,
})
