local Player, Rayfield, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/InfernoX/Variables.lua"))()

local workspace = workspace
local huge = math.huge

local Eggs = {}
local Rifts = {"None"}
local Areas = {"None"}
local GUIs = {}
local Types = {"Normal", "Golden", "Diamond", "Divin"}

local Inventory = Player.PlayerGui.MainGui.PetInventory.MainFrame.Inventory.Inventory

local Remotes = game:GetService("ReplicatedStorage").Remotes
local MAP = workspace:WaitForChild("MAP")

local Encounter = 0

local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")

for i,v in pairs(workspace.Eggs:GetChildren()) do
	if v.ClassName == "Model" then
		table.insert(Eggs, v.Name)
	end
end

for i,v in pairs(MAP.Teleporter["FORCE_TP"]:GetChildren()) do
	if not table.find(Rifts, v.Name) then
		table.insert(Rifts, v.Name)
	end
end

for i,v in pairs(MAP.Teleporter:GetChildren()) do
	if not table.find(Areas, v.Name) and not v.Name:lower():find("rift") then
		table.insert(Areas, v.Name)
	end
end

for i,v in pairs(workspace.OpenGuiParts:GetChildren()) do
	if v.Name == "Evolve" then
		Encounter = Encounter + 1
		if Encounter == 1 then
			v.Name = "Golden Factory"
		elseif Encounter == 2 then
			v.Name = "Diamond Machine"
		end

		if v:FindFirstChild("Text") then
			v.Name = "Divin Machine"
		end
	end

	if not table.find(GUIs, v.Name) then
		table.insert(GUIs, v.Name)
	end
end

local Window = CreateWindow("v1")

local Main = Window:CreateTab("Main", 4483362458)

local Section = Main:CreateSection("Farming")

Main:CreateDropdown({
	Name = "🗡 Method",
	SectionParent = Section,
	Options = {"All", "Split"},
	CurrentOption = "All",
	Flag = "Method",
	Callback = function()end,
})

Main:CreateDropdown({
	Name = "🧱 Object Priority",
	SectionParent = Section,
	Options = {"None", "pile", "safe", "crate", "vault"},
	CurrentOption = "None",
	Flag = "Object",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "💰 Auto Farm",
	Info = "Automatically breaks the closest object to you.",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Mine",
	Callback = function()end,
})

local function GetClosestObject(Blacklist)
	local Number = huge
	local Selected
	
	for i,v in pairs(workspace.ObjectsFolder:GetChildren()) do -- Example: SPAWN
		for e,r in pairs(v:GetChildren()) do -- Example: SPAWN_pile
			if r.ClassName == "MeshPart" and not table.find(Blacklist, r) and r.Name:find(Rayfield.Flags.Object.CurrentOption[1]) then
				local Magnitude = (HumanoidRootPart.Position - r.Position).Magnitude

				if Magnitude < Number and Magnitude < 200 then
					Number = Magnitude
					Selected = r
				end
			end
		end
	end
	
	if not Selected then
		for i,v in pairs(workspace.ObjectsFolder:GetChildren()) do -- Example: SPAWN
			for e,r in pairs(v:GetChildren()) do -- Example: SPAWN_pile
				if r.ClassName == "MeshPart" and not table.find(Blacklist, r) then
					local Magnitude = (HumanoidRootPart.Position - r.Position).Magnitude

					if Magnitude < Number then
						Number = Magnitude
						Selected = r
					end
				end
			end
		end
	end
	
	return Selected
end

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Mine.CurrentValue then
			local TableSelected = {}
			local ChosenInstances = {}
			local Pets = Player.Pets:GetChildren()
			local Selected = GetClosestObject({})
			
			if Rayfield.Flags.Method.CurrentOption[1] == "Split" then
				for i,v in pairs(Pets) do
					if v and v:FindFirstChild("Equipped") and v.Equipped.Value and not TableSelected[v] and Selected and Selected.Parent then
						TableSelected[v] = GetClosestObject(ChosenInstances)
						table.insert(ChosenInstances, TableSelected[v])
					end
				end
			end
				
			for i,v in pairs(Pets) do
				if v and v:FindFirstChild("Equipped") and v.Equipped.Value and not v.Attack.Value then
					local Object = TableSelected[v] or Selected
					
					repeat
						Remotes.Client:FireServer("PetAttack", Object)
						task.wait()
					until v.Attack.Value or not Object or Object.Parent == nil or not Rayfield.Flags.Mine.CurrentValue
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🎁 Auto Redeem Gifts",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Gifts",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Gifts.CurrentValue then
			for i,v in pairs(Player.PlayerGui.MainGui.Gifts.Frame:GetChildren()) do
				if v.ClassName == "TextButton" and v.Editable.TextLabel.Text == "Redeem!" then
					Remotes.Client:FireServer("OpenFreeGift", tonumber(v.Name))
					task.wait(1)
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💼 Auto Claim Chest",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Chest",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Chest.CurrentValue and MAP:FindFirstChild("Spawn") and MAP.Spawn.LEVELCHEST.TimeText.BillboardGui.TextLabel.Text == "Ready to Claim your Level Reward!" then
			game:GetService("ReplicatedStorage").Remotes.Client:FireServer("ClaimLevelChest")
		end
	end
end)

Main:CreateToggle({
	Name = "🏝 Auto Buy Worlds",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "World",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.World.CurrentValue and workspace.Wall:GetChildren()[1] then
			Remotes.Client:FireServer("BuyWorld", workspace.Wall:GetChildren()[1].Name)
		end
	end
end)


local Section = Main:CreateSection("Hatching")

Main:CreateDropdown({
	Name = "🥚 Egg",
	SectionParent = Section,
	Options = Eggs,
	CurrentOption = "Spawn",
	Flag = "Egg",
	Callback = function()end,
})

Main:CreateDropdown({
	Name = "🔢 Amount",
	SectionParent = Section,
	Options = {"Single", "Triple", "Sextuple"},
	CurrentOption = "Single",
	Flag = "Amount",
	Callback = function()end,
})

Main:CreateToggle({
	Name = "🐣 Auto Hatch",
	Info = "Note: The Egg Opening UI will not display",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Hatch",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Hatch.CurrentValue and workspace:FindFirstChild("Eggs") then
			local EggOption = Rayfield.Flags.Egg.CurrentOption[1]
			if workspace.Eggs:FindFirstChild(EggOption) then
				local Price = workspace.Eggs[EggOption].Price

				if (HumanoidRootPart.Position - Price.Position).Magnitude > 6 then
					HumanoidRootPart.CFrame = Price.CFrame + Vector3.new(-3, 0, 5)
				end

				Remotes.EggOpened:InvokeServer(EggOption, Rayfield.Flags.Amount.CurrentOption[1])
			end
		end
	end
end)

local Section = Main:CreateSection("Inventory")

Main:CreateToggle({
	Name = "💎 Auto Evolve",
	Info = "Automatically evolves unlocked normal, gold, and diamond pets.",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Evolve",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Evolve.CurrentValue then
			for e,r in pairs(Types) do
				local ImageIds = {}

				for _,v in pairs(Inventory:GetChildren()) do
					if v and v.ClassName == "ImageButton" and not v.Editable:FindFirstChild("LockMarker") and v:FindFirstChild("PetName") then
						local Mode = (v.Editable.Icon:GetChildren()[1] and v.Editable.Icon:GetChildren()[1].Name or "Normal")
						if Types[e - 1] == Mode or (r == "Normal" and Mode == r) then
							local Index = ImageIds[v.Editable.Icon.Image]
							local CompleteTable = {}

							if Index then
								Index.Amount = Index.Amount + 1
							else
								ImageIds[v.Editable.Icon.Image] = {IDs = {}, Amount = 1}
								Index = ImageIds[v.Editable.Icon.Image]
							end

							table.insert(Index.IDs, v.Name)

							if Index.Amount >= 6 then
								for i = 1, 6 do
									table.insert(CompleteTable, Index.IDs[i])
								end

								print("Evolve", v.PetName.Value, CompleteTable, Mode)
								for e,r in pairs(CompleteTable) do
									print(e,r)
								end
								Remotes.Client:FireServer("Evolve", v.PetName.Value, CompleteTable, Mode)
								break
							end
						end
					end
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "❌ Disable Evolve GUI",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "DisableEvolve",
	Callback = function()end,
})

local GuiEvolve = Player.PlayerGui.MainGui.Evolve

GuiEvolve:GetPropertyChangedSignal("Visible"):Connect(function()
	if Rayfield.Flags.DisableEvolve.CurrentValue and GuiEvolve.Visible then
		GuiEvolve.Visible = false
	end
end)

Main:CreateToggle({
	Name = "👍 Auto Equip Best",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Best",
	Callback = function()end,
})

Player.PlayerGui.MainGui.PetInventory.MainFrame.Inventory.Inventory.ChildAdded:Connect(function()
	if Rayfield.Flags.Best.CurrentValue then
		Remotes.PetActionRequest:InvokeServer("Equip Best")
	end
end)

local Section = Main:CreateSection("Transportation")

Main:CreateDropdown({
	Name = "🌌 Teleport to Rift",
	SectionParent = Section,
	Options = Rifts,
	CurrentOption = "None",
	Flag = "Rift",
	Callback = function(Option)
		if MAP.Teleporter["FORCE_TP"]:FindFirstChild(Option[1]) then
			HumanoidRootPart.CFrame = MAP.Teleporter["FORCE_TP"][Option[1]].CFrame
		end
	end,
})

Main:CreateDropdown({
	Name = "🏝 Teleport to Area",
	SectionParent = Section,
	Options = Areas,
	CurrentOption = "None",
	Flag = "Area",
	Callback = function(Option)
		if MAP.Teleporter:FindFirstChild(Option[1]) then
			HumanoidRootPart.CFrame = MAP.Teleporter[Option[1]].CFrame
		end
	end,
})

Main:CreateDropdown({
	Name = "📄 Open GUI",
	SectionParent = Section,
	Options = GUIs,
	CurrentOption = "None",
	--Flag = "GUI",
	Callback = function(Option)
		if workspace.OpenGuiParts:FindFirstChild(Option[1]) then
			local StoredName
			local Part = workspace.OpenGuiParts[Option[1]]

			if Option[1] == "Golden Factory" or Option[1] == "Divin Machine" or Option[1] == "Diamond Machine" then
				StoredName = Option[1]
				Part.Name = "Evolve"
				Option[1] = "Evolve"
				task.wait()
			end

			firetouchinterest(Part, HumanoidRootPart, 0); firetouchinterest(Part, HumanoidRootPart, 1)

			if Option[1] == "Evolve" then
				task.wait()
				Part.Name = StoredName
				Option[1] = StoredName
			end
		end
	end,
})

Main:CreateButton({
	Name = "🌊 Collect all Sanctuary Pets",
	SectionParent = Section,
	Callback = function()
		if MAP:FindFirstChild("Sanctuary") then
			for i,v in pairs(MAP.Sanctuary.Cacher:GetChildren()) do
				HumanoidRootPart.CFrame = v:GetChildren()[1].CFrame
				repeat task.wait() until not v or v.Parent ~= MAP.Sanctuary.Cacher
			end
		end
	end,
})

Main:CreateButton({
	Name = "🍦 Collect all Ice Cream",
	SectionParent = Section,
	Callback = function()
		for i,v in pairs(game:GetService("Workspace")["ice_cream"]:GetChildren()) do
			HumanoidRootPart.CFrame = v.CFrame
			task.wait(.1)
		end
	end,
})

Main:CreateButton({
	Name = "🧁 Collect all Cupcakes",
	SectionParent = Section,
	Callback = function()
		for i,v in pairs(game:GetService("Workspace").cupcake:GetChildren()) do
			HumanoidRootPart.CFrame = v.CFrame
			task.wait(.1)
		end
	end,
})
