local Players = game:GetService("Players")
local quick_menu = {}
local expect = game.WaitForChild

quick_menu.Initialize = function(frame)
    local settingsToggle = expect(frame,"Settings",99)
    local carryToggle = expect(frame,"CarryToggle",99)
    local giveTool = expect(frame,"Give",99)
    local plr = game:GetService("Players").LocalPlayer
    local plrInfo = expect(plr,"PlayerInfo",99)

    if not settingsToggle or not carryToggle or not giveTool or not plrInfo then return end
    if plr:GetRankInGroup(10311167) >= 100 then settingsToggle.Visible = true end
end

return quick_menu