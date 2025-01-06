ScriptVersion = "v1.0.0"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getfenv().HandleConnection
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal

local Rayfield = getfenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any}} = Rayfield.Flags

local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFunctions: {[string]: RemoteFunction} = ReplicatedStorage.RemoteFunctions
local RemoteEvents: {[string]: RemoteEvent} = ReplicatedStorage.RemoteEvents

local Window = getfenv().Window

local Tab = Window:CreateTab("Automatics", "repeat")

Tab:CreateSection("Buildings")

Tab:CreateToggle({
	Name = "🎲 • Auto Roll",
	CurrentValue = false,
	Flag = "Roll",
	Callback = function(Value)	
		while Flags.Roll.CurrentValue and task.wait() do
			RemoteFunctions.Roll:InvokeServer()
		end
	end,
})

Tab:CreateToggle({
	Name = "🔀 • Auto Merge Buildings",
	CurrentValue = false,
	Flag = "Merge",
	Callback = function(Value)	
		while Flags.Merge.CurrentValue and task.wait() do
			for _, Building: Frame in Player.PlayerGui.Inventory.Main.Main.Main.Body.Inventory["Decorative Frame"].Inventory:GetChildren() do
				if not Building:IsA("Frame") then
					continue
				end
				
				local Count = Building.Count.Text:gsub("%D", "")
				
				if tonumber(Count) < 3 then
					continue
				end
				
				local Level = Building.Level.Text:gsub("%D", "")
				
				RemoteEvents.Upgrade:FireServer(Building.Name, Level, math.floor(tonumber(Count) / 3))
			end
		end
	end,
})

Tab:CreateSection("Items")

local function PickupDrops(Flamethrower: boolean?)
	if not Flags.Pickup.CurrentValue and not Flags.Flamethrower.CurrentValue then
		return
	end
	
	for _, Drop: BasePart in (if Flamethrower then workspace.FlamethrowerEntityFolder else workspace.PotionEntityFolder):GetChildren() do
		while Drop.Parent and (Flags.Pickup.CurrentValue or Flags.Flamethrower.CurrentValue) and task.wait() do
			Player.Character:PivotTo(Drop:GetPivot())
		end
	end
end

Tab:CreateToggle({
	Name = "🎒 • Auto Pickup Dice & Potions",
	CurrentValue = false,
	Flag = "Pickup",
	Callback = function(Value)	
		PickupDrops()
	end,
})

HandleConnection(workspace.PotionEntityFolder.ChildAdded:Connect(PickupDrops), "Pickup")

Tab:CreateToggle({
	Name = "🔥 • Auto Pickup Flamethrower",
	CurrentValue = false,
	Flag = "Flamethrower",
	Callback = function(Value)	
		PickupDrops(true)
	end,
})

HandleConnection(workspace.FlamethrowerEntityFolder.ChildAdded:Connect(function()
	PickupDrops(true)
end), "Flamethrower")

Tab:CreateToggle({
	Name = "🔁 • Auto Use Items",
	CurrentValue = false,
	Flag = "Use",
	Callback = function(Value)	
		while Flags.Use.CurrentValue and task.wait() do
			for _, Item: Frame in Player.PlayerGui.PotionManager.Main.Body.Inventory:GetChildren() do
				if not Item:IsA("Frame") or not Item:FindFirstChild("Use") then
					continue
				end
				
				for i = 1, #ReplicatedStorage.Assets.Potions:GetChildren() do
					RemoteFunctions.UsePotion:InvokeServer(tostring(i))
				end
			end
		end
	end,
})

local Tab = Window:CreateTab("Teleporting", "building-2")

Tab:CreateSection("Areas")

local NPCs = {"None"}

for _,v in workspace.NPCs:GetChildren() do
	table.insert(NPCs, v.Name)
end

Tab:CreateDropdown({
	Name = "🌀 • Teleport To NPC",
	Options = NPCs,
	CurrentOption = "None",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]
		
		if CurrentOption == "None" then
			return
		end
		
		Player.Character:PivotTo(workspace.NPCs[CurrentOption]:GetPivot())
	end,
})

local TycoonsAssociated = {}
local Tycoons = {"None"}

for _,v in workspace.Tycoons:GetChildren() do
	local OwnerName = v.Owner.OwnerPart.BillboardGui.PlayerImage.PlayerName.Text
	
	table.insert(Tycoons, OwnerName)
	TycoonsAssociated[OwnerName] = v
end

Tab:CreateDropdown({
	Name = "🏢 • Teleport To Tycoon",
	Options = Tycoons,
	CurrentOption = "None",
	MultipleOptions = false,
	--Flag = "Flag",
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "None" then
			return
		end

		Player.Character:PivotTo(TycoonsAssociated[CurrentOption].Spawn.Spawn:GetPivot())
	end,
})

getfenv().CreateUniversalTabs()
