local SoundsHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)
local AnimationsHandler = require(game.ReplicatedStorage.Modules.AnimationHandler)
local Functions = require(game.ReplicatedStorage.Modules.Library.Functions)
local ContentProvider = game:GetService("ContentProvider")

local RemoteEvent = game.ReplicatedStorage.Events.RemoteEvent

local ConstraintInfo = {
	{
		["Attach1"]	= "UpperTorso",
		["Attach0"]	= "LowerTorso",
		["AttName"]	= "Waist",
	},
	{
		["Attach1"]	= "Head",
		["Attach0"]	= "UpperTorso",
		["AttName"]	= "Neck",
	},
	{
		["Attach1"]	= "LeftUpperLeg",
		["Attach0"]	= "LowerTorso",
		["AttName"]	= "LeftHip",
	},
	{
		["Attach1"]	= "RightUpperLeg",
		["Attach0"]	= "LowerTorso",
		["AttName"]	= "RightHip",
	},
	{
		["Attach1"]	= "RightLowerLeg",
		["Attach0"]	= "RightUpperLeg",
		["AttName"]	= "RightKnee",
	},
	{
		["Attach1"]	= "LeftLowerLeg",
		["Attach0"]	= "LeftUpperLeg",
		["AttName"]	= "LeftKnee",
	},	
	{
		["Attach1"]	= "RightUpperArm",
		["Attach0"]	= "UpperTorso",
		["AttName"]	= "RightShoulder",
	},
	{
		["Attach1"]	= "LeftUpperArm",
		["Attach0"]	= "UpperTorso",
		["AttName"]	= "LeftShoulder",
	},
	{
		["Attach1"]	= "LeftLowerArm",
		["Attach0"]	= "LeftUpperArm",
		["AttName"]	= "LeftElbow",
	},
	{
		["Attach1"]	= "RightLowerArm",
		["Attach0"]	= "RightUpperArm",
		["AttName"]	= "RightElbow",
	},
	{
		["Attach1"]	= "RightHand",
		["Attach0"]	= "RightLowerArm",
		["AttName"]	= "RightWrist",
	},
	{
		["Attach1"]	= "LeftHand",
		["Attach0"]	= "LeftLowerArm",
		["AttName"]	= "LeftWrist",
	},
	{
		["Attach1"]	= "LeftFoot",
		["Attach0"]	= "LeftLowerLeg",
		["AttName"]	= "LeftAnkle",
	},
	{
		["Attach1"]	= "RightFoot",
		["Attach0"]	= "RightLowerLeg",
		["AttName"]	= "RightAnkle",
	},
}

local Ragdoll = {}

function createCarryPrompt(Victim)
	local Prompt = Instance.new("ProximityPrompt")
	Prompt.Parent = Victim.UpperTorso
	Prompt.Name = "carryPrompt"
	Prompt.Enabled = false
	Prompt.ActionText = "Carry"
	Prompt.ObjectText = Victim.Name
	Prompt.ClickablePrompt = true
	Prompt.KeyboardKeyCode = Enum.KeyCode.E
	Prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
	Prompt.MaxActivationDistance = 5
	Prompt.RequiresLineOfSight = false
	Prompt.Style = Enum.ProximityPromptStyle.Custom
	Prompt.HoldDuration = 0
end

function ToggleMotors(Victim,condition)
	for b=1,#ConstraintInfo do
		local RigData = ConstraintInfo[b]
		local Attach0 = RigData["Attach0"]
		local RootPart = Victim:FindFirstChild(Attach0)
		if RootPart ~= nil then
			local Motor = RootPart:FindFirstChildWhichIsA("Motor6D")
			if Motor ~= nil and Motor.Name ~= "Root" and Motor.Name ~= "Neck" and Motor.Name ~= "Waist" then
				RootPart:FindFirstChildWhichIsA("Motor6D").Enabled = condition
			end
		end
	end
end

function Ragdoll.setupConstraints(Victim)
	local RDFolder = Instance.new("Folder")
	RDFolder.Name = "Constraints & Collisions"
	RDFolder.Parent = Victim
	for b=1,#ConstraintInfo do
		local RigData = ConstraintInfo[b]
		local Attach1 = RigData["Attach1"]
		local Attach0 = RigData["Attach0"]
		local RootPart = Victim:FindFirstChild(Attach0)
		local RPWeldTo = Victim:FindFirstChild(Attach1)

		if RPWeldTo == nil or RootPart == nil then
			return "Error"
		end

		local Constraint = Instance.new("BallSocketConstraint")
		Constraint.Name = RigData["AttName"]
		Constraint.Parent = RDFolder
		Constraint.Attachment0 = RootPart:WaitForChild(RigData["AttName"].."RigAttachment",1)
		Constraint.Attachment1 = RPWeldTo:WaitForChild(RigData["AttName"].."RigAttachment",1)
		Constraint.MaxFrictionTorque = 2
		Constraint.Restitution = 0
		Constraint.LimitsEnabled = true
		Constraint.TwistLimitsEnabled = true
		Constraint.TwistLowerAngle = -20
		Constraint.TwistUpperAngle = 20
		Constraint.UpperAngle = 20
		Constraint.Enabled = true


		local CollisionPart = Instance.new("Part")
		CollisionPart.Anchored = true
		CollisionPart.CanCollide = false
		CollisionPart.Name = RigData["AttName"].."Collision"
		CollisionPart.Parent = RDFolder
		CollisionPart.Size = Vector3.new(0.25,0.25,0.25)
		CollisionPart.CFrame = RootPart.CFrame
		CollisionPart.Transparency = 1
		CollisionPart.Massless = true
		CollisionPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 1, 0, 1)

		local CollisionPartWeld = Instance.new("Weld")
		CollisionPartWeld.Parent = CollisionPart
		CollisionPartWeld.Name = RigData["AttName"].."CollisionWeld"
		CollisionPartWeld.Part0 = RootPart
		CollisionPartWeld.Part1 = CollisionPart
		CollisionPartWeld.Enabled = true
		CollisionPart.Anchored = false
	end
end

function Ragdoll.applyVelocity(Victim,Direction)
	for a,Part in next,Victim:GetChildren() do
		if Part:IsA("BasePart") then
			Part.Velocity = Direction * 40
		end
	end
end

function Ragdoll.isRagdolled(Victim)
	if Victim:FindFirstChild("CharInfo") ~= nil then
		return Victim.CharInfo.Ragdoll.Value
	else
		return "No ragdoll data"
	end
end

function Ragdoll.isCarrying(Victim)
	if Victim:FindFirstChild("CharInfo") ~= nil then
		if Victim.CharInfo.CurrentlyCarrying.Value ~= nil then return true else return false end
	else
		return "No ragdoll data"
	end
end

function Ragdoll.isBeingCarried(Victim)
	if Victim:FindFirstChild("CharInfo") ~= nil then
		if Victim.CharInfo.CarriedBy.Value ~= nil then return true else return false end
	else
		return "No ragdoll data"
	end
end

function removeCollisionParts(Victim)
	if Ragdoll.isRagdolled(Victim) == true then
		for _,v in next,Victim["Constraints & Collisions"]:GetChildren() do
			if v:IsA("Part") then
				v:Destroy()
			end
		end
	end
end

function Ragdoll.ActivateRagdoll(Victim,Type)
	if Type == "Client" then RemoteEvent:FireServer("Client Ragdoll","Activate") return end
	
	if Ragdoll.isCarrying(Victim) == true then
		Ragdoll.EndCarry(Victim.CharInfo.CurrentlyCarrying.Value)
	end
	
	Victim.CharInfo.Ragdoll.Value = true
	Victim.Humanoid.AutoRotate = false
	
	for a,b in next,Victim["Constraints & Collisions"]:GetChildren() do
		if b:IsA("BasePart") then
			b.CanCollide = true
			b.Massless = false
		elseif b:IsA("Constraint") then
			b.Enabled = true
		end
	end
	
	ToggleMotors(Victim,false)
	createCarryPrompt(Victim)
end

function Ragdoll.DeactivateRagdoll(Victim,Type)
	if Type == "Client" then RemoteEvent:FireServer("Client Ragdoll","Deactivate") return end
	local _getUp
	
	if Ragdoll.isBeingCarried(Victim) == true then
		Ragdoll.EndCarry(Victim)
	end
	
	if Victim.UpperTorso.Orientation.X <= 0 then _getUp = AnimationsHandler.ReturnAnimation(Victim.Humanoid.Animator,"Wake Up Face Down")
	else _getUp = AnimationsHandler.ReturnAnimation(Victim.Humanoid.Animator,"Wake Up Face Up") end
	
	Victim.CharInfo.Ragdoll.Value = false
	Victim.Humanoid.AutoRotate = true
	
	_getUp:Play(0)
	ToggleMotors(Victim,true)
	Victim.UpperTorso.carryPrompt:Destroy()
end

function Ragdoll.BeginCarry(Victim,Carrier)
	if Ragdoll.isRagdolled(Victim) == true and Ragdoll.isRagdolled(Carrier) == false and Carrier.CharInfo.CurrentlyCarrying.Value == nil and Victim.CharInfo.CarriedBy.Value == nil then
		local CarrierCharInfo = Carrier.CharInfo
		local Hand = Carrier.RightHand
		local VictimHRP = Victim.HumanoidRootPart
		local VictimCharInfo = Victim.CharInfo
		VictimCharInfo.CarriedBy.Value = Carrier
		CarrierCharInfo.CurrentlyCarrying.Value = Victim
		VictimHRP.CFrame = Hand.CFrame * CFrame.new(-0.6, -0.7, -0.5) * CFrame.Angles(math.rad(91),math.rad(-178),math.rad(-94))

		local carryWeld = Instance.new("WeldConstraint")
		carryWeld.Parent = Victim["Constraints & Collisions"]
		carryWeld.Name = "carryWeld"
		carryWeld.Part0 = Hand
		carryWeld.Part1 = VictimHRP
		carryWeld.Enabled = true
		
		for _,v in next,Victim:GetDescendants() do
			if v:IsA("BasePart") then
				v.Massless = true
				v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 1, 0, 1)
				if v.Parent.Name == "Constraints & Collisions" then
					v.CanCollide = false
				end
			elseif v:IsA("BallSocketConstraint") then
				v.UpperAngle = 0
			end
		end
	end
end

function Ragdoll.EndCarry(Victim)
	if Victim.CharInfo.CarriedBy.Value ~= nil then
		local Carrier = Victim.CharInfo.CarriedBy.Value
		Carrier.CharInfo.CurrentlyCarrying.Value = nil
		Victim.CharInfo.CarriedBy.Value = nil
		Victim["Constraints & Collisions"].carryWeld:Destroy()

		for _,v in next,Victim:GetDescendants() do
			if v:IsA("BasePart") then
				v.Massless = false
				v.CustomPhysicalProperties = PhysicalProperties.new(0.7,0.5,1,0.3,1)
				if v.Parent.Name == "Constraints & Collisions" then
					v.CanCollide = true
				end
			elseif v:IsA("BallSocketConstraint") then
				v.UpperAngle = 20
			end
		end
	end
end

return Ragdoll
