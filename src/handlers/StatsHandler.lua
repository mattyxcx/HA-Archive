local StatsHandler = {}

function StatsHandler.UpdateServerStats(Player,Stat,Value)
	if not Player.PlayerInfo then
		Player:WaitForChild("PlayerInfo")
	end
	if Player.PlayerInfo.Stats:FindFirstChild(Stat) ~= nil then
		Player.PlayerInfo.Stats:FindFirstChild(Stat).Value = Value
	end
end

function StatsHandler.UpdateClientStats(Player,Stat,StatFrame)
	if Stat == "Health" then
		local Size = (Player.PlayerInfo.Stats.Health.Value/100)
		StatFrame.Frame:TweenSize(UDim2.new(Size,0,1,0),"Out","Quad",0.25)
	elseif Stat == "Hunger" then
		local Size = (Player.PlayerInfo.Stats.Hunger.Value/100)
		StatFrame.Frame:TweenSize(UDim2.new(Size,0,1,0),"Out","Quad",0.25)
	elseif Stat == "Energy" then
		local Size = (Player.PlayerInfo.Stats.Energy.Value/100)
		StatFrame.Frame:TweenSize(UDim2.new(Size,0,1,0),"Out","Quad",0.25)
	elseif Stat == "MaxEnergy" then
		local Size = (Player.PlayerInfo.Stats.MaxEnergy.Value/100)
		StatFrame.Frame:TweenSize(UDim2.new(Size,0,1,0),"Out","Quad",0.25)
	elseif Stat == "Time" then
		local Time = string.sub(game.Lighting.TimeOfDay,1,#game.Lighting.TimeOfDay-3)
		StatFrame.Time.Text = Time
	end
end

function StatsHandler.ResetClientStats(StatsFrame)
	for a,b in next,StatsFrame:GetChildren() do
		if b:IsA("Frame") then
			b.Frame:TweenSize(UDim2.new(1,0,1,0),"Out","Quad",0.25)
		end
	end
end

return StatsHandler