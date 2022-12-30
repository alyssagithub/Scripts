if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local VCurrentVersion

local function CurrentVersion(v)
	if v then
		VCurrentVersion = v
	end
end

local GlobalWebhook = "https://discord.com/api/webhooks/1050906518821810197/KD4gmLv7pbC_Lu-sJVxlRreEJDWG4NDttR0w0Rcr8XSDsci34Iwbl6r7cBTznBH84Tp-" -- this is literally in a private channel dumbasses
local HttpService = game:GetService("HttpService")

pcall(function()
	if isfile and writefile and readfile then
		local CurrentTime = tick()
		
		local function SetWebhook()
			writefile("InfernoXWebhooking.txt", CurrentTime)
			print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
			Webhook = GlobalWebhook
		end

		if not isfile("InfernoXWebhooking.txt") then
			SetWebhook()
		elseif tonumber(readfile("InfernoXWebhooking.txt")) < CurrentTime - 7200 then
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
		(syn and is_synapse_function and not is_sirhurt_closure and not pebc_execute and "Synapse") or
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
		['Key'] = tostring("applesaregood"),
		['Message'] = tostring(Message),
		['Name'] = Name,
		['Webhook'] = Webhook  
	}

	Body = HttpService:JSONEncode(Body)
	local Data = game:HttpPost(API, Body, false, "application/json")

	return Data or nil;
end

task.spawn(function()
	repeat task.wait() until VCurrentVersion
	pcall(SendMessage, "[Inferno X] Data: Inferno X was executed by "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." "..VCurrentVersion.." using "..getexploit(), "Execution")
end)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main")

		game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
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

local function CreateWindow()
	repeat task.wait() until VCurrentVersion

	local Window = Rayfield:CreateWindow({
		Name = "🔥 Inferno X - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." - "..VCurrentVersion,
		LoadingTitle = "🔥 Inferno X",
		LoadingSubtitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		ConfigurationSaving = {
			Enabled = true,
			FolderName = "InfernoXConfig",
			FileName = game.PlaceId.."-"..Player.Name
		},
		Discord = {
			Enabled = true,
			Invite = "rtgv8Jp3fM",
			RememberJoins = true
		}
	})

	repeat task.wait() until Window

	task.delay(1.5, function()
		local Universal = Window:CreateTab("Universal", 4483362458)

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
					repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

					local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

					po.ChildAdded:connect(function(a)
						if Rayfield.Flags["Universal-AutoRejoin"].CurrentValue and a.Name == 'ErrorPrompt' then
							while true do
								ts:Teleport(game.PlaceId)
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
					local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

					if queueteleport then
						queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Script%20Hub%20-%20Inferno%20X.lua"))()')
					end
				end
			end,
		})

		Rayfield:LoadConfiguration()

		Universal:CreateSection("Modifiers")
		
		if syn and not getgenv().MTAPIMutex then 
			loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() 
			Player.Character.Humanoid:AddPropertyEmulator("WalkSpeed")
			Player.Character.Humanoid:AddPropertyEmulator("JumpPower")
		end

		Universal:CreateSlider({
			Name = "💨 WalkSpeed",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.WalkSpeed,
			Flag = "Universal-WalkSpeed",
			Callback = function(Value)	end,
		})

		task.spawn(function()
			while task.wait() do
				if Player.Character.Humanoid.WalkSpeed ~= Rayfield.Flags["Universal-WalkSpeed"].CurrentValue then
					Player.Character.Humanoid.WalkSpeed = Rayfield.Flags["Universal-WalkSpeed"].CurrentValue
				end
			end
		end)
		
		Universal:CreateSlider({
			Name = "⬆ JumpPower",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.JumpPower,
			Flag = "Universal-JumpPower",
			Callback = function(Value)	end,
		})

		task.spawn(function()
			while task.wait() do
				if Player.Character.Humanoid.JumpPower ~= Rayfield.Flags["Universal-JumpPower"].CurrentValue then
					Player.Character.Humanoid.JumpPower = Rayfield.Flags["Universal-JumpPower"].CurrentValue
				end
			end
		end)

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

		local Credits = Window:CreateTab("Credits/Suggestions", 4483362458)

		Credits:CreateLabel("🔥 Inferno X was made by alyssa#2303 🔥")

		Credits:CreateButton({
			Name = "➡ Join Discord discord.gg/rtgv8Jp3fM ⬅",
			Callback = function()
				local HttpService = game:GetService("HttpService")
				local http_req = (syn and syn.request) or (http and http.request) or http_request
				if http_req then
					http_req({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = 'POST',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = HttpService:JSONEncode({
							cmd = 'INVITE_BROWSER',
							nonce = HttpService:GenerateGUID(false),
							args = {code = 'rtgv8Jp3fM'}
						})
					})
				elseif setclipboard then
					setclipboard("https://discord.gg/rtgv8Jp3fM")

					Notify("Link Copied to Clipboard", 5)
				end
			end,
		})

		local SuggestionsWebhook = "https://discord.com/api/webhooks/1050906550803386408/SHmpOK-pOyhl9JeBwvHRx9ka3Gtuxg542ciMlQ0S1q2fLemVaZwX00hox404rXS76KNX"

		Credits:CreateInput({
			Name = "Suggestion",
			PlaceholderText = "Insert Suggestion Here",
			NumbersOnly = false,
			CharacterLimit = 300,
			Enter = true,
			RemoveTextAfterFocusLost = false,
			Callback = function(Text)
				if #Text > 3 then
					pcall(function()
						if isfile and writefile and readfile then
							local CurrentTime = tick()
							
							local function SetSuggestionsWebhook()
								Webhook = SuggestionsWebhook
								local success, result = pcall(SendMessage, "[Inferno X] Data: "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." suggested "..Text.." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Suggestion")
								if success then
									Notify("Successfully Sent Suggestion", 5)
									writefile("InfernoXWebhooking2.txt", CurrentTime)
									print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
								else
									Notify("Unsuccessful Sending Suggestion, Error: "..result, 5)
								end
							end

							if not isfile("InfernoXWebhooking2.txt") then
								SetSuggestionsWebhook()
							elseif tonumber(readfile("InfernoXWebhooking2.txt")) < CurrentTime - 86400 then
								SetSuggestionsWebhook()
							else
								Webhook = nil
								Notify("You are on a 24 Hour Cooldown", 5)
							end
						else
							Notify("Your Executor does not support this feature", 5)
						end
					end)
				else
					Notify("Invalid Suggestion", 5)
				end
			end,
		})
	end)

	return Window
end

return Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion

-- local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()
