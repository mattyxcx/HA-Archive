local hungerLossRate = 1/350
local sprintingLossRateHunger = 1/250
local energyLossRate = 1/300
local sprintingLossRateEnergy = 1/100

local PlayerStats = game.Players.LocalPlayer:WaitForChild("PlayerInfo").Stats
local Hunger = PlayerStats.Hunger
local Energy = PlayerStats.Energy
local MaxEnergy = PlayerStats.MaxEnergy
local LastSprint = PlayerStats.LastSprint

while wait(1) do
	local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild('Humanoid')
	if Hunger.Value == 0 then
		Humanoid:TakeDamage(10)
		game.ReplicatedStorage.Events.Notifications.Thought:FireClient(game.Players:GetPlayerFromCharacter(Character),"I'm starving...")
		wait(30)
		return
	end
	if MaxEnergy.Value == 0 then
		Humanoid:TakeDamage(2)
		game.ReplicatedStorage.Events.Notifications.Thought:FireClient(game.Players:GetPlayerFromCharacter(Character),"I'm exhausted...")
		wait(30)
		return
	end
	if Humanoid.WalkSpeed < 22 and tick()-LastSprint.Value >= 4 then
		Hunger.Value = Hunger.Value-hungerLossRate
		Energy.Value = MaxEnergy.Value-energyLossRate
		MaxEnergy.Value = MaxEnergy.Value-energyLossRate
	else
		Hunger.Value = Hunger.Value-sprintingLossRateHunger
		MaxEnergy.Value = MaxEnergy.Value-sprintingLossRateEnergy
	end
end