local ContextActionService = game:GetService("ContextActionService")
local CAS = {}

function CAS.Bind(Name,Function,Button,Priority,Trigger)
	ContextActionService:BindActionAtPriority(Name,Function,Button,Priority,Trigger)
end

function CAS.Unbind(Name)
	ContextActionService:UnbindAction(Name)
end

function CAS.GetButton(Name)
	return ContextActionService:GetButton(Name) 
end

function CAS.SetImage(Name,Image)
	ContextActionService:SetImage(Name,Image)
end

function CAS.SetPosition(Name,Position)
	ContextActionService:SetPosition(Name,Position)
end

return CAS
