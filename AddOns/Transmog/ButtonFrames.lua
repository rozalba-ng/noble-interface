


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Scripts                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


local function Transmog_GameTooltipOnEnter(self)
    GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
    GameTooltip:SetText (self.TransmogTooltip_text, nil, nil, nil, nil, true)
    GameTooltip:Show()
end
local function Transmog_GameTooltipOnLeave(self)
    GameTooltip:Hide()
end


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Frames                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
----------------------------------------------------------------------------------------------------------------
--[[Переключение вкладок от стандартных к сохраненным пресетам(сумки).]]
 local Transmog_SaveOutfits = CreateFrame("BUTTON", "Transmog_SaveOutfits", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_SaveOutfits:SetSize(154, 42)
 Transmog_SaveOutfits:SetAlpha(0.75)
 Transmog_SaveOutfits:SetFrameStrata("MEDIUM")
 Transmog_SaveOutfits:SetFrameLevel(2)
 Transmog_SaveOutfits:SetPoint("CENTER", Transmog_MainPanel, "CENTER", 80, 142)
 Transmog_SaveOutfits:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\button4.tga")
 Transmog_SaveOutfits:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\ButtonH.tga")
 Transmog_SaveOutfits:RegisterForClicks("AnyUp")
 Transmog_SaveOutfits:SetScript("OnClick", function(self, button)
    TransmogElunaSave = false
    Transmog_buttonBlock:Play()
    PlaySound("gsTitleOptionOK");
	CallIds()
end)

local Transmog_SaveOutfits_text = Transmog_SaveOutfits:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Transmog_SaveOutfits_text:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 0, 0)
Transmog_SaveOutfits_text:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Transmog_SaveOutfits_text:SetText("Отобразить код")
Transmog_SaveOutfits_text:SetAlpha(0.9)

 local Transmog_CodeOutfit = CreateFrame("BUTTON", "Transmog_CodeOutfit", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_CodeOutfit:SetSize(154, 42)
 Transmog_CodeOutfit:SetAlpha(0.75)
 Transmog_CodeOutfit:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 0, 40)
 Transmog_CodeOutfit:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\button4.tga")
 Transmog_CodeOutfit:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\ButtonH.tga")
 Transmog_CodeOutfit:RegisterForClicks("AnyUp")
 Transmog_CodeOutfit:SetScript("OnClick", function(self, button)
    PlaySound("gsTitleOptionOK");
    Transmog_NameIconEdit = false
    Transmog_MacroPopupFrame:Show()
end)

local Transmog_CodeOutfit_text = Transmog_CodeOutfit:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Transmog_CodeOutfit_text:SetPoint("CENTER", Transmog_CodeOutfit, "CENTER", 0, 0)
Transmog_CodeOutfit_text:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Transmog_CodeOutfit_text:SetText("Сохранить облик")
Transmog_CodeOutfit_text:SetAlpha(0.9)

 local Transmog_OutfitsMiniButton = CreateFrame("BUTTON", "Transmog_OutfitsMiniButton", Transmog_MainPanel, "TransmogSelectTabButtonTemplate");
 Transmog_OutfitsMiniButton:SetAlpha(0.75)
 Transmog_OutfitsMiniButton:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 110, 40)
 Transmog_OutfitsMiniButton:SetNormalTexture("Interface\\Icons\\INV_Chest_Cloth_21")
 Transmog_OutfitsMiniButton:SetHighlightTexture("Interface\\Icons\\INV_Chest_Cloth_21")
 Transmog_OutfitsMiniButton:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_OutfitsMiniButton:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_OutfitsMiniButton.TransmogTooltip_text = "Облики"
 Transmog_OutfitsMiniButton:SetScript("OnClick", function(self, button)
 PlaySound("gsTitleOptionOK");
 SelectTab_MiniFaux = 0
 Transmog_SelectFunc()
 Transmog_ButtonGoldenFrameChange()
end)

 local Transmog_BagMiniButton = CreateFrame("BUTTON", "Transmog_BagMiniButton", Transmog_MainPanel, "TransmogSelectTabButtonTemplate");
 Transmog_BagMiniButton:SetAlpha(0.75)
 Transmog_BagMiniButton:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 155, 40)
 Transmog_BagMiniButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Bag_19")
 Transmog_BagMiniButton:SetHighlightTexture("Interface\\Icons\\INV_Misc_Bag_19")
 Transmog_BagMiniButton:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_BagMiniButton:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_BagMiniButton.TransmogTooltip_text = "Сумки\nАксессуары"
 Transmog_BagMiniButton:SetScript("OnClick", function(self, button)
 PlaySound("gsTitleOptionOK");
 SelectTab_MiniFaux = 1
 Transmog_SelectFunc()
 Transmog_ButtonGoldenFrameChange()
end)



 local Transmog_BeltsMiniButton = CreateFrame("BUTTON", "Transmog_BeltsMiniButton", Transmog_MainPanel, "TransmogSelectTabButtonTemplate");
 Transmog_BeltsMiniButton:SetAlpha(0.75)
 Transmog_BeltsMiniButton:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 110, 0)
 Transmog_BeltsMiniButton:SetNormalTexture("Interface\\Icons\\inv_belt_09")
 Transmog_BeltsMiniButton:SetHighlightTexture("Interface\\Icons\\inv_belt_09")
 Transmog_BeltsMiniButton:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_BeltsMiniButton:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_BeltsMiniButton.TransmogTooltip_text = "Ремни"
 Transmog_BeltsMiniButton:SetScript("OnClick", function(self, button)
 PlaySound("gsTitleOptionOK");
 SelectTab_MiniFaux = 2
 Transmog_SelectFunc()
 Transmog_ButtonGoldenFrameChange()
end)

 local Transmog_EnchantsMiniButton = CreateFrame("BUTTON", "Transmog_EnchantsMiniButton", Transmog_MainPanel, "TransmogSelectTabButtonTemplate");
 Transmog_EnchantsMiniButton:SetAlpha(0.75)
 Transmog_EnchantsMiniButton:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", 155, 0)
 Transmog_EnchantsMiniButton:SetNormalTexture("Interface\\Icons\\inv_enchant_essencenetherlarge")
 Transmog_EnchantsMiniButton:SetHighlightTexture("Interface\\Icons\\inv_enchant_essencenetherlarge")
 Transmog_EnchantsMiniButton:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_EnchantsMiniButton:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_EnchantsMiniButton.TransmogTooltip_text = "Зачарования оружия"
 Transmog_EnchantsMiniButton:SetScript("OnClick", function(self, button)
        PlaySound("gsTitleOptionOK");
        SelectTab_MiniFaux = 3
        Transmog_SelectFunc()
        Transmog_ButtonGoldenFrameChange()
end)

local Transmog_DisEnchantsButton = CreateFrame("BUTTON", "Transmog_DisEnchantsButton", Transmog_MainPanel, "TransmogSelectTabButtonTemplate");
 Transmog_DisEnchantsButton:SetAlpha(0.75)
 Transmog_DisEnchantsButton:SetPoint("CENTER", Transmog_SaveOutfits, "CENTER", -130, -332)
 Transmog_DisEnchantsButton:SetNormalTexture("Interface\\Icons\\inv_enchant_disenchant")
 Transmog_DisEnchantsButton:SetHighlightTexture("Interface\\Icons\\inv_enchant_disenchant")
 Transmog_DisEnchantsButton:SetScript("OnClick", function(self, button)

end)
 Transmog_DisEnchantsButton:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine("Снять зачарование с оружия")
    GameTooltip:Show()
end)
 Transmog_DisEnchantsButton:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)

Transmog_DisEnchantsButton:SetScript("OnClick", function()
	ToggleDropDownMenu(1, nil, Transmog_DisEnchantsDropDownMenu, 'cursor', 0, 0)
end)


 Transmog_GoldenFrameSelect = CreateFrame("BUTTON", "Transmog_SelectFrame1", Transmog_OutfitsMiniButton, "GoldenFrameSelectTabTemplate"); --// Обводка табов.
 Transmog_GoldenFrameSelect:SetFrameLevel(3) 
 
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Scripts                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function Transmog_ToggleTabButtons(state)
    if state == 1 then
        Transmog_SaveOutfits:Show()
        Transmog_CodeOutfit:Show()
        Transmog_OutfitsMiniButton:Show()
        Transmog_BagMiniButton:Show()
        Transmog_BeltsMiniButton:Show()
		Transmog_HeightButton:Show()
		Transmog_EnchantsMiniButton:Show()
    else
        Transmog_SaveOutfits:Hide()
        Transmog_CodeOutfit:Hide()
        Transmog_OutfitsMiniButton:Hide()
        Transmog_BagMiniButton:Hide()
        Transmog_BeltsMiniButton:Hide()
		Transmog_EnchantsMiniButton:Hide()
		HeightDeclineEdit:Hide()
		HeightApplyEdit:Hide()
		Transmog_HeightInfo:Hide()
		Transmog_HeightSlider:Hide()
		Transmog_HeightButton:Hide()
    end
end

function Transmog_ButtonGoldenFrameChange()
    if SelectTab_MiniFaux == 1 then
        Transmog_GoldenFrameSelect:SetPoint("CENTER", Transmog_BagMiniButton, "CENTER", 0, -2.5)
    elseif SelectTab_MiniFaux == 2 then
        Transmog_GoldenFrameSelect:SetPoint("CENTER", Transmog_BeltsMiniButton, "CENTER", 0, -2.5)
	elseif SelectTab_MiniFaux == 3 then
        Transmog_GoldenFrameSelect:SetPoint("CENTER", Transmog_EnchantsMiniButton, "CENTER", 0, -2.5)
    elseif SelectTab_MiniFaux == 0 then
        Transmog_GoldenFrameSelect:SetPoint("CENTER", Transmog_OutfitsMiniButton, "CENTER", 0, -2.5)
    end
end