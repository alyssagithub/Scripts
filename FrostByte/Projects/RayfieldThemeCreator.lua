local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "ThemeCreator"
getgenv().PlaceName = "Projects"
getgenv().PlaceFileName = `Projects-{getgenv().ScriptVersion}`

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Core.lua"))()

type Tab = {
	CreateSection: (self: Tab, Name: string) -> Section,
	CreateDivider: (self: Tab) -> Divider,
}

local Notify: (Title: string, Content: string, Image: string) -> () = getgenv().Notify

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local Window = getgenv().Window

if not Window then
	return
end

local ThemeInfo = {
	TextColor = Color3.fromRGB(240, 240, 240),

	Background = Color3.fromRGB(25, 25, 25),
	Topbar = Color3.fromRGB(34, 34, 34),
	Shadow = Color3.fromRGB(20, 20, 20),

	NotificationBackground = Color3.fromRGB(20, 20, 20),
	NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

	TabBackground = Color3.fromRGB(80, 80, 80),
	TabStroke = Color3.fromRGB(85, 85, 85),
	TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
	TabTextColor = Color3.fromRGB(240, 240, 240),
	SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

	ElementBackground = Color3.fromRGB(35, 35, 35),
	ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
	SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
	ElementStroke = Color3.fromRGB(50, 50, 50),
	SecondaryElementStroke = Color3.fromRGB(40, 40, 40),

	SliderBackground = Color3.fromRGB(50, 138, 220),
	SliderProgress = Color3.fromRGB(50, 138, 220),
	SliderStroke = Color3.fromRGB(58, 163, 255),

	ToggleBackground = Color3.fromRGB(30, 30, 30),
	ToggleEnabled = Color3.fromRGB(0, 146, 214),
	ToggleDisabled = Color3.fromRGB(100, 100, 100),
	ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
	ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
	ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
	ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

	DropdownSelected = Color3.fromRGB(40, 40, 40),
	DropdownUnselected = Color3.fromRGB(30, 30, 30),

	InputBackground = Color3.fromRGB(30, 30, 30),
	InputStroke = Color3.fromRGB(65, 65, 65),
	PlaceholderColor = Color3.fromRGB(178, 178, 178)
}

local function UpdateTheme()
	for Name, Info in Flags do
		if ThemeInfo[Name] then
			ThemeInfo[Name] = Info.Color
		end
	end
	
	Window.ModifyTheme(ThemeInfo)
end

local Tab: Tab = Window:CreateTab("Tabs", "rectangle-ellipsis")

Tab:CreateSection("Background")

Tab:CreateColorPicker({
	Name = "TabBackground",
	Color = Color3.fromRGB(80, 80, 80),
	Flag = "TabBackground",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "TabStroke",
	Color = Color3.fromRGB(85, 85, 85),
	Flag = "TabStroke",
	Callback = UpdateTheme
})

Tab:CreateSection("Selected")

Tab:CreateColorPicker({
	Name = "TabBackgroundSelected",
	Color = Color3.fromRGB(210, 210, 210),
	Flag = "TabBackgroundSelected",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "SelectedTabTextColor",
	Color = Color3.fromRGB(50, 50, 50),
	Flag = "SelectedTabTextColor",
	Callback = UpdateTheme
})

Tab:CreateSection("Text")

Tab:CreateColorPicker({
	Name = "TabTextColor",
	Color = Color3.fromRGB(240, 240, 240),
	Flag = "TabTextColor",
	Callback = UpdateTheme
})

local Tab: Tab = Window:CreateTab("Main", "app-window")

Tab:CreateSection("Background")

Tab:CreateColorPicker({
	Name = "Shadow",
	Color = Color3.fromRGB(20, 20, 20),
	Flag = "Shadow",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "Background",
	Color = Color3.fromRGB(25, 25, 25),
	Flag = "Background",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "Topbar",
	Color = Color3.fromRGB(34, 34, 34),
	Flag = "Topbar",
	Callback = UpdateTheme
})

Tab:CreateSection("Notification")

Tab:CreateColorPicker({
	Name = "NotificationBackground",
	Color = Color3.fromRGB(20, 20, 20),
	Flag = "NotificationBackground",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "NotificationActionsBackground",
	Color = Color3.fromRGB(230, 230, 230),
	Flag = "NotificationActionsBackground",
	Callback = UpdateTheme
})

Tab:CreateSection("Text")

Tab:CreateColorPicker({
	Name = "TextColor",
	Color = Color3.fromRGB(240, 240, 240),
	Flag = "TextColor",
	Callback = UpdateTheme
})

local Tab: Tab = Window:CreateTab("Elements", "layout-grid")

Tab:CreateSection("Slider")

Tab:CreateColorPicker({
	Name = "SliderProgress",
	Color = Color3.fromRGB(50, 138, 220),
	Flag = "SliderProgress",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "SliderBackground",
	Color = Color3.fromRGB(50, 138, 220),
	Flag = "SliderBackground",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "SliderStroke",
	Color = Color3.fromRGB(58, 163, 255),
	Flag = "SliderStroke",
	Callback = UpdateTheme
})

Tab:CreateSection("Input")

Tab:CreateColorPicker({
	Name = "PlaceholderColor",
	Color = Color3.fromRGB(178, 178, 178),
	Flag = "PlaceholderColor",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "InputStroke",
	Color = Color3.fromRGB(65, 65, 65),
	Flag = "InputStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "InputBackground",
	Color = Color3.fromRGB(30, 30, 30),
	Flag = "InputBackground",
	Callback = UpdateTheme
})

Tab:CreateSection("Toggle")

Tab:CreateColorPicker({
	Name = "ToggleDisabledStroke",
	Color = Color3.fromRGB(125, 125, 125),
	Flag = "ToggleDisabledStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleDisabledOuterStroke",
	Color = Color3.fromRGB(65, 65, 65),
	Flag = "ToggleDisabledOuterStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleEnabledOuterStroke",
	Color = Color3.fromRGB(100, 100, 100),
	Flag = "ToggleEnabledOuterStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleEnabled",
	Color = Color3.fromRGB(0, 146, 214),
	Flag = "ToggleEnabled",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleEnabledStroke",
	Color = Color3.fromRGB(0, 170, 255),
	Flag = "ToggleEnabledStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleDisabled",
	Color = Color3.fromRGB(100, 100, 100),
	Flag = "ToggleDisabled",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ToggleBackground",
	Color = Color3.fromRGB(30, 30, 30),
	Flag = "ToggleBackground",
	Callback = UpdateTheme
})

Tab:CreateSection("Dropdown")

Tab:CreateColorPicker({
	Name = "DropdownUnselected",
	Color = Color3.fromRGB(30, 30, 30),
	Flag = "DropdownUnselected",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "DropdownSelected",
	Color = Color3.fromRGB(40, 40, 40),
	Flag = "DropdownSelected",
	Callback = UpdateTheme
})

Tab:CreateSection("All")

Tab:CreateColorPicker({
	Name = "ElementBackgroundHover",
	Color = Color3.fromRGB(40, 40, 40),
	Flag = "ElementBackgroundHover",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "SecondaryElementStroke",
	Color = Color3.fromRGB(40, 40, 40),
	Flag = "SecondaryElementStroke",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ElementBackground",
	Color = Color3.fromRGB(35, 35, 35),
	Flag = "ElementBackground",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "SecondaryElementBackground",
	Color = Color3.fromRGB(25, 25, 25),
	Flag = "SecondaryElementBackground",
	Callback = UpdateTheme
})

Tab:CreateColorPicker({
	Name = "ElementStroke",
	Color = Color3.fromRGB(50, 50, 50),
	Flag = "ElementStroke",
	Callback = UpdateTheme
})

local Tab: Tab = Window:CreateTab("Example", "toggle-left")

Tab:CreateSection("Elements")

Tab:CreateButton({
	Name = "Press for Notification",
	Callback = function()
		if not Flags.Notifications.CurrentValue then
			Flags.Notifications:Set(true)
		end
		
		Notify("Title", "Content", "octagon-alert")
	end,
})

Tab:CreateToggle({
	Name = "Toggle",
	CurrentValue = false,
	Callback = function()end,
})

Tab:CreateColorPicker({
	Name = "Color Picker",
	Color = Color3.fromRGB(255, 255, 255),
	Callback = function()end
})

Tab:CreateSlider({
	Name = "Slider",
	Range = {0, 100},
	Increment = 1,
	Suffix = "Suffix",
	CurrentValue = 0,
	Callback = function()end,
})

Tab:CreateInput({
	Name = "Input",
	CurrentValue = "",
	PlaceholderText = "Placeholder",
	RemoveTextAfterFocusLost = false,
	Callback = function()end,
})

Tab:CreateDropdown({
	Name = "Dropdown",
	Options = {"Option1", "Option2", "Option3", "Option4"},
	CurrentOption = "Option1",
	MultipleOptions = true,
	Callback = function()end,
})

Tab:CreateSection("Binds")

Tab:CreateKeybind({
	Name = "Keybind",
	CurrentKeybind = "Q",
	HoldToInteract = false,
	Callback = function()end,
})

Tab:CreateSection("Textual")

Tab:CreateLabel("Label Title", "info")

Tab:CreateParagraph({Title = "Paragraph Title", Content = "Paragraph Content\n🔥⚔⚡⛏️🔄✨🖼️🔓💰🛒💯🧲🗃💵🎒🌟📚🔍⚖🧬🌠🌥🏝💸📦🐦🛠📏🏷️🌋💥🔢"})

local Tab: Tab = Window:CreateTab("Settings", "settings")

Tab:CreateSection("Notifications")

Tab:CreateToggle({
	Name = "Notifications",
	CurrentValue = true,
	Flag = "Notifications",
	Callback = function(Value)
		local Rayfield = game:GetService("CoreGui"):FindFirstChild("Rayfield")
		
		if not Rayfield then
			return
		end

		Rayfield.Notifications.Visible = Value
	end,
})

task.wait(1)
UpdateTheme()
