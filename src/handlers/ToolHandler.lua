local RemoteEvent = game.ReplicatedStorage.Events.RemoteEvent
local ToolHandler = {}

function ToolHandler.FetchTool(Tool)
	local foundTool = nil
	for a,b in next,game.ReplicatedStorage.Tools:GetDescendants() do
		if b.Name == Tool and b:IsA("Tool") then
			foundTool = b
		end
	end
	
	if foundTool == nil then
		return "No tool found"
	else
		return foundTool
	end
end

function ToolHandler.FetchSettings(Tool)
	local toReturn = nil
	if Tool:IsA("Tool") then
		if Tool:FindFirstChild("Settings") ~= nil then
			toReturn = Tool.Settings
		end
	end
	return toReturn
end

function ToolHandler.GivePlayerTool(Player,Tools)
	for _,Tool in ipairs(Tools) do
		if ToolHandler.FetchTool(Tool) ~= "No tool found" then Tool = ToolHandler.FetchTool(Tool) end
		if Player:FindFirstChild("PlayerInfo") ~= nil then
			local PlayerRank = Player.PlayerInfo.Rank.Value
			local ToolSettings = ToolHandler.FetchSettings(Tool)
			if Player.Backpack:FindFirstChild(Tool.Name) == nil then
				if PlayerRank >= ToolSettings["rankId"].Value then
					local clone = Tool:Clone()
					clone.Parent = Player.Backpack
				end
			elseif Player.Backpack:FindFirstChild(Tool.Name) ~= nil then
				if ToolSettings["canHaveMultiple"].Value == true then
					if PlayerRank >= ToolSettings["rankId"].Value then
						local clone = Tool:Clone()
						clone.Parent = Player.Backpack
					end
				end
			end
		end
	end
end

return ToolHandler