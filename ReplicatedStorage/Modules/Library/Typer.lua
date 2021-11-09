local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local SoundHandler = require(game.ReplicatedStorage.Modules.SoundsHandler)

local SOURCE_LOCALE = "en"
local translator = nil

local AnimateUI = {}

function  AnimateUI.loadTranslator()
	pcall(function()
		translator  = LocalizationService:GetTranslatorForPlayerAsync(Players.LocalPlayer)
	end)
	if not translator then
		pcall(function()
			translator = LocalizationService:GetTranslatorForLocaleAsync(SOURCE_LOCALE)
		end)
	end
end

function  AnimateUI.typeWrite(guiObject, text, delayBetweenChars, sound)
	guiObject .Visible = true
	guiObject .AutoLocalize = false
	local displayText = text

	-- Translate text if possible
	if translator then
		displayText = translator:Translate(guiObject, text)
	end

	-- Replace line break tags so grapheme loop will not miss those characters
	displayText = displayText:gsub("<br%s*/>", "\n")
	displayText:gsub("<[^<>]->", "")

	-- Set translated/modified text on parent
	guiObject .Text = displayText

	local index = 0
	for first, last in utf8.graphemes(displayText) do
		index = index + 1
		guiObject .MaxVisibleGraphemes = index
		if sound == true then SoundHandler.PlaySound("Type",game.Lighting) end
		wait(delayBetweenChars)
	end
end

return AnimateUI

-- // creds to https://developer.roblox.com/en-us/articles/animating-text