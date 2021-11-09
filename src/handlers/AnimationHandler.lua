local AH = {}

function AH.GetAnimation(Animation)
	local foundAnim = nil
	for a,b in next,game.ReplicatedStorage.Animations:GetDescendants() do
		if b.Name == Animation and b:IsA("Animation") then
			foundAnim = b
		end
	end
	return foundAnim
end

function AH.ReturnAnimation(Animator,Animation)
	local foundAnim = AH.GetAnimation(Animation)
	foundAnim = Animator:LoadAnimation(foundAnim)
	return foundAnim
end

return AH