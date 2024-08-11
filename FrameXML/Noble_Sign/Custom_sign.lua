--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Variables                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local CS_MaterialTable = {
[0] = "Parchment",
[1] = "Stone",
[2] = "Bronze",
[3] = "Silver",
[4] = "Marble",
[5] = "Valentine",
}

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Frames                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local CS_Frame = CreateFrame('Frame', 'CS_Frame', GossipFrame)
CS_Frame:SetWidth(340)
CS_Frame:SetHeight(374)
CS_Frame:SetPoint('CENTER', GossipFrame, 'CENTER', 335, 49)
CS_Frame:SetFrameStrata('DIALOG')
CS_Frame:EnableMouseWheel(true)
CS_Frame:EnableMouse()
CS_Frame:Hide()

CS_Frame.Texture = CS_Frame:CreateTexture("ARTWORK")
CS_Frame.Texture:SetTexture("Interface\\NobleProject\\CustomSign\\CustomSignTexture.blp")
CS_Frame.Texture:SetPoint("CENTER",85,-85)
CS_Frame.Texture:SetSize(535, 535)

CS_Frame.EditBox = CreateFrame('EditBox', 'CS_Frame.EditBox', CS_Frame)
CS_Frame.EditBox:SetMultiLine(true)
CS_Frame.EditBox:SetAutoFocus(true)
CS_Frame.EditBox:EnableMouse(true)
CS_Frame.EditBox:SetMaxLetters(1000)
CS_Frame.EditBox:SetFont("Fonts\\MORPHEUS.ttf", 16)
CS_Frame.EditBox:SetTextColor(0, 0, 0, 0.85);
CS_Frame.EditBox:SetWidth(260)
CS_Frame.EditBox:SetHeight(300)
CS_Frame.EditBox:EnableMouseWheel(true)

CS_Frame.EditBox:SetScript('OnTextChanged', function(self)
	ScrollingEdit_OnTextChanged(self, self:GetParent());
end)

CS_Frame.EditBox:SetScript('OnCursorChanged', function(self, x, y, w, h)
	ScrollingEdit_OnCursorChanged(self, x, y, w, h);
end)

CS_Frame.EditBox:SetScript('OnUpdate', function(self, elapsed)
	ScrollingEdit_OnUpdate(self, elapsed, self:GetParent());
end)

CS_Frame.EditBox:SetScript('OnEscapePressed', function(self)
	self:ClearFocus();
	StaticPopup1:Hide()
end)

CS_Frame.ScrollFrame = CreateFrame('ScrollFrame', 'CS_ScrollFrame', CS_Frame, 'UIPanelScrollFrameTemplate')
CS_Frame.ScrollFrame:SetPoint('TOPLEFT', CS_Frame, 'TOPLEFT', 25, -60)
CS_Frame.ScrollFrame:SetPoint('BOTTOMRIGHT', CS_Frame, 'BOTTOMRIGHT', -50, 25)
CS_Frame.ScrollFrame:EnableMouseWheel(true)
CS_Frame.ScrollFrame:SetScrollChild(CS_Frame.EditBox)

CS_ScrollFrameScrollBar:HookScript("OnShow", function()
CS_ScrollFrameScrollBar:Hide()
end)

CS_Frame.ButtonOk = CreateFrame("Button", "CS_Frame.ButtonOk", CS_Frame, "UIPanelButtonTemplate")
CS_Frame.ButtonOk:SetPoint("BOTTOMLEFT", CS_Frame, "BOTTOM", 37, -21)
CS_Frame.ButtonOk:SetHeight(20)
CS_Frame.ButtonOk:SetWidth(100)
CS_Frame.ButtonOk:SetText("Установить")
CS_Frame.ButtonOk:SetScript("OnClick", function()
        StaticPopup1EditBox:SetText(CS_Frame.EditBox:GetText())
        StaticPopup1Button1:Click()
end)

CS_Frame.Close = CreateFrame("Button", "CS_Frame.Close", CS_Frame, "UIPanelCloseButton")
CS_Frame.Close:SetPoint("TOP", 127.5, -12.5)
CS_Frame.Close:SetSize(32, 32)
CS_Frame.Close:SetScript("OnClick", function()
CS_Frame:Hide()
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Functions                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function CS_Frame:HideEditPanel()
            ---
    StaticPopup1:ClearAllPoints();
    StaticPopup1:SetPoint("CENTER", UIParent, "TOP", -4000, -4000)
            ---
    CS_Frame:Show()
    StaticPopup1EditBox:ClearFocus()
end

function CS_Frame:ShowEditPanel()
    CS_Frame:Hide()
    CS_Frame.EditBox:SetText("")
    PlaySound("igCharacterInfoClose");
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Hooks                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
StaticPopup1:HookScript("OnShow", function()
    if GossipTitleButton5:GetText() == "Изменить фон" and GossipTitleButton5:IsVisible() then
      if string.find(StaticPopup1Text:GetText(),"введите код") then
          CS_Frame:HideEditPanel()
      end
    end
end)

StaticPopup1:HookScript("OnHide", function()
    if GossipTitleButton5:GetText() == "Изменить фон" then
        CS_Frame:ShowEditPanel()
    end
end)


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                         Event Handler                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local function GetCustomSignText(self, prefix, text, channel, sender)
if prefix == "CUSTOMSIGN_GET_TEXT" and sender == GetUnitName("player") then
local CS_v1, CS_v2 = strsplit("#", text, 2)
local material = CS_MaterialTable[tonumber(CS_v1)]
local textColor = GetMaterialTextColors(material);
ItemTextPageText:SetTextColor(textColor[1], textColor[2], textColor[3]);
ItemTextTitleText:SetText("Табличка");
ItemTextPageText:SetText(CS_v2)
--
ShowUIPanel(ItemTextFrame)
ItemTextCurrentPage:Hide();
ItemTextNextPageButton:Hide()
ItemTextPrevPageButton:Hide()
ItemTextScrollFrameScrollBar:Show()
ItemTextScrollFrameScrollBar:SetValue(0);
        if ( material == "Parchment" ) then
			ItemTextMaterialTopLeft:Hide();
			ItemTextMaterialTopRight:Hide();
			ItemTextMaterialBotLeft:Hide();
			ItemTextMaterialBotRight:Hide();
		else
			ItemTextMaterialTopLeft:Show();
			ItemTextMaterialTopRight:Show();
			ItemTextMaterialBotLeft:Show();
			ItemTextMaterialBotRight:Show();
			ItemTextMaterialTopLeft:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopLeft");
			ItemTextMaterialTopRight:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopRight");
			ItemTextMaterialBotLeft:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotLeft");
			ItemTextMaterialBotRight:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotRight");
		end
end
end
RegisterEvent("CHAT_MSG_ADDON", GetCustomSignText, self, prefix, text, channel, sender)