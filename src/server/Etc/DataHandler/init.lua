local module = {}
local proxyurl = "https://thehiddenacademy.herokuapp.com/"
local baseurl,parenturl
local https = game:GetService("HttpService")
local http = require(script.Parent.ProxyService) 
local translatetypes =  {
	["string"]="stringValue",
	["boolean"]="booleanValue",
	["number"]="doubleValue",
	["table"] = "mapValue"
}
local translateop= {
	["<"] = "LESS_THAN",
	["<="] = "LESS_THAN_OR_EQUAL",
	[">"] = "GREATER_THAN",
	[">="] = "GREATER_THAN_OR_EQUAL",
	["="] = "EQUAL",
	["~="] = "NOT_EQUAL"
}

function module.Setup(accesskey,id)
	baseurl = "https://firestore.googleapis.com/v1beta1/projects/"..id.."/databases/(default)/documents"
	parenturl = "https://firestore.googleapis.com/v1beta1/projects/"..id.."/databases/(default)"
	http:New(proxyurl,accesskey)
end

function module.Get(datastore,key)
	local response = nil
	local url = baseurl.."/"..datastore.."/"..key
	local success, err = pcall(function()
		response = http:Get(url)
	end)
	if success then
		local data = https:JSONDecode(response.body)
		return data
	end
	if err then
		return "Error"
	end
end

function module.Set(Datastore,key,data)
	local response = nil
	local body = https:JSONEncode(data)
	local url = baseurl.."/"..Datastore.."/"..key
	local success, err = pcall(function()
		response = http:Patch(url,body)
	end)
	if success then
		local rt = https:JSONDecode(response.body)
		return rt
	end
	if err then
		warn("Error at patchdocuments!")
		return "Error"
	end
end

return module

