local BlackScreen = Instance.new("Frame")
local ScreenGui = Instance.new("ScreenGui")

local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")
local isloaded = false

function Tween(Element:Instance,TInf,Properties)
	local Time,Style,Direction,Reverses,_Delay = TInf[1],TInf[2],TInf[3],TInf[4],TInf[5]
	if Time == nil then Time = 0.2 end
	if Style == nil then Style = Enum.EasingStyle.Quad end
	if Direction == nil then Direction = Enum.EasingDirection.Out end
	local TweenInformation = TweenInfo.new(Time,Style,Direction,0,Reverses,_Delay)
	TweenService:Create(Element,TweenInformation,Properties):Play()
end

function createText(Content)
	local newText = Instance.new("TextLabel")
	newText.Name = "Title"
	newText.Parent = BlackScreen
	newText.AnchorPoint = Vector2.new(0, 0.5)
	newText.BackgroundColor3 = Color3.fromRGB(100, 71, 57)
	newText.BackgroundTransparency = 1.000
	newText.BorderColor3 = Color3.fromRGB(27, 42, 53)
	newText.BorderSizePixel = 0
	newText.Position = UDim2.new(0, 0, 0.5, 0)
	newText.Size = UDim2.new(1, 0, 0, 50)
	newText.Font = Enum.Font.Fantasy
	newText.Text = Content
	newText.TextSize = 18
	newText.TextColor3 = Color3.fromRGB(254, 238, 215)
	newText.TextTransparency = 0
	newText.TextWrapped = true
	newText.ZIndex = 16
	return newText
end

ScreenGui.Name = "Client Loading"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui
ScreenGui.DisplayOrder = 2
ScreenGui.ResetOnSpawn = false

BlackScreen.Name = "Black Screen"
BlackScreen.Parent = ScreenGui
BlackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackScreen.Position = UDim2.new(0, 0, 0, -37)
BlackScreen.Size = UDim2.new(1, 0, 1, 37)
BlackScreen.ZIndex = 15

local Title = createText("Loading")

ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,false)

coroutine.resume(coroutine.create(function()
	while true do
		if isloaded == false then
			Title.Text = "○ ○ ○ Loading ○ ○ ○"
			wait(0.25)
			Title.Text = "○ ○ ● Loading ● ○ ○"
			wait(0.25)
			Title.Text = "○ ● ● Loading ● ● ○"
			wait(0.25)
			Title.Text = "● ● ● Loading ● ● ●"
			wait(0.25)
			Title.Text = "○ ● ● Loading ● ● ○"
			wait(0.25)
			Title.Text = "○ ○ ● Loading ● ○ ○"
			wait(0.25)
		else coroutine.yield() break end
	end
end))

repeat wait() until game:IsLoaded() and workspace:FindFirstChild("Etc") ~= nil and player:FindFirstChild("PlayerInfo") ~= nil and game.ReplicatedStorage:FindFirstChild("Modules") ~= nil
local typer = require(game.ReplicatedStorage.Modules:WaitForChild("Library"):WaitForChild("Typer"))
wait(10)

isloaded = true
player.PlayerInfo.Loaded.Value = true

Title.TextTransparency = 1
local newTitle = createText("Loaded Successfully")
wait(2)
Tween(newTitle,{1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,false,0},{TextTransparency = 1})
wait(2)
local typerTitle = createText("")
typerTitle.TextSize = 24
typer.typeWrite(typerTitle,"September 3rd, 1940",0,true)
wait(2)
local typerTitle2 = createText("")
typerTitle2.Position = UDim2.new(0, 0, 0.5, 32)
typerTitle2.TextTransparency = 0.25
typer.typeWrite(typerTitle2,"Cairnholm, Wales",0,true)
wait(3)
Tween(BlackScreen,{3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,false,0},{BackgroundTransparency = 1})
Tween(typerTitle,{3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,false,0},{TextTransparency = 1})
Tween(typerTitle2,{3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,false,0},{TextTransparency = 1})
wait(3)
ScreenGui:Destroy()