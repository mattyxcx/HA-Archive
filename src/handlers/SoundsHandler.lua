local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Functions = require(game.ReplicatedStorage.Modules.Library.Functions)
local SM = {}

function SM.GetSoundSetting(Setting)
	if SoundService:FindFirstChild(Setting) then
		Setting = SoundService:FindFirstChild(Setting)
		return Setting.Volume
	end
end

function SM.PlaySound(Sound,Parent)
	local foundSound = nil
	for a,b in next,game.ReplicatedStorage.Sounds:GetDescendants() do
		if b.Name == Sound and b:IsA("Sound") then
			foundSound = b
		end
	end
	foundSound = foundSound:Clone()
	foundSound.Parent = (Parent)
	foundSound:Play()
	foundSound.Ended:Connect(function()
		foundSound:Destroy()
	end)
	return foundSound
end

function SM.CreateSound(Information)
	local AssetId,Parent,TimePosition,Pitch,Volume = Functions.UnpackTable(Information)
	if TimePosition == nil then TimePosition = 0 end
	if Pitch == nil then Pitch = 1 end
	if Volume == nil then Volume = 1 end
	local Sound = Instance.new("Sound")
	Sound.Parent = (Parent or game.Lighting)
	Sound.SoundId = "rbxassetid://"..AssetId
	Sound.TimePosition = TimePosition
	Sound.PlaybackSpeed = Pitch
	Sound.Volume = Volume
	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)
	Sound:Play()
end


function SM.PlaySoundNoDestroy(Sound,Parent)
	local foundSound = nil
	for a,b in next,game.ReplicatedStorage.Sounds:GetDescendants() do
		if b.Name == Sound and b:IsA("Sound") then
			foundSound = b
		end
	end
	foundSound = foundSound:Clone()
	foundSound.Parent = (Parent)
	foundSound:Play()
	foundSound.Ended:Connect(function()
		foundSound:Destroy()
	end)
	return foundSound
end

function SM.ChangeSoundSetting(Setting,NewValue)
	if SoundService:FindFirstChild(Setting) then
		Setting = SoundService:FindFirstChild(Setting)
		Setting.Volume = NewValue
	end
end

return SM