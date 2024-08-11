--[[Фреймы поиска.]]
local Transmog_SearchFrame = CreateFrame("EditBox","TransmogFrameSearchFrame",Transmog_MainPanel,"InputBoxTemplate")
Transmog_SearchFrame:SetFrameStrata("MEDIUM")
Transmog_SearchFrame:SetAutoFocus(false)
Transmog_SearchFrame:SetSize(130, 30)
Transmog_SearchFrame:SetPoint("TOP",205,-38)
Transmog_SearchFrame:SetText("")
Transmog_SearchFrame:SetScript("OnEnterPressed", function(self)
	Transmog_SearchKey = Transmog_SearchFrame:GetText()
	Transmog_SearchFrame:ClearFocus()
end)
Transmog_SearchFrame:SetScript("OnTextChanged", function(self)
Transmog_SearchKey = Transmog_SearchFrame:GetText()
    if Transmog_SearchKey == "" then
        Transmog_SearchFrame.ItemSearchButtonClear:Hide()
    else
        Transmog_SearchFrame.ItemSearchButtonClear:Show()
    end
    Transmog_DataRefreshAll()
end)

Transmog_SearchFrame:SetScript("OnMouseDown", function(self)
    Transmog_SearchFrame.ItemSearchButtonIcon:Hide()
end)

Transmog_SearchFrame:SetScript("OnEditFocusGained", function(self)
    if Transmog_SearchKey == "" then
    Transmog_SearchFrame.ItemSearchButtonIcon:Hide()
    end
end)

Transmog_SearchFrame:SetScript("OnEditFocusLost", function(self)
    if Transmog_SearchKey == "" then
        Transmog_SearchFrame.ItemSearchButtonIcon:Show()
    end
end)

Transmog_SearchFrame.ItemSearchButtonIcon = CreateFrame("BUTTON", "VendorItemSearchButtonIcon", Transmog_SearchFrame, "SecureHandlerClickTemplate");
Transmog_SearchFrame.ItemSearchButtonIcon:Show()
Transmog_SearchFrame.ItemSearchButtonIcon:SetAlpha(0.5);
Transmog_SearchFrame.ItemSearchButtonIcon:SetSize(15,15)
Transmog_SearchFrame.ItemSearchButtonIcon:SetPoint("CENTER", Transmog_SearchFrame, -58, -2)
Transmog_SearchFrame.ItemSearchButtonIcon:SetNormalTexture("Interface\\NobleProject\\searchbox-icon.blp")

local Transmog_SearchTitle = Transmog_SearchFrame.ItemSearchButtonIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Transmog_SearchTitle:SetPoint("CENTER", Transmog_SearchFrame.ItemSearchButtonIcon, "CENTER", 63, 2)
Transmog_SearchTitle:SetText("Введите название")
----------///
Transmog_SearchFrame.ItemSearchButtonClear = CreateFrame("BUTTON", "VendorItemSearchButtonClear", Transmog_SearchFrame, "SecureHandlerClickTemplate");
Transmog_SearchFrame.ItemSearchButtonClear:Hide()
Transmog_SearchFrame.ItemSearchButtonClear:SetAlpha(0.6);
Transmog_SearchFrame.ItemSearchButtonClear:SetSize(12,12)
Transmog_SearchFrame.ItemSearchButtonClear:SetPoint("CENTER", Transmog_SearchFrame, 55, 0)
Transmog_SearchFrame.ItemSearchButtonClear:RegisterForClicks("AnyUp")
Transmog_SearchFrame.ItemSearchButtonClear:SetNormalTexture("Interface\\NobleProject\\searchbox-close.blp")
Transmog_SearchFrame.ItemSearchButtonClear:SetHighlightTexture("Interface\\NobleProject\\searchbox-close.blp")
Transmog_SearchFrame.ItemSearchButtonClear:SetScript("OnClick", function()
    Transmog_SearchFrame.ItemSearchButtonIcon:Show()
    Transmog_SearchFrame:SetText("")
    Transmog_SearchFrame:ClearFocus()
end)
-----------------------
function Transmog_FindClose()
    if Transmog_CodeListFrame:IsVisible() then
        Transmog_SearchFrame:Hide()
    else
        Transmog_SearchFrame:Show()
    end
end