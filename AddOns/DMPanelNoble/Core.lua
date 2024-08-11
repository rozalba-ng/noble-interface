
DMPanelNoble = LibStub("AceAddon-3.0"):NewAddon("DMPanelNoble", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                               Variables                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local EditboxStatement = nil
local EditboxText = nil
local SingleWord
local line
local BindingName
local ConvertedBind
local LastPossName
local MessageRadius = 1
local Chosen_colour = 1
local Chosen_GobDelRadius = 2
DMPanelNoble.PanelState = 0
--- 0 - main
--- 1 - chat panel
--- 2 - Search and del
--- 3 - auras
--- 4 - npc control
--- 5 - editbox
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                          MinimapIconButton                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local DMN_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DMN_Minimap", {
    type = "data source",
    text = "DMN_Minimap",
    icon = "Interface\\Icons\\inv_misc_dice_01",
    OnClick = function()
                DMPanelNoble:MinMapButtonFunc()
              end,
    OnEnter = function()
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(LibDBIcon10_DMN_Minimap,"ANCHOR_TOP");
				GameTooltip:AddLine("Аддон для ДМ-доступа")
				GameTooltip:AddLine("Нажмите для открытия меню")
				GameTooltip:Show()
              end,
    })

local MinimapIconButton = LibStub("LibDBIcon-1.0")




function DMPanelNoble:HasDMLevel()
if DMLevel > 0 then
    MinimapIconButton:Show("DMN_Minimap")
else
    MinimapIconButton:Hide("DMN_Minimap")
end
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                            Scripts                                      ]]
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
local function ConvertRadius(radius)
    if tonumber(radius) == 1 then
        return 2
    elseif tonumber(radius) == 2 then
        return 5
    elseif tonumber(radius) == 3 then
       return 10
    elseif tonumber(radius) == 4 then
        return 15
    else return 0 end
end

local function isempty(text)
  return text == " " or text == nil or text == ''  ---%s+  ???
end

local function ReturnNoSpace(text)
new_text = string.gsub(text, "%s+", " ")
return new_text
end

function isNPCtarget()
  return UnitIsPlayer("target") == nil and UnitExists("target") == 1
end

local function IsAllowedNotify(text)
    return isNPCtarget() and not isempty(text)
end

local function GameTooltipOnEnter(self)
        if self.Tooltip then
            GameTooltip:SetOwner(self,"ANCHOR_TOP");
            GameTooltip:AddLine(self.Tooltip);
            GameTooltip:Show();
        end
end
    local function GameTooltipOnLeave(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide(); end end
    
    
    
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                           Message Splitter                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function NPCChatSender(text, state, radius, colour)
if isempty(text) then return end
if text:len() > 350 then return end
    NPCChatRetranslator(text, state, radius, colour)
end
      
local function MessageStringSplitter(line, state, radius, colour)
local WordsTemp = "";
local WordsTable = {}
    for SingleWord in line:gmatch("%S+") do
        table.insert(WordsTable, SingleWord);
    end
-----
    if line:len() <= (350) then
        NPCChatSender(line, state, radius, colour)
    else
        for i=1 , table.getn(WordsTable) do
            WordsTemp = WordsTemp.." "..WordsTable[i];
            if i == table.getn(WordsTable) then
                NPCChatSender(WordsTemp, state, radius, colour)
                break
            end
            if (WordsTemp:len() + WordsTable[i+1]:len()) > 349 then
                NPCChatSender(WordsTemp, state, radius, colour)
                WordsTemp = "";
            end
        end

    end
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Addon Load                                  ]]
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function DMPanelNoble:OnInitialize()
    ---// MinimapIconButton Initialize
    self.db = LibStub("AceDB-3.0"):New("MinMapDB", {
    profile = {
        minimap = {
            hide = true, },
        settings = {
            NPCSayByEmote = false,
            AddNameToEmote = true,
            SaveFocus = true,
            ChatRadius = 40,
            RollOneShot = 36,
            RollStatic = 45,
                                    },
                  },                               })
    MinimapIconButton:Register("DMN_Minimap", DMN_LDB, self.db.profile.minimap)
end

function DMPanelNoble:OnEnable()
    self:SecureHook("SendChatMessage",  "CommandMessageHook")
    self:RegisterEvent("CHAT_MSG_SYSTEM", "SystemMessageHandler")
    self:RegisterEvent("UPDATE_BINDINGS", "SetBindings")
    self:ScheduleTimer("DMLevelTimer", 0.2)
    
    
    DMPanelNoble:SetBindings()
    if self.db.profile.settings.NPCSayByEmote then SettingsFrame.NPCSay:SetChecked(true) else SettingsFrame.NPCSay:SetChecked(false) end
    if DMPanelNoble.db.profile.settings.AddNameToEmote then SettingsFrame.AddName:SetChecked(true) else SettingsFrame.AddName:SetChecked(false) end
    if DMPanelNoble.db.profile.settings.SaveFocus then SettingsFrame.SaveFocusEditbox:SetChecked(true) else SettingsFrame.SaveFocusEditbox:SetChecked(false) end
    
    SettingsFrame.RadiusSlider:SetValue(tonumber(DMPanelNoble.db.profile.settings.ChatRadius))
    if self.db.profile.settings.RollStatic then SettingsFrame.RollStateEditBox:SetNumber(tonumber(self.db.profile.settings.RollStatic)) else SettingsFrame.RollStateEditBox:SetNumber(0) end
    if self.db.profile.settings.RollOneShot then SettingsFrame.RollOneShotEditBox:SetNumber(tonumber(self.db.profile.settings.RollOneShot)) else SettingsFrame.RollOneShotEditBox:SetNumber(0) end
end


function DMPanelNoble:DMLevelTimer()
    if DMLevel > 0 then
        print("|cffff9716[ДМ-аддон]: Ваш текущий уровень ДМ-доступа - " .. DMLevel .. "|r")
    end
    DMPanelNoble:HasDMLevel()
if DMLevel < 3 then
    MPA_AurasAndStatesPanel.InvisOnoff.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.SpeedOnOff.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.FlyOnOff.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.Phase.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.SetAura.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.ClearAura.Icon.Lock:SetTexture("interface\\buttons\\UI-GroupLoot-Pass-Up");
    MPA_AurasAndStatesPanel.InvisOnoff.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
    MPA_AurasAndStatesPanel.SpeedOnOff.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
    MPA_AurasAndStatesPanel.FlyOnOff.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
    MPA_AurasAndStatesPanel.Phase.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
    MPA_AurasAndStatesPanel.SetAura.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
    MPA_AurasAndStatesPanel.ClearAura.Icon.Tooltip="Только для ДМ-доступа\nтретьего уровня";
end
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 UI                                      ]]
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// MainPanel UI
-----------------------------------------------------------------------------------------------------------------------------------------------------
local MPA_MainPanel = CreateFrame("Frame", "MPA_MainPanel", UIParent)
MPA_MainPanel:SetClampedToScreen(true)
MPA_MainPanel:Hide()
MPA_MainPanel:SetFrameStrata("FULLSCREEN")
MPA_MainPanel:SetSize(318.94, 120.25)
MPA_MainPanel:SetPoint("CENTER", UIParent, "CENTER")
MPA_MainPanel:EnableMouse()
MPA_MainPanel:SetMovable(true)
MPA_MainPanel:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)
MPA_MainPanel:SetScript("OnMouseUp", MPA_MainPanel.StopMovingOrSizing)

MPA_MainPanel.Texture = MPA_MainPanel:CreateTexture("ARTWORK")
MPA_MainPanel.Texture:SetTexture("Interface\\AddOns\\DMPanelNoble\\IMG\\blank.blp")
MPA_MainPanel.Texture:SetAllPoints(MPA_MainPanel)
MPA_MainPanel.Texture:SetTexCoord(0, 0, 0, 0.634, 0.843, 0, 0.843, 0.634);

MPA_MainPanel.Title = MPA_MainPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MPA_MainPanel.Title:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, 41)
MPA_MainPanel.Title:SetFont("Fonts\\MORPHEUS.TTF", 14, "OUTLINE")
MPA_MainPanel.Title:SetText("Главное меню")
MPA_MainPanel.Title:SetAlpha(0.85)
-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// Control Buttons UI
-----------------------------------------------------------------------------------------------------------------------------------------------------
MPA_MainPanel.CloseButton = CreateFrame("BUTTON", "MPA_MainPanel.CloseButton", MPA_MainPanel, "DMPanelNoble:CloseButtonTemplate");
MPA_MainPanel.CloseButton:SetSize(23,23)
MPA_MainPanel.CloseButton:SetAlpha(.9)
MPA_MainPanel.CloseButton:SetPoint("CENTER", MPA_MainPanel, "CENTER", 142, 41)
MPA_MainPanel.CloseButton:RegisterForClicks("AnyUp")
MPA_MainPanel.CloseButton:SetScript("OnClick", function(self)
    MPA_MainPanel:Hide()
end)

MPA_MainPanel.RefreshButton = CreateFrame("BUTTON", "MPA_MainPanel.RefreshButton", MPA_MainPanel, "DMPanelNoble:RefreshButtonTemplate");
MPA_MainPanel.RefreshButton:SetSize(23,23)
MPA_MainPanel.RefreshButton:SetAlpha(.9)
MPA_MainPanel.RefreshButton:SetPoint("CENTER", MPA_MainPanel, "CENTER", -142, 41)
MPA_MainPanel.RefreshButton:RegisterForClicks("AnyUp")
MPA_MainPanel.RefreshButton:SetScript("OnClick", function(self)
    DMPanelNoble:ReturnToMain()
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// Main EditBox UI
-----------------------------------------------------------------------------------------------------------------------------------------------------
local MPA_EditPanel = CreateFrame("Frame", "MPA_EditPanel", MPA_MainPanel)
MPA_EditPanel:SetSize(318.94, 120.25)
MPA_EditPanel:SetAllPoints(MPA_MainPanel)
MPA_EditPanel:Hide()

MPA_EditPanel.SetFocus = CreateFrame("BUTTON", "MPA_EditPanel.SetFocus", MPA_EditPanel, "SecureHandlerClickTemplate");
MPA_EditPanel.SetFocus:SetSize(275, 75)
MPA_EditPanel.SetFocus:SetPoint("CENTER", MPA_EditPanel, "CENTER", -11, -15)

MPA_EditPanel.SetFocus:SetScript("OnClick", function()
    if not MPA_EditPanel.EditBox:HasFocus() then MPA_EditPanel.EditBox:SetFocus() end
end)

MPA_EditPanel.EditBox = CreateFrame('EditBox', 'MPA_MainEditBox', MPA_EditPanel)
MPA_EditPanel.EditBox:SetMultiLine(true)
MPA_EditPanel.EditBox:SetAutoFocus(false)
MPA_EditPanel.EditBox:EnableMouse(true)
MPA_EditPanel.EditBox:SetMaxLetters(2550)
MPA_EditPanel.EditBox:SetFontObject(GameFontHighlight)
MPA_EditPanel.EditBox:SetWidth(270)
MPA_EditPanel.EditBox:SetHeight(10)
MPA_EditPanel.EditBox:EnableMouseWheel(true)

MPA_EditPanel.EditBox:SetScript('OnTextChanged', function(self)
    ScrollingEdit_OnTextChanged(self, self:GetParent());
end)

MPA_EditPanel.EditBox:SetScript('OnCursorChanged', function(self, x, y, w, h)
    ScrollingEdit_OnCursorChanged(self, x, y, w, h);
end)

MPA_EditPanel.EditBox:SetScript('OnUpdate', function(self, elapsed)
    ScrollingEdit_OnUpdate(self, elapsed, self:GetParent());
end)

MPA_EditPanel.EditBox:SetScript('OnEditFocusLost', function(self, elapsed)
    MPA_EditPanel.SetFocus:Show()
end)

MPA_EditPanel.EditBox:SetScript('OnEditFocusGained', function(self, elapsed)
    MPA_EditPanel.SetFocus:Hide()
end)

MPA_EditPanel.EditBox:SetScript('OnEscapePressed', function(self)
MPA_EditPanel.EditBox:ClearFocus();
--MPA_EditPanel:Hide()
end)

MPA_EditPanel.EditBox:SetScript('OnEnterPressed', function(self)
EditboxText = MPA_EditPanel.EditBox:GetText()
if EditboxStatement == nil then print("Произошла ошибка ввода.")
elseif EditboxStatement == "LOOKUPCREATURE" then
    SendChatMessage(".lo cr "..tostring(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
elseif EditboxStatement == "LOOKUPGAMEOBJECTS" then
    SendChatMessage(".lo ob "..tostring(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
elseif EditboxStatement == "NPCSAYSTATE" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif isempty(tostring(EditboxText)) then
        return
    else
        if not DMPanelNoble.db.profile.settings.NPCSayByEmote then
            MessageStringSplitter(tostring(EditboxText), 1, 0, 0)
        else
            local TargetName = GetUnitName("target")
            MessageStringSplitter(TargetName .. " говорит: ".. tostring(EditboxText), 2, 0, 0)
        end
    end
elseif EditboxStatement == "NPCEMOTESTATE" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif isempty(tostring(EditboxText)) then
        return
    else
        if DMPanelNoble.db.profile.settings.AddNameToEmote == true then
            MessageStringSplitter(GetUnitName("target") .." " .. tostring(EditboxText), 3, 0, 0)
        else
            MessageStringSplitter(tostring(EditboxText), 3, 0, 0)
        end
    end
elseif EditboxStatement == "NPCYELLSTATE" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif isempty(tostring(EditboxText)) then
        return
    else
        MessageStringSplitter(tostring(EditboxText), 4, 0, 0)
    end
elseif EditboxStatement == "CHATCOLORSTATE" then
    if isempty(tostring(EditboxText)) then
        return
    else
        if (not DMPanelNoble.db.profile.settings.ChatRadius) or DMPanelNoble.db.profile.settings.ChatRadius == nil or tonumber(DMPanelNoble.db.profile.settings.ChatRadius) == 0 then
            MessageStringSplitter(tostring(EditboxText), 5, 0, tonumber(Chosen_colour))
        else
            MessageStringSplitter(tostring(EditboxText), 5, tonumber(DMPanelNoble.db.profile.settings.ChatRadius), tonumber(Chosen_colour))
        end
    end
elseif EditboxStatement == "TALKINGHEADSTATE" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif isempty(tostring(EditboxText)) then
        return
    else
        if (not DMPanelNoble.db.profile.settings.ChatRadius) or DMPanelNoble.db.profile.settings.ChatRadius == nil or tonumber(DMPanelNoble.db.profile.settings.ChatRadius) == 0 then
            TalkingHeadRetranslator(tostring(EditboxText), GetUnitName("target"), GetUnitName("player"), 0)
        else
            TalkingHeadRetranslator(tostring(EditboxText), GetUnitName("target"), GetUnitName("player"), tonumber(DMPanelNoble.db.profile.settings.ChatRadius))
        end
    end
elseif EditboxStatement == "DELETEGOBNAMESTATE" then
    if ReturnNoSpace(tostring(EditboxText)):len() < 5 then
        print("|cffff9716[ГМ-аддон]: Название должно быть длиннее 4 символов.|r")
        return
    else
        --DMPanelNoble:UndoNameGobject(tostring(EditboxText), tonumber(Chosen_GobDelRadius))
        UndoPhaseNameGobjects(ReturnNoSpace(tostring(EditboxText)), ConvertRadius(tonumber(Chosen_GobDelRadius)))
    end
elseif EditboxStatement == "PHASESTATEMENT" then
    if not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Фаза должа состоять из цифр.|r")
    elseif tonumber(EditboxText) == 1024 then
        print("|cffff9716[ГМ-аддон]: Запрещенная фаза.|r")
    else
        SendChatMessage(".mod phase "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "MORPHSTATEMENT" then
    if isempty(tostring(EditboxText)) then
        return
    else
        SendChatMessage(".skin "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "SETAURASTATEMENT" then
    if not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Номер ауры должен состоять из цифр.|r")
    else
        SendChatMessage(".auraput "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "CLEARAURASTATEMENT" then
    if isempty(tostring(EditboxText)) then
        SendChatMessage(".cleartargetauras","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    elseif not tonumber(EditboxText) then
        print("|cffff9716[ГМ-аддон]: Номер ауры должен состоять из цифр.|r")
    else
        SendChatMessage(".auradisp "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "SETSCALENPCSTATEMENT" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Размер НПС должен быть в диапазоне 0.05 - 5|r")
    elseif tonumber(EditboxText) > 5 or tonumber(EditboxText) < 0.05 then
        print("|cffff9716[ГМ-аддон]: Размер НПС должен быть в диапазоне 0.05 - 5|r")
    else
        SendChatMessage(".changescale "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "NPCPLAYEMOTESTATEMENT" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Эмоция должна быть числом.|r")
    else
        SendChatMessage(".npcplayemote ".. tostring(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "NPCSTATESTATEMENT" then
    if not isNPCtarget() then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
        return
    elseif not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Статическая эмоция должна быть числом.|r")
    else
        SendChatMessage(".npcsetstate "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "SUMMONSTATEMENT" then
    if isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Необходимо ввести ник игрока.|r")
    elseif string.lower(tostring(EditboxText)) == 1 or string.lower(tostring(EditboxText)) == "all" or string.lower(tostring(EditboxText)) == "raid" then
    -----
        for Call_d=1,GetNumRaidMembers() do
            Call_d_d = "raid"..Call_d
            Call_name = UnitName(Call_d_d)
            SendChatMessage(".call "..Call_name,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        end
    -----
    else
        SendChatMessage(".call "..tostring(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "SETDIFFSTATEMENT" then
    if not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Значение должно быть числом.|r")
    elseif not (UnitExists("target")) or not UnitIsPlayer("target") then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель игрока.|r")
        return
    else
        SendChatMessage(".setdiff "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
elseif EditboxStatement == "RAIDSETDIFFSTATEMENT" then
    if not tonumber(EditboxText) or isempty(tostring(EditboxText)) then
        print("|cffff9716[ГМ-аддон]: Значение должно быть числом.|r")
    else
        SendChatMessage(".raidsetdiff "..tonumber(EditboxText),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end
DMPanelNoble:EditBoxCollectGarbage()
end)

UNM_ScrollFrame = CreateFrame('ScrollFrame', 'UNM_ScrollFrame', MPA_EditPanel, 'UIPanelScrollFrameTemplate')
UNM_ScrollFrame:SetPoint('TOPLEFT', MPA_EditPanel, 'TOPLEFT', 10, -45)
UNM_ScrollFrame:SetPoint('BOTTOMRIGHT', MPA_EditPanel, 'BOTTOMRIGHT', -35, 10)
UNM_ScrollFrame:EnableMouseWheel(true)
UNM_ScrollFrame:SetScrollChild(MPA_EditPanel.EditBox)

function DMPanelNoble:EditBoxCollectGarbage()
MPA_EditPanel.EditBox:SetText("");
    if not DMPanelNoble.db.profile.settings.SaveFocus then
        MPA_EditPanel.EditBox:ClearFocus();
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// Select Panel UI
-----------------------------------------------------------------------------------------------------------------------------------------------------
local MPA_SelectPanel = CreateFrame("Frame", "MPA_SelectPanel", MPA_MainPanel)
MPA_SelectPanel:SetSize(318.94, 120.25)
MPA_SelectPanel:SetAllPoints(MPA_MainPanel)

MPA_SelectPanel.NPCButton = CreateFrame("Button", "MPA_SelectPanel.NPCButton", MPA_SelectPanel, "DMPanelNoble:IconButtonBG")
MPA_SelectPanel.NPCButton:SetPoint("CENTER", -120, -18)

MPA_SelectPanel.NPCButton.Icon = CreateFrame("BUTTON", nil, MPA_SelectPanel.NPCButton, "DMPanelNoble:IconButtonTemplate");
MPA_SelectPanel.NPCButton.Icon:SetNormalTexture("interface\\ICONS\\inv_misc_paperbundle03c")
MPA_SelectPanel.NPCButton.Icon:SetHighlightTexture("interface\\ICONS\\inv_misc_paperbundle03c")
MPA_SelectPanel.NPCButton.Icon:SetAlpha(0.85)
MPA_SelectPanel.NPCButton.Icon:SetScript("OnClick", function() DMPanelNoble:NPCPanel_ShowAll() end)
MPA_SelectPanel.NPCButton.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SelectPanel.NPCButton.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SelectPanel.NPCButton.Icon.Tooltip="Инструменты чата";
--- - - - - - - - - - - - -
--- - - - - - - - - - - - -
MPA_SelectPanel.SearchAndDel = CreateFrame("Button", "MPA_SelectPanel.SearchAndDel", MPA_SelectPanel, "DMPanelNoble:IconButtonBG")  
MPA_SelectPanel.SearchAndDel:SetPoint("CENTER", -60, -18)

MPA_SelectPanel.SearchAndDel.Icon = CreateFrame("BUTTON", nil, MPA_SelectPanel.SearchAndDel, "DMPanelNoble:IconButtonTemplate");
MPA_SelectPanel.SearchAndDel.Icon:SetNormalTexture("interface\\ICONS\\trade_archaeology")
MPA_SelectPanel.SearchAndDel.Icon:SetHighlightTexture("interface\\ICONS\\trade_archaeology")
MPA_SelectPanel.SearchAndDel.Icon:SetAlpha(0.85)
MPA_SelectPanel.SearchAndDel.Icon:SetScript("OnClick", function() DMPanelNoble:SearchAndDel_ShowAll() end)
MPA_SelectPanel.SearchAndDel.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SelectPanel.SearchAndDel.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SelectPanel.SearchAndDel.Icon.Tooltip="Поиск и удаление";
--- - - - - - - - - - - - -
--- - - - - - - - - - - - -
MPA_SelectPanel.AurasButton = CreateFrame("Button", "MPA_SelectPanel.AurasButton", MPA_SelectPanel, "DMPanelNoble:IconButtonBG")  
MPA_SelectPanel.AurasButton:SetPoint("CENTER", 0, -18)

MPA_SelectPanel.AurasButton.Icon = CreateFrame("BUTTON", nil, MPA_SelectPanel.AurasButton, "DMPanelNoble:IconButtonTemplate");
MPA_SelectPanel.AurasButton.Icon:SetNormalTexture("interface\\ICONS\\spell_arcane_blast")
MPA_SelectPanel.AurasButton.Icon:SetHighlightTexture("interface\\ICONS\\spell_arcane_blast")
MPA_SelectPanel.AurasButton.Icon:SetAlpha(0.85)
MPA_SelectPanel.AurasButton.Icon:SetScript("OnClick", function() DMPanelNoble:AurasAndStates_ShowAll() end)
MPA_SelectPanel.AurasButton.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SelectPanel.AurasButton.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SelectPanel.AurasButton.Icon.Tooltip="Ауры и состояния";
--- - - - - - - - - - - - -
--- - - - - - - - - - - - -
MPA_SelectPanel.Dops = CreateFrame("Button", "MPA_SelectPanel.Dops", MPA_SelectPanel, "DMPanelNoble:IconButtonBG")  
MPA_SelectPanel.Dops:SetPoint("CENTER", 60, -18)

MPA_SelectPanel.Dops.Icon = CreateFrame("BUTTON", nil, MPA_SelectPanel.Dops, "DMPanelNoble:IconButtonTemplate");
MPA_SelectPanel.Dops.Icon:SetNormalTexture("interface\\ICONS\\spell_shadow_twistedfaith")
MPA_SelectPanel.Dops.Icon:SetHighlightTexture("interface\\ICONS\\spell_shadow_twistedfaith")
MPA_SelectPanel.Dops.Icon:SetAlpha(0.85)
MPA_SelectPanel.Dops.Icon:SetScript("OnClick", function() DMPanelNoble:ControlPanel_ShowAll() end)
MPA_SelectPanel.Dops.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SelectPanel.Dops.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SelectPanel.Dops.Icon.Tooltip="Контроль НПС";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SelectPanel.Options = CreateFrame("Button", "MPA_SelectPanel.Options", MPA_SelectPanel, "DMPanelNoble:IconButtonBG")  
MPA_SelectPanel.Options:SetPoint("CENTER", 120, -18)

MPA_SelectPanel.Options.Icon = CreateFrame("BUTTON", nil, MPA_SelectPanel.Options, "DMPanelNoble:IconButtonTemplate");
MPA_SelectPanel.Options.Icon:SetNormalTexture("interface\\ICONS\\icon_petfamily_mechanical")
MPA_SelectPanel.Options.Icon:SetHighlightTexture("interface\\ICONS\\icon_petfamily_mechanical")
MPA_SelectPanel.Options.Icon:SetAlpha(0.85)
MPA_SelectPanel.Options.Icon:SetScript("OnClick", function() DMPanelNoble:SettingsFrameOnOff() end)
MPA_SelectPanel.Options.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SelectPanel.Options.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SelectPanel.Options.Icon.Tooltip="Настройки";

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// Select Panel UI
-----------------------------------------------------------------------------------------------------------------------------------------------------


local MPA_NPCPanel = CreateFrame("Frame", "MPA_NPCPanel", MPA_MainPanel)
MPA_NPCPanel:SetSize(318.94, 120.25)
MPA_NPCPanel:SetAllPoints(MPA_MainPanel)
MPA_NPCPanel:Hide()

MPA_NPCPanel.NPCSay_Button = CreateFrame("BUTTON", "MPA_MainPanel.NPCSay_Button", MPA_NPCPanel, "DMPanelNoble:NPCSAYButton");
MPA_NPCPanel.NPCSay_Button:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, 0)
MPA_NPCPanel.NPCSay_Button.Tooltip="Отпись за НПС";
MPA_NPCPanel.NPCSay_Button:SetScript("OnEnter", GameTooltipOnEnter);
MPA_NPCPanel.NPCSay_Button:SetScript("OnLeave",GameTooltipOnLeave);
MPA_NPCPanel.NPCSay_Button:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "NPCSAYSTATE";
    MPA_MainPanel.Title:SetText("Отпись за НПС")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_NPCPanel.NPCEmote_Button = CreateFrame("BUTTON", "MPA_MainPanel.NPCEmote_Button", MPA_NPCPanel, "DMPanelNoble:NPCEmoteButton");
MPA_NPCPanel.NPCEmote_Button:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, 0)
MPA_NPCPanel.NPCEmote_Button.Tooltip="Эмоции за НПС";
MPA_NPCPanel.NPCEmote_Button:SetScript("OnEnter", GameTooltipOnEnter);
MPA_NPCPanel.NPCEmote_Button:SetScript("OnLeave",GameTooltipOnLeave);
MPA_NPCPanel.NPCEmote_Button:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "NPCEMOTESTATE";
    MPA_MainPanel.Title:SetText("Эмоции за НПС")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_NPCPanel.Colour_Button = CreateFrame("BUTTON", "MPA_MainPanel.Colour_Button", MPA_NPCPanel, "DMPanelNoble:NPCColourButton");
MPA_NPCPanel.Colour_Button:SetPoint("CENTER", MPA_MainPanel, "CENTER", 100, 0)
MPA_NPCPanel.Colour_Button.Tooltip="Цветная отпись";
MPA_NPCPanel.Colour_Button:SetScript("OnEnter", GameTooltipOnEnter);
MPA_NPCPanel.Colour_Button:SetScript("OnLeave",GameTooltipOnLeave);
MPA_NPCPanel.Colour_Button:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "CHATCOLORSTATE";
    MPA_MainPanel.Title:SetText("Цветная отпись")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_NPCPanel.NPCYell_Button = CreateFrame("BUTTON", "MPA_MainPanel.NPCYell_Button", MPA_NPCPanel, "DMPanelNoble:NPCYellButton");
MPA_NPCPanel.NPCYell_Button:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, -35)
MPA_NPCPanel.NPCYell_Button.Tooltip="Крик за НПС";
MPA_NPCPanel.NPCYell_Button:SetScript("OnEnter", GameTooltipOnEnter);
MPA_NPCPanel.NPCYell_Button:SetScript("OnLeave",GameTooltipOnLeave);
MPA_NPCPanel.NPCYell_Button:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "NPCYELLSTATE";
    MPA_MainPanel.Title:SetText("Крик за НПС")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_NPCPanel.TalkingHead_Button = CreateFrame("BUTTON", "MPA_MainPanel.TalkingHead_Button", MPA_NPCPanel, "DMPanelNoble:NPCTalkingHeadButton");
MPA_NPCPanel.TalkingHead_Button:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, -35)
MPA_NPCPanel.TalkingHead_Button.Tooltip="Интерактивный фрейм";
MPA_NPCPanel.TalkingHead_Button:SetScript("OnEnter", GameTooltipOnEnter);
MPA_NPCPanel.TalkingHead_Button:SetScript("OnLeave",GameTooltipOnLeave);
MPA_NPCPanel.TalkingHead_Button:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "TALKINGHEADSTATE";
    MPA_MainPanel.Title:SetText("Интерактивный фрейм")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_NPCPanel.ColourDropDown = CreateFrame("Button", "MPA_NPCPanel.ColourDropDown", MPA_NPCPanel, "UIDropDownMenuTemplate")
MPA_NPCPanel.ColourDropDown:SetPoint("CENTER", MPA_MainPanel, "CENTER", 100, -35)
 
local Colour_items = {
   "|cffbbbbbbСерый|r",
   "|cffff0000Красный",
   "|cff00ccffСиний",
   "|cff93c57fЗеленый",
   "|cffFF6EB4Розовый",
   "|cffec9c22Оранжевый",
   "|cffc169d2Фиолетовый",
}
 
local function OnClick(self)
   UIDropDownMenu_SetSelectedID(MPA_NPCPanel.ColourDropDown, self:GetID())
   Chosen_colour = self:GetID()
end
 
local function initialize(self, level)
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(Colour_items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end
 
UIDropDownMenu_Initialize(MPA_NPCPanel.ColourDropDown, initialize)
UIDropDownMenu_SetWidth(MPA_NPCPanel.ColourDropDown, 70);
UIDropDownMenu_SetButtonWidth(MPA_NPCPanel.ColourDropDown, 80)
UIDropDownMenu_SetSelectedID(MPA_NPCPanel.ColourDropDown, 1)
UIDropDownMenu_SetText(MPA_NPCPanel.ColourDropDown, "Цвет")
UIDropDownMenu_JustifyText(MPA_NPCPanel.ColourDropDown, "LEFT")

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// SearchAndDel UI
-----------------------------------------------------------------------------------------------------------------------------------------------------

local MPA_SearchAndDelPanel = CreateFrame("Frame", "MPA_SearchAndDelPanel", MPA_MainPanel)
MPA_SearchAndDelPanel:SetSize(318.94, 120.25)
MPA_SearchAndDelPanel:SetAllPoints(MPA_MainPanel)
MPA_SearchAndDelPanel:Hide()

--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.LoCrButton = CreateFrame("BUTTON", "MPA_SearchAndDelPanel.LoCrButton", MPA_SearchAndDelPanel, "DMPanelNoble:LoCrButtonTemplate");
MPA_SearchAndDelPanel.LoCrButton:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, -35)
MPA_SearchAndDelPanel.LoCrButton.Tooltip="Поиск НПС";
MPA_SearchAndDelPanel.LoCrButton:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.LoCrButton:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.LoCrButton:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "LOOKUPCREATURE";
    MPA_MainPanel.Title:SetText("Поиск НПС")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.LoObjButton = CreateFrame("BUTTON", "MPA_SearchAndDelPanel.LoObjButton", MPA_SearchAndDelPanel, "DMPanelNoble:LoObjButtonTemplate");
MPA_SearchAndDelPanel.LoObjButton:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, -35)
MPA_SearchAndDelPanel.LoObjButton.Tooltip="Поиск объектов";
MPA_SearchAndDelPanel.LoObjButton:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.LoObjButton:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.LoObjButton:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "LOOKUPGAMEOBJECTS";
    MPA_MainPanel.Title:SetText("Поиск объектов")
    DMPanelNoble:OpenMainEditbox();
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.DeleteNPC = CreateFrame("Button", "MPA_SearchAndDelPanel.DeleteNPC", MPA_SearchAndDelPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_SearchAndDelPanel.DeleteNPC:SetPoint("CENTER", -90, 0)

MPA_SearchAndDelPanel.DeleteNPC.Icon = CreateFrame("BUTTON", nil, MPA_SearchAndDelPanel.DeleteNPC, "DMPanelNoble:MiniIconButtonTemplate");
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetNormalTexture("interface\\ICONS\\inv_jewelry_trinket_04")
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetHighlightTexture("interface\\ICONS\\inv_jewelry_trinket_04")
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetAlpha(0.8)
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetScript("OnClick", function() DMPanelNoble:TargetDeleteNPC() end)
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.DeleteNPC.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.DeleteNPC.Icon.Tooltip="Удалить НПС.";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.DeleteNearNPC = CreateFrame("Button", "MPA_SearchAndDelPanel.DeleteNPC", MPA_SearchAndDelPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_SearchAndDelPanel.DeleteNearNPC:SetPoint("CENTER", -50, 0)

MPA_SearchAndDelPanel.DeleteNearNPC.Icon = CreateFrame("BUTTON", nil, MPA_SearchAndDelPanel.DeleteNearNPC, "DMPanelNoble:MiniIconButtonTemplate");
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetNormalTexture("interface\\ICONS\\warrior_skullbanner")
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetHighlightTexture("interface\\ICONS\\warrior_skullbanner")
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetAlpha(0.8)
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetScript("OnClick", function() SendChatMessage(".delnearnpc","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end)
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.DeleteNearNPC.Icon.Tooltip="Удаление ближайшего НПС.";

local UndoGob_block = false;
local UndoGob_Cooldown = CreateFrame("Frame")
local UndoGob_Cooldown_AnimationGroup = UndoGob_Cooldown:CreateAnimationGroup()
local UndoGob_CooldownAnimation = UndoGob_Cooldown_AnimationGroup:CreateAnimation("Alpha")
UndoGob_CooldownAnimation:SetDuration(1)
UndoGob_Cooldown_AnimationGroup:SetScript("OnFinished", function(self)
        UndoGob_block = false;
end)

--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.UndoGob = CreateFrame("Button", "MPA_SearchAndDelPanel.UndoGob", MPA_SearchAndDelPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_SearchAndDelPanel.UndoGob:SetPoint("CENTER", -10, 0)

MPA_SearchAndDelPanel.UndoGob.Icon = CreateFrame("BUTTON", nil, MPA_SearchAndDelPanel.UndoGob, "DMPanelNoble:MiniIconButtonTemplate");
MPA_SearchAndDelPanel.UndoGob.Icon:SetNormalTexture("interface\\ICONS\\spell_holy_borrowedtime")
MPA_SearchAndDelPanel.UndoGob.Icon:SetHighlightTexture("interface\\ICONS\\spell_holy_borrowedtime")
MPA_SearchAndDelPanel.UndoGob.Icon:SetAlpha(0.8)
MPA_SearchAndDelPanel.UndoGob.Icon:SetScript("OnClick", function()
if UndoGob_block == true then return end
    UndoGob_block = true;
    DMPanelNoble:UndoGobject()
    UndoGob_CooldownAnimation:Play()
    MPA_SearchAndDelPanel.UndoGob.Icon.Cooldown:SetCooldown(GetTime(), 1)
end)
MPA_SearchAndDelPanel.UndoGob.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.UndoGob.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.UndoGob.Icon.Tooltip="Откат предыдущей ГО.";

MPA_SearchAndDelPanel.UndoGob.Icon.Cooldown = CreateFrame("Cooldown", "MPA_SearchAndDelPanel.UndoGob.Icon.Cooldown", MPA_SearchAndDelPanel.UndoGob.Icon, "CooldownFrameTemplate")
MPA_SearchAndDelPanel.UndoGob.Icon.Cooldown:SetAllPoints()
MPA_SearchAndDelPanel.UndoGob.Icon.Cooldown:SetCooldown(0, 0)

--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.GobDelRadiusButton = CreateFrame("Button", "MPA_SearchAndDelPanel.GobDelRadiusButton", MPA_SearchAndDelPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_SearchAndDelPanel.GobDelRadiusButton:SetPoint("CENTER", 120, 0)

MPA_SearchAndDelPanel.GobDelRadiusButton.Icon = CreateFrame("BUTTON", nil, MPA_SearchAndDelPanel.GobDelRadiusButton, "DMPanelNoble:MiniIconButtonTemplate");
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetNormalTexture("interface\\ICONS\\inv_misc_bomb_05")
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetHighlightTexture("interface\\ICONS\\inv_misc_bomb_05")
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetAlpha(0.8)
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetScript("OnClick", function() DMPanelNoble:WarningFrameShow(Chosen_GobDelRadius) end)
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.GobDelRadiusButton.Icon.Tooltip="Удаление всех ГО вокруг.\nУдаляются даже покупные ГО.";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.GobDelByNameButton = CreateFrame("Button", "MPA_SearchAndDelPanel.GobDelByNameButton", MPA_SearchAndDelPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_SearchAndDelPanel.GobDelByNameButton:SetPoint("CENTER", 80, 0)

MPA_SearchAndDelPanel.GobDelByNameButton.Icon = CreateFrame("BUTTON", nil, MPA_SearchAndDelPanel.GobDelByNameButton, "DMPanelNoble:MiniIconButtonTemplate");
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetNormalTexture("interface\\ICONS\\garrison_building_workshop")
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetHighlightTexture("interface\\ICONS\\garrison_building_workshop")
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetAlpha(0.8)
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetScript("OnClick", function()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "DELETEGOBNAMESTATE";
    MPA_MainPanel.Title:SetText("Удаление ГО по названию")
    DMPanelNoble:OpenMainEditbox();
    MPA_EditPanel.EditBox:SetTextColor(1, 0, 0, 1);
end)
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_SearchAndDelPanel.GobDelByNameButton.Icon.Tooltip="Удаление всех ГО по названию.\nУдаляются даже покупные ГО.";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_SearchAndDelPanel.GobDeleteDropDown = CreateFrame("Button", "MPA_SearchAndDelPanel.GobDeleteDropDown", MPA_SearchAndDelPanel, "UIDropDownMenuTemplate")
MPA_SearchAndDelPanel.GobDeleteDropDown:SetPoint("CENTER", MPA_MainPanel, "CENTER", 100, -35)
 
local GobDelete_radius = {
   "2 ярда",
   "5 ярдов",
   "10 ярдов",
   "15 ярдов",
}
 
 
local function OnClick(self)
   UIDropDownMenu_SetSelectedID(MPA_SearchAndDelPanel.GobDeleteDropDown, self:GetID())
   Chosen_GobDelRadius = self:GetID()
end
 
local function initialize(self, level)
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(GobDelete_radius) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end
 
UIDropDownMenu_Initialize(MPA_SearchAndDelPanel.GobDeleteDropDown, initialize)
UIDropDownMenu_SetWidth(MPA_SearchAndDelPanel.GobDeleteDropDown, 70);
UIDropDownMenu_SetButtonWidth(MPA_SearchAndDelPanel.GobDeleteDropDown, 70)
UIDropDownMenu_SetSelectedID(MPA_SearchAndDelPanel.GobDeleteDropDown, 2)
UIDropDownMenu_SetText(MPA_SearchAndDelPanel.GobDeleteDropDown, "Радиус:")
UIDropDownMenu_JustifyText(MPA_SearchAndDelPanel.GobDeleteDropDown, "LEFT")

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// SearchAndDel UI
-----------------------------------------------------------------------------------------------------------------------------------------------------

local MPA_AurasAndStatesPanel = CreateFrame("Frame", "MPA_AurasAndStatesPanel", MPA_MainPanel)
MPA_AurasAndStatesPanel:SetSize(318.94, 120.25)
MPA_AurasAndStatesPanel:SetAllPoints(MPA_MainPanel)
MPA_AurasAndStatesPanel:Hide()


MPA_AurasAndStatesPanel.Morph = CreateFrame("BUTTON", "MPA_AurasAndStatesPanel.Morph", MPA_AurasAndStatesPanel, "DMPanelNoble:MorphButtonTemplate");
MPA_AurasAndStatesPanel.Morph:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, -35)
MPA_AurasAndStatesPanel.Morph.Tooltip="Смена облика";
MPA_AurasAndStatesPanel.Morph:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.Morph:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.Morph:SetScript("OnClick", function(self)
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "MORPHSTATEMENT";
    MPA_MainPanel.Title:SetText("Смена облика")
    DMPanelNoble:OpenMainEditbox();
end)

MPA_AurasAndStatesPanel.DeMorph = CreateFrame("BUTTON", "MPA_AurasAndStatesPanel.DeMorph", MPA_AurasAndStatesPanel, "DMPanelNoble:DeMorphButtonTemplate");
MPA_AurasAndStatesPanel.DeMorph:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, -35)
MPA_AurasAndStatesPanel.DeMorph.Tooltip="Снять облик";
MPA_AurasAndStatesPanel.DeMorph:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.DeMorph:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.DeMorph:SetScript("OnClick", function(self)
    SendChatMessage(".deskin","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.Phase = CreateFrame("Button", "MPA_AurasAndStatesPanel.Phase", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.Phase:SetPoint("CENTER", 120, 0)

MPA_AurasAndStatesPanel.Phase.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.Phase, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.Phase.Icon:SetNormalTexture("interface\\ICONS\\achievement_zone_lochmodan")
MPA_AurasAndStatesPanel.Phase.Icon:SetHighlightTexture("interface\\ICONS\\achievement_zone_lochmodan")
MPA_AurasAndStatesPanel.Phase.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.Phase.Icon:SetScript("OnClick", function()
if DMLevel < 3 then return end
    if not UnitAura("player", "Творческая фаза") then
        SendChatMessage(".gotophase","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        SendChatMessage(".leavephase","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)
MPA_AurasAndStatesPanel.Phase.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.Phase.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.Phase.Icon.Tooltip="Творческая фаза";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.FlyOnOff = CreateFrame("Button", "MPA_AurasAndStatesPanel.FlyOnOff", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.FlyOnOff:SetPoint("CENTER", 80, 0)

MPA_AurasAndStatesPanel.FlyOnOff.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.FlyOnOff, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetNormalTexture("interface\\ICONS\\spell_shadow_twistedfaith")
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetHighlightTexture("interface\\ICONS\\spell_shadow_twistedfaith")
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetScript("OnClick", function()
if DMLevel < 3 or not UnitAura("player", "Творческая фаза") then print("|cffff9716[ДМ-аддон]: Вы должны находиться в творческой фазе.|r") return end
    if not UnitAura("player", "Полет") then
        SendChatMessage(".dmflyon","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        SendChatMessage(".dmflyoff","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.FlyOnOff.Icon.Tooltip="Полет";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.InvisOnoff = CreateFrame("Button", "MPA_AurasAndStatesPanel.InvisOnoff", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.InvisOnoff:SetPoint("CENTER", 80, -35)

local InvisModif = 0
MPA_AurasAndStatesPanel.InvisOnoff.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.InvisOnoff, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetNormalTexture("interface\\ICONS\\ability_stealth")
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetHighlightTexture("interface\\ICONS\\ability_stealth")
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetScript("OnClick", function()
if DMLevel < 3 or not UnitAura("player", "Творческая фаза") then print("|cffff9716[ДМ-аддон]: Вы должны находиться в творческой фазе.|r") return end
    if not InvisModif or InvisModif == 0 then
        InvisModif = 1
        SendChatMessage(".invis","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        InvisModif = 0
        SendChatMessage(".deinvis","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.InvisOnoff.Icon.Tooltip="Невидимость";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.SpeedOnOff = CreateFrame("Button", "MPA_AurasAndStatesPanel.SpeedOnOff", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.SpeedOnOff:SetPoint("CENTER", 120, -35)

local SeedUpModif = 0
MPA_AurasAndStatesPanel.SpeedOnOff.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.SpeedOnOff, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetNormalTexture("interface\\ICONS\\ability_rogue_sprint")
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetHighlightTexture("interface\\ICONS\\ability_rogue_sprint")
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetScript("OnClick", function()
if DMLevel < 3 or not UnitAura("player", "Творческая фаза") then print("|cffff9716[ДМ-аддон]: Вы должны находиться в творческой фазе.|r") return end
    if not SeedUpModif or SeedUpModif == 0 then
        SeedUpModif = 1
        SendChatMessage(".speedup","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        SeedUpModif = 0
        SendChatMessage(".resetspeed","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end)
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.SpeedOnOff.Icon.Tooltip="Ускорение";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.SetAura = CreateFrame("Button", "MPA_AurasAndStatesPanel.SetAura", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.SetAura:SetPoint("CENTER", -120, 0)

MPA_AurasAndStatesPanel.SetAura.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.SetAura, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.SetAura.Icon:SetNormalTexture("interface\\ICONS\\spell_arcane_studentofmagic")
MPA_AurasAndStatesPanel.SetAura.Icon:SetHighlightTexture("interface\\ICONS\\spell_arcane_studentofmagic")
MPA_AurasAndStatesPanel.SetAura.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.SetAura.Icon:SetScript("OnClick", function()
if DMLevel < 3 then return end
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "SETAURASTATEMENT";
    MPA_MainPanel.Title:SetText("Добавить ауру")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_AurasAndStatesPanel.SetAura.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.SetAura.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.SetAura.Icon.Tooltip="Добавить ауру";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.ClearAura = CreateFrame("Button", "MPA_AurasAndStatesPanel.ClearAura", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.ClearAura:SetPoint("CENTER", -80, 0)

MPA_AurasAndStatesPanel.ClearAura.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.ClearAura, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.ClearAura.Icon:SetNormalTexture("interface\\ICONS\\spell_holy_dispelmagic")
MPA_AurasAndStatesPanel.ClearAura.Icon:SetHighlightTexture("interface\\ICONS\\spell_holy_dispelmagic")
MPA_AurasAndStatesPanel.ClearAura.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.ClearAura.Icon:SetScript("OnClick", function()
if DMLevel < 3 then return end
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "CLEARAURASTATEMENT";
    MPA_MainPanel.Title:SetText("Убрать ауру")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_AurasAndStatesPanel.ClearAura.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.ClearAura.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.ClearAura.Icon.Tooltip="Убрать ауру";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_AurasAndStatesPanel.SetScale = CreateFrame("Button", "MPA_AurasAndStatesPanel.SetScale", MPA_AurasAndStatesPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_AurasAndStatesPanel.SetScale:SetPoint("CENTER", 0, 0)

MPA_AurasAndStatesPanel.SetScale.Icon = CreateFrame("BUTTON", nil, MPA_AurasAndStatesPanel.SetScale, "DMPanelNoble:MiniIconButtonTemplate");
MPA_AurasAndStatesPanel.SetScale.Icon:SetNormalTexture("interface\\ICONS\\spell_shaman_improvedreincarnation")
MPA_AurasAndStatesPanel.SetScale.Icon:SetHighlightTexture("interface\\ICONS\\spell_shaman_improvedreincarnation")
MPA_AurasAndStatesPanel.SetScale.Icon:SetAlpha(0.8)
MPA_AurasAndStatesPanel.SetScale.Icon:SetScript("OnClick", function()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "SETSCALENPCSTATEMENT";
    MPA_MainPanel.Title:SetText("Изменить размер НПС")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_AurasAndStatesPanel.SetScale.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_AurasAndStatesPanel.SetScale.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_AurasAndStatesPanel.SetScale.Icon.Tooltip="Изменить размер НПС";

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------/// Control Panel
-----------------------------------------------------------------------------------------------------------------------------------------------------

local MPA_ControlPanel = CreateFrame("Frame", "MPA_ControlPanel", MPA_MainPanel)
MPA_ControlPanel:SetSize(318.94, 120.25)
MPA_ControlPanel:SetAllPoints(MPA_MainPanel)
MPA_ControlPanel:Hide()
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -

MPA_ControlPanel.EmoteST = CreateFrame("Button", "MPA_ControlPanel.EmoteST", MPA_ControlPanel, "DMPanelNoble:MiniIconButtonBG")
MPA_ControlPanel.EmoteST:SetPoint("CENTER", 80, -17)

MPA_ControlPanel.EmoteST.Icon = CreateFrame("BUTTON", nil, MPA_ControlPanel.EmoteST, "DMPanelNoble:MiniIconButtonTemplate");
MPA_ControlPanel.EmoteST.Icon:SetNormalTexture("interface\\ICONS\\achievement_bg_tophealer_ab")
MPA_ControlPanel.EmoteST.Icon:SetHighlightTexture("interface\\ICONS\\achievement_bg_tophealer_ab")
MPA_ControlPanel.EmoteST.Icon:SetAlpha(0.8)
MPA_ControlPanel.EmoteST.Icon:SetScript("OnClick", function()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "NPCPLAYEMOTESTATEMENT";
    MPA_MainPanel.Title:SetText("Проиграть эмоцию НПС")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_ControlPanel.EmoteST.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.EmoteST.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.EmoteST.Icon.Tooltip="Проиграть эмоцию НПС";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -

MPA_ControlPanel.EmoteStatement = CreateFrame("Button", "MPA_ControlPanel.EmoteStatement", MPA_ControlPanel, "DMPanelNoble:MiniIconButtonBG")
MPA_ControlPanel.EmoteStatement:SetPoint("CENTER", 120, -17)

MPA_ControlPanel.EmoteStatement.Icon = CreateFrame("BUTTON", nil, MPA_ControlPanel.EmoteStatement, "DMPanelNoble:MiniIconButtonTemplate");
MPA_ControlPanel.EmoteStatement.Icon:SetNormalTexture("interface\\ICONS\\spell_arcane_mindmastery")
MPA_ControlPanel.EmoteStatement.Icon:SetHighlightTexture("interface\\ICONS\\spell_arcane_mindmastery")
MPA_ControlPanel.EmoteStatement.Icon:SetAlpha(0.8)
MPA_ControlPanel.EmoteStatement.Icon:SetScript("OnClick", function()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "NPCSTATESTATEMENT";
    MPA_MainPanel.Title:SetText("Поле Byte1 НПС")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_ControlPanel.EmoteStatement.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.EmoteStatement.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.EmoteStatement.Icon.Tooltip="Поле Byte1 НПС";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -

MPA_ControlPanel.RollButton = CreateFrame("BUTTON", "MPA_ControlPanel.RollButton", MPA_ControlPanel, "DMPanelNoble:BattleButtonTemplate");
MPA_ControlPanel.RollButton:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, 0)
MPA_ControlPanel.RollButton.Tooltip="Панель боёвки";
MPA_ControlPanel.RollButton:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.RollButton:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.RollButton:SetScript("OnClick", function(self)
    if MPA_BattlePanel:IsVisible() then
        MPA_BattlePanel:Hide()
    else
        MPA_BattlePanel:Show()
    end
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_ControlPanel.Summon = CreateFrame("Button", "MPA_ControlPanel.Summon", MPA_ControlPanel, "DMPanelNoble:MiniIconButtonBG")  
MPA_ControlPanel.Summon:SetPoint("CENTER", 0, -35)

MPA_ControlPanel.Summon.Icon = CreateFrame("BUTTON", nil, MPA_ControlPanel.Summon, "DMPanelNoble:MiniIconButtonTemplate");
MPA_ControlPanel.Summon.Icon:SetNormalTexture("interface\\ICONS\\spell_arcane_portalstormwind")
MPA_ControlPanel.Summon.Icon:SetHighlightTexture("interface\\ICONS\\spell_arcane_portalstormwind")
MPA_ControlPanel.Summon.Icon:SetAlpha(0.8)
MPA_ControlPanel.Summon.Icon:SetScript("OnClick", function()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "SUMMONSTATEMENT";
    MPA_MainPanel.Title:SetText("Суммон игрока")
    DMPanelNoble:OpenMainEditbox();
end)
MPA_ControlPanel.Summon.Icon:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.Summon.Icon:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.Summon.Icon.Tooltip="Суммон игрока";
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -

MPA_ControlPanel.PossUnposs = CreateFrame("BUTTON", "MPA_ControlPanel.PossUnposs", MPA_ControlPanel, "DMPanelNoble:PossUnpossButton");
MPA_ControlPanel.PossUnposs:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, -35)
MPA_ControlPanel.PossUnposs.Tooltip="Poss / Unposs";
MPA_ControlPanel.PossUnposs:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.PossUnposs:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.PossUnposs:SetScript("OnClick", function(self)
        if UnitExists("pet") and not isNPCtarget() then
            PetAbandon();
        elseif GetUnitName("target") == LastPossName then
            PetAbandon();
            LastPossName = nil
            return
        else
            if isNPCtarget() then
                PetAbandon();
                LastPossName = GetUnitName("target")
                SendChatMessage(".npcposs","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
            else
                print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
            end
        end
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
MPA_ControlPanel.Waypoint = CreateFrame("BUTTON", "MPA_ControlPanel.Waypoint", MPA_ControlPanel, "DMPanelNoble:WaypointButtonTemplate");
MPA_ControlPanel.Waypoint:SetPoint("CENTER", MPA_MainPanel, "CENTER", -100, 0)
MPA_ControlPanel.Waypoint.Tooltip="Waypoints";
MPA_ControlPanel.Waypoint:SetScript("OnEnter", GameTooltipOnEnter);
MPA_ControlPanel.Waypoint:SetScript("OnLeave",GameTooltipOnLeave);
MPA_ControlPanel.Waypoint:SetScript("OnClick", function(self)
    if MPA_WaypointPanel:IsVisible() then
        MPA_WaypointPanel:Hide()
    else
        MPA_WaypointPanel:Show()
    end
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                            Settings Frame                               ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local SettingsFrame = CreateFrame("Frame", "SettingsFrame", MPA_MainPanel)
SettingsFrame:Hide()
SettingsFrame:SetWidth(300)
SettingsFrame:SetHeight(210)
SettingsFrame:SetPoint("CENTER", MPA_MainPanel, "CENTER", 0, 170)
SettingsFrame:EnableMouse()
SettingsFrame:SetFrameStrata("FULLSCREEN")

SettingsFrame.Texture = SettingsFrame:CreateTexture("ARTWORK")
SettingsFrame.Texture:SetTexture("Interface\\AddOns\\DMPanelNoble\\IMG\\DopPanels.blp")
SettingsFrame.Texture:SetAllPoints(SettingsFrame)
SettingsFrame.Texture:SetTexCoord(0, 0, 0, 0.553, 0.782, 0, 0.782, 0.553);
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
SettingsFrame.CloseButton = CreateFrame("BUTTON", "SettingsFrame.CloseButton", SettingsFrame, "DMPanelNoble:CloseButtonTemplate");
SettingsFrame.CloseButton:SetSize(23,23)
SettingsFrame.CloseButton:SetAlpha(.9)
SettingsFrame.CloseButton:SetPoint("CENTER", SettingsFrame, "CENTER", 135, 90)
SettingsFrame.CloseButton:RegisterForClicks("AnyUp")
SettingsFrame.CloseButton:SetScript("OnClick", function(self)
    SettingsFrame:Hide()
end)

SettingsFrame.Title = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
SettingsFrame.Title:SetPoint("CENTER", SettingsFrame, "TOP", 0, -25)
SettingsFrame.Title:SetText("Настройки")
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
SettingsFrame.NPCSay = CreateFrame("CheckButton", "SettingsFrame_NPCSay", SettingsFrame, "ChatConfigCheckButtonTemplate");
SettingsFrame.NPCSay:SetPoint("TOPLEFT", 15, -85);
SettingsFrame_NPCSayText:SetText("Альтернативный NPC SAY");
SettingsFrame.NPCSay.tooltip = "Переключение в режим NPC SAY одной строки.";
SettingsFrame.NPCSay:SetScript("OnClick", 
  function()
    DMPanelNoble.db.profile.settings.NPCSayByEmote = not DMPanelNoble.db.profile.settings.NPCSayByEmote
    if DMPanelNoble.db.profile.settings.NPCSayByEmote then SettingsFrame.NPCSay:SetChecked(true) else SettingsFrame.NPCSay:SetChecked(false) end
  end
);
SettingsFrame.NPCSay:Hide()
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
SettingsFrame.AddName = CreateFrame("CheckButton", "SettingsFrame_AddName", SettingsFrame, "ChatConfigCheckButtonTemplate");
SettingsFrame.AddName:SetPoint("TOPLEFT", 15, -110);
SettingsFrame_AddNameText:SetText("Авто-добавление имени НПС");
SettingsFrame.AddName.tooltip = "Авто-добавление имени НПС к эмоции.";
SettingsFrame.AddName:SetScript("OnClick", 
  function()
    DMPanelNoble.db.profile.settings.AddNameToEmote = not DMPanelNoble.db.profile.settings.AddNameToEmote
    if DMPanelNoble.db.profile.settings.AddNameToEmote then SettingsFrame.AddName:SetChecked(true) else SettingsFrame.AddName:SetChecked(false) end
  end
);
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
SettingsFrame.SaveFocusEditbox = CreateFrame("CheckButton", "SettingsFrame_SaveFocusEditbox", SettingsFrame, "ChatConfigCheckButtonTemplate");
SettingsFrame.SaveFocusEditbox:SetPoint("TOPLEFT", 15, -135);
SettingsFrame_SaveFocusEditboxText:SetText("Сохранение окна ввода.");
SettingsFrame.SaveFocusEditbox.tooltip = "Сохранять фокус в окне редактирования после ввода.";
SettingsFrame.SaveFocusEditbox:SetScript("OnClick", 
  function()
    DMPanelNoble.db.profile.settings.SaveFocus = not DMPanelNoble.db.profile.settings.SaveFocus
    if DMPanelNoble.db.profile.settings.SaveFocus then SettingsFrame.SaveFocusEditbox:SetChecked(true) else SettingsFrame.SaveFocusEditbox:SetChecked(false) end
  end
);


SettingsFrame.RadiusSlider = CreateFrame("Slider", "MPA_RadiusSlider", SettingsFrame, "OptionsSliderTemplate")

SettingsFrame.RadiusSlider:ClearAllPoints()
SettingsFrame.RadiusSlider:SetPoint("CENTER", SettingsFrame, "TOP", 0, -60)
SettingsFrame.RadiusSlider:SetWidth(150)
SettingsFrame.RadiusSlider.tooltipText = "Регулирует радиус вещания ColorChat и TalkingHead."
SettingsFrame.RadiusSlider:SetMinMaxValues(0, 89)
SettingsFrame.RadiusSlider:SetValueStep(10)
getglobal(SettingsFrame.RadiusSlider:GetName() .. 'Low'):SetText('Группа');
getglobal(SettingsFrame.RadiusSlider:GetName() .. 'High'):SetText('89');
getglobal(SettingsFrame.RadiusSlider:GetName() .. 'Text'):SetText(SettingsFrame.RadiusSlider:GetValue());

SettingsFrame.RadiusSlider:SetScript("OnValueChanged", function(self)
local SliderValue = self:GetValue()
    if SliderValue == 0 then
        getglobal(SettingsFrame.RadiusSlider:GetName() .. 'Text'):SetText("Группа / рейд");
    else
        getglobal(SettingsFrame.RadiusSlider:GetName() .. 'Text'):SetText(SettingsFrame.RadiusSlider:GetValue() .. " ярдов от Вас.");
    end
    DMPanelNoble.db.profile.settings.ChatRadius = tonumber(SliderValue)
end)
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
--- - - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -///- - - - - - - - - - - -
SettingsFrame.RollStateEditBox = CreateFrame("EditBox", "SettingsFrame.RollStateEditBox", SettingsFrame, "InputBoxTemplate")
SettingsFrame.RollStateEditBox:SetPoint("CENTER", SettingsFrame, "CENTER", 10, -75)
SettingsFrame.RollStateEditBox:SetSize(32, 16)
SettingsFrame.RollStateEditBox:SetAltArrowKeyMode(false)
SettingsFrame.RollStateEditBox:SetAutoFocus(false)
SettingsFrame.RollStateEditBox:SetFontObject(GameFontHighlight)
SettingsFrame.RollStateEditBox:SetMaxLetters(3)
SettingsFrame.RollStateEditBox:SetNumeric(true)
--SettingsFrame.RollStateEditBox:SetNumber(0)
SettingsFrame.RollStateEditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    DMPanelNoble.db.profile.settings.RollStatic = tonumber(self:GetText())
end)
SettingsFrame.RollStateEditBox:SetScript('OnEditFocusLost', function(self, elapsed)
    self:ClearFocus()
    DMPanelNoble.db.profile.settings.RollStatic = tonumber(self:GetText())
end)

SettingsFrame.RollOneShotEditBox = CreateFrame("EditBox", "SettingsFrame.RollOneShotEditBox", SettingsFrame, "InputBoxTemplate")
SettingsFrame.RollOneShotEditBox:SetPoint("CENTER", SettingsFrame.RollStateEditBox, "CENTER", 50, 0)
SettingsFrame.RollOneShotEditBox:SetSize(32, 16)
SettingsFrame.RollOneShotEditBox:SetAltArrowKeyMode(false)
SettingsFrame.RollOneShotEditBox:SetAutoFocus(false)
SettingsFrame.RollOneShotEditBox:SetFontObject(GameFontHighlight)
SettingsFrame.RollOneShotEditBox:SetMaxLetters(3)
SettingsFrame.RollOneShotEditBox:SetNumeric(true)
--SettingsFrame.RollOneShotEditBox:SetNumber(0)
SettingsFrame.RollOneShotEditBox:SetScript('OnEnterPressed', function(self)
    self:ClearFocus()
    DMPanelNoble.db.profile.settings.RollOneShot = tonumber(self:GetText())
end)
SettingsFrame.RollOneShotEditBox:SetScript('OnEditFocusLost', function(self, elapsed)
    self:ClearFocus()
    DMPanelNoble.db.profile.settings.RollOneShot = tonumber(self:GetText())
end)

SettingsFrame.RollStateEditBox.Text = SettingsFrame.RollStateEditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
SettingsFrame.RollStateEditBox.Text:SetPoint("LEFT", SettingsFrame.RollStateEditBox, "CENTER", -137, 0)
SettingsFrame.RollStateEditBox.Text:SetFontObject(GameFontHighlight)
SettingsFrame.RollStateEditBox.Text:SetText("Эмоции NPC-Roll:")

SettingsFrame.RollStateEditBox.Static = SettingsFrame.RollStateEditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
SettingsFrame.RollStateEditBox.Static:SetPoint("CENTER", SettingsFrame.RollStateEditBox, "CENTER", -4, 15)
SettingsFrame.RollStateEditBox.Static:SetFontObject(GameFontHighlightSmall)
SettingsFrame.RollStateEditBox.Static:SetText("Static")

SettingsFrame.RollOneShotEditBox.OneShot = SettingsFrame.RollOneShotEditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
SettingsFrame.RollOneShotEditBox.OneShot:SetPoint("CENTER", SettingsFrame.RollOneShotEditBox, "CENTER", -2, 15)
SettingsFrame.RollOneShotEditBox.OneShot:SetFontObject(GameFontHighlightSmall)
SettingsFrame.RollOneShotEditBox.OneShot:SetText("OneShot")
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                            Frames closer                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function DMPanelNoble:HideAllFrames()
MPA_EditPanel.EditBox:SetTextColor(1, 1, 1, 1.0);

MPA_NPCPanel:Hide()
MPA_EditPanel:Hide()
MPA_SelectPanel:Hide()
MPA_SearchAndDelPanel:Hide()
MPA_AurasAndStatesPanel:Hide()
MPA_ControlPanel:Hide()
end

function DMPanelNoble:OpenMainEditbox()
DMPanelNoble:HideAllFrames()
MPA_EditPanel:Show()
MPA_EditPanel.EditBox:SetFocus()
end


function DMPanelNoble:ReturnToMain()
if MPA_EditPanel.EditBox:IsVisible() then
    if DMPanelNoble.PanelState == 1 then
        DMPanelNoble:NPCPanel_ShowAll()
    elseif DMPanelNoble.PanelState == 2 then
        DMPanelNoble:SearchAndDel_ShowAll()
    elseif DMPanelNoble.PanelState == 3 then
        DMPanelNoble:AurasAndStates_ShowAll()
    elseif DMPanelNoble.PanelState == 4 then
        DMPanelNoble:ControlPanel_ShowAll()
    else
        DMPanelNoble.PanelState = 0
        DMPanelNoble:HideAllFrames()
        MPA_MainPanel.Title:SetText("Главное меню")
        MPA_SelectPanel:Show()
    end
else
    DMPanelNoble.PanelState = 0
    DMPanelNoble:HideAllFrames()
    MPA_MainPanel.Title:SetText("Главное меню")
    MPA_SelectPanel:Show()
end
end

function DMPanelNoble:NPCPanel_ShowAll()
DMPanelNoble.PanelState = 1
DMPanelNoble:HideAllFrames()
MPA_MainPanel.Title:SetText("Инструменты чата")
MPA_NPCPanel:Show()
end

function DMPanelNoble:SearchAndDel_ShowAll()
DMPanelNoble.PanelState = 2
DMPanelNoble:HideAllFrames()
MPA_MainPanel.Title:SetText("Поиск и удаление")
MPA_SearchAndDelPanel:Show()
end

function DMPanelNoble:AurasAndStates_ShowAll()
DMPanelNoble.PanelState = 3
DMPanelNoble:HideAllFrames()
MPA_MainPanel.Title:SetText("Ауры и состояния")
MPA_AurasAndStatesPanel:Show()
end

function DMPanelNoble:ControlPanel_ShowAll()
DMPanelNoble.PanelState = 4
DMPanelNoble:HideAllFrames()
MPA_MainPanel.Title:SetText("Контроль НПС")
MPA_ControlPanel:Show()
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                            Binding Funcs                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function DMPanelNoble:ClearAllAuraBind()
    if(UnitExists("target")) then 
        SendChatMessage(".cleartargetauras","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        print("|cffff9716[ГМ-аддон]: У Вас нет цели.|r")
    end
end


function DMPanelNoble:SettingsFrameOnOff()
    if SettingsFrame:IsVisible() then
    SettingsFrame:Hide()
   else
    SettingsFrame:Show()
   end
end

function DMPanelNoble:MinMapButtonFunc()
   if MPA_MainPanel:IsVisible() then
    MPA_MainPanel:Hide()
   else
    MPA_MainPanel:Show()
   end
end

function DMPanelNoble:ClearEditboxFunc()
   MPA_EditPanel.EditBox:SetText("")
end

function DMPanelNoble:AuraDeathFunc()
    if(UnitExists("target")) then 
        SendChatMessage(".auraput 88053","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        print("|cffff9716[ГМ-аддон]: У Вас нет цели.|r")
    end
end

function DMPanelNoble:AuraLayFunc()
    if(UnitExists("target")) then 
        SendChatMessage(".auraput 64393","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    else
        print("|cffff9716[ГМ-аддон]: У Вас нет цели.|r")
    end
end

function DMPanelNoble:SetDiffFunc()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "SETDIFFSTATEMENT";
    MPA_MainPanel.Title:SetText("Модификатор SetDiff")
    DMPanelNoble:OpenMainEditbox();
end

function DMPanelNoble:SetDiffRaidFunc()
    DMPanelNoble:EditBoxCollectGarbage();
    EditboxStatement = "RAIDSETDIFFSTATEMENT";
    MPA_MainPanel.Title:SetText("Модификатор RaidSetDiff")
    DMPanelNoble:OpenMainEditbox();
end

function DMPanelNoble:RaidSumm()
    for Call_d=1,GetNumRaidMembers() do
        Call_d_d = "raid"..Call_d
        Call_name = UnitName(Call_d_d)
        SendChatMessage(".call "..Call_name,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end