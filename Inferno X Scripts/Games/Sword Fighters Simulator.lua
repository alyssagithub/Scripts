local loadstring, pairs, table_find, table_insert, task_spawn, task_wait, tick, Vector3_new, tostring = loadstring, pairs, table.find, table.insert, task.spawn, task.wait, tick, Vector3.new, tostring

local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1")

local Services = game:GetService("ReplicatedStorage").Packages.Knit.Services
local workspace = workspace
local virtualInput = game:GetService("VirtualInputManager")

local Quests = {}
local Eggs = {}
local EggsTP = {}
local Portals = {"None"}
local NPCs = {"Closest NPC"}

local function ClosestEgg(v)
    local Number = math.huge
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

for i,v in pairs(Player.PlayerGui.Index.Background.ImageFrame.Window.Frames.WeaponFrame.WeaponHolder.WeaponScrolling:GetChildren()) do
    if v:IsA("Frame") then
        table_insert(NPCs, v.Name)
    end
end

for i,v in pairs(workspace.Resources.Eggs:GetChildren()) do
    ClosestEgg(v)
end

for i,v in pairs(workspace.Resources.QuestDummy:GetChildren()) do
	table_insert(Quests, v.Name)
end

for i,v in pairs(workspace.Live.FloatingEggs:GetChildren()) do
    if not table_find(Eggs, v.Name) then
        table_insert(Eggs, v.Name)
    end
end

for i,v in pairs(Player.PlayerGui:GetChildren()) do
	if v.Name == "Portal" then
		table_insert(Portals, v.Text1.Text)
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateSection("Combat")

Main:CreateToggle({
	Name = "🖱 Auto Swing",
	Info = "Automatically gains power & attacks the closest NPC",
	CurrentValue = false,
	Flag = "Swing",
	Callback = function(Value)	end,
})

task_spawn(function()
	while task_wait() do
		if Rayfield.Flags.Swing.CurrentValue then
			local Mob
			local Number = math.huge
			
			for i,v in pairs(workspace.Live.NPCs.Client:GetChildren()) do
			    local Magnitude = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
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
	Options = NPCs,
	CurrentOption = "Goblin",
	Flag = "NPC",
	Callback = function(Option)	end,
})

Main:CreateToggle({
	Name = "🗡 Teleport to NPC",
	CurrentValue = false,
	Flag = "TPNPC",
	Callback = function(Value)	end,
})

task_spawn(function()
    while task_wait() do
        if Rayfield.Flags.TPNPC.CurrentValue then
            local Number = math.huge
            local ClosestNPC
            
            for i,v in pairs(workspace.Live.NPCs.Client:GetChildren()) do
                if v and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("NPCTag") and (Rayfield.Flags.NPC.CurrentOption == v.HumanoidRootPart.NPCTag.NameLabel.Text or Rayfield.Flags.NPC.CurrentOption == "Closest NPC") and (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < Number then
                    Number = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    ClosestNPC = v
                end
            end
            
            if ClosestNPC then
                repeat
                    Player.Character.HumanoidRootPart.CFrame = ClosestNPC.HumanoidRootPart.CFrame + Vector3_new(0, 10, 0) + ClosestNPC.HumanoidRootPart.CFrame.LookVector * 5
                    task_wait()
                until not ClosestNPC or not workspace.Live.NPCs.Client:FindFirstChild(ClosestNPC.Name) or not Rayfield.Flags.TPNPC.CurrentValue
            end
        end
    end
end)

Main:CreateSection("Farming")

Main:CreateToggle({
	Name = "💎 Auto Collect Drops",
	CurrentValue = false,
	Flag = "Drops",
	Callback = function(Value)	end,
})

task_spawn(function()
	while task_wait() do
		if Rayfield.Flags.Drops.CurrentValue then
			for i,v in pairs(workspace.Live.Pickups:GetChildren()) do
				if v then
					v.CFrame = Player.Character.HumanoidRootPart.CFrame
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💸 Auto Ascend",
	CurrentValue = false,
	Flag = "Ascend",
	Callback = function(Value)	end,
})

task_spawn(function()
	while task_wait() do
		if Rayfield.Flags.Ascend.CurrentValue and Player.PlayerGui.LeftSidebar.Background.Frame.BottomButtons.Ascend.ReadyLabel.Visible then
			Services.AscendService.RF.Ascend:InvokeServer()
		end
	end
end)

Main:CreateToggle({
	Name = "📜 Auto Quest",
	Info = "Automatically starts & completes quests.",
	CurrentValue = false,
	Flag = "AutoQuest",
	Callback = function(Value)	end,
})

task_spawn(function()
	while task_wait() do
		if Rayfield.Flags.AutoQuest.CurrentValue then
		    for i,v in pairs(Quests) do
		        Services.QuestService.RF.ActionQuest:InvokeServer(v)
		    end
		    task_wait(1)
		end
	end
end)

Main:CreateSection("Hatching")

local EggDropdown = Main:CreateDropdown({
	Name = "🥚 Egg",
	Options = Eggs,
	CurrentOption = "Weak Egg",
	Flag = "Egg",
	Callback = function(Option)	end,
})

workspace.Resources.Eggs.ChildAdded:Connect(function(Child)
    local Egg = ClosestEgg(Child)
    
	EggDropdown:Add(Egg.Name)
end)

Main:CreateToggle({
	Name = "🐣 Auto Hatch",
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function(Value)	end,
})

task_spawn(function()
	while task_wait() do
		if Rayfield.Flags.Hatch.CurrentValue and EggsTP[Rayfield.Flags.Egg.CurrentOption] then
			Player.Character.HumanoidRootPart.CFrame = EggsTP[Rayfield.Flags.Egg.CurrentOption].CFrame
			Services.EggService.RF.BuyEgg:InvokeServer({["eggName"] = EggsTP[Rayfield.Flags.Egg.CurrentOption].Name, ["auto"] = false, ["amount"] = 1})
		end
	end
end)

Main:CreateSection("Inventory")

Main:CreateToggle({
	Name = "🔪 Equip Best",
	CurrentValue = false,
	Flag = "EquipBest",
	Callback = function(Value)	end,
})

Player.PlayerGui.PetInv.Background.ImageFrame.Window.PetHolder.PetScrolling.ChildAdded:Connect(function()
    if Rayfield.Flags.EquipBest.CurrentValue then
        Services.PetInvService.RF.EquipBest:InvokeServer()
	end
end)

Main:CreateToggle({
	Name = "🛠 Auto Forge",
	Info = "Forge your weapons into divine/godly!",
	CurrentValue = false,
	Flag = "Forge",
	Callback = function(Value)	end,
})

Main:CreateToggle({
	Name = "🌟 Auto Star",
	Info = "Automatically adds stars to your godly weapons!",
	CurrentValue = false,
	Flag = "Star",
	Callback = function(Value)	end,
})

Player.PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling.ChildAdded:Connect(function(Child)
    if Rayfield.Flags.EquipBest.CurrentValue then
        Services.WeaponInvService.RF.EquipBest:InvokeServer()
    end

    if Rayfield.Flags.Forge.CurrentValue then
        Services.ForgeService.RF.Forge:InvokeServer(Child.Name)
    end
    
    if Rayfield.Flags.Star.CurrentValue then
        for i,v in pairs(Player.PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling:GetChildren()) do
            if v:IsA("Frame") and v:FindFirstChild("Frame") and v.Frame.Tier.Visible and tostring(v.Frame.Tier.BackgroundColor3) == "0.988235, 0.843137, 0.141176" then
                Services.WeaponStarService.RF.AddStar:InvokeServer(v.Name)
            end
        end
    end
end)

Main:CreateSection("Transportation")

Main:CreateDropdown({
	Name = "🌊 Teleport to Area",
	Options = Portals,
	CurrentOption = "None",
	Flag = "Area",
	Callback = function(Option)
		for i,v in pairs(Player.PlayerGui:GetChildren()) do
			if v.Name == "Portal" and v.Text1.Text == Option then
				Player.Character.HumanoidRootPart.CFrame = v.Adornee.CFrame
				local Start = tick()
		
		        repeat
		            virtualInput:SendKeyEvent(true, "E", false, nil)
		            task_wait()
		        until Player.PlayerGui.Transition.Background.Visible == true or Start - tick() >= 1
				break
			end
		end
	end,
})
