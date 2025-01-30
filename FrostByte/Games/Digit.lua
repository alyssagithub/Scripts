local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v2.4.4"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local firetouchinterest: (Part1: BasePart, Part2: BasePart, Ended: number) -> () = getfenv().firetouchinterest
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal
local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector
local hookmetamethod: (Object: Object, Metamethod: string, NewFunction: (Object?, any) -> (any)) -> ((any) -> (any)) = getfenv().hookmetamethod
local getnamecallmethod: () -> (string) = getfenv().getnamecallmethod
local checkcaller: () -> (boolean) = getfenv().checkcaller

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local HandleConnection: (Connection: RBXScriptConnection, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

type Tab = {
	CreateSection: (self: Tab, Name: string) -> (Section),
	CreateDivider: (self: Tab) -> (Divider),
}

local Rayfield = getgenv().Rayfield
local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = Rayfield.Flags

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Automation", "repeat")

Tab:CreateSection("Digging")

local function ReEquipTool(Tool: Tool)
	if not Tool then
		return
	end
	
	local Humanoid: Humanoid = Player.Character.Humanoid
	
	task.wait(0.5)

	Humanoid:UnequipTools()
	Humanoid:EquipTool(Tool)
end

HandleConnection(game:GetService("ScriptContext").Error:Connect(function(Message, StackTrace, CallingScript)
	if CallingScript and CallingScript.Name == "Shovel" and Message:find("attempt to index nil with 'GetAttribute'") then
		ReEquipTool(Player.Character:FindFirstChildOfClass("Tool"))
	end
end), "ShovelError")

local TreasurePiles = workspace.TreasurePiles

Tab:CreateToggle({
	Name = "⚡ • Auto Fast Dig (Combinable with Legit)",
	CurrentValue = false,
	Flag = "Dig",
	Callback = function(Value)
		while Flags.Dig.CurrentValue and task.wait() do
			if not Player.Character:FindFirstChildOfClass("Tool") then
				continue
			end
			
			local Adornee: Model? = Player.Character.Shovel.Highlight.Adornee
			
			if not Adornee or Adornee.Parent ~= TreasurePiles or Adornee:GetAttribute("Blacklisted") then
				continue
			end
			
			RemoteFunctions.Digging:InvokeServer({
				Command = "DigPile",
				TargetPileIndex = Adornee:GetAttribute("PileIndex")
			})
		end
	end,
})

local function LegitDig()
	if not Flags.LegitDig.CurrentValue then
		return
	end

	local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

	if not DigMinigame then
		return
	end
	
	local Connection: RBXScriptConnection
	Connection = game:GetService("RunService").Heartbeat:Connect(function()
		local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")
		
		if not DigMinigame or not Flags.LegitDig.CurrentValue then
			return Connection:Disconnect()
		end

		DigMinigame.Cursor.Position = DigMinigame.Area.Position
	end)

	HandleConnection(Connection, "LegitDigHeartbeat")
end

Tab:CreateToggle({
	Name = "⛏️ • Auto Legit Dig (100% Success Rate)",
	CurrentValue = false,
	Flag = "LegitDig",
	Callback = function(Value)
		if Value then
			LegitDig()
		end
	end,
})

HandleConnection(Player.PlayerGui.Main.ChildAdded:Connect(LegitDig), "LegitDig")

Tab:CreateDivider()

Tab:CreateToggle({
	Name = "🏞️ • Auto Create Piles on Any Terrain",
	CurrentValue = false,
	Flag = "CreatePiles",
	Callback = function(Value)
		while Flags.CreatePiles.CurrentValue and task.wait() do
			if Player:GetAttribute("PileCount") ~= 0 then
				continue
			end
			
			local PileAdornee: Model? = Player.Character.Shovel.Highlight.Adornee

			if PileAdornee and (PileAdornee.Parent ~= TreasurePiles or PileAdornee:GetAttribute("Completed") or PileAdornee:GetAttribute("Destroying")) then
				continue
			end
			
			RemoteFunctions.Digging:InvokeServer({
				Command = "CreatePile"
			})
		end
	end,
})

Tab:CreateToggle({
	Name = "🏖️ • Auto Fast Create Piles on Any Terrain (BLATANT)",
	CurrentValue = false,
	Flag = "FastCreatePiles",
	Callback = function(Value)
		while Flags.FastCreatePiles.CurrentValue and task.wait() do
			if Player:GetAttribute("PileCount") ~= 0 then
				continue
			end

			RemoteFunctions.Digging:InvokeServer({
				Command = "CreatePile"
			})
		end
	end,
})

Tab:CreateToggle({
	Name = "🕳️ • Auto Legit Create Piles (Needed for Legit Dig)",
	CurrentValue = false,
	Flag = "LegitPiles",
	Callback = function(Value)	
		while Flags.LegitPiles.CurrentValue and task.wait() do
			local Tool = Player.Character:FindFirstChildOfClass("Tool")
			
			if not Tool or Tool:GetAttribute("Type") ~= "Shovel" then
				continue
			end
			
			local PileAdornee: Model? = Player.Character.Shovel.Highlight.Adornee

			if PileAdornee and (PileAdornee.Parent ~= TreasurePiles or PileAdornee:GetAttribute("Blacklisted") or PileAdornee:GetAttribute("Completed") or PileAdornee:GetAttribute("Destroying")) then
				continue
			end
			
			Tool:Activate()
		end
	end,
})

Tab:CreateDivider()

local function RandomVector(Size: Vector3, Position: Vector3)

	local X = Position.X + math.random(-Size.X / 2, Size.X / 2)
	local Z = Position.Z + math.random(-Size.Z / 2, Size.Z / 2)

	return Vector3.new(X, Position.Y, Z)
end

local function IsPointInVolume(point: Vector3, volumeCenter: CFrame, volumeSize: Vector3): boolean
	local volumeSpacePoint = volumeCenter:PointToObjectSpace(point)
	return volumeSpacePoint.X >= -volumeSize.X/2
		and volumeSpacePoint.X <= volumeSize.X/2
		--and volumeSpacePoint.Y >= -volumeSize.Y/2
		--and volumeSpacePoint.Y <= volumeSize.Y/2
		and volumeSpacePoint.Z >= -volumeSize.Z/2
		and volumeSpacePoint.Z <= volumeSize.Z/2
end

local ChosenPosition

Tab:CreateToggle({
	Name = "🔄 • Auto Walk After Dig",
	CurrentValue = false,
	Flag = "DigWalk",
	Callback = function(Value)
		local Visualizer = workspace:FindFirstChild("FrostByteVisualizer")
		local Character = Player.Character
		local StartPos = Character:GetPivot().Position - Vector3.yAxis * Character.HumanoidRootPart.Size.Y

		while Flags.DigWalk.CurrentValue and task.wait() do	
			if Player:GetAttribute("IsDigging") then
				continue
			end

			local Character = Player.Character

			local WalkZoneSizeFlag = Flags.ZoneSize.CurrentValue

			local ZoneSize = Vector3.new(WalkZoneSizeFlag, 1, WalkZoneSizeFlag)

			local Visualizer: Part = workspace:FindFirstChild("FrostByteVisualizer")
			
			if Visualizer and Visualizer.Size ~= ZoneSize then
				Visualizer:Destroy()
				Visualizer = nil
			end

			if not Visualizer then
				Visualizer = Instance.new("Part")
				Visualizer.Size = ZoneSize
				Visualizer.Position = StartPos
				Visualizer.Anchored = true
				Visualizer.Color = Color3.fromRGB(75, 255, 75)
				Visualizer.CanCollide = false
				Visualizer.CanQuery = false
				Visualizer.Material = Enum.Material.SmoothPlastic
				Visualizer.Transparency = 0.4
				Visualizer.CastShadow = false
				Visualizer.Name = "FrostByteVisualizer"
				Visualizer.Parent = workspace
			end

			local Humanoid: Humanoid = Character.Humanoid

			local FoundPile = false

			for _, Pile: Model in TreasurePiles:GetChildren() do
				if Pile:GetAttribute("Owner") ~= Player.UserId or Pile:GetAttribute("Blacklisted") then
					continue
				end
				
				if not IsPointInVolume(Pile:GetPivot().Position, Visualizer.CFrame, ZoneSize) then
					continue
				end

				FoundPile = true

				for _, Descendant: BasePart in Pile:GetDescendants() do
					if not Descendant:IsA("BasePart") then
						continue
					end

					Descendant.CanCollide = false
				end

				Humanoid:MoveTo(Pile:GetPivot().Position)
				break
			end

			if FoundPile then
				continue
			end

			if not ChosenPosition then
				ChosenPosition = RandomVector(ZoneSize, Visualizer.Position)

				Humanoid.MoveToFinished:Once(function()
					ChosenPosition = nil
				end)
			end

			Humanoid:MoveTo(ChosenPosition)
		end

		if Value then
			ChosenPosition = nil
			Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
		end

		local Visualizer = workspace:FindFirstChild("FrostByteVisualizer")

		if Visualizer then
			Visualizer:Destroy()
		end
	end,
})

Tab:CreateSlider({
	Name = "🟩 • Auto Walk Zone Size",
	Range = {5, 100},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 20,
	Flag = "ZoneSize",
	Callback = function()end,
})

Tab:CreateDivider()

local Success, Rarities: {[string]: {["Color"]: Color3, ["BarColor"]: Color3}} = pcall(require, ReplicatedStorage.Settings.Rarities)

if not Success then
	Rarities = {
		["Junk"] = {
			["Color"] = Color3.fromRGB(97, 97, 97),
			["BarColor"] = Color3.fromRGB(227, 227, 227)
		},
		["Ordinary"] = {
			["Color"] = Color3.fromRGB(75, 151, 82),
			["BarColor"] = Color3.fromRGB(110, 221, 119)
		},
		["Rare"] = {
			["Color"] = Color3.fromRGB(100, 153, 200),
			["BarColor"] = Color3.fromRGB(127, 195, 255)
		},
		["Epic"] = {
			["Color"] = Color3.fromRGB(90, 75, 151),
			["BarColor"] = Color3.fromRGB(139, 118, 236)
		},
		["Legendary"] = {
			["Color"] = Color3.fromRGB(170, 138, 84),
			["BarColor"] = Color3.fromRGB(255, 206, 126)
		},
		["Mythical"] = {
			["Color"] = Color3.fromRGB(170, 84, 84),
			["BarColor"] = Color3.fromRGB(255, 126, 126)
		},
		["Special"] = {
			["Color"] = Color3.fromRGB(217, 17, 217),
			["BarColor"] = Color3.fromRGB(255, 20, 255)
		},
		["Secret"] = {
			["Color"] = Color3.fromRGB(104, 8, 131),
			["BarColor"] = Color3.fromRGB(49, 3, 75)
		}
	}
end

Tab:CreateToggle({
	Name = "✨ • Auto Skip Rarities (Bad with Fast Dig)",
	CurrentValue = false,
	Flag = "Skip",
	Callback = function(Value)
		while Flags.Skip.CurrentValue and task.wait() do
			local PileAdornee: Model? = Player.Character.Shovel.Highlight.Adornee

			if not PileAdornee then
				continue
			end
			
			local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")
			
			if not DigMinigame then
				continue
			end
			
			local ImageColor3: Color3 = DigMinigame.Background.ImageColor3
			
			local Rarity
			
			for i,v in Rarities do
				if v.BarColor == ImageColor3 then
					Rarity = i
					break
				end
			end
			
			if not table.find(Flags.Rarity.CurrentOption, Rarity) then
				continue
			end
			
			ReEquipTool(Player.Character:FindFirstChildOfClass("Tool"))
			
			repeat
				task.wait()
			until not Player.PlayerGui.Main:FindFirstChild("DigMinigame") or not Flags.Skip.CurrentValue
			
			PileAdornee:SetAttribute("Blacklisted", true)
		end
	end,
})

local RarityList = {}

for Name: string, _ in Rarities do
	table.insert(RarityList, Name)
end

Tab:CreateDropdown({
	Name = "📃 • Rarities",
	Options = RarityList,
	MultipleOptions = true,
	Flag = "Rarity",
	Callback = function()end,
})

Tab:CreateSection("Events")

local PreviousLocation

local function MeteorIslandTeleport(Meteor: Model?)
	if Meteor.Name ~= "Meteor Island" or not Flags.Meteor.CurrentValue then
		return
	end
	
	local Character = Player.Character
	
	PreviousLocation = Character:GetPivot()
	
	Character:PivotTo(Meteor:GetPivot() + Vector3.yAxis * Meteor:GetExtentsSize().Y / 2)
end

local Temporary: Folder = workspace.Temporary

Tab:CreateToggle({
	Name = "🌠 • Auto Teleport to Meteor Islands",
	CurrentValue = false,
	Flag = "Meteor",
	Callback = function(Value)
		if Value then
			for i,v in Temporary:GetChildren() do
				MeteorIslandTeleport(v)
			end
		elseif PreviousLocation then
			Player.Character:PivotTo(PreviousLocation)
			PreviousLocation = nil
		end
	end,
})

HandleConnection(Temporary.ChildAdded:Connect(MeteorIslandTeleport), "Meteor")
HandleConnection(Temporary.ChildRemoved:Connect(function(Child: Model?)
	if Child.Name == "Meteor Island" and PreviousLocation and Flags.Meteor.CurrentValue then
		Player.Character:PivotTo(PreviousLocation)
		PreviousLocation = nil
	end
end), "MeteorRemoved")

local PreviousLocation

local function LunarCloudsTeleport(Lunar: Model?)
	if Lunar.Name ~= "Lunar Clouds" or not Flags.LunarClouds.CurrentValue then
		return
	end

	local Character = Player.Character

	PreviousLocation = Character:GetPivot()
	
	Character:PivotTo(Lunar.SpawnPoint.CFrame)
end

Tab:CreateToggle({
	Name = "🌥 • Auto Teleport to Lunar Clouds",
	CurrentValue = false,
	Flag = "LunarClouds",
	Callback = function(Value)
		if Value then
			for i,v in workspace.Map.Islands:GetChildren() do
				LunarCloudsTeleport(v)
			end
		elseif PreviousLocation then
			Player.Character:PivotTo(PreviousLocation)
			PreviousLocation = nil
		end
	end,
})

HandleConnection(workspace.Map.Islands.ChildAdded:Connect(LunarCloudsTeleport), "LunarClouds")
HandleConnection(workspace.Map.Islands.ChildRemoved:Connect(function(Child: Model)
	if Child.Name == "Lunar Clouds" and PreviousLocation and Flags.LunarClouds.CurrentValue then
		Player.Character:PivotTo(PreviousLocation)
		PreviousLocation = nil
	end
end), "LunarCloudsRemoved")

local Tab: Tab = Window:CreateTab("Shortcuts", "square-slash")

Tab:CreateSection("Transport")

local Islands = {}

for i,v in workspace.Map.Islands:GetChildren() do
	table.insert(Islands, v.Name)
end

for i,v in ReplicatedStorage.Assets.Sounds.Soundtrack.Locations:GetChildren() do
	if v.Name == "Ocean" then
		continue
	end

	if not table.find(Islands, v.Name) then
		table.insert(Islands, v.Name)
	end
end

table.sort(Islands)

local TeleporttoIsland

TeleporttoIsland = Tab:CreateDropdown({
	Name = "🏝 • Teleport to Island",
	Options = Islands,
	CurrentOption = "",
	MultipleOptions = false,
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "" then
			return
		end
		
		TeleporttoIsland:Set({""})

		local Island: Folder = workspace.Map.Islands:FindFirstChild(CurrentOption)

		if not Island then
			return Notify("Error", "That island doesn't currently exist.")
		end

		if Island:FindFirstChild("LocationSpawn") then
			Player.Character:PivotTo(Island.LocationSpawn.CFrame)
		elseif Island:FindFirstChild("SpawnPoint") then
			Player.Character:PivotTo(Island.SpawnPoint.CFrame)
		elseif CurrentOption ~= "Badlands" then
			Player.Character:PivotTo(Island:GetAttribute("Pivot") --[[+ Vector3.yAxis * Island:GetAttribute("Size") / 2]])
		else
			Player.Character:PivotTo(Island:GetAttribute("Pivot") + Vector3.yAxis * Island:GetAttribute("Size") / 2)
		end
	end,
})

Tab:CreateSection("UI")

local AFKHook

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🏷️ • Disable [AFK] Tag", hookmetamethod and getnamecallmethod and checkcaller),
	CurrentValue = false,
	Flag = "AFKTag",
	Callback = function(Value)
		if Value and not AFKHook then
			AFKHook = hookmetamethod(RemoteEvents.Player, "__namecall", function(self, ...)
				local Method = getnamecallmethod()
				local Args = {...}
				
				if not checkcaller() and Method == "FireServer" and Args[1].Command == "SetAFK" and Args[1].State and Flags.AFKTag.CurrentValue then
					local NewArgs = {}
					NewArgs.Command = Args[1].Command
					NewArgs.State = false
					self:FireServer(NewArgs)
					return
				end
				
				return AFKHook(self, ...)
			end)
		end
	end,
})

Tab:CreateSection("Miscellaneous")

local Codes = {
	"PLSMOLE",
	"LUNARV2",
	"TWITTER_DIGITRBLX",
	"5MILLION",
	"SECRET",
	"300KLIKES",
	"12MVISITS",
	"PLS_FALLEN_STAR",
}

Tab:CreateButton({
	Name = "🐦 • Redeem Known Codes",
	Callback = function()
		for _, Code: string in Codes do
			local Result = RemoteFunctions.Codes:InvokeServer({
				Command = "Redeem",
				Code = Code
			})
			
			if Result.Status then
				continue
			elseif Result.AlreadyRedeemed then
				continue
			elseif Result.NotValid then
				Notify("Failed!", `The code '{Code}' is not valid anymore.`)
			else
				Notify("Error", `The code '{Code}' has had an internal error while redeeming.`)
			end
		end
		
		Notify("Completed", "Applied all the known codes.")
	end,
})

local Tab: Tab = Window:CreateTab("Items", "shovel")

Tab:CreateSection("Safekeeping")

local OpenBankHook
local MoveToBankHook
local AlreadyWaiting = false

Tab:CreateToggle({
	Name = ApplyUnsupportedName("🏦 • Access Bank Anywhere", hookmetamethod and getnamecallmethod and checkcaller),
	CurrentValue = false,
	Flag = "Bank",
	Callback = function(Value)
		if Value and not OpenBankHook then
			OpenBankHook = hookmetamethod(RemoteFunctions.Marketplace, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				local args = {...}

				if not checkcaller() and method == "InvokeServer" and args[1].Command == "OwnsProduct" and args[1].Product == "Store Anywhere" and Flags.Bank.CurrentValue then
					return true
				end

				return OpenBankHook(self, ...)
			end)
		end

		if Value and not MoveToBankHook then
			MoveToBankHook = hookmetamethod(RemoteFunctions.Inventory, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				local args = {...}

				if method == "InvokeServer" and args[1].Command == "MoveToBank" and Flags.Bank.CurrentValue and not AlreadyWaiting then
					local Result: {["Status"]: boolean}

					AlreadyWaiting = true

					local Character = Player.Character

					local PreviousPosition = Character:GetPivot()

					repeat
						Character:PivotTo(workspace.Map.Islands.Nookville.BackpackIsland.Ronald:GetPivot())
						Result = self:InvokeServer(args[1])
					until (Result and Result.Status) or not Flags.Bank.CurrentValue

					AlreadyWaiting = false

					Character:PivotTo(PreviousPosition)
				end

				local Success, Result = pcall(MoveToBankHook, self, ...)

				return if Success then Result else {Status = true}
			end)
		end
	end,
})

Tab:CreateToggle({
	Name = "🏧 • Auto Bank Items (Needs Bank Access)",
	CurrentValue = false,
	Flag = "BankItems",
	Callback = function(Value)
		while Flags.BankItems.CurrentValue and task.wait() do	
			for _, Item: string in Flags.ItemsToBank.CurrentOption do
				local Tool = Player.Backpack:FindFirstChild(Item)

				if not Tool then
					continue
				end

				RemoteFunctions.Inventory:InvokeServer({
					Command = "MoveToBank",
					UID = Tool:GetAttribute("ID")
				})
			end
		end
	end,
})

local Items = {}

for i,v in ReplicatedStorage.Settings.Items.Treasures:GetChildren() do
	table.insert(Items, v.Name)
end

table.sort(Items)

Tab:CreateDropdown({
	Name = "🧰 • Items to Bank",
	Options = Items,
	MultipleOptions = true,
	Flag = "ItemsToBank",
	Callback = function()end,
})

Tab:CreateDivider()

local ItemInfo

Tab:CreateButton({
	Name = ApplyUnsupportedName("🔙 • Quick Withdraw Items (Open Bank First)", pcall(require, ReplicatedStorage.Settings.Items.Treasures:FindFirstChildOfClass("ModuleScript"))),
	Callback = function()
		if not ItemInfo then
			return Notify("Error", `An item named '{Flags.ItemToWithdraw.CurrentValue}' was not found`)
		end
		
		local AmountWithdrawn = 0
		
		for _, Item: ImageLabel in Player.PlayerGui.Main.Core.Inventory.Inventory.Slots:GetChildren() do
			if not Item:IsA("ImageLabel") then
				continue
			end
			
			if not Item.Icon.Image:find(ItemInfo.Icon) then
				continue
			end
			
			if AmountWithdrawn >= Flags.AmountToWithdraw.CurrentValue then
				break
			end
			
			local Result: {Status: boolean} = RemoteFunctions.Inventory:InvokeServer({
				Command = "WithdrawFromBank",
				UID = Item.Name
			})
			
			if Result.Status then
				AmountWithdrawn += 1
			end
		end
		
		Notify("Success", `Withdrew {AmountWithdrawn} {Flags.ItemToWithdraw.CurrentValue}s`)
	end,
})

Tab:CreateSlider({
	Name = "➖ • Amount to Withdraw",
	Range = {1, 1000},
	Increment = 1,
	Suffix = "Items",
	CurrentValue = 1,
	Flag = "AmountToWithdraw",
	Callback = function()end,
})

Tab:CreateInput({
	Name = ApplyUnsupportedName("📑 • Item to Withdraw", pcall(require, ReplicatedStorage.Settings.Items.Treasures:FindFirstChildOfClass("ModuleScript"))),
	CurrentValue = "",
	PlaceholderText = "Full Item Name Here",
	RemoveTextAfterFocusLost = false,
	Flag = "ItemToWithdraw",
	Callback = function(Text)
		for _, Treasure: ModuleScript in ReplicatedStorage.Settings.Items.Treasures:GetChildren() do
			if Treasure.Name:lower() == Text:lower() then
				local Success, Result = pcall(require, Treasure)
				
				if Success then
					ItemInfo = Result
				end
				
				break
			end
		end
	end,
})

Tab:CreateDivider()

local function PinItems(Tool: Tool)
	if not Flags.PinItems.CurrentValue then
		return
	end

	if not table.find(Flags.ItemsToPin.CurrentOption, Tool.Name) then
		return
	end

	if Tool:GetAttribute("Pinned") then
		return
	end

	task.wait(1)

	local Result = RemoteFunctions.Inventory:InvokeServer({
		Command = "ToggleSlotPin",
		UID = Tool:GetAttribute("ID")
	})

	if Result then
		Tool:SetAttribute("Pinned", not Tool:GetAttribute("Pinned"))
	end
end

Tab:CreateToggle({
	Name = "📌 • Auto Pin Items",
	CurrentValue = false,
	Flag = "PinItems",
	Callback = function(Value)
		if Value then
			for _, Tool: Tool in Player.Backpack:GetChildren() do
				PinItems(Tool)
			end
		end
	end,
})

HandleConnection(Player.Backpack.ChildAdded:Connect(PinItems), "PinItems")

Tab:CreateDropdown({
	Name = "🖼️ • Items to Pin",
	Options = Items,
	MultipleOptions = true,
	Flag = "ItemsToPin",
	Callback = function()end,
})

Tab:CreateSection("Containers")

local Treasures = ReplicatedStorage.Settings.Items.Treasures

local ContainerNames = {
	"Chest",
	"Loot Bag",
	"Crate",
	"Magnet Box",
	"Strange Vase",
	"Sparkle Flask",
	"Gift of Labor",
	"Gift of Voyage",
	"Gift of Elves",
	"Frozen Container",
	"Pinata Box",
	"Frozen Magnet Box",
	"Piggy Bank",
	"Benson's Present",
	"Benson's Royal Crate",
	"Benson's Safe",
	"Benson's Box",
	"Gift of Dragons",
	"Gift of Abundance",
	"Gift of Fortune",
}

local function OpenContainer(Tool: Tool)
	if not Flags.OpenContainers.CurrentValue then
		return
	end

	local Module: ModuleScript? = Treasures:FindFirstChild(Tool.Name)

	if not Module then
		return
	end
	
	local Success, Info = pcall(require, Module)
	
	if Success then
		if not Info.ContainerType then
			return
		end
	elseif not table.find(ContainerNames, Tool.Name) then
		return
	end

	task.wait(0.5)

	RemoteEvents.Treasure:FireServer({
		Command = "RedeemContainer",
		Container = Tool
	})
end

Tab:CreateToggle({
	Name = "💸 • Auto Open Containers",
	CurrentValue = false,
	Flag = "OpenContainers",
	Callback = function(Value)
		for _, Tool: Tool in Player.Backpack:GetChildren() do
			OpenContainer(Tool)
		end
	end,
})

HandleConnection(Player.Backpack.ChildAdded:Connect(OpenContainer), "OpenContainers")

local CollectedRewards = {}

Tab:CreateToggle({
	Name = "📦 • Auto Collect Salary Rewards (Will Appear Unclaimed)",
	CurrentValue = false,
	Flag = "Salary",
	Callback = function(Value)
		while Flags.Salary.CurrentValue and task.wait() do
			local TierTimers = RemoteFunctions.TimeRewards:InvokeServer({
				Command = "GetSessionTimers"
			})

			for Tier, Timer in TierTimers do
				if Timer ~= 0 then
					CollectedRewards[Tier] = false
					continue
				end

				if CollectedRewards[Tier] then
					continue
				end

				RemoteFunctions.TimeRewards:InvokeServer({
					Command = "RedeemTier",
					Tier = Tier
				})

				CollectedRewards[Tier] = true
			end

			task.wait(5)
		end
	end,
})

Tab:CreateSection("Shop")

local function GetInventorySize()
	local Inventory: {[string]: {["Attributes"]: {["Weight"]: number}}} = RemoteFunctions.Player:InvokeServer({
		Command = "GetInventory"
	})

	local InventorySize = 0

	for ID, Object in Inventory do
		InventorySize += 1
	end

	return InventorySize
end

function SellInventory()
	Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

	local Merchant: Model

	for _,v: TextLabel in workspace.Map.Islands:GetDescendants() do
		if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
			continue
		end

		Merchant = v.Parent.Parent

		break
	end

	local SellEnabled = Flags.Sell.CurrentValue
	local PreviousPosition = Player.Character:GetPivot()
	local PreviousSize = GetInventorySize()

	local Teleported = false

	local StartTime = tick()

	repeat
		if not MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 1003325804) then
			Player.Character:PivotTo(Merchant:GetPivot())
			Teleported = true
		end

		task.wait(1)

		RemoteEvents.Merchant:FireServer({
			Command = "SellAllTreasures",
			Merchant = Merchant
		})
	until GetInventorySize() ~= PreviousSize or Flags.Sell.CurrentValue ~= SellEnabled or tick() - StartTime >= 3

	if Teleported then
		Player.Character:PivotTo(PreviousPosition)
	end
end

Tab:CreateToggle({
	Name = "💰 • Auto Sell Inventory at Max Capacity",
	CurrentValue = false,
	Flag = "Sell",
	Callback = function(Value)	
		while Flags.Sell.CurrentValue and task.wait() do
			if GetInventorySize() < Player:GetAttribute("MaxInventorySize") + 9 then
				continue
			end

			SellInventory()
		end
	end,
})

Tab:CreateButton({
	Name = "💰 • Quick Sell Inventory",
	Callback = SellInventory,
})

Tab:CreateButton({
	Name = "🧲 • Purchase Magnet Box(es)",
	Callback = function()
		RemoteFunctions.Shop:InvokeServer({
			Command = "Buy",
			Type = "Item",
			Product = "Magnet Box",
			Amount = Flags.MagnetBoxes.CurrentValue
		})
	end,
})

Tab:CreateSlider({
	Name = "🗃 • Amount of Magnet Boxes to Purchase",
	Range = {1, 100},
	Increment = 1,
	Suffix = "Magnet Box(es)",
	CurrentValue = 1,
	Flag = "MagnetBoxes",
	Callback = function()end,
})

local Shovels = {}
local OriginalShovelNames = {}

local function AddComma(amount: number)
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

for i,v in ReplicatedStorage.Settings.Items.Shovels:GetChildren() do
	local Success, ItemInfo = pcall(require, v)
	
	local BuyPrice = 0
	local NewName
	
	if Success and ItemInfo then
		if not ItemInfo.BuyPrice then
			continue
		end
		
		BuyPrice = ItemInfo.BuyPrice

		NewName = `{v.Name} (${AddComma(BuyPrice)})`
	else
		NewName = `{v.Name} (Can't See Price)`
	end

	table.insert(Shovels, NewName)
	OriginalShovelNames[NewName] = {
		Name = v.Name,
		BuyPrice = BuyPrice
	}
end

table.sort(Shovels, function(a,b)
	return OriginalShovelNames[a].BuyPrice < OriginalShovelNames[b].BuyPrice
end)

local PurchaseShovel
PurchaseShovel = Tab:CreateDropdown({
	Name = "💵 • Purchase Shovel",
	Options = Shovels,
	CurrentOption = "",
	MultipleOptions = false,
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "" then
			return
		end

		RemoteFunctions.Shop:InvokeServer({
			Command = "Buy",
			Type = "Item",
			Product = OriginalShovelNames[CurrentOption].Name,
			Amount = 1
		})

		PurchaseShovel:Set({""})
	end,
})

Tab:CreateSection("Upgrading")

local EnchantShovel

EnchantShovel = Tab:CreateToggle({
	Name = "🌟 • Auto Enchant Shovel",
	CurrentValue = false,
	Flag = "EnchantShovel",
	Callback = function(Value)	
		while Flags.EnchantShovel.CurrentValue and task.wait() do
			local Backpack = Player.Backpack

			local Mole = Backpack:FindFirstChild("Mole") or Backpack:FindFirstChild("Royal Mole")

			if not Mole then
				continue
			end

			local Shovel

			for _, Tool: Tool in Backpack:GetChildren() do
				if Tool:GetAttribute("Type") == "Shovel" then
					Shovel = Tool
				end
			end

			if not Shovel then
				Shovel = Player.Character:FindFirstChildOfClass("Tool")
			end

			if not Shovel or Shovel:GetAttribute("Type") ~= "Shovel" then
				continue
			end

			local Result = RemoteFunctions.MolePit:InvokeServer({
				Command = "OfferEnchant",
				ID = Mole:GetAttribute("ID")
			})

			if Result ~= true then
				continue
			end

			local Result = RemoteFunctions.MolePit:InvokeServer({
				Command = "OfferShovel",
				ID = Shovel:GetAttribute("ID")
			})

			if Result ~= true then
				continue
			end

			local ShovelInfo

			repeat
				local Equipment = RemoteFunctions.Player:InvokeServer({
					Command = "GetEquipment"
				})

				for Name, Info in Equipment.Shovels do
					if Name ~= Shovel.Name then
						continue
					end

					ShovelInfo = Info
				end
				task.wait()
			until ShovelInfo

			for Name, Level in ShovelInfo.Enchantments do
				local Enchant = `{Name} {Level}`

				print("New Enchant:", Enchant)

				Notify("New Enchant", Enchant, "book")

				if table.find(Flags.Enchants.CurrentOption, Enchant) then
					Notify("Auto Enchant", "Stopped due to finding an enchant to stop at", "book")
					EnchantShovel:Set(false)
				end
			end
		end
	end,
})

local Success, EnchantModule = pcall(require, ReplicatedStorage.Settings.Enchantments)

if not Success then
	EnchantModule = game:GetService("HttpService"):JSONDecode([[
	{
  "Loaded": true,
  "WaitForAll": null,
  "EnchantmentsList": {
    "Blessed": {
      "Name": "Blessed",
      "MoleWeight": 5,
      "Color": null,
      "Tiers": [
        {
          "LootLuck": 0.17,
          "Precision": 0.15,
          "Stability": 0.15,
          "Control": 0.15
        },
        {
          "LootLuck": 0.3,
          "Precision": 0.3,
          "Stability": 0.3,
          "Control": 0.3
        },
        {
          "LootLuck": 0.4,
          "Precision": 0.4,
          "Stability": 0.4,
          "Control": 0.4
        }
      ],
      "TierCount": 3
    },
    "Lucky": {
      "Name": "Lucky",
      "MoleWeight": 20,
      "Color": null,
      "Tiers": [
        {
          "LootLuck": 0.17
        },
        {
          "LootLuck": 0.3
        },
        {
          "LootLuck": 0.4
        }
      ],
      "TierCount": 3
    },
    "Strong": {
      "Name": "Strong",
      "MoleWeight": 40,
      "Color": null,
      "Tiers": [
        {
          "Strength": 0.15
        },
        {
          "Strength": 0.3
        },
        {
          "Strength": 0.4
        }
      ],
      "TierCount": 3
    },
    "Steady": {
      "Name": "Steady",
      "MoleWeight": 20,
      "Color": null,
      "Tiers": [
        {
          "Stability": 0.15,
          "Control": 0.15
        },
        {
          "Stability": 0.3,
          "Control": 0.3
        },
        {
          "Stability": 0.4,
          "Control": 0.4
        }
      ],
      "TierCount": 3
    },
    "Durable": {
      "Name": "Durable",
      "MoleWeight": 70,
      "Color": null,
      "Tiers": [
        {
          "MaxMass": 0.1
        },
        {
          "MaxMass": 0.25
        },
        {
          "MaxMass": 0.5
        }
      ],
      "TierCount": 3
    },
    "Precise": {
      "Name": "Precise",
      "MoleWeight": 90,
      "Color": null,
      "Tiers": [
        {
          "Precision": 0.15
        },
        {
          "Precision": 0.3
        },
        {
          "Precision": 0.4
        }
      ],
      "TierCount": 3
    },
    "Exact": {
      "Name": "Exact",
      "MoleWeight": 20,
      "Color": null,
      "Tiers": [
        {
          "Control": 0.15,
          "Precision": 0.15
        },
        {
          "Control": 0.3,
          "Precision": 0.3
        },
        {
          "Control": 0.4,
          "Precision": 0.4
        }
      ],
      "TierCount": 3
    },
    "Stamina": {
      "Name": "Stamina",
      "MoleWeight": 70,
      "Color": null,
      "Tiers": [
        {
          "StaminaLoss": -0.2
        },
        {
          "StaminaLoss": -0.4
        },
        {
          "StaminaLoss": -0.5
        }
      ],
      "TierCount": 3
    },
    "Control": {
      "Name": "Control",
      "MoleWeight": 90,
      "Color": null,
      "Tiers": [
        {
          "Control": 0.15
        },
        {
          "Control": 0.3
        },
        {
          "Control": 0.4
        }
      ],
      "TierCount": 3
    },
    "Accurate": {
      "Name": "Accurate",
      "MoleWeight": 20,
      "Color": null,
      "Tiers": [
        {
          "Stability": 0.15,
          "Precision": 0.15
        },
        {
          "Stability": 0.3,
          "Precision": 0.3
        },
        {
          "Stability": 0.4,
          "Precision": 0.4
        }
      ],
      "TierCount": 3
    },
    "Perfect": {
      "Name": "Perfect",
      "MoleWeight": 1,
      "Color": null,
      "Tiers": [
        {
          "MaxMass": 0.1,
          "Control": 0.15,
          "Stability": 0.15,
          "Precision": 0.15,
          "LootLuck": 0.17,
          "Strength": 0.15
        },
        {
          "MaxMass": 0.25,
          "Control": 0.3,
          "Stability": 0.3,
          "Precision": 0.3,
          "LootLuck": 0.3,
          "Strength": 0.3
        },
        {
          "MaxMass": 0.5,
          "Control": 0.4,
          "Stability": 0.4,
          "Precision": 0.4,
          "LootLuck": 0.4,
          "Strength": 0.4
        }
      ],
      "TierCount": 3
    },
    "Stable": {
      "Name": "Stable",
      "MoleWeight": 90,
      "Color": null,
      "Tiers": [
        {
          "Stability": 0.15
        },
        {
          "Stability": 0.3
        },
        {
          "Stability": 0.4
        }
      ],
      "TierCount": 3
    },
    "Super": {
      "Name": "Super",
      "MoleWeight": 10,
      "Color": null,
      "Tiers": [
        {
          "Control": 0.15,
          "MaxMass": 0.1,
          "Precision": 0.15,
          "Strength": 0.15,
          "Stability": 0.15
        },
        {
          "Control": 0.3,
          "MaxMass": 0.25,
          "Precision": 0.3,
          "Strength": 0.3,
          "Stability": 0.3
        },
        {
          "Control": 0.4,
          "MaxMass": 0.5,
          "Precision": 0.4,
          "Strength": 0.4,
          "Stability": 0.4
        }
      ],
      "TierCount": 3
    }
  },
  "Update": null
}
	]])
	
	EnchantModule.EnchantmentsList.Secret = {
		TierCount = 3
	}
end

local Enchantments = {}

for Enchant, Info in EnchantModule.EnchantmentsList do
	for Tier = 1, Info.TierCount do
		table.insert(Enchantments, `{Enchant} {Tier}`)
	end
end

table.sort(Enchantments)

Tab:CreateDropdown({
	Name = "📚 • Enchants to Stop at",
	Options = Enchantments,
	MultipleOptions = true,
	Flag = "Enchants",
	Callback = function()end,
})

Tab:CreateDivider()

local AutoAppraise

AutoAppraise = Tab:CreateToggle({
	Name = `🔍 • Auto Appraise Held Item [${RemoteFunctions.LootPit:InvokeServer({Command = "GetPlayerPrice"})}]`,
	CurrentValue = false,
	Flag = "Appraise",
	Callback = function(Value)	
		while Flags.Appraise.CurrentValue and task.wait() do
			local Tool = Player.Character:FindFirstChildOfClass("Tool")

			if not Tool then
				return
			end

			local Result = RemoteFunctions.LootPit:InvokeServer({
				Command = "AppraiseItem"
			})

			for _, NewTool: Tool in Player.Backpack:GetChildren() do
				if NewTool:GetAttribute("Serial") == Tool:GetAttribute("Serial") and NewTool.Name == Tool.Name then			
					if NewTool:GetAttribute("Weight") >= Flags.Weight.CurrentValue then
						Notify("Auto Appraise", "Stopped because the selected weight was achieved")
						AutoAppraise:Set(false)
					elseif NewTool:GetAttribute("Modifier") and table.find(Flags.Modifiers.CurrentOption, NewTool:GetAttribute("Modifier")) then
						Notify("Auto Appraise", "Stopped because a selected modifier was received")
						AutoAppraise:Set(false)
					else
						Player.Character.Humanoid:EquipTool(NewTool)
					end
					
					break
				end
			end
		end
	end,
})

Tab:CreateSlider({
	Name = "⚖ • Minimum Weight to Stop at",
	Range = {1, 10000},
	Increment = 5,
	Suffix = "kg",
	CurrentValue = 1,
	Flag = "Weight",
	Callback = function()end,
})

local Modifiers = {}

local Success, ModifiersModule = pcall(require, ReplicatedStorage.Settings.Modifiers.Colors)

if not Success then
	ModifiersModule = {
		["Regular"] = Color3.fromRGB(35, 35, 35),
		["Golden"] = Color3.fromRGB(255, 235, 17),
		["Neon"] = Color3.fromRGB(16, 255, 219),
		["Quantum"] = Color3.fromRGB(186, 24, 255),
		["Festive"] = Color3.fromRGB(255, 143, 167),
		["Wooden"] = Color3.fromRGB(125, 62, 17),
		["Rusty"] = Color3.fromRGB(141, 18, 18),
		["Holy"] = Color3.fromRGB(255, 255, 255),
		["Hot"] = Color3.fromRGB(255, 0, 0),
		["Biodegradable"] = Color3.fromRGB(9, 198, 38),
		["Magma"] = Color3.fromRGB(255, 1, 1),
		["Evil"] = Color3.fromRGB(149, 1, 1),
		["Rainbow"] = Color3.fromRGB(0, 0, 0),
		["Solar"] = Color3.fromRGB(),
		["Venom"] = Color3.fromRGB()
	}
end

for i,v in ModifiersModule do
	table.insert(Modifiers, i)
end

Tab:CreateDropdown({
	Name = "🧬 • Modifiers to Stop at",
	Options = Modifiers,
	MultipleOptions = true,
	Flag = "Modifiers",
	Callback = function()end,
})

Tab:CreateSection("Information")

local Icons = {
	Mole = "rbxassetid://71479472086037",
	RoyalMole = "rbxassetid://71400449192663"
}

Tab:CreateButton({
	Name = "🔢 • Get Mole Count (Open Bank First)",
	Callback = function()
		local Moles = 0
		local RoyalMoles = 0

		for i,v: Tool in Player.Backpack:GetChildren() do
			if v.Name == "Mole" then
				Moles += 1
			elseif v.Name == "Royal Mole" then
				RoyalMoles += 1
			end
		end

		for i,v: ImageLabel in Player.PlayerGui.Main.Core.Inventory.Inventory.Slots:GetChildren() do
			if not v:IsA("ImageLabel") then
				continue
			end

			if v.Icon.Image == Icons.Mole then
				Moles += 1
			elseif v.Icon.Image == Icons.RoyalMole then
				RoyalMoles += 1
			end
		end

		Notify("Total Moles", `You have {Moles} Moles and {RoyalMoles} Royal Moles`)
	end,
})

getgenv().CreateUniversalTabs()
