local TweenService = game:GetService("TweenService")
local TweenSettings = TweenInfo.new(0.2)
local module = {}

module.setupShow = function(ParentFrame)
    local returning = {}
    local targets = ParentFrame:GetDescendants(); table.insert(targets,ParentFrame)
    for _,Instance in ipairs(targets) do
        if Instance:IsA("Frame") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = Instance.BackgroundTransparency}
                ))
            )
        elseif Instance:IsA("ScrollingFrame") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = Instance.BackgroundTransparency,
                    ScrollBarImageTransparency = Instance.ScrollBarImageTransparency}
                ))
            )
        elseif Instance:IsA("ImageLabel") or Instance:IsA("ImageButton") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = Instance.BackgroundTransparency,
                    ImageTransparency = Instance.ImageTransparency}
                ))
            )
        elseif Instance:IsA("TextLabel") or Instance:IsA("TextButton") or Instance:IsA("TextBox") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = Instance.BackgroundTransparency,
                    TextStrokeTransparency = Instance.TextStrokeTransparency,
                    TextTransparency = Instance.TextStrokeTransparency}
                ))
            )
        end
    end

    return returning
end

module.setupHide = function(ParentFrame,includePF)
    local returning = {}
    local targets = ParentFrame:GetDescendants(); table.insert(targets,ParentFrame)
    for _,Instance in ipairs(targets) do
        if Instance:IsA("Frame") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = 1}
                ))
            )
        elseif Instance:IsA("ScrollingFrame") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = 1,
                    ScrollBarImageTransparency = 1}
                ))
            )
        elseif Instance:IsA("ImageLabel") or Instance:IsA("ImageButton") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = 1,
                    ImageTransparency = 1}
                ))
            )
        elseif Instance:IsA("TextLabel") or Instance:IsA("TextButton") or Instance:IsA("TextBox") then
            table.insert(returning,(TweenService:Create(Instance,TweenSettings,
                    {BackgroundTransparency = 1,
                    TextStrokeTransparency = 1,
                    TextTransparency = 1}
                ))
            )
        end
    end

    return returning
end

return module