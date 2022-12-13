local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.0.0")

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
	Name = "⚔ Auto Attack Closest",
	Info = "Attacks & teleports to the closest enemy",
	CurrentValue = false,
	Flag = "Attack",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Attack.CurrentValue then
			local CurrentNumber = math.huge
			local CurrentEnemy
			
			for i,v in pairs(workspace.Fight.ClientChests:GetChildren()) do
				if Player.Character:FindFirstChild("HumanoidRootPart") then
					local Magnitude = (Player.Character.HumanoidRootPart.Position - v.Root.Position).Magnitude
					if Magnitude < CurrentNumber then
						CurrentNumber = Magnitude
						CurrentEnemy = v.Name
					end
				end
			end
			
			if CurrentEnemy then
				workspace.Fight.Events.FightAttack:InvokeServer(0, CurrentEnemy)
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🌪 Killaura",
	Info = "Attacks every enemy within 30 studs of you",
	CurrentValue = false,
	Flag = "Killaura",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Killaura.CurrentValue then
			for i,v in pairs(workspace.Fight.ClientChests:GetChildren()) do
				if v:FindFirstChild("Root") and Player.Character:FindFirstChild("HumanoidRootPart") and (Player.Character.HumanoidRootPart.Position - v.Root.Position).Magnitude <= 30 then
					workspace.Fight.Events.FightAttack:InvokeServer(0, v.Name)
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🐉 Auto Fight Best Boss",
	Info = "Automatically fights your best world's boss (must be at world)",
	CurrentValue = false,
	Flag = "Boss",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Boss.CurrentValue then
			local CurrentNumber = 0

			for i,v in pairs(workspace.Fight:GetChildren()) do
				if v.Name:match("FightArea") and tonumber(v.Name:split("FightArea_")[2]:split("_")[1]) > CurrentNumber then
					CurrentNumber = tonumber(v.Name:split("FightArea_")[2]:split("_")[1])
				end
			end

			game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Funcs.BossRoomEnterFunc:InvokeServer(CurrentNumber, "room2")
			game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Events.BossRoomStartEvent:FireServer(CurrentNumber, "room2")
			game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Events.BossRoomLeaveEvent:FireServer(CurrentNumber, "room2")

			local good

			repeat
				for i,v in pairs(workspace.Fight:GetChildren()) do
					if v.Name:match("FightArena") then
						good = v.Name:split("FightArena_")[2]
					end
				end
				task.wait()
			until good

			local Boss = game:GetService("Workspace").Fight.Chests:FindFirstChild(good.."_Boss_1")

			repeat task.wait() until Boss

			Player.Character.HumanoidRootPart.CFrame = Boss.MonsterCFrame.Value
			task.wait(1)
			workspace.Fight.Events.FightAttack:InvokeServer(0, good.."_Boss_1")

			repeat
				if Boss and Player.Character:FindFirstChild("HumanoidRootPart") then
					Player.Character.HumanoidRootPart.CFrame = Boss.MonsterCFrame.Value
				end
				task.wait()
			until not game:GetService("Workspace").Fight.Chests:FindFirstChild(good.."_Boss_1") or not Rayfield.Flags.Boss.CurrentValue

			task.wait(1)

			game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Funcs.DataPullFunc:InvokeServer("ArenaTeleportLeaveChannel", "Out")

		end
	end
end)
