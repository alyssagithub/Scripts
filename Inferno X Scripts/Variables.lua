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

		if not isfile("InfernoXWebhooking.txt") then
			writefile("InfernoXWebhooking.txt", CurrentTime)
			print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
			Webhook = GlobalWebhook
		elseif tonumber(readfile("InfernoXWebhooking.txt")) < CurrentTime - 7200 then
			writefile("InfernoXWebhooking.txt", CurrentTime)
			print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
			Webhook = GlobalWebhook
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

pcall(SendMessage, "[Inferno X] Data: Inferno X was executed by "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." using "..getexploit(), "Execution")

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
		Duration = Duration,
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
			FileName = game.PlaceId
		},
		Discord = {
			Enabled = true,
			Invite = "rtgv8Jp3fM",
			RememberJoins = true
		}
	})

	repeat task.wait() until Window

	task.defer(function()
		task.wait(1.5)
		local Universal = Window:CreateTab("Universal", 4483362458)

		Universal:CreateToggle({
			Name = "🚫 Anti-AFK",
			CurrentValue = false,
			Flag = "Universal-AntiAFK",
			Callback = function(Value)
				if Value then
					local VirtualUser = game:GetService("VirtualUser")
					Player.Idled:Connect(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton2(Vector2.new())
					end)
				end
			end,
		})

		Universal:CreateToggle({
			Name = "🔁 Auto Rejoin",
			CurrentValue = false,
			Flag = "Universal-AutoRejoin",
			Callback = function(Value)
				if Value then
					repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

					local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

					po.ChildAdded:connect(function(a)
						if a.Name == 'ErrorPrompt' then
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

		Universal:CreateSection("")

		local Speed

		Universal:CreateSlider({
			Name = "💨 WalkSpeed",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.WalkSpeed,
			--Flag = "Universal-WalkSpeed",
			Callback = function(Value)
				Speed = Value
				if Speed then
					if syn then
						if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
					end
					Player.Character.Humanoid:AddPropertyEmulator("WalkSpeed")
				end
			end,
		})

		task.spawn(function()
			while task.wait() do
				if Speed and Player.Character.Humanoid.WalkSpeed ~= Speed then
					Player.Character.Humanoid.WalkSpeed = Speed
				end
			end
		end)

		local Jump

		Universal:CreateSlider({
			Name = "⬆ JumpPower",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.JumpPower,
			--Flag = "Universal-JumpPower",
			Callback = function(Value)
				Jump = Value
				if syn then
					if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
				end
				Player.Character.Humanoid:AddPropertyEmulator("JumpPower")
			end,
		})

		task.spawn(function()
			while task.wait() do
				if Jump and Player.Character.Humanoid.JumpPower ~= Jump then
					Player.Character.Humanoid.JumpPower = Jump
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
				if Text ~= "" and Text ~= " " then
					pcall(function()
						if isfile and writefile and readfile then
							local CurrentTime = tick()

							if not isfile("InfernoXWebhooking2.txt") then
								Webhook = SuggestionsWebhook
								local success, result = pcall(SendMessage, "[Inferno X] Data: "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." suggested "..Text.." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Suggestion")
								if success then
									Notify("Successfully Sent Suggestion", 5)
									writefile("InfernoXWebhooking2.txt", CurrentTime)
									print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
								else
									Notify("Unsuccessful Sending Suggestion, Error: "..result, 5)
								end
							elseif tonumber(readfile("InfernoXWebhooking2.txt")) < CurrentTime - 86400 then
								Webhook = SuggestionsWebhook
								local success, result = pcall(SendMessage, "[Inferno X] Data: "..((Player.Name ~= Player.DisplayName and Player.DisplayName) or "Unknown.."..Player.Name:sub(-2, -1)).." suggested "..Text.." on "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Suggestion")
								if success then
									Notify("Successfully Sent Suggestion", 5)
									writefile("InfernoXWebhooking2.txt", CurrentTime)
									print("[Inferno X] Debug: Webhook Delay Set at "..CurrentTime)
								else
									Notify("Unsuccessful Sending Suggestion, Error: "..result, 5)
								end
							else
								Webhook = nil
								Notify("You are on a 24 Hour Cooldown", 5)
							end
						else
							Notify("Your Executor does not support this feature")
						end
					end)
				end
			end,
		})
	end)

	return Window
end

return Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion

-- local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()
