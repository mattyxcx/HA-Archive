local TweenService = game:GetService("TweenService")
local musicHandler,recentlyPlayed = {},{}

function fadeSound(Sound,Length,Target)
    local tweenInfo = TweenInfo.new(Length,Enum.EasingStyle.Linear)
    if Sound.Playing == true then
        TweenService:Create(Sound,tweenInfo,{Volume = Target})
    end
end

function queueMusic()

end

return musicHandler