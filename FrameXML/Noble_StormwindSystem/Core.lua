
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  MainFrame                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local ChosenSocialClass = 0
StromwindSystem = CreateFrame("Frame", "StromwindSystem", UIParent)

local frame = StromwindSystem
frame:Hide()
frame:SetWidth(900)
frame:SetHeight(512)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
frame:EnableMouse()
frame:SetFrameStrata("HIGH")
frame:SetToplevel(true)


frame.TextureLeft = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
frame.TextureLeft:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\1.tga")
frame.TextureLeft:SetPoint("CENTER",-176,0)
frame.TextureLeft:SetSize(512, 512)

frame.TextureRight = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
frame.TextureRight:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\2.tga")
frame.TextureRight:SetPoint("CENTER",336,0)
frame.TextureRight:SetSize(512, 512)

frame.Ribbon = frame:CreateTexture(nil, "ARTWORK", nil, 1)
frame.Ribbon:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\23.blp")
frame.Ribbon:SetTexCoord(0,0.854,0,0.724)
frame.Ribbon:SetPoint("CENTER",0,145)
frame.Ribbon:SetSize(551.25, 58.59)

frame.Ribbon.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.Ribbon.Text:SetPoint("CENTER",0,145)
frame.Ribbon.Text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
frame.Ribbon.Text:SetText("Выбор социального класса")
frame.Ribbon.Text:SetAlpha(0.70)

frame.ButtonEsc = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.ButtonEsc:SetPoint("TOP", frame, "TOPRIGHT", -28, -55)
frame.ButtonEsc:SetSize(27, 27)
frame.ButtonEsc:SetScript("OnClick", function()
	frame:Hide()
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  Frame1                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
frame.Frame1 = CreateFrame("BUTTON", nil, frame, "StormTemplate1");
frame.Frame1:SetPoint("CENTER", frame, "CENTER", -305, -70);
frame.Frame1.Header:SetText("Духовенство")

frame.Frame1.Texture = frame.Frame1:CreateTexture(nil, "ARTWORK", nil, 1)
frame.Frame1.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\answer-chromiescenario-chromie-small")
frame.Frame1.Texture:SetPoint("CENTER",0,90)
frame.Frame1.Texture:SetSize(179.2, 89.6)

frame.Frame1.Text = frame.Frame1:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
frame.Frame1.Text:SetPoint("CENTER",0,-40)
frame.Frame1.Text:SetSize(150, 170)
frame.Frame1.Text:SetJustifyV("TOP");
frame.Frame1.Text:SetTextColor(0.13, 0.07, 0.01, 1)
frame.Frame1.Text:SetText("")
frame.Frame1.Text:SetAlpha(1)

frame.Frame1.Choose = CreateFrame("Button", "frame.Frame1.Choose", frame.Frame1, "UIPanelButtonTemplate")
frame.Frame1.Choose:SetPoint("CENTER", frame.Frame1, "CENTER", 0, -135)
frame.Frame1.Choose:SetSize(100,20)
frame.Frame1.Choose:SetText("Выбрать")
frame.Frame1.Choose:SetScript("OnClick", function(self)
    ChosenSocialClass = 1
	frame.WarningFrame:Show()
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  Frame2                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
frame.Frame2 = CreateFrame("BUTTON", nil, frame.Frame1, "StormTemplate1");
frame.Frame2:SetPoint("CENTER", frame.Frame1, "CENTER", 205, 0);
frame.Frame2.Header:SetText("Магократия")

frame.Frame2.Texture = frame.Frame2:CreateTexture(nil, "ARTWORK", nil, 1)
frame.Frame2.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\answer-chromiescenario-chromie-small")
frame.Frame2.Texture:SetPoint("CENTER",0,90)
frame.Frame2.Texture:SetSize(179.2, 89.6)

frame.Frame2.Text = frame.Frame2:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
frame.Frame2.Text:SetPoint("CENTER",0,-40)
frame.Frame2.Text:SetSize(150, 170)
frame.Frame2.Text:SetJustifyV("TOP");
frame.Frame2.Text:SetTextColor(0.13, 0.07, 0.01, 1)
frame.Frame2.Text:SetText("")
frame.Frame2.Text:SetAlpha(1)

frame.Frame2.Choose = CreateFrame("Button", "frame.Frame2.Choose", frame.Frame2, "UIPanelButtonTemplate")
frame.Frame2.Choose:SetPoint("CENTER", frame.Frame2, "CENTER", 0, -135)
frame.Frame2.Choose:SetSize(100,20)
frame.Frame2.Choose:SetText("Выбрать")
frame.Frame2.Choose:SetScript("OnClick", function(self)
    ChosenSocialClass = 2
	frame.WarningFrame:Show()
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  Frame3                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
frame.Frame3 = CreateFrame("BUTTON", nil, frame.Frame2, "StormTemplate1");
frame.Frame3:SetPoint("CENTER", frame.Frame2, "CENTER", 205, 0);
frame.Frame3.Header:SetText("Мещанин")

frame.Frame3.Texture = frame.Frame3:CreateTexture(nil, "ARTWORK", nil, 1)
frame.Frame3.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\answer-chromiescenario-chromie-small")
frame.Frame3.Texture:SetPoint("CENTER",0,90)
frame.Frame3.Texture:SetSize(179.2, 89.6)

frame.Frame3.Text = frame.Frame3:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
frame.Frame3.Text:SetPoint("CENTER",0,-40)
frame.Frame3.Text:SetSize(150, 170)
frame.Frame3.Text:SetJustifyV("TOP");
frame.Frame3.Text:SetTextColor(0.13, 0.07, 0.01, 1)
frame.Frame3.Text:SetText("")
frame.Frame3.Text:SetAlpha(1)

frame.Frame3.Choose = CreateFrame("Button", "frame.Frame3.Choose", frame.Frame3, "UIPanelButtonTemplate")
frame.Frame3.Choose:SetPoint("CENTER", frame.Frame3, "CENTER", 0, -135)
frame.Frame3.Choose:SetSize(100,20)
frame.Frame3.Choose:SetText("Выбрать")
frame.Frame3.Choose:SetScript("OnClick", function(self)
    ChosenSocialClass = 3
	frame.WarningFrame:Show()
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  Frame3                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
frame.Frame4 = CreateFrame("BUTTON", nil, frame.Frame3, "StormTemplate1");
frame.Frame4:SetPoint("CENTER", frame.Frame3, "CENTER", 205, 0);
frame.Frame4.Header:SetText("Мещанин")

frame.Frame4.Texture = frame.Frame4:CreateTexture(nil, "ARTWORK", nil, 1)
frame.Frame4.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\answer-chromiescenario-chromie-small")
frame.Frame4.Texture:SetPoint("CENTER",0,90)
frame.Frame4.Texture:SetSize(179.2, 89.6)

frame.Frame4.Text = frame.Frame4:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
frame.Frame4.Text:SetPoint("CENTER",0,-40)
frame.Frame4.Text:SetSize(150, 170)
frame.Frame4.Text:SetJustifyV("TOP");
frame.Frame4.Text:SetTextColor(0.13, 0.07, 0.01, 1)
frame.Frame4.Text:SetText("")
frame.Frame4.Text:SetAlpha(1)

frame.Frame4.Choose = CreateFrame("Button", "frame.Frame3.Choose", frame.Frame4, "UIPanelButtonTemplate")
frame.Frame4.Choose:SetPoint("CENTER", frame.Frame4, "CENTER", 0, -135)
frame.Frame4.Choose:SetSize(100,20)
frame.Frame4.Choose:SetText("Выбрать")
frame.Frame4.Choose:SetScript("OnClick", function(self)
    ChosenSocialClass = 4
	frame.WarningFrame:Show()
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                    Info                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


local StromwindSystemClassTable = {
[1] = {
"Дворянин",
"Представители древних родов, что привыкли жить в роскоши. О вас наверняка слышал едва ли не каждый, кто приближен ко двору. \n\n|cff065b1cБонусы:|r дает право занимать придворные должности, обладает дворянскими привилегиями. \n\n|cffff0027Ограничения:|r не может владеть лавкой.",
"dvor",
function() Strom_SelectClass(1) end,
},
[2] = {
"Духовенство",
"Адепты Святого Света изо дня в день трудятся, чтобы помогать жителям королевства во всех бедах и невзгодах.\n\n|cff065b1cБонусы:|r дает право занимать должности при соборе и некоторые придворные должности.\n\n|cffff0027Ограничения:|r не может владеть лавкой, запрет на мещанские должности.",
"priest",
function() Strom_SelectClass(2) end,
},
[3] = {
"Магократия",
"После того, как Даларан скрылся за куполом, именно в Штормграде осталась самая сильная магическая община.\n\n\n|cff065b1cБонусы:|r дает право занимать должности в Башне Магов и некоторые придворные должности, можно владеть лавкой.\n\n|cffff0027Ограничения:|r запрет на мещанские должности.",
"mage",
function() Strom_SelectClass(3) end,
},
[4] = {
"Вольный житель",
"Вы странник, ремесленник или торговец? А может, вы уже шагнули в 'тень'? Вы вольны в своих действиях!\n\n|cff065b1cБонусы:|r может занимать любые городские должности, может владеть лавкой, полная свобода в отыгрыше Теней Штормграда.\n\n|cffff0027Ограничения:|r не имеет права занимать придворные должности, должности в башне магов и должности при соборе.",
"workman",
function() Strom_SelectClass(4) end,
},
}



local RotationTable = {
{1, 2, 3, 4},
}
local function ReturnNextInd(num, ind)
	if num <= 0 then
		return RotationTable[1][ind]
	elseif num > 4 then
		return RotationTable[4][ind]
	else
		return RotationTable[num][ind]
	end
end

function SetUpStormwindSocialClasses(PageNum)
frame.Frame1.Header:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 1)][1])
frame.Frame1.Text:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 1)][2])
frame.Frame1.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\" .. StromwindSystemClassTable[ReturnNextInd(PageNum, 1)][3])


frame.Frame2.Header:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 2)][1])
frame.Frame2.Text:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 2)][2])
frame.Frame2.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\" .. StromwindSystemClassTable[ReturnNextInd(PageNum, 2)][3])

frame.Frame3.Header:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 3)][1])
frame.Frame3.Text:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 3)][2])
frame.Frame3.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\" .. StromwindSystemClassTable[ReturnNextInd(PageNum, 3)][3])

frame.Frame4.Header:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 4)][1])
frame.Frame4.Text:SetText(StromwindSystemClassTable[ReturnNextInd(PageNum, 4)][2])
frame.Frame4.Texture:SetTexture("Interface\\FrameXML\\Noble_StormwindSystem\\" .. StromwindSystemClassTable[ReturnNextInd(PageNum, 4)][3])
end
SetUpStormwindSocialClasses(1)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                               WarningFrame                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

frame.WarningFrame = CreateFrame("Frame", "frame.WarningFrame", UIParent)
frame.WarningFrame:Hide()
frame.WarningFrame:SetWidth(290)
frame.WarningFrame:SetHeight(140)
frame.WarningFrame:SetPoint("CENTER", UIParent, "CENTER")
frame.WarningFrame:EnableMouse()
frame.WarningFrame:SetFrameStrata("FULLSCREEN_DIALOG")
frame.WarningFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
frame.WarningFrame:SetBackdropColor(0, 0, 0, 1)

frame.WarningFrame.Title = frame.WarningFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
frame.WarningFrame.Title:SetPoint("CENTER", frame.WarningFrame, "TOP", 0, -50)
frame.WarningFrame.Title:SetText("Вы уверены, что хотите выбрать\nсоциальный класс? Это будет\nокончательным решением.")

frame.WarningFrame.ButtonOK = CreateFrame("Button", nil, frame.WarningFrame, "UIPanelButtonTemplate")
frame.WarningFrame.ButtonOK:SetPoint("BOTTOM", frame.WarningFrame, "BOTTOM", -70, 13)
frame.WarningFrame.ButtonOK:SetSize(100, 25)
frame.WarningFrame.ButtonOK:SetText("Выбрать")
frame.WarningFrame.ButtonOK:SetScript("OnClick", function()
    if ChosenSocialClass > 0 then
		StromwindSystemClassTable[tonumber(ChosenSocialClass)][4]()
		frame.WarningFrame:Hide()
	end
	frame:Hide()
end)

frame.WarningFrame.ButtonEsc = CreateFrame("Button", nil, frame.WarningFrame, "UIPanelButtonTemplate")
frame.WarningFrame.ButtonEsc:SetPoint("BOTTOM", frame.WarningFrame, "BOTTOM", 70, 13)
frame.WarningFrame.ButtonEsc:SetSize(100, 25)
frame.WarningFrame.ButtonEsc:SetText("Отмена")
frame.WarningFrame.ButtonEsc:SetScript("OnClick", function()
    ChosenSocialClass = 0
	frame.WarningFrame:Hide()
end)

frame.WarningFrame.ButtonEsc = CreateFrame("Button", nil, frame.WarningFrame, "UIPanelCloseButton")
frame.WarningFrame.ButtonEsc:SetPoint("TOP", frame.WarningFrame, "TOPRIGHT", -20, -5)
frame.WarningFrame.ButtonEsc:SetSize(30, 30)
frame.WarningFrame.ButtonEsc:SetScript("OnClick", function()
    ChosenSocialClass = 0
	frame.WarningFrame:Hide()
end)