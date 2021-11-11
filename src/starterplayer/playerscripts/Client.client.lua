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

local Commands = {
	["academy"] = "Academy/Front",
	["kitchen"] = "Academy/Kitchen",
	["dungeon"] = "Academy/Dungeon",
	["testroom"] = "Other/Test Room",
}

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
		for Command,Path in pairs(Commands) do
			if Message:lower():sub(1,#Command) == Command then
				local pathTable = string.split(Path,"/"); local prvParent = nil
				for index,value in ipairs(pathTable) do
					local found
					if prvParent == nil then
						found = ClientWorkspace["Key Points"]:FindFirstChild(value)
					else
						found = prvParent:FindFirstChild(value)
					end
					if found ~= nil then prvParent = found else print("Unexpected error when finding path") end
				end
				Player.Character.HumanoidRootPart.CFrame = prvParent.CFrame
			end
		end
		if Message:lower():sub(1,5) == "rain" then
			local condition = Message:lower():sub(7,8) local Val
			if condition == nil then
				Val = not game.ReplicatedStorage.Server.Rain.Value
			elseif condition == "on" then
				Val = true
			elseif Message:lower():sub(7,9) == "off" then
				Val = false
			end
			game.ReplicatedStorage.Server.Rain.Value = Val
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