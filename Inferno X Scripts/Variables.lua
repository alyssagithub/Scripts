if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GlobalWebhookUnsplit = "https://discord.com/api/webhooks/1086557042073927720/CEG1sHOtOTU{FGGMLRSUCb6wp9LBeP_aqAGzfIyobQXW4NFJxTn4kLNC6VpsFFWx-AUHc" -- this is literally in a private channel dumbasses
local SuggestionsWebhookUnsplit = "https://discord.com/api/webhooks/1058223889756471316/fPntTW{_aNzGAaTPS8HILTRRS_8VoFQreBhrwhS04kQMTRrkNgBqpNLGWwn-5jwpUR2NI"

local GlobalWebhook = GlobalWebhookUnsplit:split("{")[1]..GlobalWebhookUnsplit:split("{")[2]
local SuggestionsWebhook = SuggestionsWebhookUnsplit:split("{")[1]..SuggestionsWebhookUnsplit:split("{")[2]

local function CurrentVersion()
	return
end

pcall(function()
	if isfile and writefile and readfile then
		local CurrentTime = tick()

		local function SetWebhook()
			writefile("InfernoXWebhooking.txt", CurrentTime)
			print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
			Webhook = GlobalWebhook
		end

		if not isfile("InfernoXWebhooking.txt") or tonumber(readfile("InfernoXWebhooking.txt")) < CurrentTime - 7200 then
			SetWebhook()
		else
			Webhook = nil
		end
	end
end)

local function getexploit()
	return
		(secure_load and "Sentinel") or
		(is_sirhurt_closure and "Sirhurt") or
		(pebc_execute and "ProtoSmasher") or
		(KRNL_LOADED and "Krnl") or
		(WrapGlobal and "WeAreDevs") or
		(isvm and "Proxo") or
		(shadow_env and "Shadow") or
		(jit and "EasyExploits") or
		(getscriptenvs and "Calamari") or
		(unit and not syn and "Unit") or
		(OXYGEN_LOADED and "Oxygen U") or
		(IsElectron and "Electron") or
		(IS_COCO_LOADED and "Coco") or
		(IS_VIVA_LOADED and "Viva") or
		(syn and is_synapse_function and "Synapse") or
		("Other")
end

print("[Inferno X] Debug: Detected Executor: "..getexploit())

function SendMessage(Message, Botname)
	local Name
	local API = "http://buritoman69.glitch.me/webhook"

	if (not Message or Message == "" or not Botname) or not Webhook then
		Name = "GameBot"
		return error("nil or empty message!")
	else
		Name = Botname
	end

	local Body = {
		['Key'] = "applesaregood",
		['Message'] = tostring(Message),
		['Name'] = "Execution",
		['Webhook'] = Webhook  
	}

	Body = HttpService:JSONEncode(Body)
	local Data = game:HttpPost(API, Body, false, "application/json")

	return Data or nil;
end

task.spawn(function()
	pcall(SendMessage, "[Inferno X] Data: Inferno X was executed by "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." using "..getexploit())
end)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until CoreGui:FindFirstChild("Rayfield"):FindFirstChild("Main")

		CoreGui:FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
	end)
end)

local function Click(v)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,true,v,1)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,false,v,1)
end

local function comma(amount)
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

local function Notify(Message, Duration)
	Rayfield:Notify({
		Title = "🔥 Inferno X",
		Content = Message,
		Duration = Duration or 5,
		Image = 4483362458,
		Actions = {},
	})
end

local function CreateWindow(Version)
	local Window = Rayfield:CreateWindow({
		Name = "🔥 Inferno X - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." - "..(Version and Version or "v1"),
		LoadingTitle = "🔥 Inferno X",
		LoadingSubtitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		ConfigurationSaving = {
			Enabled = true,
			FolderName = "InfernoXConfig",
			FileName = game.PlaceId.."-"..Player.Name
		}
	})
	
	repeat task.wait() until CoreGui:FindFirstChild("Rayfield") and CoreGui.Rayfield:FindFirstChild("Main") and CoreGui.Rayfield.Main:FindFirstChild("TabList")
	
	local LastChild = tick()
	
	CoreGui.Rayfield.Main.TabList.ChildAdded:Connect(function(Child)
		LastChild = tick()
	end)
	
	repeat task.wait() until tick() - LastChild > .1

	--task.delay(1, function()
		local Universal = Window:CreateTab("Extra", 4483362458)

		Universal:CreateSection("AFKing")

		Universal:CreateToggle({
			Name = "🚫 Anti-AFK",
			CurrentValue = false,
			Flag = "Universal-AntiAFK",
			Callback = function(Value)	end,
		})

		local VirtualUser = game:GetService("VirtualUser")
		Player.Idled:Connect(function()
			if Rayfield.Flags["Universal-AntiAFK"].CurrentValue then
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end
		end)

		local AutoRejoin = Universal:CreateToggle({
			Name = "🔁 Auto Rejoin",
			CurrentValue = false,
			Flag = "Universal-AutoRejoin",
			Callback = function(Value)
				if Value then
					repeat task.wait() until CoreGui:FindFirstChild("RobloxPromptGui")

					CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:connect(function(a)
						if a.Name == "ErrorPrompt" and Rayfield.Flags["Universal-AutoRejoin"].CurrentValue then
							while true do
								TeleportService:Teleport(game.PlaceId)
								task.wait(2)
							end
						end
					end)
				end
			end,
		})

		Universal:CreateToggle({
			Name = "📶 Auto Re-Execute",
			CurrentValue = false,
			Flag = "Universal-AutoRe-Execute",
			Callback = function(Value)
				if Value then
					local queueteleport = queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport

					if queueteleport then
						queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Script%20Hub%20-%20Inferno%20X.lua"))()')
					end
				end
			end,
		})

		Universal:CreateSection("Safety")

		local GroupId = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Creator.CreatorTargetId

		Universal:CreateToggle({
			Name = "🚪 Leave Upon Staff Join",
			Info = "Kicks you if a player above the group role 1 joins/is in the server",
			CurrentValue = false,
			Flag = "Universal-AutoLeave",
			Callback = function(Value)
				if Value then
					for i,v in pairs(game.Players:GetPlayers()) do
						pcall(function()
							if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
								AutoRejoin:Set(false)
								Player:Kick("Detected Staff (Player above group rank 1)")
							end
						end)
					end
				end
			end,
		})

		game:GetService("Players").PlayerAdded:Connect(function(v)
			if Rayfield.Flags["Universal-AutoLeave"].CurrentValue then
				pcall(function()
					if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
						AutoRejoin:Set(false)
						Player:Kick("Detected Staff (Player above group rank 1)")
					end
				end)
			end
		end)

		Universal:CreateSection("Grinding")

		local function ServerHop()
			local Http = game:GetService("HttpService")
			local TPS = game:GetService("TeleportService")
			local Api = "https://games.roblox.com/v1/games/"

			local _place,_id = game.PlaceId, game.JobId
			local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

			local function ListServers(cursor)
				local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
				return Http:JSONDecode(Raw)
			end

			local Next; repeat
				local Servers = ListServers(Next)
				for i,v in next, Servers.data do
					if v.playing < v.maxPlayers and v.id ~= _id then
						local s,r = pcall(TPS.TeleportToPlaceInstance,TPS,_place,v.id,Player)
						if s then break end
					end
				end

				Next = Servers.nextPageCursor
			until not Next
		end

		Universal:CreateButton({
			Name = "🔂 One-Time Server Hop",
			Callback = function()
				ServerHop()
			end,
		})

		Universal:CreateToggle({
			Name = "🔁 Server Hop",
			Info = "Automatically server hops after the interval",
			CurrentValue = false,
			Flag = "Universal-ServerHop",
			Callback = function(Value)	end,
		})

		Universal:CreateSlider({
			Name = "⏲ Server Hop Intervals",
			Info = "Sets the interval in seconds for the Server Hop",
			Range = {5, 600},
			Increment = 1,
			CurrentValue = 5,
			Flag = "Universal-ServerhopIntervals",
			Callback = function(Value)	end,
		})

		task.spawn(function()
			while task.wait(Rayfield.Flags["Universal-ServerhopIntervals"].CurrentValue) do
				if Rayfield.Flags["Universal-ServerHop"].CurrentValue then
					ServerHop()
				end
			end
		end)

		Rayfield:LoadConfiguration()
	--end)

	return Window
end

return Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion

-- local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrnetVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()
