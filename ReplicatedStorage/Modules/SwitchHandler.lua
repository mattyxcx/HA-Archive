local TweenService = game:GetService("TweenService")
local SoundHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)
local LightsHandler = require(game.ReplicatedStorage.Modules.LightsHandler)
local AlarmsHandler = require(game.ReplicatedStorage.Modules.AlarmsHandler)
local DoorHandler = require(game.ReplicatedStorage.Modules.DoorHandler)
local Functions = require(game.ReplicatedStorage.Modules.Library.Functions)

local OnTweens,OffTweens,SwitchHandler = {},{},{}

function toggleTestRoomLights()
	local serverConditional = game.ReplicatedStorage:WaitForChild("Etc")
	for a,b in next,serverConditional["Test Room"].Lights:GetChildren() do
		LightsHandler.updateLight(b)
	end
end

function toggleTestRoomAlarms()
	local serverConditional = game.ReplicatedStorage:WaitForChild("Etc")
	for a,b in next,serverConditional["Test Room"].Alarms:GetChildren() do
		AlarmsHandler.updateAlarm(b)
	end
end

function toggleAcademyAlarms()
	local serverConditional = game.ReplicatedStorage:WaitForChild("Etc")
	for a,b in next,serverConditional["Alarms"]:GetChildren() do
		AlarmsHandler.updateAlarm(b)
	end
end

function toggleAcademyLights()
	local serverConditional = game.ReplicatedStorage:WaitForChild("Etc")
	for a,b in next,serverConditional["Lights"]:GetChildren() do
		LightsHandler.updateLight(b)
	end
end

function slidingDoor(Player,model)
	local twinSwitch = Functions.Expect("Twin",model)
	local door = Functions.Expect("Door",model)
	SwitchHandler.UseSwitch(twinSwitch.Value,Player,true)
	DoorHandler.Use(door.Value,Player)
end

function kitchenShutter(Player,model)
	local door = Functions.Expect("Door",model)
	DoorHandler.Use(door.Value,Player)
end

local functionList = {
	["testRoomLights"] = toggleTestRoomLights,
	["testRoomAlarms"] = toggleTestRoomAlarms,
	["testRoomSlider"] = slidingDoor,
	["dungeonDoor"] = slidingDoor,
	["academyAlarms"] = toggleAcademyAlarms,
	["academyLights"] = toggleAcademyLights,
	["kitchenShutter"] = kitchenShutter,
}

function handleCustomFunction(which,Player,model)
	local functionFound = functionList[which]
	if functionFound == nil then return end
	functionFound(Player,model)
end

function changeState(model)
	local information = string.split(model.Name,"|")
	local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
	local newState if currentState == "Off" then newState = "On" elseif currentState == "Unused" then newState = "On" elseif currentState == "On" then newState = "Off" end
	model.Name = switchName.."|"..newState.."|"..specificFunction.."|"..minRank
end

function ClientUpdate(model)
	local information = string.split(model.Name,"|")
	local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
	local Hinge = model.Hinge
	if currentState == "On" then
		local HingeTween = OnTweens[Hinge]
		HingeTween:Play()
		SoundHandler.PlaySound("Switch",Hinge)
	elseif currentState == "Off" then
		local HingeTween = OffTweens[Hinge]
		HingeTween:Play()
		SoundHandler.PlaySound("Switch",Hinge)
	end
end

function SwitchHandler.UseSwitch(model,Player,skip)
	local information = string.split(model.Name,"|")
	local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
	if tonumber(minRank) <= Player.PlayerInfo.Rank.Value then
		if skip ~= true then handleCustomFunction(specificFunction,Player,model) end
		changeState(model)
	end
end

function SwitchHandler.Setup(Directory)
	for _,model in next,Directory:GetChildren() do
		local information = string.split(model.Name,"|")
		local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
		local Hinge = Functions.Expect("Hinge",model)
		local on,off
		on = Functions.ReturnTween(Hinge,{0.5,Enum.EasingStyle.Back},{CFrame = Hinge.CFrame * CFrame.Angles(math.rad(-175),0,0)})
		off = Functions.ReturnTween(Hinge,{0.25},{CFrame = Hinge.CFrame})
		OnTweens[Hinge] = on
		OffTweens[Hinge] = off
		model:GetPropertyChangedSignal("Name"):Connect(function() ClientUpdate(model) end)
		ClientUpdate(model)
	end
end

return SwitchHandler