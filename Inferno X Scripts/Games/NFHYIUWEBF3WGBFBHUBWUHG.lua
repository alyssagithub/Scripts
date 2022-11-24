local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

local NewLooping
local ItemLooping

local SelectedPrice = 100

local GetItems
local Buy

local Items = {}
local Items2 = {}

local GetItemLooping = true

if Player.PlayerGui.MainUI.Warning.Visible == true then
	repeat
		Click(Player.PlayerGui.MainUI.Warning.button)
		task.wait()
	until Player.PlayerGui.MainUI.Warning.Visible == false
end

if Player.PlayerGui.MainUI.Tutorial.Visible == true then
	repeat
		Click(Player.PlayerGui.MainUI.Tutorial.Next)
		task.wait()
	until Player.PlayerGui.MainUI.Tutorial.Visible == false
	task.wait(1)
end

task.spawn(function()
	while task.wait(Random.new():NextNumber(2, 5)) do
		pcall(function()
			if GetItemLooping then
				local GetItems2 = game:GetService("ReplicatedStorage").Remotes.GetItems:InvokeServer()
				repeat task.wait() until GetItems2
				GetItems = GetItems2
			end
		end)
	end
end)

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "🔍 New Item Sniper",
	CurrentValue = false,
	Flag = "NewItemSniper",
	Callback = function(Value)
		NewLooping = Value
	end,
})

if GetItems then
	for i,v in pairs(GetItems) do
		if not table.find(Items, v.name) then
			table.insert(Items, v.name)
		end
	end
end

task.spawn(function()
	while task.wait() do
		if NewLooping then
			if GetItems then
				for i,v in pairs(GetItems) do
					if v.status == "new" and not table.find(Items, v.name) then
						repeat
							pcall(function()
								Buy = game:GetService("ReplicatedStorage").Remotes.Purchase:InvokeServer(v.name)
								if Buy[1] and Buy[1] == "Success" then
									print("[Inferno X] Debug: (New Item Sniper) Bought item: "..v.name)
								end
								task.wait(math.random(1, 5))
							end)
						until Buy and Buy.error and Buy.error == "You have max amount of this item"
					end
				end
			end
		end
	end
end)

Main:CreateSlider({
	Name = "🔢 Item Sniping Price",
	Range = {0, 1000},
	Increment = 1,
	CurrentValue = 100,
	Flag = "SelectedPrice",
	Callback = function(Value)
		SelectedPrice = Value
	end,
})

Main:CreateToggle({
	Name = "🔎 Item Sniper",
	CurrentValue = false,
	Flag = "ItemSniper",
	Callback = function(Value)
		ItemLooping = Value
	end,
})

task.spawn(function()
	while task.wait() do
		if ItemLooping then
			if GetItems then
				for i,v in pairs(GetItems) do
					if v.status == "limited" and v.price and v.price <= SelectedPrice and not GetItemLooping then
						local GetItemInfo = game:GetService("ReplicatedStorage").Remotes.GetItemInfo:InvokeServer(v.name)

						if not GetItemInfo.listings or not GetItemInfo.listings[1] then
							repeat task.wait() until GetItemInfo.listings and GetItemInfo.listings[1]
						end

						local Id = GetItemInfo.listings[1].id

						if not table.find(Items2, Id) and GetItemInfo.listings[1].price and GetItemInfo.listings[1].price <= v.price then
							GetItemLooping = false
							local Buy2 = game:GetService("ReplicatedStorage").Remotes.PurchaseL:InvokeServer(v.name, Id)
							print(Buy2)
							print("[Inferno X] Debug: (Item Sniper) Bought item: "..v.name.." for "..v.price.." or "..GetItemInfo.listings[1].price.." with id "..Id)
							table.insert(Items2, Id)
							task.wait(2)
							GetItemLooping = true
						end
					end
				end
			end
		end
	end
end)
