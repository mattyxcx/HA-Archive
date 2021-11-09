local Prompts = {}
local Uis = require(game.ReplicatedStorage.Modules.Library.UIs)

function Prompts.createPrompt(Key,Action,Ui)
	local Main = Instance.new("Frame")
	local KeyFrame = Instance.new("Frame")
	local KeyCode = Instance.new("TextLabel")
	local Backing = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UICorner_2 = Instance.new("UICorner")
	local ActionText = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")
	local SizeFinal = UDim2.new(1,0,1,0)
	
	Main.Name = "Main"
	Main.Parent = Ui
	Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Main.BackgroundTransparency = 1.000
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 0, 0, 0)

	UIListLayout.Parent = Main
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0.05, 0)

	KeyFrame.Name = "KeyFrame"
	KeyFrame.Parent = Main
	KeyFrame.BackgroundColor3 = Color3.fromRGB(100, 70, 59)
	KeyFrame.Position = UDim2.new(0.075, 0, 0.2, 0)
	KeyFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
	KeyFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY

	KeyCode.Name = "KeyCode"
	KeyCode.Parent = KeyFrame
	KeyCode.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
	KeyCode.BackgroundTransparency = 1.000
	KeyCode.Position = UDim2.new(0.2, 0, 0.2, 0)
	KeyCode.Size = UDim2.new(0.6, 0, 0.6, 0)
	KeyCode.ZIndex = 3
	KeyCode.Font = Enum.Font.GothamBold
	KeyCode.Text = Key
	KeyCode.TextColor3 = Color3.fromRGB(254, 238, 215)
	KeyCode.TextScaled = true
	KeyCode.TextSize = 14.000
	KeyCode.TextTransparency = 0.100
	KeyCode.TextWrapped = true

	Backing.Name = "Backing"
	Backing.Parent = KeyFrame
	Backing.BackgroundColor3 = Color3.fromRGB(50, 35, 28)
	Backing.BackgroundTransparency = 0.500
	Backing.Position = UDim2.new(0.1, 0, 0.1, 0)
	Backing.Size = UDim2.new(0.8, 0, 0.8, 0)
	Backing.ZIndex = 2

	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = Backing

	UICorner_2.CornerRadius = UDim.new(0.5, 0)
	UICorner_2.Parent = KeyFrame

	ActionText.Name = "ActionText"
	ActionText.Parent = Main
	ActionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ActionText.BackgroundTransparency = 1.000
	ActionText.Size = UDim2.new(0.5, 0, 0.6, 0)
	ActionText.Font = Enum.Font.Merriweather
	ActionText.Text = Action
	ActionText.TextColor3 = Color3.fromRGB(254, 238, 215)
	ActionText.TextStrokeColor3 = Color3.fromRGB(50, 35, 28)
	ActionText.TextStrokeTransparency = 0.5
	ActionText.TextScaled = true
	ActionText.TextSize = 14.000
	ActionText.TextWrapped = true
	ActionText.TextXAlignment = Enum.TextXAlignment.Left
	
	if Ui:FindFirstChildOfClass("Frame") ~= nil then
		local Frame = Ui:FindFirstChildOfClass("Frame")
		Ui.Size = UDim2.new((Ui.Size.X.Scale),0,(Ui.Size.Y.Scale*2),0)
		Frame.Size = UDim2.new(1,0,(Frame.Size.Y.Scale/2),0)
		Frame.Position = UDim2.new(0.5, 0, 0.25, 0)
		Main.Position = UDim2.new(0.5, 0, 0.75, 0)
		SizeFinal = UDim2.new(1, 0, 0.5, 0)
	end
	
	local function cleanup()
		Uis.TweenSize(Main,UDim2.new(0,0,0,0))
		delay(0.2,function()
			if #Ui:GetChildren() == 1 then
				Ui:Destroy()
			else
				local Frame = Ui:FindFirstChildOfClass("Frame")
				Uis.TweenSize(Frame,UDim2.new(1,0,(Frame.Size.Y.Scale*2),0))
				Uis.TweenPosition(Frame,UDim2.new(0,0,0,0))
				Ui:Destroy()
			end
		end)
	end
	
	Uis.TweenSize(Main,SizeFinal)
	
	return cleanup
end

function Prompts.createMobilePrompt(Action,Ui)
	local Main = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	local Content = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local TouchIcon = Instance.new("ImageLabel")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local ActionText = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")
	local SizeFinal = UDim2.new(1,0,1,0)
	
	Main.Name = "Main"
	Main.Parent = Ui
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(100, 70, 59)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 0, 0, 0)
	Main.Text = ""

	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = Main

	Content.Name = "Content"
	Content.Parent = Main
	Content.BackgroundColor3 = Color3.fromRGB(50, 35, 28)
	Content.BackgroundTransparency = 0.500
	Content.Position = UDim2.new(0.025, 0, 0.1, 0)
	Content.Size = UDim2.new(0.95, 0, 0.8, 0)

	UIListLayout.Parent = Content
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0.05, 0)

	UICorner_2.CornerRadius = UDim.new(0.5, 0)
	UICorner_2.Parent = Content

	TouchIcon.Name = "TouchIcon"
	TouchIcon.Parent = Content
	TouchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TouchIcon.BackgroundTransparency = 1.000
	TouchIcon.Position = UDim2.new(0.075, 0, 0.2, 0)
	TouchIcon.Size = UDim2.new(1, 0, 0.75, 0)
	TouchIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	TouchIcon.Image = "rbxasset://textures/ui/Controls/TouchTapIcon@2x.png"
	TouchIcon.ImageColor3 = Color3.fromRGB(254, 238, 215)

	UIAspectRatioConstraint.Parent = TouchIcon
	UIAspectRatioConstraint.AspectRatio = 0.806

	ActionText.Name = "ActionText"
	ActionText.Parent = Content
	ActionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ActionText.BackgroundTransparency = 1.000
	ActionText.Size = UDim2.new(0.7, 0, 0.6, 0)
	ActionText.Font = Enum.Font.Merriweather
	ActionText.Text = "Action Text"
	ActionText.TextColor3 = Color3.fromRGB(254, 238, 215)
	ActionText.TextStrokeColor3 = Color3.fromRGB(50, 35, 28)
	ActionText.TextStrokeTransparency = 0.5
	ActionText.TextScaled = true
	ActionText.TextSize = 14.000
	ActionText.TextWrapped = true

	if Ui:FindFirstChildOfClass("TextButton") ~= nil then
		local Frame = Ui:FindFirstChildOfClass("TextButton")
		Ui.Size = UDim2.new((Ui.Size.X.Scale),0,(Ui.Size.Y.Scale*2),0)
		Frame.Size = UDim2.new(1,0,(Frame.Size.Y.Scale/2),0)
		Frame.Position = UDim2.new(0.5, 0, 0.25, 0)
		Main.Position = UDim2.new(0.5, 0, 0.75, 0)
		SizeFinal = UDim2.new(1, 0, 0.5, 0)
	end
	
	local function cleanup()
		Uis.TweenSize(Main,UDim2.new(0,0,0,0))
		delay(0.2,function()
			if #Ui:GetChildren() == 1 then
				Ui:Destroy()
			else
				local Frame = Ui:FindFirstChildOfClass("TextButton")
				Uis.TweenSize(Frame,UDim2.new(1,0,(Frame.Size.Y.Scale*2),0))
				Uis.TweenPosition(Frame,UDim2.new(0.5,0,0,0))
				Ui:Destroy()
			end
		end)
	end

	Uis.TweenSize(Main,SizeFinal)
	
	return cleanup
end

return Prompts
