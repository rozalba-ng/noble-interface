--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                   Vars                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local TargetNameToRoll = nil

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Funcs                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function GameTooltipOnEnter(self)
        if self.Tooltip then
            GameTooltip:SetOwner(self,"ANCHOR_TOP");
            GameTooltip:AddLine(self.Tooltip);
            GameTooltip:Show();
        end
end
    local function GameTooltipOnLeave(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide(); end end

local function isNPCtarget()
  return UnitIsPlayer("target") == nil and UnitExists("target") == 1
end 
    
    
local PlayOneshotAnim = CreateFrame("Frame")
local PlayOneshotAnim_AnimationGroup = PlayOneshotAnim:CreateAnimationGroup()
local PlayOneshotAnimationAlpha = PlayOneshotAnim_AnimationGroup:CreateAnimation("Alpha")
PlayOneshotAnimationAlpha:SetDuration(0.1)
PlayOneshotAnim_AnimationGroup:SetScript("OnFinished", function(self)
    SendChatMessage(".npcplayemote " .. tonumber(DMPanelNoble.db.profile.settings.RollOneShot) ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)   
    
local function NPCRollPlusEmote()
if DMPanelNoble.db.profile.settings.RollStatic then
    if DMPanelNoble.db.profile.settings.RollStatic ~= 0 then
        SendChatMessage(".npc playemote " .. tonumber(DMPanelNoble.db.profile.settings.RollStatic) ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end

if DMPanelNoble.db.profile.settings.RollOneShot then
    if DMPanelNoble.db.profile.settings.RollOneShot ~= 0 then
        if DMPanelNoble.db.profile.settings.RollStatic == 0 then
            SendChatMessage(".npcplayemote " .. tonumber(DMPanelNoble.db.profile.settings.RollOneShot) ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        else
            PlayOneshotAnimationAlpha:Play()
        end
    end
end
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Frames                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



local MPA_BattlePanel = CreateFrame("Frame", "MPA_BattlePanel", UIParent)
MPA_BattlePanel:Hide()
MPA_BattlePanel:SetClampedToScreen(true)
MPA_BattlePanel:SetFrameStrata("DIALOG")
MPA_BattlePanel:SetSize(300, 264.25)
MPA_BattlePanel:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, 200)
MPA_BattlePanel:EnableMouse()
MPA_BattlePanel:SetMovable(true)
MPA_BattlePanel:SetScript("OnDragStart", function(self) self:StartMoving() end)
MPA_BattlePanel:SetScript("OnMouseDown", function(self) self:StartMoving() end)
MPA_BattlePanel:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
MPA_BattlePanel:RegisterForDrag("LeftButton","RightButton")

MPA_BattlePanel.Texture = MPA_BattlePanel:CreateTexture("ARTWORK")
MPA_BattlePanel.Texture:SetTexture("Interface\\AddOns\\DMPanelNoble\\IMG\\DopPanels.blp")
MPA_BattlePanel.Texture:SetAllPoints(MPA_BattlePanel)
MPA_BattlePanel.Texture:SetTexCoord(0, 0, 0, 0.553, 0.782, 0, 0.782, 0.553);


MPA_BattlePanel.CloseButton = CreateFrame("BUTTON", "MPA_BattlePanel.CloseButton", MPA_BattlePanel, "DMPanelNoble:CloseButtonTemplate");
MPA_BattlePanel.CloseButton:SetSize(23,23)
MPA_BattlePanel.CloseButton:SetAlpha(.9)
MPA_BattlePanel.CloseButton:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 130, 110)
MPA_BattlePanel.CloseButton:RegisterForClicks("AnyUp")
MPA_BattlePanel.CloseButton:SetScript("OnClick", function(self)
    MPA_BattlePanel:Hide()
end)


MPA_BattlePanel.SetHP = CreateFrame("Button", "MPA_BattlePanel.SetHP", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetHP:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -90, 104)
MPA_BattlePanel.SetHP:SetHeight(25)
MPA_BattlePanel.SetHP:SetWidth(75)
MPA_BattlePanel.SetHP:SetText("SetHP")
MPA_BattlePanel.SetHP:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetHP.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    SendChatMessage(".sethp " .. tonumber(MPA_BattlePanel.SetHP.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetHP.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetHP.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetHP.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetHP, "CENTER", 59, 0)
MPA_BattlePanel.SetHP.EditBox:SetSize(32, 16)
MPA_BattlePanel.SetHP.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetHP.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetHP.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetHP.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetHP.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetHP.EditBox:SetNumeric(true)
MPA_BattlePanel.SetHP.EditBox:SetNumber(3)
MPA_BattlePanel.SetHP.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.DamHP = CreateFrame("Button", "MPA_BattlePanel.DamHP", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.DamHP:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -90, 77)
MPA_BattlePanel.DamHP:SetHeight(25)
MPA_BattlePanel.DamHP:SetWidth(75)
MPA_BattlePanel.DamHP:SetText("DamHP")
MPA_BattlePanel.DamHP:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.DamHP.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    SendChatMessage(".damhp " .. tonumber(MPA_BattlePanel.DamHP.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.DamHP.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.DamHP.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.DamHP.EditBox:SetPoint("CENTER", MPA_BattlePanel.DamHP, "CENTER", 59, 0)
MPA_BattlePanel.DamHP.EditBox:SetSize(32, 16)
MPA_BattlePanel.DamHP.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.DamHP.EditBox:SetHistoryLines(5)
MPA_BattlePanel.DamHP.EditBox:SetAutoFocus(false)
MPA_BattlePanel.DamHP.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.DamHP.EditBox:SetMaxLetters(3)
MPA_BattlePanel.DamHP.EditBox:SetNumeric(true)
MPA_BattlePanel.DamHP.EditBox:SetNumber(1)
MPA_BattlePanel.DamHP.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.AddHP = CreateFrame("Button", "MPA_BattlePanel.AddHP", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.AddHP:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -90, 50)
MPA_BattlePanel.AddHP:SetHeight(25)
MPA_BattlePanel.AddHP:SetWidth(75)
MPA_BattlePanel.AddHP:SetText("AddHP")
MPA_BattlePanel.AddHP:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.AddHP.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    if not UnitAura("target", "Очки жизней") then
        SendChatMessage(".sethp " .. tonumber(MPA_BattlePanel.AddHP.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        SendChatMessage(".addhp " .. tonumber(MPA_BattlePanel.AddHP.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)

MPA_BattlePanel.AddHP.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.AddHP.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.AddHP.EditBox:SetPoint("CENTER", MPA_BattlePanel.AddHP, "CENTER", 59, 0)
MPA_BattlePanel.AddHP.EditBox:SetSize(32, 16)
MPA_BattlePanel.AddHP.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.AddHP.EditBox:SetHistoryLines(5)
MPA_BattlePanel.AddHP.EditBox:SetAutoFocus(false)
MPA_BattlePanel.AddHP.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.AddHP.EditBox:SetMaxLetters(3)
MPA_BattlePanel.AddHP.EditBox:SetNumeric(true)
MPA_BattlePanel.AddHP.EditBox:SetNumber(1)
MPA_BattlePanel.AddHP.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)


MPA_BattlePanel.SetWound = CreateFrame("Button", "MPA_BattlePanel.SetWound", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetWound:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -90, 22)
MPA_BattlePanel.SetWound:SetHeight(25)
MPA_BattlePanel.SetWound:SetWidth(75)
MPA_BattlePanel.SetWound:SetText("SetWound")
MPA_BattlePanel.SetWound:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetWound.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    SendChatMessage(".setwound " .. tonumber(MPA_BattlePanel.SetWound.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetWound.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetWound.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetWound.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetWound, "CENTER", 59, 0)
MPA_BattlePanel.SetWound.EditBox:SetSize(32, 16)
MPA_BattlePanel.SetWound.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetWound.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetWound.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetWound.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetWound.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetWound.EditBox:SetNumeric(true)
MPA_BattlePanel.SetWound.EditBox:SetNumber(1)
MPA_BattlePanel.SetWound.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)




MPA_BattlePanel.SetArmor = CreateFrame("Button", "MPA_BattlePanel.SetArmor", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetArmor:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 40, 104)
MPA_BattlePanel.SetArmor:SetHeight(25)
MPA_BattlePanel.SetArmor:SetWidth(75)
MPA_BattlePanel.SetArmor:SetText("SetArmor")
MPA_BattlePanel.SetArmor:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetArmor.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    SendChatMessage(".setarmor " .. tonumber(MPA_BattlePanel.SetArmor.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetArmor.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetArmor.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetArmor.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetArmor, "CENTER", 59, 0)
MPA_BattlePanel.SetArmor.EditBox:SetSize(32, 16)
MPA_BattlePanel.SetArmor.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetArmor.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetArmor.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetArmor.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetArmor.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetArmor.EditBox:SetNumeric(true)
MPA_BattlePanel.SetArmor.EditBox:SetNumber(1)
MPA_BattlePanel.SetArmor.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)


MPA_BattlePanel.RemoveArmor = CreateFrame("Button", "MPA_BattlePanel.RemoveArmor", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.RemoveArmor:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 40, 77)
MPA_BattlePanel.RemoveArmor:SetHeight(25)
MPA_BattlePanel.RemoveArmor:SetWidth(75)
MPA_BattlePanel.RemoveArmor:SetText("DamArmor")
MPA_BattlePanel.RemoveArmor:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.RemoveArmor.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    SendChatMessage(".removearmor " .. tonumber(MPA_BattlePanel.RemoveArmor.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.RemoveArmor.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.RemoveArmor.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.RemoveArmor.EditBox:SetPoint("CENTER", MPA_BattlePanel.RemoveArmor, "CENTER", 59, 0)
MPA_BattlePanel.RemoveArmor.EditBox:SetSize(32, 16)
MPA_BattlePanel.RemoveArmor.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.RemoveArmor.EditBox:SetHistoryLines(5)
MPA_BattlePanel.RemoveArmor.EditBox:SetAutoFocus(false)
MPA_BattlePanel.RemoveArmor.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.RemoveArmor.EditBox:SetMaxLetters(3)
MPA_BattlePanel.RemoveArmor.EditBox:SetNumeric(true)
MPA_BattlePanel.RemoveArmor.EditBox:SetNumber(1)
MPA_BattlePanel.RemoveArmor.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)


MPA_BattlePanel.AddArmor = CreateFrame("Button", "MPA_BattlePanel.AddArmor", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.AddArmor:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 40, 50)
MPA_BattlePanel.AddArmor:SetHeight(25)
MPA_BattlePanel.AddArmor:SetWidth(75)
MPA_BattlePanel.AddArmor:SetText("AddArmor")
MPA_BattlePanel.AddArmor:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.AddArmor.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
    if not UnitAura("target", "Очки брони") then
        SendChatMessage(".setarmor " .. tonumber(MPA_BattlePanel.AddArmor.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        SendChatMessage(".addarmor " .. tonumber(MPA_BattlePanel.AddArmor.EditBox:GetText()),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)

MPA_BattlePanel.AddArmor.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.AddArmor.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.AddArmor.EditBox:SetPoint("CENTER", MPA_BattlePanel.AddArmor, "CENTER", 59, 0)
MPA_BattlePanel.AddArmor.EditBox:SetSize(32, 16)
MPA_BattlePanel.AddArmor.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.AddArmor.EditBox:SetHistoryLines(5)
MPA_BattlePanel.AddArmor.EditBox:SetAutoFocus(false)
MPA_BattlePanel.AddArmor.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.AddArmor.EditBox:SetMaxLetters(3)
MPA_BattlePanel.AddArmor.EditBox:SetNumeric(true)
MPA_BattlePanel.AddArmor.EditBox:SetNumber(1)
MPA_BattlePanel.AddArmor.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.WakeUp = CreateFrame("Button", "MPA_BattlePanel.WakeUp", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.WakeUp:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 40, 22)
MPA_BattlePanel.WakeUp:SetHeight(25)
MPA_BattlePanel.WakeUp:SetWidth(75)
MPA_BattlePanel.WakeUp:SetText("WakeUp")
MPA_BattlePanel.WakeUp:SetScript("OnClick", function(self)
    SendChatMessage(".wakeup" ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)


-- блок с усановкой характеристик, по 3 в ряд

MPA_BattlePanel.SetStrength = CreateFrame("Button", "MPA_BattlePanel.SetStrength", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetStrength:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -100, -11)
MPA_BattlePanel.SetStrength:SetHeight(25)
MPA_BattlePanel.SetStrength:SetWidth(49)
MPA_BattlePanel.SetStrength:SetText("Сила")
MPA_BattlePanel.SetStrength:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetStrength.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
	print("|cffff9716[ДМ-аддон]: Используемая характеристика/порог NPC выставлены на " ..tonumber(MPA_BattlePanel.SetStrength.EditBox:GetText()) .. ", но мнимо они будут равны:|r");
    SendChatMessage(".npcsetstat 1 " .. tonumber(MPA_BattlePanel.SetStrength.EditBox:GetText()) *2,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetStrength.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetStrength.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetStrength.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetStrength, "CENTER", 43, 0)
MPA_BattlePanel.SetStrength.EditBox:SetSize(22, 16)
MPA_BattlePanel.SetStrength.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetStrength.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetStrength.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetStrength.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetStrength.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetStrength.EditBox:SetNumeric(true)
MPA_BattlePanel.SetStrength.EditBox:SetNumber(1)
MPA_BattlePanel.SetStrength.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.SetAgility = CreateFrame("Button", "MPA_BattlePanel.SetAgility", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetAgility:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -15, -11)
MPA_BattlePanel.SetAgility:SetHeight(25)
MPA_BattlePanel.SetAgility:SetWidth(49)
MPA_BattlePanel.SetAgility:SetText("Ловк")
MPA_BattlePanel.SetAgility:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetAgility.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
	print("|cffff9716[ДМ-аддон]: Используемая характеристика/порог NPC выставлены на " ..tonumber(MPA_BattlePanel.SetAgility.EditBox:GetText()) .. ", но мнимо они будут равны:|r");
    SendChatMessage(".npcsetstat 2 " .. tonumber(MPA_BattlePanel.SetAgility.EditBox:GetText()) *2,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetAgility.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetAgility.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetAgility.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetAgility, "CENTER", 43, 0)
MPA_BattlePanel.SetAgility.EditBox:SetSize(22, 16)
MPA_BattlePanel.SetAgility.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetAgility.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetAgility.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetAgility.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetAgility.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetAgility.EditBox:SetNumeric(true)
MPA_BattlePanel.SetAgility.EditBox:SetNumber(1)
MPA_BattlePanel.SetAgility.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.SetInta = CreateFrame("Button", "MPA_BattlePanel.SetInta", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetInta:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 65, -11)
MPA_BattlePanel.SetInta:SetHeight(25)
MPA_BattlePanel.SetInta:SetWidth(49)
MPA_BattlePanel.SetInta:SetText("Инта")
MPA_BattlePanel.SetInta:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetInta.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
	print("|cffff9716[ДМ-аддон]: Используемая характеристика/порог NPC выставлены на " ..tonumber(MPA_BattlePanel.SetInta.EditBox:GetText()) .. ", но мнимо они будут равны:|r");
    SendChatMessage(".npcsetstat 3 " .. tonumber(MPA_BattlePanel.SetInta.EditBox:GetText()) *2,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetInta.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetInta.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetInta.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetInta, "CENTER", 43, 0)
MPA_BattlePanel.SetInta.EditBox:SetSize(22, 16)
MPA_BattlePanel.SetInta.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetInta.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetInta.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetInta.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetInta.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetInta.EditBox:SetNumeric(true)
MPA_BattlePanel.SetInta.EditBox:SetNumber(1)
MPA_BattlePanel.SetInta.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.SetVersa = CreateFrame("Button", "MPA_BattlePanel.SetVersa", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetVersa:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -100, -37)
MPA_BattlePanel.SetVersa:SetHeight(25)
MPA_BattlePanel.SetVersa:SetWidth(49)
MPA_BattlePanel.SetVersa:SetText("Физ")
MPA_BattlePanel.SetVersa:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetVersa.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
	print("|cffff9716[ДМ-аддон]: Используемая характеристика/порог NPC выставлены на " ..tonumber(MPA_BattlePanel.SetVersa.EditBox:GetText()) .. ", но мнимо они будут равны:|r");
    SendChatMessage(".npcsetstat 5 " .. tonumber(MPA_BattlePanel.SetVersa.EditBox:GetText()) *2,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetVersa.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetVersa.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetVersa.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetVersa, "CENTER", 43, 0)
MPA_BattlePanel.SetVersa.EditBox:SetSize(22, 16)
MPA_BattlePanel.SetVersa.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetVersa.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetVersa.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetVersa.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetVersa.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetVersa.EditBox:SetNumeric(true)
MPA_BattlePanel.SetVersa.EditBox:SetNumber(1)
MPA_BattlePanel.SetVersa.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.SetWill = CreateFrame("Button", "MPA_BattlePanel.SetWill", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetWill:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -15, -37)
MPA_BattlePanel.SetWill:SetHeight(25)
MPA_BattlePanel.SetWill:SetWidth(49)
MPA_BattlePanel.SetWill:SetText("Воля")
MPA_BattlePanel.SetWill:SetScript("OnClick", function(self)
    if tonumber(MPA_BattlePanel.SetWill.EditBox:GetText()) == nil then print("|cffff9716[ДМ-аддон]: Необходимо ввести значение.|r") return end
	print("|cffff9716[ДМ-аддон]: Используемая характеристика/порог NPC выставлены на " ..tonumber(MPA_BattlePanel.SetWill.EditBox:GetText()) .. ", но мнимо они будут равны:|r");
    SendChatMessage(".npcsetstat 6 " .. tonumber(MPA_BattlePanel.SetWill.EditBox:GetText()) *2,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

MPA_BattlePanel.SetWill.EditBox = CreateFrame("EditBox", "MPA_BattlePanel.SetWill.EditBox", MPA_BattlePanel, "InputBoxTemplate")
MPA_BattlePanel.SetWill.EditBox:SetPoint("CENTER", MPA_BattlePanel.SetWill, "CENTER", 43, 0)
MPA_BattlePanel.SetWill.EditBox:SetSize(22, 16)
MPA_BattlePanel.SetWill.EditBox:SetAltArrowKeyMode(false)
MPA_BattlePanel.SetWill.EditBox:SetHistoryLines(5)
MPA_BattlePanel.SetWill.EditBox:SetAutoFocus(false)
MPA_BattlePanel.SetWill.EditBox:SetFontObject(GameFontHighlight)
MPA_BattlePanel.SetWill.EditBox:SetMaxLetters(3)
MPA_BattlePanel.SetWill.EditBox:SetNumeric(true)
MPA_BattlePanel.SetWill.EditBox:SetNumber(1)
MPA_BattlePanel.SetWill.EditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    self:AddHistoryLine(tonumber(self:GetText()));
end)

MPA_BattlePanel.SetAllToTarget = CreateFrame("Button", "MPA_BattlePanel.SetAllToTarget", MPA_BattlePanel, "UIPanelButtonTemplate")
MPA_BattlePanel.SetAllToTarget:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -75, -62)
MPA_BattlePanel.SetAllToTarget:SetHeight(22)
MPA_BattlePanel.SetAllToTarget:SetWidth(110)
MPA_BattlePanel.SetAllToTarget:SetText("Применить всё")
MPA_BattlePanel.SetAllToTarget:SetScript("OnClick", function(self)
    local strength = tonumber(MPA_BattlePanel.SetStrength.EditBox:GetText()) * 2; if strength == nil then strength = 0 end
    local agila = tonumber(MPA_BattlePanel.SetAgility.EditBox:GetText()) * 2; if strength == nil then strength = 0 end
    local inta = tonumber(MPA_BattlePanel.SetInta.EditBox:GetText()) * 2; if strength == nil then strength = 0 end
    local versa = tonumber(MPA_BattlePanel.SetVersa.EditBox:GetText()) * 2; if strength == nil then strength = 0 end
    local will = tonumber(MPA_BattlePanel.SetWill.EditBox:GetText()) * 2; if strength == nil then strength = 0 end
    local hpval = tonumber(MPA_BattlePanel.SetHP.EditBox:GetText()); if hpval == nil then hpval = 0 end
    local ammoval = tonumber(MPA_BattlePanel.SetArmor.EditBox:GetText()); if hpval == nil then hpval = 0 end

    SendChatMessage(".npcsetstat 1 " .. strength,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".npcsetstat 2 " .. agila,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".npcsetstat 3 " .. inta,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".npcsetstat 5 " .. versa,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".npcsetstat 6 " .. will,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".sethp " .. hpval,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    SendChatMessage(".setarmor  " .. ammoval,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------

MPA_BattlePanel.GetTargetRoll = CreateFrame("Button", "MPA_BattlePanel.GetTargetRoll", MPA_BattlePanel, "DMPanelNoble:MiniIconButtonBG")  --// First button
MPA_BattlePanel.GetTargetRoll:SetPoint("CENTER", MPA_BattlePanel, "CENTER", -120, -98)

MPA_BattlePanel.GetTargetRoll.Icon = CreateFrame("BUTTON", nil, MPA_BattlePanel.GetTargetRoll, "DMPanelNoble:MiniIconButtonTemplate");
MPA_BattlePanel.GetTargetRoll.Icon:SetNormalTexture("interface\\ICONS\\ability_hunter_markedfordeath")
MPA_BattlePanel.GetTargetRoll.Icon:SetHighlightTexture("interface\\ICONS\\ability_hunter_markedfordeath")
MPA_BattlePanel.GetTargetRoll.Icon:SetAlpha(0.8)
MPA_BattlePanel.GetTargetRoll.Icon:SetScript("OnClick", function()
    if isNPCtarget() then
        print("|cffff9716[ДМ-аддон]: Целью бросков должен быть игрок.|r")
    elseif not UnitExists("target") then
        print("|cffff9716[ДМ-аддон]: Целью бросков должен быть игрок.|r")
    else
        TargetNameToRoll = tostring(GetUnitName("target"));
        MPA_BattlePanel.GetTargetRoll.Icon.TargetName:SetText(">: " .. tostring(GetUnitName("target")))
        print("|cffff9716[ДМ-аддон]: Цель бросков - " .. tostring(GetUnitName("target")) .. ".|r")
    end
end)
MPA_BattlePanel.GetTargetRoll.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_BattlePanel.GetTargetRoll.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_BattlePanel.GetTargetRoll.Icon.Tooltip="Выбрать игрока";

MPA_BattlePanel.GetTargetRoll.Icon.TargetName = MPA_BattlePanel.GetTargetRoll.Icon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MPA_BattlePanel.GetTargetRoll.Icon.TargetName:SetPoint("LEFT", MPA_BattlePanel.GetTargetRoll, "CENTER", 22, 0)
MPA_BattlePanel.GetTargetRoll.Icon.TargetName:SetFontObject(GameFontNormal)
MPA_BattlePanel.GetTargetRoll.Icon.TargetName:SetText("<Нет Цели>")


MPA_BattlePanel.RollInt = CreateFrame("Button", "MPA_BattlePanel.RollInt", MPA_BattlePanel, "DMPanelNoble:MiniIconButtonBG")  --// First button
MPA_BattlePanel.RollInt:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 120, -98)

MPA_BattlePanel.RollInt.Icon = CreateFrame("BUTTON", nil, MPA_BattlePanel.RollInt, "DMPanelNoble:MiniIconButtonTemplate");
MPA_BattlePanel.RollInt.Icon:SetNormalTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye04")
MPA_BattlePanel.RollInt.Icon:SetHighlightTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye04")
MPA_BattlePanel.RollInt.Icon:SetAlpha(0.8)
MPA_BattlePanel.RollInt.Icon:SetScript("OnClick", function()
   if isNPCtarget() then
    if TargetNameToRoll ~= nil then
        SendChatMessage(".npcroll " .. tostring(TargetNameToRoll) .. " 3" ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        NPCRollPlusEmote()
    else
        print("|cffff9716[ДМ-аддон]: Необходимо выбрать игрока для броска.|r")
    end
   else
    print("|cffff9716[ДМ-аддон]: Необходимо взять в цель НПС.|r")
   end
end)
MPA_BattlePanel.RollInt.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_BattlePanel.RollInt.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_BattlePanel.RollInt.Icon.Tooltip="Бросок - интеллект";


MPA_BattlePanel.RollAgila = CreateFrame("Button", "MPA_BattlePanel.RollAgila", MPA_BattlePanel, "DMPanelNoble:MiniIconButtonBG")  --// First button
MPA_BattlePanel.RollAgila:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 80, -98)

MPA_BattlePanel.RollAgila.Icon = CreateFrame("BUTTON", nil, MPA_BattlePanel.RollAgila, "DMPanelNoble:MiniIconButtonTemplate");
MPA_BattlePanel.RollAgila.Icon:SetNormalTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye03")
MPA_BattlePanel.RollAgila.Icon:SetHighlightTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye03")
MPA_BattlePanel.RollAgila.Icon:SetAlpha(0.8)
MPA_BattlePanel.RollAgila.Icon:SetScript("OnClick", function()
   if isNPCtarget() then
    if TargetNameToRoll ~= nil then
        SendChatMessage(".npcroll " .. tostring(TargetNameToRoll) .. " 2" ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        NPCRollPlusEmote()
    else
        print("|cffff9716[ДМ-аддон]: Необходимо выбрать игрока для броска.|r")
    end
   else
    print("|cffff9716[ДМ-аддон]: Необходимо взять в цель НПС.|r")
   end
end)
MPA_BattlePanel.RollAgila.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_BattlePanel.RollAgila.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_BattlePanel.RollAgila.Icon.Tooltip="Бросок - ловкость";


MPA_BattlePanel.RollStr = CreateFrame("Button", "MPA_BattlePanel.RollStr", MPA_BattlePanel, "DMPanelNoble:MiniIconButtonBG")  --// First button
MPA_BattlePanel.RollStr:SetPoint("CENTER", MPA_BattlePanel, "CENTER", 40, -98)

MPA_BattlePanel.RollStr.Icon = CreateFrame("BUTTON", nil, MPA_BattlePanel.RollStr, "DMPanelNoble:MiniIconButtonTemplate");
MPA_BattlePanel.RollStr.Icon:SetNormalTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye05")
MPA_BattlePanel.RollStr.Icon:SetHighlightTexture("interface\\ICONS\\inv_jewelcrafting_dragonseye05")
MPA_BattlePanel.RollStr.Icon:SetAlpha(0.8)
MPA_BattlePanel.RollStr.Icon:SetScript("OnClick", function()
   if isNPCtarget() then
    if TargetNameToRoll ~= nil then
        SendChatMessage(".npcroll " .. tostring(TargetNameToRoll) .. " 1" ,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        NPCRollPlusEmote()
    else
        print("|cffff9716[ДМ-аддон]: Необходимо выбрать игрока для броска.|r")
    end
   else
    print("|cffff9716[ДМ-аддон]: Необходимо взять в цель НПС.|r")
   end
end)
MPA_BattlePanel.RollStr.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_BattlePanel.RollStr.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_BattlePanel.RollStr.Icon.Tooltip="Бросок - сила";