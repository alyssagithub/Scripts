local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local workspace = workspace
local huge = math.huge

local Eggs = {}
local Rifts = {"None"}
local Areas = {"None"}
local GUIs = {}

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
	Options = {"All", "(Experimental) Split"},
	CurrentOption = "All",
	Flag = "Method",
	Callback = function(Option)
		Rayfield.Flags.Method.CurrentOption = Option
	end,
})

Main:CreateToggle({
	Name = "⛏ Auto Mine",
	Info = "Automatically mines the closest object to you.",
	SectionParent = Section,
	CurrentValue = false,
	Flag = "Mine",
	Callback = function()end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Mine.CurrentValue then
			local Number = huge
			local Number2 = huge
			local Selected
			local Selected2

			for i,v in pairs(workspace.ObjectsFolder:GetChildren()) do
				local Magnitude = (HumanoidRootPart.Position - v.Position).Magnitude
				if Magnitude < Number and #v:GetChildren() >= 1 then
					Number = Magnitude
					Selected = v
				end
			end

			if Selected then
				
				if Rayfield.Flags.Method.CurrentOption == "All" then
					for i,v in pairs(Selected:GetChildren()) do
						local Magnitude = (HumanoidRootPart.Position - v.Position).Magnitude
						if Magnitude < Number2 then
							Number2 = Magnitude
							Selected2 = v
						end
					end

					if Selected2 then
						repeat
							for i,v in pairs(Player.Pets:GetChildren()) do
								if v and v:FindFirstChild("Equipped") and v.Equipped.Value and not v.Attack.Value then
									Remotes.Client:FireServer("PetAttack", Selected2)
								end
							end
							task.wait()
						until not Selected2 or not Selected2:FindFirstChildOfClass("BillboardGui") or not Selected2:FindFirstChildOfClass("BillboardGui").Enabled or not Rayfield.Flags.Mine.CurrentValue
					end
				else
					local TableSelected = {}

					for i,v in pairs(Player.Pets:GetChildren()) do
						if v and v:FindFirstChild("Equipped") and v.Equipped.Value then
							for e,r in pairs(Selected:GetChildren()) do
								local Magnitude = (HumanoidRootPart.Position - r.Position).Magnitude
								if Magnitude < Number2 and not TableSelected[v.Name] then
									Number2 = Magnitude
									TableSelected[v.Name] = r
								end
							end
						end
					end

					for i,v in pairs(Player.Pets:GetChildren()) do
						if v and v:FindFirstChild("Equipped") and v.Equipped.Value and not v.Attack.Value then
							Remotes.Client:FireServer("PetAttack", TableSelected[v.Name])
						end
					end
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
	Callback = function(Option)
		Rayfield.Flags.Egg.CurrentOption = Option
	end,
})

Main:CreateDropdown({
	Name = "🔢 Amount",
	SectionParent = Section,
	Options = {"Single", "Triple", "Sextuple"},
	CurrentOption = "Single",
	Flag = "Amount",
	Callback = function(Option)
		Rayfield.Flags.Amount.CurrentOption = Option
	end,
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
			local EggOption = Rayfield.Flags.Egg.CurrentOption
			if workspace.Eggs:FindFirstChild(EggOption) then
				local Price = workspace.Eggs[EggOption].Price

				if (HumanoidRootPart.Position - Price.Position).Magnitude > 5 then
					HumanoidRootPart.CFrame = Price.CFrame
				end

				Remotes.EggOpened:InvokeServer(EggOption, Rayfield.Flags.Amount.CurrentOption)
			end
		end
	end
end)

local Section = Main:CreateSection("Inventory")

Main:CreateToggle({
	Name = "💰 Auto Equip Best",
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
		if MAP.Teleporter["FORCE_TP"]:FindFirstChild(Option) then
			HumanoidRootPart.CFrame = MAP.Teleporter["FORCE_TP"][Option].CFrame
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
		if MAP.Teleporter:FindFirstChild(Option) then
			HumanoidRootPart.CFrame = MAP.Teleporter[Option].CFrame
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
		if workspace.OpenGuiParts:FindFirstChild(Option) then
			local StoredName
			local Part = workspace.OpenGuiParts[Option]

			if Option == "Golden Factory" or Option == "Divin Machine" or Option == "Diamond Machine" then
				StoredName = Option
				Part.Name = "Evolve"
				Option = "Evolve"
				task.wait()
			end

			firetouchinterest(Part, HumanoidRootPart, 0)
			firetouchinterest(Part, HumanoidRootPart, 1)

			if Option == "Evolve" then
				task.wait()
				Part.Name = StoredName
				Option = StoredName
			end
		end
	end,
})

Main:CreateButton({
	Name = "🌊 Collect all Waterfall Pets",
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
	Name = "🍀 Collect all Trefles",
	SectionParent = Section,
	Callback = function()
		if workspace:FindFirstChild("Trefles") then
			for i,v in pairs(workspace.Trefles:GetChildren()) do
				HumanoidRootPart.CFrame = v.CFrame
				repeat task.wait() until not v or v.Parent ~= workspace.Trefles
			end
		end
	end,
})
