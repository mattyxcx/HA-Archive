local Module = {}
local ServerInfo = game.ReplicatedStorage.Server.Ext

function Module.CreateBody(Caller,Note)
    return {
        ["content"] = "<@&829941010317705246>",
        ["embeds"] =  {
           [1] =  {
              ["author"] =  {
                 ["name"] = Caller.Name
              },
              ["color"] = 2097286,
              ["description"] = [[> ]] .. Caller.Name .. [[ needs extra assistance in ]] .. ServerInfo.LoopName.Value .. [[! Please enter this loop and offer your assistance if you happen to be available...
     
     - ***faulty phone line connects*** -
     > *"]] .. Note .. [[" - ]] .. Caller.Name .. [[*
     - ***line is severed*** -
     
     > [*Enter loop*](https://www.roblox.com/games/6664565660/The-Hidden-Academy?gameId=]] .. ServerInfo.JobId.Value .. [[)]],
              ["fields"] =  {
                 [1] =  {
                    ["inline"] = true,
                    ["name"] = "Faculty Headcount",
                    ["value"] = "```" .. ServerInfo.Staff.Value .. "```"
                 },
                 [2] =  {
                    ["inline"] = true,
                    ["name"] = "Peculiar Headcount",
                    ["value"] = "```" .. #game.Players:GetPlayers()-ServerInfo.Staff.Value .. "```"
                 },
                 [3] =  {
                    ["inline"] = true,
                    ["name"] = "Loop Time",
                    ["value"] = "```" .. game.Lighting.TimeOfDay .. "```"
                 }
              }
           }
        }
    }
end

return Module