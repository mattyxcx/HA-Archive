local InsanityHandler = {}
local RemoteEvent = game.ReplicatedStorage.Events.RemoteEvent

function InsanityHandler.CheckInsanityLevel(Player)
	if Player:FindFirstChild("PlayerInfo") ~= nil then
		return Player.PlayerInfo.Stats.InsanityLevel.Value
	else
		return "No PlayerInfo information available"
	end
end

function InsanityHandler.ChangeInsanityLevel(Player,Level)
	if Player:FindFirstChild("PlayerInfo") ~= nil then
		Player.PlayerInfo.Stats.InsanityLevel.Value = Level
	else
		return "No PlayerInfo information available"
	end
end

function InsanityHandler.CheckInsane(Player)
	if Player:FindFirstChild("PlayerInfo") ~= nil then
		return Player.PlayerInfo.Stats.Insane.Value
	else
		return "No PlayerInfo information available"
	end
end

function InsanityHandler.TriggerEpisode(Player,Args)
	RemoteEvent:FireClient(Player,"Insane Episode",Args)
end

function InsanityHandler.ToggleMonster(Player)
	if Player.PlayerInfo.Stats.Insane.Value == false then
		local PlayerInfo = Player.PlayerInfo
		local Character = Player.Character
		local MonsterClone = game.ReplicatedStorage.Insanity.Resources.StarterCharacter:Clone()
		local Animations = game.ReplicatedStorage.Insanity.Resources.Animate:Clone()
		PlayerInfo.Stats.Insane.Value = true
		MonsterClone.HumanoidRootPart.Anchored = true
		MonsterClone.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
		Character.Animate:Destroy()
		Animations.Parent = MonsterClone
		MonsterClone.Name = Player.Name
		MonsterClone.Parent = workspace
		Player.Character = MonsterClone
		for a,b in next,Character:GetChildren() do
			if b:IsA("Script") then
				b.Parent = MonsterClone
			elseif b:IsA("LocalScript") then
				b.Parent = MonsterClone
			elseif b:IsA("BillboardGui") then
				b.Parent = MonsterClone
			elseif b:IsA("Folder") then
				b.Parent = MonsterClone
			end
		end
		Character:Destroy()
		MonsterClone.HumanoidRootPart.Anchored = false
		RemoteEvent:FireClient(Player,"Fix Client")
	else
		local PlayerInfo = Player.PlayerInfo
		local previousCFrame = Player.Character.HumanoidRootPart.CFrame
		PlayerInfo.Stats.Insane.Value = false
		Player:LoadCharacter()
		Player.Character.HumanoidRootPart.CFrame = previousCFrame
	end
end

return InsanityHandler
