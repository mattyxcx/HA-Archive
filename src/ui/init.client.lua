local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Handlers = ReplicatedStorage:WaitForChild("Modules")
local Library = Handlers:WaitForChild("Library")
local Functions = require(Library.Functions)
local Transitions = require(script.transitions)

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Interfaces = script.Parent.HUD
local QuickMenu = Interfaces["Quick Menu"]
local tweens = {}

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 or Input.UserInputType == Enum.UserInputType.Touch then
        if Mouse.Target and Mouse.Target.Parent.ClassName == "Model" and Mouse.Target.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
            QuickMenu.Visible = true
            QuickMenu.Position = UDim2.new(0,Mouse.X+100,0,Mouse.Y)
            QuickMenu:TweenPosition(UDim2.new(0,Mouse.X,0,Mouse.Y),"Out","Sine",0.3)
            task.wait(0.15)
            playTransitions(QuickMenu,"Show")
        end
    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        if not Mouse.Target or Mouse.Target.Parent.ClassName ~= "Model" then
            playTransitions(QuickMenu,"Hide")
            QuickMenu:TweenPosition(UDim2.new(0,QuickMenu.Position.X.Offset+100,0,QuickMenu.Position.Y.Offset),"In","Sine",0.3)
            task.wait(0.2)
            QuickMenu.Visible = false
        end
    end
end)

function setupTransitions(Frame)
    tweens[Frame] = {}
    tweens[Frame]["Show"] = Transitions.setupShow(Frame)
    tweens[Frame]["Hide"] = Transitions.setupHide(Frame)
    playTransitions(Frame,"Hide")
    print(tweens)
end

function playTransitions(Frame,Condition)
    if tweens[Frame] and tweens[Frame][Condition] then
        for _,Tween in ipairs(tweens[Frame][Condition]) do
            Tween:Play()
        end
    end
end

setupTransitions(QuickMenu)