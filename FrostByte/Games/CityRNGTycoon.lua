local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.4"

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFunctions: {[string]: RemoteFunction} = ReplicatedStorage.RemoteFunctions
local RemoteEvents: {[string]: RemoteEvent} = ReplicatedStorage.RemoteEvents

local Window = getgenv().Window

if not Window then
	return
end

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
	Name = ApplyUnsupportedName("🔀 • Auto Merge Buildings", pcall(require, ReplicatedStorage.ClientSystems.Inventory)),
	CurrentValue = false,
	Flag = "Merge",
	Callback = function(Value)	
		while Flags.Merge.CurrentValue and task.wait() do
			local Success, Module = pcall(require, ReplicatedStorage.ClientSystems.Inventory)
			
			if not Success then
				continue
			end
			
			local Inventory = Module._Inventory
			
			if not Inventory then
				continue
			end
			
			local All = Inventory.All
			
			if not All then
				continue
			end
			
			for Name, Building in All do
				for Level, Info in Building do
					local Count = Info.Count
					
					if Count < 3 then
						continue
					end
					
					RemoteEvents.Upgrade:FireServer(Name, Level, math.floor(Count / 3))
				end
			end
		end
	end,
})

Tab:CreateSection("Items")

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
	Callback = function(CurrentOption)
		CurrentOption = CurrentOption[1]

		if CurrentOption == "None" then
			return
		end

		Player.Character:PivotTo(TycoonsAssociated[CurrentOption].Spawn.Spawn:GetPivot())
	end,
})

getgenv().CreateUniversalTabs()
