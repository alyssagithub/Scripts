--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "BETA"

getgenv().Changelog = [[
aun is a femboy
]]

do
	repeat
		local Core = loadstring(game:HttpGet("https://github.com/alyssagithub/Scripts/raw/main/FrostByte/Core.luau"))

		if Core then
			Core()
		else
			warn("[FrostByte]: Failed to load the Core, retrying")
		end

		task.wait()
	until Core
end

-- Types

type Element = {
	CurrentValue: any,
	CurrentOption: {string},
	Set: (self: Element, any) -> ()
}

type Flags = {
	[string]: Element
}

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Element,
	CreateDivider: (self: Tab) -> Element,
	CreateToggle: (self: Tab, any) -> Element,
	CreateSlider: (self: Tab, any) -> Element,
	CreateDropdown: (self: Tab, any) -> Element,
	CreateButton: (self: Tab, any) -> Element,
	CreateLabel: (self: Tab, any, any?) -> Element,
	CreateParagraph: (self: Tab, any) -> Element,
	CreateInput: (self: Tab, any) -> Element,
}

-- Variables

local HandleConnection: (Connection: RBXScriptConnection?, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string?) -> () = getgenv().Notify
local GetClosestChild: (Children: {PVInstance}, (Child: PVInstance) -> ()?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local CreateFeature: (Tab: Tab, FeatureName: string) -> () = getgenv().CreateFeature

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = game:GetService("Players").LocalPlayer

-- Features

local Flags: Flags = getgenv().Flags

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Visuals", "sparkles")

Tab:CreateSection("ESP")

local CoreGui: Folder = game:GetService("CoreGui")

local function StringFloor(Number): string
	return tostring(math.floor(Number))
end

local function ESPModel(Model: Model, FlagName: string, OverheadText: string)
	local FolderName = `{Model.Name}_{FlagName}`

	if not Flags[FlagName].CurrentValue then
		local Holder = CoreGui:FindFirstChild(FolderName)

		if not Holder then
			return
		end

		Holder:Destroy()

		return
	end

	do
		local ExistingFolder = CoreGui:FindFirstChild(FolderName)

		if ExistingFolder then
			ExistingFolder:Destroy()
		end
	end

	local Holder = Instance.new("Folder")
	Holder.Name = FolderName
	Holder.Parent = CoreGui

	for _, Object in Model:GetChildren() do
		if not Object:IsA("BasePart") and not Object:IsA("Model") then
			continue
		end

		local BoxHandleAdornment = Instance.new("BoxHandleAdornment")
		BoxHandleAdornment.Name = Model.Name
		BoxHandleAdornment.Adornee = Object
		BoxHandleAdornment.AlwaysOnTop = true
		BoxHandleAdornment.ZIndex = 10
		BoxHandleAdornment.Size = if Object:IsA("BasePart") then Object.Size else Object:GetExtentsSize()
		BoxHandleAdornment.Transparency = 0.5
		BoxHandleAdornment.Color3 = if Players:GetPlayerFromCharacter(Model) then BrickColor.new("Lapis").Color else BrickColor.new("Bright red").Color
		BoxHandleAdornment.Parent = Holder
	end

	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Name = Model.Name
	BillboardGui.Adornee = Model:FindFirstChild("Head") or Model:FindFirstChildWhichIsA("PVInstance")
	BillboardGui.Size = UDim2.new(0, 100, 0, 150)
	BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Parent = Holder

	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0, 0, 0, -50)
	TextLabel.Size = UDim2.new(0, 100, 0, 100)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 20
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TextLabel.Text = "Loading..."
	TextLabel.ZIndex = 10
	TextLabel.Parent = BillboardGui

	local RenderSteppedConnection: RBXScriptConnection
	RenderSteppedConnection = RunService.RenderStepped:Connect(function()
		if not Flags[FlagName].CurrentValue then
			Holder:Destroy()
			return
		end

		local ModelHumanoid = Model:FindFirstChild("Humanoid") :: Humanoid

		if not Model.Parent or (ModelHumanoid and ModelHumanoid.Health <= 0) then
			Holder:Destroy()
			return
		end

		local NewText = OverheadText:gsub("<NAME>", Model.Name)

		if Player.Character and Player.Character:FindFirstChild("Humanoid") then
			local Distance = math.floor((Model:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude)
			NewText = NewText:gsub("<DISTANCE>", StringFloor(Distance))
		end

		if ModelHumanoid then
			NewText = NewText:gsub("<HEALTH>", StringFloor(ModelHumanoid.Health))
			NewText = NewText:gsub("<MAXHEALTH>", StringFloor(ModelHumanoid.MaxHealth))
			NewText = NewText:gsub("<HEALTHPERCENTAGE>", StringFloor(ModelHumanoid.Health / ModelHumanoid.MaxHealth * 100))
		end

		TextLabel.Text = NewText
	end)

	Holder.Destroying:Once(function()
		RenderSteppedConnection:Disconnect()
	end)
end

local PlayerText = "Player: <NAME> | Health: <HEALTH>/<MAXHEALTH> (<HEALTHPERCENTAGE>%) | Distance: <DISTANCE>"

local function PlayerESP(Target: Model)
	if not Target:GetAttribute("LivesLeft") then
		return
	end
	
	if Target.Name == Player.Name then
		return
	end

	ESPModel(Target, "PlayerESP", PlayerText)
end

Tab:CreateToggle({
	Name = "🧍‍ • Player ESP",
	CurrentValue = false,
	Flag = "PlayerESP",
	Callback = function(Value)
		for _, Target in workspace:GetChildren() do
			PlayerESP(Target)
		end
	end,
})

HandleConnection(workspace.ChildAdded:Connect(PlayerESP), "PlayerESP")

getgenv().CreateUniversalTabs()
