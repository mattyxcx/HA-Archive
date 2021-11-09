local __externalData = require(script.Parent.Data)
local serverSettings = require(game.ReplicatedStorage.Modules.Library.Settings)

if serverSettings["Server Information"]["Name"] == "" then repeat wait() until serverSettings["Server Information"]["Name"] ~= nil end
if serverSettings["Server Information"]["Players"] == 0 then repeat wait() until serverSettings["Server Information"]["Players"] ~= 0 end
local ServerName = serverSettings["Server Information"]["Name"]
local JobId = serverSettings["Server Information"]["JobId"]
local shuttingDown = false
local lastupdate = 0

local prevValues = {0,0}

function process(baseDict)
	local ServerPlayers = serverSettings["Server Information"]["Players"]
	local ServerStaff = serverSettings["Server Information"]["Staff"]
	if baseDict["error"] == nil then
		if baseDict["fields"] == nil then baseDict["fields"] = {} end
		baseDict["fields"][JobId] = {
			["arrayValue"] = {
				["values"] = {
					[1] = {["stringValue"] = JobId},
					[2] = {["stringValue"] = ServerName},
					[3] = {["integerValue"] = ServerStaff},
					[4] ={["integerValue"] = ServerPlayers},
				}
			}
		}
		__externalData.Set("active-servers","all",baseDict)
		prevValues = {ServerPlayers,ServerStaff}
	elseif baseDict["error"] ~= nil then
		print("error",unpack(baseDict["error"]))
	end
end

function close(baseDict)
	if baseDict["error"] == nil then
		if baseDict["fields"] == nil then baseDict["fields"] = {} end
		baseDict["fields"][JobId] = nil
		__externalData.Set("active-servers","all",baseDict)
	elseif baseDict["error"] ~= nil then
		print("error",baseDict["error"])
	end
end

function updateClients(data)
	for a,Players in next,game.Players:GetPlayers() do
		if Players:FindFirstChild("PlayerInfo") ~= nil then
			if Players.PlayerInfo.Rank.Value >= 5 then
				game.ReplicatedStorage.Events.RemoteEvent:FireClient(Players,"Servers Update",data,JobId)
			end
		end
	end
end

game:BindToClose(function()
	shuttingDown = true
	close(__externalData.Get("active-servers","all"))
end)

while true do
	if (tick() - lastupdate >= 60) and shuttingDown ~= true and {serverSettings["Server Information"]["Players"],serverSettings["Server Information"]["Staff"]} ~= prevValues then
		lastupdate = tick()
		local dataGot = __externalData.Get("active-servers","all")
		process(dataGot)
		updateClients(dataGot)
		print("Loop Info Updated")
	end
	wait(10)
end