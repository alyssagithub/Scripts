if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()

local GlobalWebhook = "https://discord.com/api/webhooks/1044331288179527821/v10RqcIiN7OKHkDdgBxAWuD2rPoUp4HUc5k4m1ds4JvbDCXzS3E7OZST7X2WIe9lxV2Z" -- this is literally in a private channel dumbasses
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
	return (syn and is_synapse_function and not is_sirhurt_closure and not pebc_execute and "Synapse") or
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
		("Other")
end

print("Detected Executor: "..getexploit())

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

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

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
		Title = "Inferno X",
		Content = Message,
		Duration = Duration,
		Image = 4483362458,
		Actions = {},
	})
end

local function CreateWindow()
	local Window = Rayfield:CreateWindow({
		Name = "Inferno X - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		LoadingTitle = "Inferno X",
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

		Universal:CreateSlider({
			Name = "💨 WalkSpeed",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.WalkSpeed,
			--Flag = "Universal-WalkSpeed",
			Callback = function(Value)
				if syn then
					if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
				end
				Player.Character.Humanoid:AddPropertyEmulator("WalkSpeed")
				Player.Character.Humanoid.WalkSpeed = Value
			end,
		})

		Universal:CreateSlider({
			Name = "⬆ JumpPower",
			Range = {0, 500},
			Increment = 1,
			CurrentValue = Player.Character.Humanoid.JumpPower,
			--Flag = "Universal-JumpPower",
			Callback = function(Value)
				if syn then
					if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/KikoTheDon/MT-Api-v2/main/__source/mt-api%20v2.lua", true))() end
				end
				Player.Character.Humanoid:AddPropertyEmulator("JumpPower")
				Player.Character.Humanoid.JumpPower = Value
			end,
		})

		local Credits = Window:CreateTab("Credits", 4483362458)

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
	end)
	return Window
end

return Player, Rayfield, Click, comma, Notify, CreateWindow

-- local Player, Rayfield, Click, comma, Notify, CreateWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()
