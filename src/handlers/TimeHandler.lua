local TweenService = game:GetService("TweenService")
local SoundsHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)
local playingRn = nil
local typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Night
local recentlyPlayed = nil
local morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = false,false,false,false,false
local lastRain = 0
local rainValue = game.ReplicatedStorage.Server.Rain

local TimeHandler = {}

function pickRandom(Folder)
	local numberChosen = math.random(1,#Folder:GetChildren())
	local soundChosen = Folder[Folder.Name.."_"..numberChosen]
	if recentlyPlayed == soundChosen then
		pickRandom(Folder)
	else
		recentlyPlayed = soundChosen
	end
	return soundChosen
end

function fadeSound(Sound,Time,Del,Result)
	local tweenInfo = TweenInfo.new(
		Time,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		Del
	)
	local resultTween = TweenService:Create(Sound,tweenInfo,{Volume = (Result)})
	return resultTween
end

function forceStopBGM()
	local resultTween = fadeSound(playingRn,5,0,0)
	resultTween:Play()
	resultTween.Completed:Connect(function()
		playingRn:Stop()
	end)
end

function playSound()
	local chosenSound = pickRandom(typePlayingRn)
	playingRn = SoundsHandler.PlaySoundNoDestroy(chosenSound.Name,game.Lighting)
	if playingRn.IsLoaded ~= true then
		playingRn.Loaded:Wait()
	end
	playingRn:Play()
	local tweenOut = fadeSound(playingRn,5,playingRn.TimeLength-5,0)
	tweenOut:Play()
	playingRn.Ended:Connect(function()
		playingRn:Destroy()
		playingRn = nil
		playSound()
	end)
	playingRn.Stopped:Connect(function()
		playingRn:Destroy()
		playingRn = nil
		playSound()
	end)
end

function handleRain()
	local odds = math.random(1,3)
	if odds == 1 and tick()-lastRain >= 500 and rainValue.Value == false then
		print("Starting Rain...")
		lastRain = tick()
		local duration = math.random(60,300)
		rainValue.Value = true
		delay(duration, function() rainValue.Value = false end)
		print("Rain Started. Lasting "..duration.." seconds")
	end
end

function TimeHandler.timeChanged()
	for a,b in next,game.ReplicatedStorage.Atmosphere:GetChildren() do
		if b.Name == string.sub(game.Lighting.ClockTime,1,#b.Name) then
			local tweenInfo = TweenInfo.new(10,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
			TweenService:Create(
				game.Lighting.Atmosphere,
				tweenInfo,
				{Density = b.Density,Offset = b.Offset,Color = b.Color,Decay = b.Decay,Glare = b.Glare,Haze = b.Haze}
			):Play()
		end
	end
	
	if game.Lighting.TimeOfDay == "05:30:00" then
		local newAmbience = SoundsHandler.PlaySound("Birds",game.Lighting,true)
	elseif game.Lighting.TimeOfDay == "20:00:00" then
		local newAmbience = SoundsHandler.PlaySound("Evening Ambience "..math.random(1,2),game.Lighting)
	elseif game.Lighting.TimeOfDay == "00:00:00" then
		local newAmbience = SoundsHandler.PlaySound("Spook Ambience "..math.random(1,2),game.Lighting)
	elseif game.Lighting.TimeOfDay == "03:00:00" then
		local newAmbience = SoundsHandler.PlaySound("Spook Ambience "..math.random(1,2),game.Lighting)
	end
	
	if game.Lighting.ClockTime > 6 and game.Lighting.ClockTime <=10.5 and morningChangeSignal == false then
		morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = true,false,false,false,false
		typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Morning
		forceStopBGM()
		handleRain()
	elseif game.Lighting.ClockTime > 10.5 and game.Lighting.ClockTime <=13 and middayChangeSignal == false then
		morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = false,true,false,false,false
		typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Midday
		forceStopBGM()
		handleRain()
	elseif game.Lighting.ClockTime > 13 and game.Lighting.ClockTime <=17 and afternoonChangeSignal == false then
		morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = false,false,true,false,false
		typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Afternoon
		forceStopBGM()
		handleRain()
	elseif game.Lighting.ClockTime > 17 and game.Lighting.ClockTime <=21 and eveningChangeSignal == false then
		morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = false,false,false,true,false
		typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Dusk
		forceStopBGM()
		handleRain()
	elseif nightChangeSignal == false and (game.Lighting.ClockTime > 21 or (game.Lighting.ClockTime >= 0 and game.Lighting.ClockTime <= 6)) then
		morningChangeSignal,middayChangeSignal,afternoonChangeSignal,eveningChangeSignal,nightChangeSignal = false,false,false,false,true
		typePlayingRn = game.ReplicatedStorage.Sounds.BGM.Night
		forceStopBGM()
		handleRain()
	end
end

function TimeHandler.Setup()
	playSound()
end

return TimeHandler
