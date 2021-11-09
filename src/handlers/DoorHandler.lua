local TweenService = game:GetService("TweenService")
local SoundHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)
local Functions = require(game.ReplicatedStorage.Modules.Library.Functions)

local DoorHandler,OpenTweens,CloseTweens,PP = {},{},{},{}

function changeState(model,newState,optLocked)
	local information = string.split(model.Name,"|")
	local doorName,currentState,lockedState,minRank = unpack(information)
	if optLocked == nil then optLocked = lockedState end
	model.Name = doorName.."|"..newState.."|"..optLocked.."|"..minRank
end

function doorCooldown(model)
	for _,Part in ipairs(model:GetChildren()) do
		if Part.Name == "Prompt" then
			for __,Child in ipairs(Part:GetChildren()) do
				if Child:IsA("ProximityPrompt") then
					Child.Enabled = false
					delay(1,function() Child.Enabled = true end)
				end
			end
		end
	end
end

function ClientUpdate(model)
	local information = string.split(model.Name,"|")
	local doorName,currentState,lockedState,minRank = unpack(information)
	if PP[model] ~= nil and PP[model][1] ~= currentState then
		PP[model] = {currentState,lockedState}
		if currentState == "Open" then
			if doorName == "Single Door" then
				local Hinge = Functions.Expect("Hinge",model)
				local Door = Functions.Expect("Door",model)
				local HingeTween = OpenTweens[Hinge]
				HingeTween:Play()
				SoundHandler.PlaySound("Door Open",Door)
			elseif doorName == "Security Door" then
				local LeftHinge = Functions.Expect("LeftHinge",model)
				local RightHinge = Functions.Expect("RightHinge",model)
				local LeftHingeTween = OpenTweens[LeftHinge]
				local RightHingeTween = OpenTweens[RightHinge]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Security Door Open",LeftHinge)
				SoundHandler.PlaySound("Security Door Open",RightHinge)
			elseif doorName == "Double Door" then
				local LeftHinge = Functions.Expect("LeftHinge",model)
				local RightHinge = Functions.Expect("RightHinge",model)
				local LeftHingeTween = OpenTweens[LeftHinge]
				local RightHingeTween = OpenTweens[RightHinge]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Door Open",LeftHinge)
				SoundHandler.PlaySound("Door Open",RightHinge)
			elseif doorName == "Sliding Door" then
				local LeftDoor = Functions.Expect("Left",model)
				local RightDoor = Functions.Expect("Right",model)
				local LeftHingeTween = OpenTweens[LeftDoor]
				local RightHingeTween = OpenTweens[RightDoor]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Security Door Open",LeftDoor)
				SoundHandler.PlaySound("Security Door Open",RightDoor)
			elseif doorName == "Kitchen Shutter" then
				local Main = Functions.Expect("Main",model)
				local Tween = OpenTweens[Main]
				Tween:Play()
				SoundHandler.PlaySound("Security Door Open",Main)
			end
		elseif currentState == "Closed" then
			if doorName == "Single Door" then
				local Hinge = Functions.Expect("Hinge",model)
				local Door = Functions.Expect("Door",model)
				local HingeTween = CloseTweens[Hinge]
				HingeTween:Play()
				SoundHandler.PlaySound("Door Close",Door)
			elseif doorName == "Security Door" then
				local LeftHinge = Functions.Expect("LeftHinge",model)
				local RightHinge = Functions.Expect("RightHinge",model)
				local LeftHingeTween = CloseTweens[LeftHinge]
				local RightHingeTween = CloseTweens[RightHinge]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Security Door Close",LeftHinge)
				SoundHandler.PlaySound("Security Door Close",RightHinge)
			elseif doorName == "Double Door" then
				local LeftHinge = Functions.Expect("LeftHinge",model)
				local RightHinge = Functions.Expect("RightHinge",model)
				local LeftHingeTween = CloseTweens[LeftHinge]
				local RightHingeTween = CloseTweens[RightHinge]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Door Close",LeftHinge)
				SoundHandler.PlaySound("Door Close",RightHinge)
			elseif doorName == "Sliding Door" then
				local LeftDoor = Functions.Expect("Left",model)
				local RightDoor = Functions.Expect("Right",model)
				local LeftHingeTween = CloseTweens[LeftDoor]
				local RightHingeTween = CloseTweens[RightDoor]
				LeftHingeTween:Play()
				RightHingeTween:Play()
				SoundHandler.PlaySound("Security Door Close",LeftDoor)
				SoundHandler.PlaySound("Security Door Close",RightDoor)
			elseif doorName == "Kitchen Shutter" then
				local Main = Functions.Expect("Main",model)
				local Tween = CloseTweens[Main]
				Tween:Play()
				SoundHandler.PlaySound("Security Door Close",Main)
			end
			changeState(model,currentState,lockedState)
			doorCooldown(model)
		end
	end
end

function DoorHandler.Use(model,Player)
	local information = string.split(model.Name,"|")
	local doorName,currentState,lockedState,minRank = unpack(information)
	local p = model:FindFirstChildWhichIsA("BasePart")
	if tonumber(minRank) <= Player.PlayerInfo.Rank.Value then
		if currentState == "Closed" then
			if lockedState == "Unlocked" then
				changeState(model,"Open")
			else
				if p:FindFirstChildWhichIsA("Sound") == nil then SoundHandler.PlaySound("Door Rattle",p) end
				game.ReplicatedStorage.Events.Notifications.Thought:FireClient(Player,"It's locked!")
			end
		elseif currentState == "Unused" then
			if lockedState == "Unlocked" then
				changeState(model,"Open")
			else
				if p:FindFirstChildWhichIsA("Sound") == nil then SoundHandler.PlaySound("Door Rattle",p) end
				game.ReplicatedStorage.Events.Notifications.Thought:FireClient(Player,"It's locked!")
			end
		elseif currentState == "Open" then
			changeState(model,"Closed")
		end
	else
		game.ReplicatedStorage.Events.Notifications.Thought:FireClient(Player,"I cannot touch this door...")
	end
end

function DoorHandler.Lock(model,Player)
	local information = string.split(model.Name,"|")
	local doorName,currentState,lockedState,minRank = unpack(information)
	if tonumber(minRank) <= Player.PlayerInfo.Rank.Value then
		if Player.Character:FindFirstChild("Key") ~= nil then
			if lockedState == "Unlocked" and (currentState == "Unused" or currentState == "Closed") then
				SoundHandler.PlaySound("Door Lock",Player.Character.Key.Handle)
				model.Name = doorName.."|"..currentState.."|Locked|"..minRank
			elseif lockedState == "Locked" then
				SoundHandler.PlaySound("Door Lock",Player.Character.Key.Handle)
				model.Name = doorName.."|"..currentState.."|Unlocked|"..minRank
			end
		else
			game.ReplicatedStorage.Events.Notifications.Thought:FireClient(Player,"I need a key!")
		end
	else
		game.ReplicatedStorage.Events.Notifications.Thought:FireClient(Player,"I cannot touch this door...")
	end
end

function DoorHandler.Setup(Directory)
	for _,model in next,Directory:GetChildren() do
		local information = string.split(model.Name,"|")
		local doorName,currentState,lockedState,minRank = unpack(information)
		if doorName == "Single Door" then
			local Hinge = Functions.Expect("Hinge",model)
			local open,close
			open = Functions.ReturnTween(Hinge,{0.5,Enum.EasingStyle.Back},{CFrame = Hinge.CFrame * CFrame.Angles(0,math.rad(-95),0)})
			close = Functions.ReturnTween(Hinge,{0.25},{CFrame = Hinge.CFrame})
			OpenTweens[Hinge] = open
			CloseTweens[Hinge] = close
		elseif doorName == "Double Door" then
			local LeftHinge = Functions.Expect("LeftHinge",model)
			local RightHinge = Functions.Expect("RightHinge",model)
			local leftopen,leftclose,rightopen,rightclose
			leftopen = Functions.ReturnTween(LeftHinge,{0.5,Enum.EasingStyle.Back},{CFrame = LeftHinge.CFrame * CFrame.Angles(0,math.rad(-95),0)})
			rightopen = Functions.ReturnTween(RightHinge,{0.5,Enum.EasingStyle.Back},{CFrame = RightHinge.CFrame * CFrame.Angles(0,math.rad(95),0)})
			leftclose = Functions.ReturnTween(LeftHinge,{0.25},{CFrame = LeftHinge.CFrame})
			rightclose = Functions.ReturnTween(RightHinge,{0.25},{CFrame = RightHinge.CFrame})
			OpenTweens[LeftHinge] = leftopen
			OpenTweens[RightHinge] = rightopen
			CloseTweens[LeftHinge] = leftclose
			CloseTweens[RightHinge] = rightclose
		elseif doorName == "Security Door" then
			local LeftHinge = Functions.Expect("LeftHinge",model)
			local RightHinge = Functions.Expect("RightHinge",model)
			local leftopen,leftclose,rightopen,rightclose
			leftopen = Functions.ReturnTween(LeftHinge,{4},{CFrame = LeftHinge.CFrame * CFrame.new(5,0,0)})
			rightopen = Functions.ReturnTween(RightHinge,{4},{CFrame = RightHinge.CFrame * CFrame.new(5,0,0)})
			leftclose = Functions.ReturnTween(LeftHinge,{3},{CFrame = LeftHinge.CFrame})
			rightclose = Functions.ReturnTween(RightHinge,{3},{CFrame = RightHinge.CFrame})
			OpenTweens[LeftHinge] = leftopen
			OpenTweens[RightHinge] = rightopen
			CloseTweens[LeftHinge] = leftclose
			CloseTweens[RightHinge] = rightclose
		elseif doorName == "Sliding Door" then
			local LeftDoor = Functions.Expect("Left",model)
			local RightDoor = Functions.Expect("Right",model)
			local leftopen,leftclose,rightopen,rightclose
			leftopen = Functions.ReturnTween(LeftDoor,{4},{CFrame = LeftDoor.CFrame * CFrame.new(-9,0,0)})
			rightopen = Functions.ReturnTween(RightDoor,{4},{CFrame = RightDoor.CFrame * CFrame.new(9,0,0)})
			leftclose = Functions.ReturnTween(LeftDoor,{3},{CFrame = LeftDoor.CFrame})
			rightclose = Functions.ReturnTween(RightDoor,{3},{CFrame = RightDoor.CFrame})
			OpenTweens[LeftDoor] = leftopen
			OpenTweens[RightDoor] = rightopen
			CloseTweens[LeftDoor] = leftclose
			CloseTweens[RightDoor] = rightclose
		elseif doorName == "Kitchen Shutter" then
			local Main = Functions.Expect("Main",model)
			local open,close
			open = Functions.ReturnTween(Main,{4},{CFrame = Main.CFrame * CFrame.new(0,-6.4,0)})
			close = Functions.ReturnTween(Main,{3},{CFrame = Main.CFrame})
			OpenTweens[Main] = open
			CloseTweens[Main] = close
		end
		PP[model] = {currentState,lockedState}
		model:GetPropertyChangedSignal("Name"):Connect(function() ClientUpdate(model) end)
		ClientUpdate(model)
	end
end

return DoorHandler