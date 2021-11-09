local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local SoundsHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)

local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GamepadButtonImage = {
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
	[Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
	[Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
	[Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
	[Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
	[Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxmenu.png",
	[Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLS.png",
	[Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRS.png",
}

local KeyboardButtonImage = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png",
}

local KeyboardButtonIconMapping = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png",
}

local KeyCodeToTextMapping = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12",
}

local function getScreenGui()
	local screenGui = PlayerGui:FindFirstChild("ProximityPrompts")
	if screenGui == nil then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ProximityPrompts"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = PlayerGui
	end
	return screenGui
end

local function createPrompt(prompt, inputType, gui)

	local tweensForButtonHoldBegin = {}
	local tweensForButtonHoldEnd = {}
	local tweensForFadeOut = {}
	local tweensForFadeIn = {}
	local tweenInfoInFullDuration = TweenInfo.new(prompt.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tweenInfoOutHalfSecond = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfoOut = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tweenInfoIn = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local tweenInfoQuick = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tweenInfoReverse = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,true)

	local promptUI = Instance.new("BillboardGui")
	promptUI.Name = "Prompt"
	promptUI.AlwaysOnTop = true
	promptUI.LightInfluence = 0.5
	
	if inputType == Enum.ProximityPromptInputType.Touch then
		local Main = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local Content = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local TouchIcon = Instance.new("ImageLabel")
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		local ActionText = Instance.new("TextLabel")
		local UIListLayout = Instance.new("UIListLayout")

		Main.Name = "Main"
		Main.Parent = promptUI
		Main.AnchorPoint = Vector2.new(0.5, 0.5)
		Main.BackgroundColor3 = Color3.fromRGB(100, 70, 59)
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Main.Size = UDim2.new(1, 0, 1, 0)
		Main.Font = Enum.Font.SourceSans
		Main.Text = ""
		Main.TextColor3 = Color3.fromRGB(0, 0, 0)
		Main.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0.5, 0)
		UICorner.Parent = Main

		Content.Name = "Content"
		Content.Parent = Main
		Content.BackgroundColor3 = Color3.fromRGB(50, 35, 28)
		Content.BackgroundTransparency = 0.500
		Content.Position = UDim2.new(0.025, 0, 0.1, 0)
		Content.Size = UDim2.new(0.95, 0, 0.8, 0)

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

		UIListLayout.Parent = Content
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0.05, 0)

		ActionText.Name = "ActionText"
		ActionText.Parent = Content
		ActionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ActionText.BackgroundTransparency = 1.000
		ActionText.Size = UDim2.new(0.7, 0, 0.6, 0)
		ActionText.Font = Enum.Font.Merriweather
		ActionText.Text = prompt.ActionText
		ActionText.TextColor3 = Color3.fromRGB(254, 238, 215)
		ActionText.TextStrokeColor3 = Color3.fromRGB(58, 42, 31)
		ActionText.TextStrokeTransparency = 0.85
		ActionText.TextScaled = true
		ActionText.TextWrapped = true
		
		local buttonDown = false
		
		Main.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and
				input.UserInputState ~= Enum.UserInputState.Change then
				prompt:InputHoldBegin()
				buttonDown = true
			end
		end)
		Main.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if buttonDown then
					buttonDown = false
					prompt:InputHoldEnd()
				end
			end
		end)
		
		promptUI.Active = true
		
	else
		local buttonTextString = UserInputService:GetStringForKeyCode(prompt.KeyboardKeyCode)

		local buttonTextImage = KeyboardButtonImage[prompt.KeyboardKeyCode]
		if buttonTextImage == nil then
			buttonTextImage = KeyboardButtonIconMapping[buttonTextString]
		end

		if buttonTextImage == nil then
			local keyCodeMappedText = KeyCodeToTextMapping[prompt.KeyboardKeyCode]
			if keyCodeMappedText then
				buttonTextString = keyCodeMappedText
			end
		end

		local Main = Instance.new("Frame")
		local KeyFrame = Instance.new("Frame")
		local KeyCode = Instance.new("TextLabel")
		local Backing = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UICorner_2 = Instance.new("UICorner")
		local ActionText = Instance.new("TextLabel")
		local UIListLayout = Instance.new("UIListLayout")

		Main.Name = "Main"
		Main.Parent = promptUI
		Main.AnchorPoint = Vector2.new(0.5, 0.5)
		Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Main.BackgroundTransparency = 1.000
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Main.Size = UDim2.new(1, 0, 1, 0)

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
		KeyCode.Font = Enum.Font.GothamSemibold
		KeyCode.Text = buttonTextString
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

		UIListLayout.Parent = Main
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0.05, 0)

		ActionText.Name = "ActionText"
		ActionText.Parent = Main
		ActionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ActionText.BackgroundTransparency = 1.000
		ActionText.Size = UDim2.new(0.5, 0, 0.6, 0)
		ActionText.Font = Enum.Font.Merriweather
		ActionText.Text = prompt.ActionText
		ActionText.TextColor3 = Color3.fromRGB(254, 238, 215)
		ActionText.TextStrokeColor3 = Color3.fromRGB(58, 42, 31)
		ActionText.TextStrokeTransparency = 0.5
		ActionText.TextScaled = true
		ActionText.TextSize = 14.000
		ActionText.TextWrapped = true
		ActionText.TextXAlignment = Enum.TextXAlignment.Left
	end

	local holdBeganConnection
	local holdEndedConnection
	local triggeredConnection

	triggeredConnection = prompt.Triggered:Connect(function()
		TweenService:Create(promptUI,tweenInfoReverse,{Size = UDim2.fromScale(3.6,0.6)}):Play()
		SoundsHandler.PlaySound("Tap",game.Lighting)
		wait(0.12)
	end)

	local function updateUIFromPrompt()
		-- todo: Use AutomaticSize instead of GetTextSize when that feature becomes available
		local actionTextSize = TextService:GetTextSize(prompt.ActionText, 30, Enum.Font.Fantasy, Vector2.new(1000, 1000))
		local objectTextSize = TextService:GetTextSize(prompt.ObjectText, 18, Enum.Font.Fantasy, Vector2.new(1000, 1000))
		local maxTextWidth = math.max(actionTextSize.X, objectTextSize.X)

		local actionTextYOffset = 0
		if prompt.ObjectText ~= nil and prompt.ObjectText ~= '' then
			actionTextYOffset = 9
		end

		promptUI.Size = UDim2.fromScale(0,0)
		promptUI.StudsOffset = Vector3.new(prompt.UIOffset.X,prompt.UIOffset.Y,0)
	end

	local changedConnection = prompt.Changed:Connect(updateUIFromPrompt)
	updateUIFromPrompt()

	promptUI.Adornee = prompt.Parent
	promptUI.Parent = gui
	
	TweenService:Create(promptUI,tweenInfoOut,{Size = UDim2.fromScale(4,0.8)}):Play()
	
	for _, tween in ipairs(tweensForFadeIn) do
		tween:Play()
	end

	local function cleanup()

		triggeredConnection:Disconnect()
		changedConnection:Disconnect()

		TweenService:Create(promptUI,tweenInfoIn,{Size = UDim2.fromScale(0,0)}):Play()
		wait(0.2)

		promptUI.Parent = nil
	end

	return cleanup
end

local function onLoad()

	ProximityPromptService.PromptShown:Connect(function(prompt, inputType)
		if prompt.Style == Enum.ProximityPromptStyle.Default then
			return
		end

		local gui = getScreenGui()

		local cleanupFunction = createPrompt(prompt, inputType, gui)
		
		
		prompt.Parent.ChildRemoved:Connect(function(p)
			if p == prompt then cleanupFunction() end
		end)
		
		prompt.PromptHidden:Wait()
		cleanupFunction()
	end)
end

onLoad()