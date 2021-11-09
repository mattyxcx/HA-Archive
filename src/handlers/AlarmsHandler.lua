local AlarmsHandler = {}

function ClientUpdate(model)
	local information = string.split(model.Name,"|")
	local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
	local modelDesc = model:GetDescendants()
	if currentState == "Off" then
		for a,b in ipairs(modelDesc) do
			spawn(function()
				if b:IsA("BasePart") and b.Color == Color3.fromRGB(255, 0, 0) then
					b.Color = Color3.fromRGB(85, 0, 0)
					b.Material = Enum.Material.Glass
				elseif b:IsA("Sound") then
					b:Stop()
				end
			end)
		end
	elseif currentState == "On" then
		for a,b in ipairs(modelDesc) do
			spawn(function()
				if b:IsA("BasePart") and b.Color == Color3.fromRGB(85, 0, 0) then
					b.Color = Color3.fromRGB(255, 0, 0)
					b.Material = Enum.Material.Neon
				elseif b:IsA("Sound") then
					b:Play()
				end
			end)
		end
	end
end

function AlarmsHandler.updateAlarm(AlarmModel)
	local information = string.split(AlarmModel.Name,"|")
	local Name,Val = information[1],information[2]
	AlarmModel.Name = (Val == "On" and Name.."|Off") or Name.."|On"
end

function AlarmsHandler.Setup(Directory)
	for _,Model in ipairs(Directory:GetChildren()) do
		Model:GetPropertyChangedSignal("Name"):Connect(function() ClientUpdate(Model) end)
		ClientUpdate(Model)
	end
end

return AlarmsHandler


