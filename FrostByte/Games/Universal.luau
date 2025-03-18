--!strict
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "Universal"

getgenv().Changelog = [[
Thank you for using FrostByte!
]]

do
	local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))

	if not Core then
		return warn("Failed to load the FrostByte Core")
	end

	Core()
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
}

-- Variables

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName
local HandleConnection: (Connection: RBXScriptConnection?, Name: string) -> () = getgenv().HandleConnection
local Notify: (Title: string, Content: string, Image: string?) -> () = getgenv().Notify
local GetClosestChild: (Children: {PVInstance}, Callback: ((Child: PVInstance) -> () | boolean)?, MaxDistance: number?) -> PVInstance? = getgenv().GetClosestChild
local CreateFeature: (Tab: Tab, FeatureName: string) -> () = getgenv().CreateFeature

local Player = game:GetService("Players").LocalPlayer

-- Features

local Flags: Flags = getgenv().Flags

local Window = getgenv().Window

local Tab: Tab = Window:CreateTab("Speed", "gauge")

Tab:CreateSection("Speed")

CreateFeature(Tab, "Speed")

local Tab: Tab = Window:CreateTab("Safety", "shield")

Tab:CreateSection("Identity")

CreateFeature(Tab, "HideIdentity")

getgenv().CreateUniversalTabs()
