																																					--[[
📜 𝐌𝐨𝐝𝐮𝐥𝐞𝐬.𝐅𝐮𝐧𝐜𝐭𝐢𝐨𝐧𝐬
❓ A lengthy module containing common functions
🎉 Provides an easier way of reusing code
👷‍ Modifications could cause instabilities throughout scripts, but feel free to use wherever																]]

local TweenService = game:GetService("TweenService")
local Functions = {}

function Functions.Expect(Child,Parent,Time)
	if Time == nil then Time = 60 end
	local toReturn = Parent:WaitForChild(Child,Time)
	return toReturn
end

function Functions.IsInTable(Table,Value)
	local toReturn = false
	for i=1,#Table do
		if Table[i] == Value then
			toReturn = true
		end
	end
	return toReturn
end

function Functions.IsInDictionary(Dictionary,Value)
	local toReturn = false
	for k,v in pairs(Dictionary) do
		if k == Value then
			toReturn = true
		end
	end
	return toReturn
end

function Functions.IsValueInDictionary(Dictionary,Value)
	local toReturn = false
	for k,v in pairs(Dictionary) do
		if v == Value then
			toReturn = true
		end
	end
	return toReturn
end

function Functions.GetFromTable(Table,Value)
	local toReturn = nil
	for i=1,#Table do
		if Table[i] == Value then
			toReturn = Value
		end
	end
	return toReturn
end

function Functions.GetIndexFromTable(Table,Value)
	local toReturn = nil
	for i=1,#Table do
		if Table[i] == Value then
			toReturn = i
		end
	end
	return toReturn
end

function Functions.GetFromDictionary(Dictionary,Value)
	return Dictionary[Value]
end

function Functions.UnpackTable(Table)
	return table.unpack(Table,1,#Table)
end

function Functions.GetRankInGroup(Player,Group)
	local toReturn = nil
	local succ,mg = pcall(function()
		toReturn = Player:GetRankInGroup(Group)
	end)
	if succ and not mg then
		return toReturn
	elseif not succ and not mg then
		warn("Error in "..script:GetFullName())
		return "Error, no message provided"
	elseif not succ and mg then
		warn("Error in "..script:GetFullName().." | "..mg)
		return "Error, "..mg
	end
end

function Functions.GetRoleInGroup(Player,Group)
	local toReturn = nil
	local succ,mg = pcall(function()
		toReturn = Player:GetRoleInGroup(Group)
	end)
	if succ and not mg then
		return toReturn
	elseif not succ and not mg then
		warn("Error in "..script:GetFullName())
		return "Error, no message provided"
	elseif not succ and mg then
		warn("Error in "..script:GetFullName().." | "..mg)
		return "Error, "..mg
	end
end

function Functions.ReturnTween(Object,TweenInformation,Goal)
	local duration,easingStyle,easingDir,repeatCount,reverses,delayTime = Functions.UnpackTable(TweenInformation)
	if Object == nil then warn("Tween Error - An object must be specified!") end
	if Goal == nil then warn("Tween Error - A goal must be specified!") end
	if duration == nil then duration = 0.2 end
	if easingStyle == nil then easingStyle = Enum.EasingStyle.Quad end
	if easingDir == nil then easingDir = Enum.EasingDirection.Out end
	if repeatCount == nil then repeatCount = 0 end
	if reverses == nil then reverses = false end
	if delayTime == nil then delayTime = 0 end
	local Tween = TweenService:Create(Object,TweenInfo.new(duration,easingStyle,easingDir,repeatCount,reverses,delayTime),Goal)
	return Tween
end

function Functions.TweenPosition(GuiObject,TweenInformation)
	local newPosition,direction,style,duration,overrides = Functions.UnpackTable(TweenInformation)
	if newPosition == nil then warn("Tween Error - A new UDim2 position must be supplied!") return end
	if direction == nil then direction = Enum.EasingDirection.Out end
	if style == nil then style = Enum.EasingStyle.Quad end
	if duration == nil then duration = 0.2 end
	if overrides == nil then overrides = true end
	GuiObject:TweenPosition(newPosition,direction,style,duration,overrides)
end

function Functions.TweenSize(GuiObject,TweenInformation)
	local newSize,direction,style,duration,overrides = Functions.UnpackTable(TweenInformation)
	if newSize == nil then warn("Tween Error - A new UDim2 size must be supplied!") return end
	if direction == nil then direction = Enum.EasingDirection.Out end
	if style == nil then style = Enum.EasingStyle.Quad end
	if duration == nil then duration = 0.2 end
	if overrides == nil then overrides = true end
	GuiObject:TweenSize(newSize,direction,style,duration,overrides)
end

function Functions.CreateSound(Information)
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

function Functions.AddLog(Model,Title,Body)
	local newval = Instance.new("StringValue")
	newval.Name = tick()
	newval.Value = Model.." • "..Title.." • "..Body
end

return Functions
																																			--[[
📝 @mattybhabes
⏲ Last Edited @ 11:57 May 30th '21
																																				]]
