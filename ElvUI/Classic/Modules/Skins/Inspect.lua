local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local next, unpack = next, unpack
local hooksecurefunc = hooksecurefunc

local GetInventoryItemQuality = GetInventoryItemQuality

local function Update_InspectPaperDollItemSlotButton(button)
	local unit = button.hasItem and _G.InspectFrame.unit
	local quality = unit and GetInventoryItemQuality(unit, button:GetID())
	local r, g, b = E:GetItemQualityColor(quality and quality > 1 and quality)
	button.backdrop:SetBackdropBorderColor(r, g, b)
end

function S:Blizzard_InspectUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.inspect) then return end

	local InspectFrame = _G.InspectFrame
	S:HandleFrame(InspectFrame, true, nil, 11, -12, -32, 76)

	S:HandleCloseButton(_G.InspectFrameCloseButton, InspectFrame.backdrop)

	for i = 1, #_G.INSPECTFRAME_SUBFRAMES do
		S:HandleTab(_G['InspectFrameTab'..i])
	end

	-- Reposition Tabs
	_G.InspectFrameTab1:ClearAllPoints()
	_G.InspectFrameTab1:Point('TOPLEFT', _G.InspectFrame, 'BOTTOMLEFT', 1, 76)
	_G.InspectFrameTab2:Point('TOPLEFT', _G.InspectFrameTab1, 'TOPRIGHT', -19, 0)

	_G.InspectPaperDollFrame:StripTextures()

	for _, slot in next, { _G.InspectPaperDollItemsFrame:GetChildren() } do
		local icon = _G[slot:GetName()..'IconTexture']
		local cooldown = _G[slot:GetName()..'Cooldown']

		slot:StripTextures()
		slot:CreateBackdrop()
		slot.backdrop:SetAllPoints()
		slot:OffsetFrameLevel(2)
		slot:StyleButton()

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		if cooldown then
			E:RegisterCooldown(cooldown)
		end
	end

	hooksecurefunc('InspectPaperDollItemSlotButton_Update', Update_InspectPaperDollItemSlotButton)

	S:HandleRotateButton(_G.InspectModelFrameRotateLeftButton)
	_G.InspectModelFrameRotateLeftButton:Point('TOPLEFT', 3, -3)

	S:HandleRotateButton(_G.InspectModelFrameRotateRightButton)
	_G.InspectModelFrameRotateRightButton:Point('TOPLEFT', _G.InspectModelFrameRotateLeftButton, 'TOPRIGHT', 3, 0)

	-- Honor Frame
	local InspectHonorFrame = _G.InspectHonorFrame
	S:HandleFrame(InspectHonorFrame, true, nil, 18, -105, -39, 83)
	InspectHonorFrame.backdrop:OffsetFrameLevel(nil, InspectHonorFrame)

	_G.InspectHonorFrameProgressButton:CreateBackdrop('Transparent')

	local InspectHonorFrameProgressBar = _G.InspectHonorFrameProgressBar
	InspectHonorFrameProgressBar:Width(325)
	InspectHonorFrameProgressBar:SetStatusBarTexture(E.media.normTex)

	InspectHonorFrameProgressBar:PointXY(19, -74)

	E:RegisterStatusBar(InspectHonorFrameProgressBar)
end

S:AddCallbackForAddon('Blizzard_InspectUI')
