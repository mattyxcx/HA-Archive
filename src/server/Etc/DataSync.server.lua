local DataHandler = require(script.Parent.DataHandler)
local serverSettings = require(game.ReplicatedStorage.Modules.Library.Settings)
local serverInformation = serverSettings["Server Information"]
if serverInformation["Name"] == "" then repeat wait() until serverInformation["Name"] ~= nil end
if serverInformation["Players"] == 0 then repeat wait() until serverInformation["Players"] ~= 0 end
local ServerName = serverInformation["Name"]
local JobId = serverInformation["JobId"]
local shuttingDown = false
local lastUpdate = 0

local DataStoreUrl = "https://firestore.googleapis.com/v1beta1/projects/thaexternaldata-33wzygh1aq/databases/(default)/documents"

local prevValues = {0,0}

function process(baseDict)
	local ServerPlayers = serverInformation["Players"]
	local ServerStaff = serverInformation["Staff"]
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
		DataHandler.Patch(DataStoreUrl.."/active-servers/all",baseDict)
		prevValues = {ServerPlayers,ServerStaff}
	elseif baseDict["error"] ~= nil then
		print("error",unpack(baseDict["error"]))
	end
end

function close(baseDict)
	if baseDict["error"] == nil then
		if baseDict["fields"] == nil then baseDict["fields"] = {} end
		baseDict["fields"][JobId] = nil
		DataHandler.Patch(DataStoreUrl.."/active-servers/all",baseDict)
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
	close(DataHandler.Get(DataStoreUrl.."/active-servers/all"))
end)

while true do
	if (tick() - lastUpdate >= 60) and shuttingDown ~= true and {serverInformation["Players"],serverInformation["Staff"]} ~= prevValues then
		lastUpdate = tick()
		local dataGot = DataHandler.Get(DataStoreUrl.."/active-servers/all")
		process(dataGot)
		updateClients(dataGot)
		print("Loop Info Updated")
	end
	wait(10)
end