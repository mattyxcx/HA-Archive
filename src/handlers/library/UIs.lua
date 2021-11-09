local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local UIs = {}

function UIs.CreateAvatar(Player)
	local playerUID

	if Player:IsA("Player") == false then
		playerUID = game.Players:GetUserIdFromNameAsync(Player)
	else
		playerUID = Player.UserId
	end

	local Players = game:GetService("Players")	
	local userId = playerUID
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size150x150
	local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	return content
end

function UIs.CreateAvatarFromUsername(Username)
	local playerUID = game.Players:GetUserIdFromNameAsync(Username)
	local userId = playerUID
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size150x150
	local content, isReady = game.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	return content
end

function UIs.TweenSize(Element,NewSize,Direction,Style,Time,Overrides)
	if tostring(type(Element)) == "table" then for _,v in ipairs(Element) do UIs.TweenSize(v,NewSize,Direction,Style,Time,Overrides) end else
		if NewSize == nil then warn("Tween Error - A new UDim2 size must be supplied!") return end
		if Direction == nil then Direction = Enum.EasingDirection.Out end
		if Style == nil then Style = Enum.EasingStyle.Quart end
		if Time == nil then Time = 0.2 end
		if Overrides == nil then Overrides = true end
		Element:TweenSize(NewSize,Direction,Style,Time,Overrides)
	end
end

function UIs.TweenPosition(Element,NewPos,Direction,Style,Time,Overrides)
	if tostring(type(Element)) == "table" then for _,v in ipairs(Element) do UIs.TweenPosition(v,NewPos,Direction,Style,Time,Overrides) end else
		if NewPos == nil then warn("Tween Error - A new UDim2 size must be supplied!") return end
		if Direction == nil then Direction = Enum.EasingDirection.Out end
		if Style == nil then Style = Enum.EasingStyle.Quart end
		if Time == nil then Time = 0.2 end
		if Overrides == nil then Overrides = true end
		Element:TweenPosition(NewPos,Direction,Style,Time,Overrides)
	end
end

function UIs.Tween(Element,TInf,Properties)
	local Time,Style,Direction,Reverses,_Delay = unpack(TInf)
	if Time == nil then Time = 0.2 end
	if Style == nil then Style = Enum.EasingStyle.Quart end
	if Direction == nil then Direction = Enum.EasingDirection.Out end
	if Reverses == nil then Reverses = false end
	if _Delay == nil then _Delay = 0 end
	
	local TweenInformation = TweenInfo.new(
		Time,
		Style,
		Direction,
		0,
		Reverses,
		_Delay
	)
	TweenService:Create(Element,TweenInformation,Properties):Play()
end

function UIs.ReturnTextSize(String,TextSize,Font,MaxSize)
	return game:GetService("TextService"):GetTextSize(String,TextSize,Font,MaxSize)
end

function UIs.SubColor3(og,tc)
	return Color3.new(og.r-tc.r,og.g-tc.g,og.b-tc.b)
end

function UIs.AddColor3(og,tc)
	return Color3.new(og.r+tc.r,og.g+tc.g,og.b+tc.b)
end

function UIs.HandleMouseLabel(UiObject,Text)
	local textSize = UIs.ReturnTextSize(Text,18,Enum.Font.Fantasy,Vector2.new(1000,100))
	local mouseLabel = game.Players.LocalPlayer.PlayerGui.HUD["Mouse Label"]
	local function setup()
		mouseLabel.Size = UDim2.new(0,textSize.X+20,0,textSize.Y+10)
		mouseLabel.Text = Text
	end
	UiObject.MouseEnter:Connect(function() setup() mouseLabel.Visible = true end)
	UiObject.MouseLeave:Connect(function() mouseLabel.Visible = false end)
end

function UIs.HandleDropdownMenu(Menu)
	Menu.Toggle.Activated:Connect(function()
		UIs.TweenSize(Menu,UDim2.new(Menu.Size.X.Scale,Menu.Size.X.Offset,0,((Menu.Open.Value and 30) or Menu.Frame.UIListLayout.AbsoluteContentSize.Y+30)))
		Menu.Open.Value = not Menu.Open.Value
	end)
	for a,button in pairs(Menu.Frame:GetChildren()) do
		if button:IsA("TextButton") then
			button.Activated:Connect(function()
				UIs.TweenSize(Menu,UDim2.new(Menu.Size.X.Scale,Menu.Size.X.Offset,0,30))
				Menu.Open.Value = false
				Menu.Toggle.Body.Text = button.Body.Text
			end)
		end
	end
end

function UIs.HandleDragFrame(Frame,Value,Mouse)
	local DragBar = Frame["Drag Bar"]
	local DragButton = DragBar["Drag Button"]
	local DragValue = DragButton["Drag Value"]
	
	local Dragging = Frame["Dragging"]
	local DragMin = Frame["Min"]
	local DragMax = Frame["Max"]
	
	local ogSize = DragBar.Size
	local hSize = UDim2.new(ogSize.X.Scale,ogSize.X.Offset,ogSize.Y.Scale,ogSize.Y.Offset+5)
	
	local multiply = (DragMax.Value-DragMin.Value)
	
	Mouse.Move:Connect(function()
		if Frame.Dragging.Value == true then
			DragButton.Position = UDim2.new(0, Mouse.X - DragBar.AbsolutePosition.X, 0.5, 0)
			if DragButton.Position.X.Offset > DragBar.AbsoluteSize.X then
			--	DragButton.Position = UDim2.new(0, Mouse.X - DragBar.AbsoluteSize.X, 0.5, 0)
			elseif DragButton.Position.X.Offset < 0 then
				DragButton.Position = UDim2.new(0, 0, 0.5, 0)
			end
			Value = math.floor((DragButton.Position.X.Offset / DragBar.AbsoluteSize.X) * multiply) + DragMin.Value
			DragValue.Text = tostring(Value)
		end
	end)

	DragBar.MouseEnter:Connect(function() UIs.TweenSize(DragBar,hSize) end)
	DragBar.MouseLeave:Connect(function() UIs.TweenSize(DragBar,ogSize) end)

	DragBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input == Enum.UserInputType.Touch then
			Dragging.Value = true
			DragButton.Position = UDim2.new(0, Mouse.X - DragBar.AbsolutePosition.X, 0.5, 0)
			Value = math.floor((DragButton.Position.X.Offset / DragBar.AbsoluteSize.X) * multiply) + DragMin.Value
			DragValue.Text = tostring(Value)
		end
	end)

	DragBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
			Dragging.Value = false
		end
	end)
	
	DragButton.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input == Enum.UserInputType.Touch then
			Dragging.Value = true
		end
	end)

	DragButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
			Dragging.Value = false
		end
	end)
end

return UIs
