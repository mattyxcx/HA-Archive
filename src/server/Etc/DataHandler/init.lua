local DataHandler = {}
local HttpService = game:GetService("HttpService")
local ProxyService = require(script.ProxyService) 
local ProxyUrl = "https://thehiddenacademy.herokuapp.com/"

function DataHandler.Setup(AccessKey)
	ProxyService:New(ProxyUrl,AccessKey)
end

function DataHandler.Get(URL)
	local Response = nil
	local Success,Error = pcall(function()
		Response = ProxyService:Get(URL)
	end)
	if Success then
		return HttpService:JSONDecode(Response.body)
	end
	if Error then
		return "Error"
	end
end

function DataHandler.Patch(URL,Data)
	local Response = nil
	local Body = HttpService:JSONEncode(Data)
	local Success,Error = pcall(function()
		Response = ProxyService:Patch(URL,Body)
	end)
	if Success then
		return HttpService:JSONDecode(Response.body)
	end
	if Error then
		return "Error"
	end
end

return DataHandler

