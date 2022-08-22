-- Must be near the button to buy

-- // Variables \\ --

getgenv().AutoBuyItem = true -- set this to true/false for on/off
getgenv().DesiredAmount = 5 -- set this to the amount you want to buy
getgenv().DesiredItem = "Protein Shake $200" -- set this to the tag of the item you want, e.g "Water $65"

local AmountInInventory = 0

local Item

-- // Setup \\ --

for i,v in pairs(game:GetService("Workspace").Items:GetChildren()) do
	if v:FindFirstChild(DesiredItem) then
		Item = v:FindFirstChild(DesiredItem)
	end
end

-- // Main Function \\ --

for i = 1, DesiredAmount do
	repeat
		if AutoBuyItem then
			fireproximityprompt(Item.Head.ProximityPrompt)
			Item.Head:GetPropertyChangedSignal("Color"):Wait()

			AmountInInventory = AmountInInventory + 1
		end
	until AmountInInventory >= DesiredAmount or not AutoBuyItem
end
