local Drag = {}
local UIS = game:GetService("UserInputService")

function Drag.Setup(_Frame,DraggingFunction,ReleaseFunction,Conditional)
	local Player = game.Players.LocalPlayer
	local Mouse = Player:GetMouse()
	local Frame,Toggle
	local InputBegan,mouseMoveHandler,initialInputChanged,initInputChanged,Began,mouseMove,AncestryChanged
	Frame = _Frame:Clone()
	Frame.Parent = game.Players.LocalPlayer.PlayerGui.HUD
	Frame.Size = UDim2.new(0,_Frame.AbsoluteSize.X,0,_Frame.AbsoluteSize.Y)
	Frame.Position = UDim2.new(1,0,1,0)
	Frame.Name = "Drag Frame"
	Frame.Visible = false
	Frame.ZIndex = 99999

	local function Update(Position)
		local Position = UDim2.new(0,Position.X,0,Position.Y)
		Frame.Position = Position
		DraggingFunction(_Frame,Frame)
	end

	initInputChanged = function(Input)
		if Input.UserInputState == Enum.UserInputState.End then
			Toggle = false
			InputBegan = _Frame.InputBegan:Connect(Began)
			initialInputChanged:Disconnect()
			mouseMove:Disconnect()
			ReleaseFunction(_Frame,Frame)
		end
	end

	Began = function(Input)
		if Conditional.Value == true and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			Toggle = true
			Frame.Visible = true
			initialInputChanged = Input.Changed:Connect(function() initInputChanged(Input) end)
			InputBegan:Disconnect()
			mouseMove = Mouse.Move:Connect(mouseMoveHandler)
		end
	end

	mouseMoveHandler = function(Input)
		if Toggle == true then
			Update(Vector2.new(Mouse.X,Mouse.Y))
		end
	end
	
	AncestryChanged = function()
		if not _Frame:IsDescendantOf(game) then
			_Frame:Destroy()
		end
	end

	InputBegan = _Frame.InputBegan:Connect(Began)
	_Frame.AncestryChanged:Connect(AncestryChanged)
end

return Drag

-- >	📜 Drag Module
-- -	📝 @mattyoncé
-- <	⏰ 08/08/2021 05:21 AM BST																														]]