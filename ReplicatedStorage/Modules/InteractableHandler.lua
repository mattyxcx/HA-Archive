local RagdollHandler = require(game.ReplicatedStorage.Modules.RagdollHandler)
local AnimationHandler = require(game.ReplicatedStorage.Modules.AnimationHandler)
local Event = game.ReplicatedStorage.Events.RemoteEvent
local InteractableHandler = {}

function InteractableHandler.makePrompt(Name,Action,Key,Parent,Distance,Function,FunctionArgs)
	local ProximityPrompt = Instance.new("ProximityPrompt")
	ProximityPrompt.Name = Name
	ProximityPrompt.ActionText = Action
	ProximityPrompt.KeyboardKeyCode = Key
	ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
	ProximityPrompt.Parent = Parent
	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.MaxActivationDistance = Distance
	ProximityPrompt.Triggered:Connect(function() Function(unpack(FunctionArgs)) end)
	return ProximityPrompt
end

function InteractableHandler.GetPartInfo(Part)
	return unpack(string.split(Part.Name,"|"))
end

function InteractableHandler.CheckIsUsing(Player)
	if Player.Character ~= nil then
		return Player.Character.CharInfo.Using.Value
	end
end

function InteractableHandler.ToggleIsUsing(Player,v)
	if Player.Character ~= nil then
		Player.Character.CharInfo.Using.Value = v
	end
end

function FoodUse(Tool,Player,optStat,isDrink)
	local p = Tool:WaitForChild("p")
	local g = Tool:WaitForChild("gain")
	local prompt = Tool.Handle.Prompt:FindFirstChild("Food Consume")
	if optStat == nil then optStat = "Hunger" end
	local PStats = Player.PlayerInfo.Stats
	local Stat = PStats:FindFirstChild(optStat)
	if p.Value >= 0.2 and RagdollHandler.isRagdolled(Player.Character) == false and InteractableHandler.CheckIsUsing(Player) == false then
		if isDrink == nil then isDrink = "Food Consume" else isDrink = "Drink Consume" end
		local animation = AnimationHandler.ReturnAnimation(Tool.Parent.Humanoid.Animator,isDrink)
		InteractableHandler.ToggleIsUsing(Player,true)
		prompt.Enabled = false
		animation:Play(0.25)
		wait(animation.Length)
		local toAdd = g.Value
		if Stat.Value + toAdd > 100 then
			toAdd = 100 - Stat.Value
		end
		Stat.Value = Stat.Value + toAdd
		if tostring(p.Value) == "0.2" then prompt.Enabled = false else prompt.Enabled = true end
		Event:FireServer("Change Food State",Tool,isDrink)
		InteractableHandler.ToggleIsUsing(Player,false)
	end
end

function InteractableHandler.FoodEquip(Tool,Player,optStat,isDrink)
	local p = Tool:WaitForChild("p")
	local g = Tool:WaitForChild("gain")
	local prompt = Tool.Handle.Prompt:FindFirstChild("Food Consume")
	if prompt == nil then
		InteractableHandler.makePrompt("Food Consume","Consume",Enum.KeyCode.F,Tool.Handle.Prompt,10,FoodUse,{Tool,Player,optStat,isDrink})
	else
		if p.Value >= 0.2 then
			prompt.Enabled = true
		end
	end
end

return InteractableHandler
