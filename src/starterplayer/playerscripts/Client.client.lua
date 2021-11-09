local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")

local Handlers = ReplicatedStorage:WaitForChild("Modules")
local Events = ReplicatedStorage:WaitForChild("Events")
local ClientWorkspace = ReplicatedStorage:WaitForChild("Etc")
local Library = Handlers:WaitForChild("Library")

local RagdollHandler = require(Handlers.RagdollHandler)
local DoorHandler = require(Handlers.DoorHandler)
local LightsHandler = require(Handlers.LightsHandler)
local AlarmsHandler = require(Handlers.AlarmsHandler)
local SwitchHandler = require(Handlers.SwitchHandler)
local InteractableHandler = require(Handlers.InteractableHandler)
local Functions = require(Library.Functions)
local serverSettings = require(Library.Settings)

local Player = Players.LocalPlayer
local PlayerInfo = Player:WaitForChild("PlayerInfo")

local RemoteEvent = Events.RemoteEvent
local ClientThought = Events.Notifications.ThoughtClient
local Character,Humanoid,HumanoidRootPart,CharInfo,_Death
local RagdollUpdated

local LastRagdoll = tick()
local RagdollCause = nil

function CharacterLoaded(C)
	if C == nil then repeat wait() until Player.Character ~= nil C,Character = Player.Character,Player.Character end
	if _Death ~= nil then Death() end -- Cleanup
	Character,Humanoid,HumanoidRootPart = C,C:WaitForChild("Humanoid"),C:WaitForChild("HumanoidRootPart")
	CharInfo = C:WaitForChild("CharInfo")
	RagdollUpdated = CharInfo.Ragdoll:GetPropertyChangedSignal("Value"):Connect(RagdollUpdate)
	_Death = Humanoid.Died:Connect(Death)
end

function Death()
	_Death:Disconnect()
	RagdollUpdated:Disconnect()
end

function CancelRagdoll(Cause)
	if RagdollCause == Cause then
		RagdollHandler.DeactivateRagdoll(Character,"Client")
		RagdollCause = nil
		Humanoid.WalkSpeed = 16
		Humanoid.JumpPower = 50
	end
end

function PromptTriggered(Prompt)
	if Prompt.Name == "switchHandle" then
		RemoteEvent:FireServer("Switch Toggle",Prompt.Parent.Parent)
	elseif Prompt.Name == "doorHandle" then
		RemoteEvent:FireServer("Door Handle",Prompt.Parent.Parent)
	elseif Prompt.Name == "doorLock" then
		RemoteEvent:FireServer("Door Lock",Prompt.Parent.Parent)
	elseif Prompt.Name == "grabFood" then
		local Area,Name,Rank = InteractableHandler.GetPartInfo(Prompt.Parent)
		RemoteEvent:FireServer("Grab",Prompt.Parent.Parent,Name)
	elseif Prompt.Name == "MonsterToggle" then
		local Area,Name,Rank = InteractableHandler.GetPartInfo(Prompt.Parent)
		RemoteEvent:FireServer("Monster",Prompt.Parent.Parent,Name)
	end
end

function PartTouched(Part)
	if Part.Parent.Name == "Triggers" then
		local Duration = Part.Duration.Value
		local Thought = Part.Thought.Value
		if tick()-LastRagdoll >= 1 then
			LastRagdoll = tick()+Duration
			RagdollCause = Part
			Humanoid.WalkSpeed = 0
			Humanoid.JumpPower = 0
			ClientThought:Fire(Thought)
			RagdollHandler.ActivateRagdoll(Character,"Client")
			RagdollHandler.applyVelocity(Character,Part.Direction.CFrame.lookVector)
			delay(tonumber(Duration),function() CancelRagdoll(Part) end)
		end
	end
end

function RagdollUpdate()
	local RV = CharInfo.Ragdoll.Value
	if RV == true then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
	else
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

function HandleExclusive(Part)
	if PlayerInfo.Rank.Value >= tonumber(Part.Name) and Part:IsA("BasePart") then
		Part.CanCollide = false
	end
end

function SetupInteractables()
	for a,b in ipairs(ClientWorkspace:GetDescendants()) do
		if b:IsA("ProximityPrompt") then
			b.Triggered:Connect(function() PromptTriggered(b) end)
		end
	end
	for a,b in ipairs(ClientWorkspace["Triggers"]:GetChildren()) do
		if b:IsA("BasePart") then
			b.Touched:Connect(function(Part)
				if CharInfo.Ragdoll.Value == false then
					PartTouched(b)
				end
			end)
		end
	end
	for a,b in ipairs(ClientWorkspace["Exclusive Areas"]:GetChildren()) do 
		if b:IsA("BasePart") then
			if tonumber(b.Name) <= PlayerInfo.Rank.Value then
				b.CanCollide = false
			end
		end
	end
end

Player.Chatted:Connect(function(Message)
	if Functions.IsInTable(serverSettings["Admins"],Player.UserId) then
		if Message:lower():sub(1,8) == "testroom" then
			Player.Character.HumanoidRootPart.CFrame = ClientWorkspace["Key Points"].testroom.CFrame
		elseif Message:lower():sub(1,7) == "academy" then
			Player.Character.HumanoidRootPart.CFrame = ClientWorkspace["Key Points"].academy.CFrame
		elseif Message:lower():sub(1,5) == "rain" then
			if game.ReplicatedStorage.Server.Rain.Value == true then
				game.ReplicatedStorage.Server.Rain.Value = false
			else
				game.ReplicatedStorage.Server.Rain.Value = true
			end
		end
	end
end)

ClientWorkspace.Parent = workspace
Player.CharacterAdded:Connect(CharacterLoaded)
DoorHandler.Setup(ClientWorkspace.Doors)
SwitchHandler.Setup(ClientWorkspace.Switches)
AlarmsHandler.Setup(ClientWorkspace.Alarms)
LightsHandler.Setup(ClientWorkspace.Lights)
CharacterLoaded(Player.Character)
SetupInteractables()
ChatService:SetBubbleChatSettings({TextSize = 18,Font = Enum.Font.Merriweather})