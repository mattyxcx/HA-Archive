local LightsHandler = {}

function ClientUpdate(model)
	local information = string.split(model.Name,"|")
	local switchName,currentState,specificFunction,minRank = information[1],information[2],information[3],information[4]
	local modelDesc = model:GetDescendants()
	if currentState == "On" then
		for a,b in ipairs(modelDesc) do
			spawn(function()
				if b:IsA("BasePart") and b.Color == Color3.fromRGB(126, 104, 63) then
					b.Color = Color3.fromRGB(253, 234, 141)
					b.Material = Enum.Material.Neon
				elseif b:IsA("PointLight") then
					b.Enabled = true
				end
			end)
		end
	elseif currentState == "Off" then
		for a,b in ipairs(modelDesc) do
			spawn(function()
				if b:IsA("BasePart") and b.Color == Color3.fromRGB(253, 234, 141) then
					b.Color = Color3.fromRGB(126, 104, 63)
					b.Material = Enum.Material.Glass
				elseif b:IsA("PointLight") then
					b.Enabled = false
				end
			end)
		end
	end
end

function LightsHandler.updateLight(LightModel)
	local information = string.split(LightModel.Name,"|")
	local Name,Val = information[1],information[2]
	LightModel.Name = (Val == "On" and Name.."|Off") or Name.."|On"
end

function LightsHandler.Setup(Directory)
	for _,Model in ipairs(Directory:GetChildren()) do
		Model:GetPropertyChangedSignal("Name"):Connect(function() ClientUpdate(Model) end)
		ClientUpdate(Model)
	end
end

return LightsHandler


