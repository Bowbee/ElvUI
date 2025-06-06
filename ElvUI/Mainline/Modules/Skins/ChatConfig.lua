local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local ipairs, pairs = ipairs, pairs

local FCF_GetCurrentChatFrame = FCF_GetCurrentChatFrame
local hooksecurefunc = hooksecurefunc

function S:ChatConfig()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.blizzardOptions) then return end

	local ChatConfigFrame = _G.ChatConfigFrame
	ChatConfigFrame:StripTextures()
	ChatConfigFrame:SetTemplate('Transparent')
	ChatConfigFrame.Header:StripTextures()

	hooksecurefunc('ChatConfig_UpdateCheckboxes', function(frame)
		if not FCF_GetCurrentChatFrame() then return end

		local nameString = frame:GetName()..'Checkbox'
		for index in ipairs(frame.checkBoxTable) do
			local checkboxName = nameString..index
			local checkbox = _G[checkboxName]
			if checkbox and not checkbox.IsSkinned then
				checkbox:StripTextures()
				S:HandleCheckBox(_G[checkboxName..'Check'])

				checkbox.IsSkinned = true
			end
		end
	end)

	hooksecurefunc('ChatConfig_CreateTieredCheckboxes', function(frame, checkBoxTable)
		if frame.IsSkinned then return end

		local nameString = frame:GetName()..'Checkbox'
		for index, value in ipairs(checkBoxTable) do
			local checkboxName = nameString..index
			S:HandleCheckBox(_G[checkboxName])

			if value.subTypes then
				for i in ipairs(value.subTypes) do
					S:HandleCheckBox(_G[checkboxName..'_'..i])
				end
			end
		end

		frame.IsSkinned = true
	end)

	hooksecurefunc(_G.ChatConfigFrameChatTabManager, 'UpdateWidth', function(frame)
		for tab in frame.tabPool:EnumerateActive() do
			if not tab.IsSkinned then
				tab:StripTextures()

				tab.IsSkinned = true
			end

			tab:SetWidth(80)
		end
	end)

	do
		local i = 1
		local tab = _G['CombatConfigTab'..i]
		while tab do
			tab:StripTextures()

			tab:SetWidth(i <= 2 and 90 or 70)

			i = i + 1
			tab = _G['CombatConfigTab'..i]
		end
	end

	for _, frame in pairs({ -- backdrops
		_G.ChatConfigCategoryFrame,
		_G.ChatConfigBackgroundFrame,
		_G.ChatConfigCombatSettingsFilters,
		_G.CombatConfigColorsHighlighting,
		_G.CombatConfigColorsColorizeUnitName,
		_G.CombatConfigColorsColorizeSpellNames,
		_G.CombatConfigColorsColorizeDamageNumber,
		_G.CombatConfigColorsColorizeDamageSchool,
		_G.CombatConfigColorsColorizeEntireLine,
		_G.ChatConfigChatSettingsLeft,
		_G.ChatConfigOtherSettingsCombat,
		_G.ChatConfigOtherSettingsPVP,
		_G.ChatConfigOtherSettingsSystem,
		_G.ChatConfigOtherSettingsCreature,
		_G.ChatConfigChannelSettingsLeft,
		_G.CombatConfigMessageSourcesDoneBy,
		_G.CombatConfigColorsUnitColors,
		_G.CombatConfigMessageSourcesDoneTo,
		_G.ChatConfigTextToSpeechChannelSettingsLeft
	}) do
		frame:StripTextures()
	end

	_G.ChatConfigCategoryFrame:CreateBackdrop('Transparent')
	_G.ChatConfigCategoryFrame.backdrop:SetInside()

	_G.ChatConfigBackgroundFrame:CreateBackdrop('Transparent')
	_G.ChatConfigBackgroundFrame.backdrop:SetInside()

	_G.ChatConfigCombatSettingsFilters:CreateBackdrop('Transparent')
	_G.ChatConfigCombatSettingsFilters.backdrop:SetInside()

	for _, box in pairs({ -- combat boxes
		_G.CombatConfigColorsHighlightingLine,
		_G.CombatConfigColorsHighlightingAbility,
		_G.CombatConfigColorsHighlightingDamage,
		_G.CombatConfigColorsHighlightingSchool,
		_G.CombatConfigColorsColorizeUnitNameCheck,
		_G.CombatConfigColorsColorizeSpellNamesCheck,
		_G.CombatConfigColorsColorizeSpellNamesSchoolColoring,
		_G.CombatConfigColorsColorizeDamageNumberCheck,
		_G.CombatConfigColorsColorizeDamageNumberSchoolColoring,
		_G.CombatConfigColorsColorizeDamageSchoolCheck,
		_G.CombatConfigColorsColorizeEntireLineCheck,
		_G.CombatConfigFormattingShowTimeStamp,
		_G.CombatConfigFormattingShowBraces,
		_G.CombatConfigFormattingUnitNames,
		_G.CombatConfigFormattingSpellNames,
		_G.CombatConfigFormattingItemNames,
		_G.CombatConfigFormattingFullText,
		_G.CombatConfigSettingsShowQuickButton,
		_G.CombatConfigSettingsSolo,
		_G.CombatConfigSettingsParty,
		_G.CombatConfigSettingsRaid
	}) do
		S:HandleCheckBox(box)
	end

	hooksecurefunc('ChatConfig_UpdateSwatches', function(frame)
		if not frame.swatchTable then return end

		local nameString = frame:GetName()..'Swatch'
		for index in ipairs(frame.swatchTable) do
			local bu = _G[nameString..index]
			if bu and not bu.backdrop then
				bu:StripTextures()
				bu:CreateBackdrop('Transparent')
				bu.backdrop:SetInside()

				bu.backdrop = true
			end
		end
	end)

	S:HandleButton(_G.CombatLogDefaultButton)
	S:HandleButton(_G.ChatConfigCombatSettingsFiltersCopyFilterButton)
	S:HandleButton(_G.ChatConfigCombatSettingsFiltersAddFilterButton)
	S:HandleButton(_G.ChatConfigCombatSettingsFiltersDeleteButton)
	S:HandleButton(_G.CombatConfigSettingsSaveButton)
	S:HandleButton(_G.ChatConfigFrameOkayButton)
	S:HandleButton(_G.ChatConfigFrameDefaultButton)
	S:HandleButton(_G.ChatConfigFrameRedockButton)
	S:HandleNextPrevButton(_G.ChatConfigMoveFilterUpButton, 'up')
	S:HandleNextPrevButton(_G.ChatConfigMoveFilterDownButton, 'down')

	_G.ChatConfigMoveFilterUpButton:SetSize(22, 22)
	_G.ChatConfigMoveFilterDownButton:SetSize(22, 22)
	_G.ChatConfigCombatSettingsFiltersAddFilterButton:Point('RIGHT', _G.ChatConfigCombatSettingsFiltersDeleteButton, 'LEFT', -1, 0)
	_G.ChatConfigCombatSettingsFiltersCopyFilterButton:Point('RIGHT', _G.ChatConfigCombatSettingsFiltersAddFilterButton, 'LEFT', -1, 0)
	_G.ChatConfigMoveFilterUpButton:Point('TOPLEFT', _G.ChatConfigCombatSettingsFilters, 'BOTTOMLEFT', 3, 0)
	_G.ChatConfigMoveFilterDownButton:Point('LEFT', _G.ChatConfigMoveFilterUpButton, 'RIGHT', 1, 0)

	S:HandleEditBox(_G.CombatConfigSettingsNameEditBox)
	S:HandleRadioButton(_G.CombatConfigColorsColorizeEntireLineBySource)
	S:HandleRadioButton(_G.CombatConfigColorsColorizeEntireLineByTarget)
	S:HandleTrimScrollBar(_G.ChatConfigCombatSettingsFilters.ScrollBar)

	-- TextToSpeech
	_G.TextToSpeechButton:StripTextures()

	S:HandleButton(_G.TextToSpeechFramePlaySampleButton)
	S:HandleButton(_G.TextToSpeechFramePlaySampleAlternateButton)
	S:HandleButton(_G.TextToSpeechDefaultButton)
	S:HandleCheckBox(_G.TextToSpeechCharacterSpecificButton)

	S:HandleDropDownBox(_G.TextToSpeechFrameTtsVoiceDropdown)
	S:HandleDropDownBox(_G.TextToSpeechFrameTtsVoiceAlternateDropdown)
	S:HandleSliderFrame(_G.TextToSpeechFrameAdjustRateSlider)
	S:HandleSliderFrame(_G.TextToSpeechFrameAdjustVolumeSlider)

	for _, checkbox in pairs({ -- check boxes
		'PlayActivitySoundWhenNotFocusedCheckButton',
		'PlaySoundSeparatingChatLinesCheckButton',
		'AddCharacterNameToSpeechCheckButton',
		'NarrateMyMessagesCheckButton',
		'UseAlternateVoiceForSystemMessagesCheckButton',
	}) do
		S:HandleCheckBox(_G.TextToSpeechFramePanelContainer[checkbox])
	end

	hooksecurefunc('TextToSpeechFrame_UpdateMessageCheckboxes', function(frame)
		if not frame.checkBoxTable then return end

		local nameString = frame:GetName()..'CheckBox'
		for index in ipairs(frame.checkBoxTable) do
			local checkBox = _G[nameString..index]
			if checkBox and not checkBox.IsSkinned then
				S:HandleCheckBox(checkBox)

				checkBox.IsSkinned = true
			end
		end
	end)
end

S:AddCallback('ChatConfig')
