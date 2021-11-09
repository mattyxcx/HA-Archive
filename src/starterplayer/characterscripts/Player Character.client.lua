local wfc = game.WaitForChild
local AnimationsHandler = require(game.ReplicatedStorage.Modules.AnimationHandler)
local RagdollHandler = require(game.ReplicatedStorage.Modules.RagdollHandler)
local SoundsHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)
local CAS = require(game.ReplicatedStorage.Modules.ActionHandler)
local Player:Player = game.Players.LocalPlayer
local Character:Model = script.Parent.Parent
local Humanoid:Humanoid = wfc(Character,"Humanoid")
local rootPart:Part = wfc(Character,"HumanoidRootPart")
local charInfo:Folder = wfc(Character,"CharInfo")
local playerInfo = wfc(Player,"PlayerInfo")
local playerStats = playerInfo.Stats
local drownStat = playerStats.DrownState
local Energy = playerStats.Energy
local LastSprint = playerStats.LastSprint

local RemoteEvent = game.ReplicatedStorage.Events.RemoteEvent
local rEvent:RBXScriptSignal
local prevHeight,isSwimming,isDead,running = 0,false,false,false

local ms = {[Enum.Material.Wood] = {
	SoundId = "rbxassetid://6133240333",
	Looped = true,
	Pitch = 1.7
},
[Enum.Material.WoodPlanks] = {
	SoundId = "rbxassetid://6133240333",
	Looped = true,
	Pitch = 1.7
},
[Enum.Material.Concrete] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Metal] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Cobblestone] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.CorrodedMetal] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Basalt] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Slate] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Rock] = {
	SoundId = "rbxassetid://833564121",
	Looped = true,
	Pitch = 1.85
},
[Enum.Material.Grass] = {
	SoundId = "rbxassetid://833564767",
	Looped = true,
	Pitch = 2
},
[Enum.Material.Mud] = {
	SoundId = "rbxassetid://833564767",
	Looped = true,
	Pitch = 2
},
[Enum.Material.LeafyGrass] = {
	SoundId = "rbxassetid://833564767",
	Looped = true,
	Pitch = 2
},
[Enum.Material.Sand] = {
	SoundId = "rbxassetid://833564767",
	Looped = true,
	Pitch = 2
},
[Enum.Material.Ground] = {
	SoundId = "rbxassetid://833564767",
	Looped = true,
	Pitch = 2
},
[Enum.Material.Fabric] = {
	SoundId = "rbxassetid://133705377",
	Looped = true,
	Pitch = 2
},}

Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
Humanoid.BreakJointsOnDeath = false
Humanoid.RequiresNeck = false

function renderStepped()
	for _,v in pairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Massless = true
			v.CustomPhysicalProperties = PhysicalProperties.new(1,0,1,1,1)
		end
	end
end

function Died()
	isDead = true
	RagdollHandler.ActivateRagdoll(Character,"Client")
end

function fmChanged()
	local m = Humanoid.FloorMaterial
	if ms[m] ~= nil then
		rootPart.Running.SoundId = ms[m]["SoundId"]
		rootPart.Running.PlaybackSpeed = ms[m]["Pitch"]
	else
		rootPart.Running.SoundId = ms[Enum.Material.Concrete]["SoundId"]
		rootPart.Running.PlaybackSpeed = ms[Enum.Material.Concrete]["Pitch"]
	end
end

function onClientEvent(...)
	local Args = {...}
	if Args[1] == "Fix Client" then
		workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character
		Humanoid = Character.Humanoid
		Character.Animate.Disabled = true
		wait(0.1)
		Character.Animate.Disabled = false
	end
end

function carriedByChanged()
	if charInfo.CarriedBy.Value ~= nil then
		rEvent = game:GetService("RunService").RenderStepped:Connect(renderStepped)
	else
		rEvent:Disconnect()
		for _,v in pairs(Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
				v.Massless = false
				v.CustomPhysicalProperties = false
			end
		end
	end
end

function freeFalling(State)
	if State == true then
		prevHeight = Character.LowerTorso.Position.Y
	elseif State == false then
		local fallenHeight = prevHeight - Character.LowerTorso.Position.Y
		if fallenHeight >= 20 and fallenHeight < 60 then
			if Humanoid.Health-(fallenHeight) <= 0 then
				local Sound = SoundsHandler.PlaySound("Bone Crack",Character.UpperTorso)
				Character.Humanoid:TakeDamage(100)
			else
				local Sound = SoundsHandler.PlaySound("Bone Crack",Character.UpperTorso)
				RagdollHandler.ActivateRagdoll(Character,"Client")
				Humanoid:TakeDamage((fallenHeight))
				wait(5)
				Sound:Destroy()
				RagdollHandler.DeactivateRagdoll(Character,"Client")
			end
		elseif fallenHeight >= 60 then
			local Sound = SoundsHandler.PlaySound("Bone Crack",Character.UpperTorso)
			Humanoid:TakeDamage(100)
		end
	end
end

function stateChanged(oldState, newState)
	isSwimming = (newState == Enum.HumanoidStateType.Swimming)
end

function CasHandler(Name, Status)
	if Name == "Sprint" then
		if Status == Enum.UserInputState.Begin then
			if Energy.Value >= 1 and Humanoid.WalkSpeed == 16 then
				Running = true
				Humanoid.WalkSpeed = 22
				return
			end
		elseif Status == Enum.UserInputState.End and Humanoid.WalkSpeed == 22  then
			if Running == true then
				Running = false
				Humanoid.WalkSpeed = 16
			end
		end
	end
end

Humanoid.Died:Connect(Died)
Humanoid.FreeFalling:Connect(freeFalling)
Humanoid.StateChanged:Connect(stateChanged)
Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(fmChanged)
charInfo.CarriedBy:GetPropertyChangedSignal("Value"):Connect(carriedByChanged)
RemoteEvent.OnClientEvent:Connect(onClientEvent)
CAS.Unbind("Sprint")
CAS.Bind("Sprint",CasHandler,true,9999,Enum.KeyCode.LeftShift)
CAS.SetImage("Sprint","rbxassetid://2394405852")
CAS.SetPosition("Sprint",UDim2.new(1,-50,1,-50))
drownStat.Value = 100 

-- > Sprint
coroutine.resume(coroutine.create(function()
	while true do
		if Running == true then
			LastSprint.Value = tick()
			Energy.Value = Energy.Value-1
			Player.PlayerInfo.Stats.MaxEnergy.Value = Player.PlayerInfo.Stats.MaxEnergy.Value - 0.01
			if Energy.Value < 0.1 then
				Running = false
				Humanoid.WalkSpeed = 16
				wait(3)
			end
			wait(Player.PlayerInfo.Stats.SprintLossRate.Value)
		else
			if Player.PlayerInfo.Stats.MaxEnergy.Value ~= 0 and Energy.Value < Player.PlayerInfo.Stats.MaxEnergy.Value then
				LastSprint.Value = tick()
				Energy.Value = Energy.Value+0.5
			end
			wait(0.05)
		end
	end
end))

-- > Drown
coroutine.resume(coroutine.create(function()
	while true do
		if isSwimming == true then
			if drownStat.Value > 0 then
				drownStat.Value = drownStat.Value-1
			elseif drownStat.Value == 0 then
				Humanoid:TakeDamage(100)
			end
			wait(0.065)
		else
			if drownStat.Value < 100 then
				drownStat.Value = drownStat.Value+1
			end
			wait(0.1)
		end
	end
end))