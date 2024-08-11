
--------------------------------------------------------------------------------------------------------------------------------------------
------[[ Поиск и сортировка у вендора по названию ГО]]
--------------------------------------------------------------------------------------------------------------------------------------------
local Merchant_SearchKey = ""
local Merchant_SearchFrame = CreateFrame("EditBox","MerchantFrameSearchFrame",MerchantFrame,"InputBoxTemplate")
Merchant_SearchFrame:SetFrameStrata("HIGH")
Merchant_SearchFrame:SetAutoFocus(false)
Merchant_SearchFrame:SetWidth(140)
Merchant_SearchFrame:SetHeight(30)
Merchant_SearchFrame:SetPoint("TOP",70,-40)
Merchant_SearchFrame:SetText("")
Merchant_SearchFrame:SetScript("OnEnterPressed", function(self)
	Merchant_SearchKey = Merchant_SearchFrame:GetText()
	Merchant_SearchFrame:ClearFocus()
end)
Merchant_SearchFrame:SetScript("OnTextChanged", function(self)
Merchant_SearchKey = Merchant_SearchFrame:GetText()
    if Merchant_SearchKey == "" then
        Merchant_SearchFrame.ItemSearchButtonClear:Hide()
    else
        Merchant_SearchFrame.ItemSearchButtonClear:Show()
    end
    Merchant_SearchUpdate()
end)

Merchant_SearchFrame:SetScript("OnMouseDown", function(self)
    Merchant_SearchFrame.ItemSearchButtonIcon:Hide()
end)

Merchant_SearchFrame:SetScript("OnEditFocusGained", function(self)
    if Merchant_SearchKey == "" then
    Merchant_SearchFrame.ItemSearchButtonIcon:Hide()
    end
end)

Merchant_SearchFrame:SetScript("OnEditFocusLost", function(self)
    if Merchant_SearchKey == "" then
        Merchant_SearchFrame.ItemSearchButtonIcon:Show()
    end
end)
----------///
Merchant_SearchFrame.ItemSearchButtonIcon = CreateFrame("BUTTON", "VendorItemSearchButtonIcon", Merchant_SearchFrame, "SecureHandlerClickTemplate");
Merchant_SearchFrame.ItemSearchButtonIcon:Show()
Merchant_SearchFrame.ItemSearchButtonIcon:SetAlpha(0.5);
Merchant_SearchFrame.ItemSearchButtonIcon:SetSize(15,15)
Merchant_SearchFrame.ItemSearchButtonIcon:SetPoint("CENTER", Merchant_SearchFrame, -60, -1)
Merchant_SearchFrame.ItemSearchButtonIcon:SetNormalTexture("Interface\\NobleProject\\searchbox-icon.blp")

local Merchant_SearchTitle = Merchant_SearchFrame.ItemSearchButtonIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Merchant_SearchTitle:SetPoint("CENTER", Merchant_SearchFrame.ItemSearchButtonIcon, "CENTER", 60, 2)
Merchant_SearchTitle:SetText("Введите название")
----------///
Merchant_SearchFrame.ItemSearchButtonClear = CreateFrame("BUTTON", "VendorItemSearchButtonClear", Merchant_SearchFrame, "SecureHandlerClickTemplate");
Merchant_SearchFrame.ItemSearchButtonClear:Hide()
Merchant_SearchFrame.ItemSearchButtonClear:SetAlpha(0.6);
Merchant_SearchFrame.ItemSearchButtonClear:SetSize(12,12)
Merchant_SearchFrame.ItemSearchButtonClear:SetPoint("CENTER", Merchant_SearchFrame, 59, 0)
Merchant_SearchFrame.ItemSearchButtonClear:RegisterForClicks("AnyUp")
Merchant_SearchFrame.ItemSearchButtonClear:SetNormalTexture("Interface\\NobleProject\\searchbox-close.blp")
Merchant_SearchFrame.ItemSearchButtonClear:SetHighlightTexture("Interface\\NobleProject\\searchbox-close.blp")
Merchant_SearchFrame.ItemSearchButtonClear:SetScript("OnClick", function()
    Merchant_SearchFrame.ItemSearchButtonIcon:Show()
    Merchant_SearchFrame:SetText("")
    Merchant_SearchFrame:ClearFocus()
end)
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
function Merchant_SearchUpdate()
if MerchantFrame.selectedTab == 2 then
    Merchant_SearchFrame:Hide()
    for i=1,12 do
        _G["MerchantItem" .. i]:SetAlpha(1);
    end
    return
else
    Merchant_SearchFrame:Show()
    if Merchant_SearchKey ~= "" then
    -----///
       for i=1,10 do
            _G["MerchantItem" .. i]:SetAlpha(0.25);
       end
       MerchantPageNum = MerchantFrame.page
           if MerchantPageNum == 1 then
                ModMerchPage = 1
           else
                ModMerchPage = (MerchantPageNum - 1) * 10
           end
       Merchant_SearchKey = string.gsub(tostring(strlower(Merchant_SearchKey)), "-", "", 10)
       for i=1,10 do
        if ModMerchPage == 1 then
            GOB_NameText = string.gsub(tostring(strlower(select(1, GetMerchantItemInfo(i)))), "-", "", 10)
        else
            GOB_NameText = string.gsub(tostring(strlower(select(1, GetMerchantItemInfo(i + ModMerchPage)))), "-", "", 10)
        end
           if string.find(GOB_NameText, Merchant_SearchKey) then
            _G["MerchantItem" .. i]:SetAlpha(1);
            else
            _G["MerchantItem" .. i]:SetAlpha(0.25);
           end
       end
    -----///
    else
        for i=1,10 do
        _G["MerchantItem" .. i]:SetAlpha(1);
        end
    end
end
end
hooksecurefunc("MerchantFrame_Update", Merchant_SearchUpdate);
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------