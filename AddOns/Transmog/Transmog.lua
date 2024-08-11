Transmog_save1 = {}  ---// SavedVar
Transmog_save2 = {}
Transmog_save3 = {}

Transmog_TemporaryData1 = {} ---// Текущие таблицы данных, которые пересобираются после критериев поиска и сортировки. 
Transmog_TemporaryData2 = {}
Transmog_TemporaryData3 = {}

Transmog_SavedAura = {}
Transmog_Settings = {}


SelectTab_MiniFaux = 0 ---// Вкладка сумки(1) и вкладка поясов (2)
local Transmog_EditVariable = false
Transmog_SearchKey = "" ---// Ключевое слово поиска
TransmogElunaSave = false
Transmog_NameIconEdit = false
SelectTabTransmog = 1 ---// Вкладка переключения на сохренненые сеты и стандартные
local playerName = UnitName("player")

local Transmog_UnitSlot = {}
local Transmog_CodeText = {}
local Transmog_UnitSlotArtTexture = {}
local Transmog_SelectClickedButton1
local Transmog_SelectClickedButton2
local Transmog_SelectClickedButton3
local Transmog_ItemSetID = { ---// Порядок предметов и их айди
1,
3,
15,
5,
4,
19,
9,
10,
6,
7,
8,
16,
17,
18
}
local Transmog_ItemSetName = { ---//  Переменная изменения слова при вводе кода для трансмога.
[1] = "головы",
[3] = "плечей",
[15] = "плаща",
[5] = "груди",
[4] = "рубашки",
[19] = "\nгербовой накидки",
[9] = "запястья",
[10] = "кистей рук",
[6] = "пояса",
[7] = "поножей",
[8] = "ступней",
[16] = "правой руки",
[17] = "левой руки",
[18] = "\nоружия дальнего боя",
}
local Transmog_ItemSetName2 = { ---// Названия итемов в фрейме показа кода
"Голова",
"Плечи",
"Плащ",
"Грудь",
"Рубашка",
"Гербовая накидка",
"Запястья",
"Кисти рук",
"Пояс",
"Ноги",
"Ступни",
"Правая рука",
"Левая рука",
"Оружие дальнего боя",
}
local Transmog_ItemTexture = { ---// Иконки слотов итемов
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Head.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Shoulder.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Chest.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Chest.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Shirt.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Tabard.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Wrists.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Hands.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Waist.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Legs.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Feet.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand.blp",
"Interface\\Paperdoll\\UI-PaperDoll-Slot-Ranged.blp"}

Transmog_DefaultPresetName = {} ---// Стандартные пресеты (название)
Transmog_DefaultPresetCode = {} ---// Стандартные пресеты (код)

Transmog_BagsPresetName = {} ---// Стандартные сумки (название)
Transmog_BagsPresetCode = {}  ---// Стандартные сумки (код ауры)
Transmog_BeltPresetName = {}
Transmog_BeltPresetCode = {}

Transmog_EnchantsPresetName = Transmog_EnchantsPresetName or {
	"Яркая кровавая аура",
	"Синяя сфера у лезвия",
	"Яркая снежная аура",
	"Яркая бирюзовая аура",
	"Огненная интенсивная аура",
	"Зелёные сферы у лезвия",
	"Яркая ледяная аура",
	"Бледная бирюзовая аура",
	"Яркая оранжевая аура",
	"Бледная ледяная аура",
	"Бледная кровавая аура",
	"Яркая электрическая аура",
	"Искра у лезвия",
	"ОЧЕНЬ яркая голубая аура",
	"Фиолетовое пламя",
	"Менее яркая белая аура",
	"Бледная зелёная аура",
	"Бледная фиолетовая аура",
	"Яркая зелёная аура",
	"Яркая фиолетовая аура",
	"Яркая белая аура",
	"Бледная белая аура",
	"Яркая золотая аура",
	"Яркая красная аура",
	"Летающий синий огонёк",
	"Летающий пылающий камень",
	"Бледная синяя аура",
	"Летающая ледяная сфера",
	"Летающий огненная сфера",
	"Бледная красная аура",
	"Менее яркая золотая аура",
	"Блеск заточки",
	"Голубое пламя",
	"Капающий яд",
	"Огненная аура",
	"Яркая голубая аура",
	"Менее яркая голубая аура",
	"Синяя интенсивная аура",
}

Transmog_EnchantsPresetCode = Transmog_EnchantsPresetCode or {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	22,
	23,
	24,
	25,
	26,
	27,
	28,
	29,
	30,
	31,
	32,
	33,
	34,
	35,
	36,
	37,
	38,
}

----------------------------------------------------------------------------------------------------------------------------------------------------
--// Фильтр шмоток в чате
local Transmog_ChatFilter = false;
local Transmog_ChatFilter_Frame = CreateFrame("Frame")
local Transmog_ChatFilter_AnimationGroup = Transmog_ChatFilter_Frame:CreateAnimationGroup()
local Transmog_ChatFilter_Animation = Transmog_ChatFilter_AnimationGroup:CreateAnimation("Alpha")
Transmog_ChatFilter_Animation:SetDuration(1)
Transmog_ChatFilter_AnimationGroup:SetScript("OnFinished", function(self)
            Transmog_ChatFilter = false;
                end)
                
local function Transmog_ItemLootFilter(self, event, msg, author, ...)
   if Transmog_ChatFilter == true then
    return true
   else
    return false
   end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", Transmog_ItemLootFilter)
----------------------------------------------------------------------------------------------------------------------------------------------------
local function Transmog_GameTooltipOnEnter (self)
    GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
    GameTooltip:SetText (self.TransmogTooltip_text, nil, nil, nil, nil, true)
    GameTooltip:Show()
end
local function Transmog_GameTooltipOnLeave (self)
    GameTooltip:Hide()
end
----------------------------------------------------------------------------------------------------------------
Transmog_button_block = false;
Transmog_buttonPanel = CreateFrame("Frame")
Transmog_buttonPanel_AnimationGroup = Transmog_buttonPanel:CreateAnimationGroup()
Transmog_buttonBlock = Transmog_buttonPanel_AnimationGroup:CreateAnimation("Alpha")
Transmog_buttonBlock:SetDuration(2)
Transmog_buttonPanel_AnimationGroup:SetScript("OnFinished", function(self)
        Transmog_button_block = false;
            end)
----------------------------------------------------------------------------------------------------------------
local Transmog_MainPanel = CreateFrame("Frame", "Transmog_MainPanel", UIParent) ---// Мейнфрейм
Transmog_MainPanel:SetSize(603,563)
Transmog_MainPanel:Hide()
Transmog_MainPanel:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 10, 0)
Transmog_MainPanel:EnableMouse()
Transmog_MainPanel:SetFrameStrata("MEDIUM")
Transmog_MainPanel:SetScript("OnShow", function()
   PlaySound("igCharacterInfoOpen");
   HideUIPanel(PlayerTalentFrame);
   HideUIPanel(CharacterFrame);
   HideUIPanel(SpellBookFrame);
   HideUIPanel(MacroFrame);
   HideUIPanel(FriendsFrame);
   if SelectTabTransmog == 3 then
	Transmog_ToggleTabButtons(0)
   else
    Transmog_ToggleTabButtons(1)
   end
   ----
   Transmog_UnitModel:SetPosition( 0, 0, 0);
   Transmog_UnitModel:RefreshUnit()
   local race, raceEn = UnitRace("player");
            if raceEn == "BloodElf" and UnitSex("player") == 3 then --/ Выправляет эльфиек
                Transmog_UnitModel:SetPosition( 0, 0.15, 0);
            elseif raceEn == "Dwarf" and UnitSex("player") == 2 then --/ Выправляет дворфов
                Transmog_UnitModel:SetPosition( 0.6, 0, -0.2);
            end
end)

table.insert(UISpecialFrames, "Transmog_MainPanel")


local Transmog_UnitModel_texture1 = Transmog_MainPanel:CreateTexture(nil, "BACKGROUND", nil, 1) ---// Бэкграунд персонажа
Transmog_UnitModel_texture1:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Background\\transmogbackgroundworgen.blp")
Transmog_UnitModel_texture1:SetPoint("CENTER",-50,-35)
Transmog_UnitModel_texture1:SetSize(460, 460)

local Transmog_MainPanel_texture2 = Transmog_MainPanel:CreateTexture(nil, "ARTWORK", nil, 2) ---// Основная текстура
Transmog_MainPanel_texture2:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Main.blp") 
Transmog_MainPanel_texture2:SetPoint("CENTER",-180,10)
Transmog_MainPanel_texture2:SetSize(1126, 563)

Transmog_CloseButton = CreateFrame("Button", "Transmog_CloseButton", Transmog_MainPanel, "UIPanelCloseButton") ---// Кнопка закрытия мейнфрейма
Transmog_CloseButton:SetPoint("TOP", 277, -9)
Transmog_CloseButton:SetSize(29, 29)
Transmog_CloseButton:SetScript("OnClick", function()
Transmog_MainPanel:Hide()
PlaySound("igCharacterInfoClose");
end)

Transmog_UnitModel = CreateFrame("PlayerModel", "Transmog_UnitModel", Transmog_MainPanel) ---// Фрейм модели игрока
Transmog_UnitModel:SetSize(290, 512)
Transmog_UnitModel:SetUnit("player");
Transmog_UnitModel:SetScale(0.9)
Transmog_UnitModel:SetPoint("CENTER", Transmog_MainPanel, "CENTER",-165,-15)
Transmog_UnitModel:SetFrameLevel(1)

local Transmog_CodeListFrame = CreateFrame("Frame", "Transmog_CodeListFrame", Transmog_MainPanel) ---// Фрейм отображения кодов облика
Transmog_CodeListFrame:SetSize(300, 510)
Transmog_CodeListFrame:Hide()
Transmog_CodeListFrame:EnableMouse()
Transmog_CodeListFrame:SetPoint("CENTER", Transmog_MainPanel, "CENTER", 134, -15)
Transmog_CodeListFrame:SetFrameStrata("MEDIUM")
Transmog_CodeListFrame:SetFrameLevel(3)
Transmog_CodeListFrame:SetScript("OnShow", function()
Transmog_FindClose()
TCP_scrollFrame:Hide()
TDP_scrollFrame:Hide()
Transmog_GoldenFrameSelect:Hide() -- Скрыть рамку при переключении табов
Transmog_CopyBox:HighlightText()
Transmog_CopyBox:SetFocus()
end)
Transmog_CodeListFrame:SetScript("OnHide", function()
Transmog_FindClose()
Transmog_DataRefreshAll()
Transmog_GoldenFrameSelect:Show()
end)

local Transmog_CodeListFramePlank = CreateFrame("Frame", "Transmog_CodeListFramePlank", Transmog_CodeListFrame) ---// Плашка с фразой "Код облика"
Transmog_CodeListFramePlank:SetSize(300, 510)
Transmog_CodeListFramePlank:Show()
Transmog_CodeListFramePlank:SetPoint("CENTER", Transmog_CodeListFrame, "CENTER", 97, -15)

local Transmog_CodeListFramePlank_texture = Transmog_CodeListFramePlank:CreateTexture("ARTWORK") ---// Текстура плашки с фразой "Код облика"
Transmog_CodeListFramePlank_texture:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Plank.tga")
Transmog_CodeListFramePlank_texture:SetPoint("CENTER", -100,210)
Transmog_CodeListFramePlank_texture:SetSize(256, 64)
Transmog_CodeListFramePlank_texture:SetAlpha(0.9)

Transmog_PlankText = Transmog_CodeListFramePlank:CreateFontString(nil, "OVERLAY", "GameFontNormal") ---// Текст плашки с фразой "Код облика"
Transmog_PlankText:SetPoint("CENTER", -96,212)
Transmog_PlankText:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
Transmog_PlankText:SetText("Код облика")
Transmog_PlankText:SetAlpha(0.70)

local Transmog_Transmog_CodeListFrame_texture = Transmog_CodeListFrame:CreateTexture("ARTWORK") ---// Текстура фрейма отображения кодов облика
Transmog_Transmog_CodeListFrame_texture:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\CodeText.blp")
Transmog_Transmog_CodeListFrame_texture:SetPoint("CENTER",Transmog_MainPanel, "CENTER", -180,10)
Transmog_Transmog_CodeListFrame_texture:SetSize(1126, 563)

local Transmog_weapon = CreateFrame("Frame", "Transmog_weapon", Transmog_MainPanel) ---// Плашка с фразой "Код облика"
Transmog_weapon:SetSize(1, 1)
Transmog_weapon:Show()
Transmog_weapon:SetPoint("CENTER", Transmog_MainPanel, "CENTER", 0, 0)

Transmog_weapon.text = Transmog_weapon:CreateFontString(nil, "OVERLAY", "GameFontNormal") ---// Текст плашки с фразой "Код облика"
Transmog_weapon.text:SetPoint("CENTER", Transmog_UnitModel_texture1, "CENTER", -100,-217)
Transmog_weapon.text:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
Transmog_weapon.text:SetText("Включать оружие в облик:")
Transmog_weapon.text:SetAlpha(0.65)

Transmog_weapon.CheckBox = CreateFrame("CheckButton", "Transmog_weapon_CheckBox", Transmog_weapon, "ChatConfigCheckButtonTemplate");
Transmog_weapon.CheckBox:SetPoint("CENTER", Transmog_UnitModel_texture1, "CENTER", 3,-217)
Transmog_weapon.CheckBox.tooltip = "Трансмогрифицировать оружие вместе с обликом?";
Transmog_weapon.CheckBox:SetScript("OnClick", 
  function()
  if Transmog_Settings["weapon"] == nil then
    Transmog_Settings["weapon"] = false
    Transmog_weapon.CheckBox:SetChecked(false)
    return
  end
      Transmog_Settings["weapon"] = not Transmog_Settings["weapon"]
  end
);

local function SetWeaponChecked()
  if Transmog_Settings["weapon"] == nil then
    Transmog_Settings["weapon"] = false
    Transmog_weapon.CheckBox:SetChecked(false)
    return
  end
      if Transmog_Settings["weapon"] == false then
        Transmog_weapon.CheckBox:SetChecked(false)
      else
        Transmog_weapon.CheckBox:SetChecked(true)
end
      end

----------
----------
 for i = 1,14 do
Transmog_CodeText[i] = Transmog_CodeListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") ---// Надписи под шмотье
Transmog_CodeText[i]:SetPoint("LEFT", Transmog_CodeListFrame, "LEFT", 20, 170-20*i)
Transmog_CodeText[i]:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t Оружие дальнего боя: 12345678")
Transmog_CodeText[i]:SetAlpha(0.75)
end
----------
----------
local Transmog_CopyEditboxFrame = CreateFrame('Frame', 'Transmog_CopyEditboxFrame', Transmog_CodeListFrame) ---// Блок скроллфрейма с кодом для ручного копирования (доработать блок)
Transmog_CopyEditboxFrame:SetSize(310, 120)
Transmog_CopyEditboxFrame:SetPoint('LEFT', Transmog_CodeListFrame, 'LEFT', 7, -195)
Transmog_CopyEditboxFrame:Show()

Transmog_CopyBox = CreateFrame('EditBox', 'Transmog_CopyBox', Transmog_CopyEditboxFrame)
Transmog_CopyBox:SetMultiLine(true)
Transmog_CopyBox:SetAutoFocus(false)
Transmog_CopyBox:EnableMouse(true)
Transmog_CopyBox:SetMaxLetters(140)
Transmog_CopyBox:SetFont('Fonts\\ARIALN.ttf', 15, 'THINOUTLINE')
Transmog_CopyBox:SetSize(270, 150)
Transmog_CopyBox:SetText("12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678#12345678")
Transmog_CopyBox:SetScript('OnEscapePressed', function() Transmog_CopyBox:ClearFocus() end)
Transmog_CopyBox:SetScript('OnCursorChanged', function() Transmog_CopyBoxScrollScrollBar:Hide() end)

local Transmog_CopyBoxScroll = CreateFrame('ScrollFrame', 'Transmog_CopyBoxScroll', Transmog_CopyEditboxFrame, 'UIPanelScrollFrameTemplate')
Transmog_CopyBoxScroll:SetPoint('TOPLEFT', Transmog_CopyEditboxFrame, 'TOPLEFT', 8, -30)
Transmog_CopyBoxScroll:SetPoint('BOTTOMRIGHT', Transmog_CopyEditboxFrame, 'BOTTOMRIGHT', -30, 8)
Transmog_CopyBoxScroll:SetScrollChild(Transmog_CopyBox)
----------
----------
local Transmog_CodeInputEditBoxFrame = CreateFrame("Frame", "Transmog_CodeInputEditBoxFrame", Transmog_MainPanel) ---// Фрейм для эдитбокса для применения кода к ВСЕМУ шмоту
Transmog_CodeInputEditBoxFrame:SetSize(293, 80)
Transmog_CodeInputEditBoxFrame:Hide()
Transmog_CodeInputEditBoxFrame:SetPoint("CENTER", Transmog_MainPanel, "CENTER", 433, -84)
Transmog_CodeInputEditBoxFrame:SetFrameStrata("MEDIUM")
Transmog_CodeInputEditBoxFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
Transmog_CodeInputEditBoxFrame:SetBackdropColor(0, 0, 0, 1)

local Transmog_CodeInputEditBox = CreateFrame('EditBox', 'Transmog_CodeInputEditBox', Transmog_CodeInputEditBoxFrame, "InputBoxTemplate") ---// Эдитбокс
Transmog_CodeInputEditBox:SetAutoFocus(false)
Transmog_CodeInputEditBox:SetMaxLetters(99999)
Transmog_CodeInputEditBox:SetFont('Fonts\\ARIALN.ttf', 15, 'THINOUTLINE')
Transmog_CodeInputEditBox:SetSize(260, 20)
Transmog_CodeInputEditBox:SetPoint("CENTER", Transmog_CodeInputEditBoxFrame, "CENTER", 3, -5)
Transmog_CodeInputEditBox:SetScript('OnEscapePressed', function() Transmog_CodeInputEditBox:ClearFocus() end)

local Transmog_CodeInputEditBox_text = Transmog_CodeInputEditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight") ---// Текст над эдитбоксом
Transmog_CodeInputEditBox_text:SetPoint("CENTER", Transmog_CodeInputEditBox, "CENTER", 0, 23)
Transmog_CodeInputEditBox_text:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Transmog_CodeInputEditBox_text:SetText("Введите код облика:")
Transmog_CodeInputEditBox_text:SetAlpha(0.9)

function Transmog_CodeInputOnOff()
    if Transmog_CodeInputEditBoxFrame:IsVisible() then
        Transmog_CodeInputEditBoxFrame:Hide()
    else
        Transmog_CodeInputEditBoxFrame:Show()
    end
end
----------
----------
 local Transmog_CodeListClose = CreateFrame("BUTTON", "Transmog_CodeListClose", Transmog_CodeListFramePlank, "SecureHandlerClickTemplate"); ---// Кнопка закрытия фрейма кодов шмота
 Transmog_CodeListClose:Show()
 Transmog_CodeListClose:SetSize(32, 32)
 Transmog_CodeListClose:SetAlpha(0.9)
 Transmog_CodeListClose:SetFrameStrata("MEDIUM")
 Transmog_CodeListClose:SetPoint("CENTER", Transmog_CodeListFrame, "CENTER", 125, 205)
 Transmog_CodeListClose:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
 Transmog_CodeListClose:SetHighlightTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
 Transmog_CodeListClose:RegisterForClicks("AnyUp")
 Transmog_CodeListClose:SetScript("OnClick", function(self, button)
 Transmog_CodeListFrame:Hide()
 PlaySound("gsTitleOptionOK");
end)
----------
----------

local Transmog_ItemInputEditboxFrame = CreateFrame("Frame", "Transmog_ItemInputEditboxFrame", Transmog_UnitModel) ---// Фрейм для эдитбокса для применения кода к отдельной шмотке
Transmog_ItemInputEditboxFrame:SetSize(250, 90)
Transmog_ItemInputEditboxFrame:Hide()
Transmog_ItemInputEditboxFrame:EnableMouse()
Transmog_ItemInputEditboxFrame:SetPoint("CENTER", Transmog_UnitModel, "CENTER", 0, 0)
Transmog_ItemInputEditboxFrame:SetFrameStrata("MEDIUM")
Transmog_ItemInputEditboxFrame:SetFrameLevel(3)
Transmog_ItemInputEditboxFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
Transmog_ItemInputEditboxFrame:SetBackdropColor(0, 0, 0, 1)

local Transmog_ItemInputEditbox = CreateFrame('EditBox', 'Transmog_ItemInputEditBox', Transmog_ItemInputEditboxFrame, "InputBoxTemplate")
Transmog_ItemInputEditBox:SetAutoFocus(true)
Transmog_ItemInputEditBox:SetMaxLetters(12)
Transmog_ItemInputEditBox:SetFont('Fonts\\ARIALN.ttf', 15, 'THINOUTLINE')
Transmog_ItemInputEditBox:SetSize(180, 25)
Transmog_ItemInputEditBox:SetPoint("CENTER", Transmog_ItemInputEditboxFrame, "CENTER", 3, -5)
Transmog_ItemInputEditBox:SetScript("OnEnterPressed", function(self)
    if not UnitDebuff("player", "Трансмогрификация") then
        Transmog_ChatFilter = true
        Transmog_ChatFilter_Animation:Play()
        TransmogItem(Transmog_ItemSlotID,Transmog_ItemInputEditbox:GetText())
        Transmog_ItemInputEditboxFrame:Hide()
        PlaySound("gsTitleOptionOK");
    else
        UIErrorsFrame:AddMessage("Нужно подождать.", 1.0, 0.0, 0.0, 53, 1);
    end
end)

Transmog_ItemInputEditBox:SetScript("OnEscapePressed", function(self)
Transmog_ItemInputEditboxFrame:Hide()
PlaySound("gsTitleOptionOK");
end)

local Transmog_ItemInputEditbox_text = Transmog_ItemInputEditboxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") ---// Текст над эдитбоксом
Transmog_ItemInputEditbox_text:SetPoint("CENTER", Transmog_ItemInputEditboxFrame, "CENTER", 0, 20)
Transmog_ItemInputEditbox_text:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Transmog_ItemInputEditbox_text:SetText("Код облика для головы:")
Transmog_ItemInputEditbox_text:SetAlpha(0.9)

local Transmog_ItemInputEditbox_CloseButton = CreateFrame("Button", "Transmog_ItemInputEditbox_CloseButton", Transmog_ItemInputEditboxFrame, "UIPanelCloseButton") ---// Кнопка закрытия
Transmog_ItemInputEditbox_CloseButton:SetPoint("TOP", 105, -5)
Transmog_ItemInputEditbox_CloseButton:SetSize(29, 29)
Transmog_ItemInputEditbox_CloseButton:SetScript("OnClick", function()
Transmog_ItemInputEditboxFrame:Hide()
PlaySound("gsTitleOptionOK");
end)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local Transmog_EditPresetFrameBack = CreateFrame("Frame", "Transmog_EditPresetFrameBack", Transmog_MainPanel) ---// Мейнфрейм
Transmog_EditPresetFrameBack:SetSize(603,563)
Transmog_EditPresetFrameBack:Hide()
Transmog_EditPresetFrameBack:SetPoint("TOPLEFT", Transmog_MainPanel, "TOPLEFT", 10, 0)
Transmog_EditPresetFrameBack:SetFrameStrata("MEDIUM")

local Transmog_EditPresetFrame = CreateFrame("Frame", "Transmog_EditPresetFrame", Transmog_EditPresetFrameBack) ---// Фрейм для эдитбокса для применения кода к отдельной шмотке
Transmog_EditPresetFrame:SetSize(300, 120)
Transmog_EditPresetFrame:EnableMouse()
Transmog_EditPresetFrame:SetPoint("CENTER", Transmog_EditPresetFrameBack, "CENTER", 0, 0)
Transmog_EditPresetFrame:SetFrameStrata("MEDIUM")
Transmog_EditPresetFrame:SetFrameLevel(3)
Transmog_EditPresetFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
Transmog_EditPresetFrame:SetBackdropColor(0, 0, 0, 1)

local Transmog_EditPresetFrame_CloseButton = CreateFrame("Button", "Transmog_EditPresetFrame_CloseButton", Transmog_EditPresetFrame, "UIPanelCloseButton") ---// Кнопка закрытия
Transmog_EditPresetFrame_CloseButton:SetPoint("TOP", 130, -5)
Transmog_EditPresetFrame_CloseButton:SetSize(29, 29)
Transmog_EditPresetFrame_CloseButton:SetScript("OnClick", function()
Transmog_EditPresetFrameBack:Hide()
PlaySound("gsTitleOptionOK");
end)

local Transmog_EditPresetFrame_text = Transmog_EditPresetFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") ---// Текст над эдитбоксом
Transmog_EditPresetFrame_text:SetPoint("CENTER", Transmog_EditPresetFrame, "CENTER", 0, 20)
Transmog_EditPresetFrame_text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
Transmog_EditPresetFrame_text:SetText("Ваш текущий облик будет\nприменен для")
Transmog_EditPresetFrame_text:SetAlpha(0.9)

local Transmog_EditPresetFrame_text2 = Transmog_EditPresetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") ---// Текст над эдитбоксом
Transmog_EditPresetFrame_text2:SetPoint("CENTER", Transmog_EditPresetFrame, "CENTER", 0, -5)
Transmog_EditPresetFrame_text2:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
Transmog_EditPresetFrame_text2:SetText("ЮЮЮЮЮЮЮЮЮЮЮЮЮ")
Transmog_EditPresetFrame_text2:SetAlpha(0.9)
Transmog_EditPresetFrame_text2:SetWidth(280)
Transmog_EditPresetFrame_text2:SetHeight(120)

local Transmog_EditPresetFrame_button1 = CreateFrame("Button", "Transmog_EditPresetFrame_button1", Transmog_EditPresetFrame, "UIPanelButtonTemplate")
Transmog_EditPresetFrame_button1:SetPoint("CENTER", Transmog_EditPresetFrame, "TOP", -50, -95)
Transmog_EditPresetFrame_button1:SetHeight(25)
Transmog_EditPresetFrame_button1:SetWidth(100)
Transmog_EditPresetFrame_button1:SetText("Применить")
Transmog_EditPresetFrame_button1:SetScript("OnClick", function()
Transmog_EditPresetFrameBack:Hide()
Transmog_EditVariable = true
CallIds()
PlaySound("gsTitleOptionOK");
end)

local Transmog_EditPresetFrame_button2 = CreateFrame("Button", "Transmog_EditPresetFrame_button2", Transmog_EditPresetFrame, "UIPanelButtonTemplate")
Transmog_EditPresetFrame_button2:SetPoint("CENTER", Transmog_EditPresetFrame, "TOP", 50, -95)
Transmog_EditPresetFrame_button2:SetHeight(25)
Transmog_EditPresetFrame_button2:SetWidth(100)
Transmog_EditPresetFrame_button2:SetText("Отмена")
Transmog_EditPresetFrame_button2:SetScript("OnClick", function()
Transmog_EditPresetFrameBack:Hide()
PlaySound("gsTitleOptionOK");
end)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[Сборка таблицы кодов трансмога итемов и обновление списка + создание общего кода для ручного копирования.
Применимо для проклика "отобразить код" уже существующего пресета в SaveVar]]
local TM_Code = {}
local function CodeTransmogRefresh()
wipe(TM_Code)
TM_Code = {strsplit("#", Transmog_SelectClickedButton3, 14)}
    for i = 1,14 do
         if tonumber(TM_Code[i]) == 0  then
                        Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": -")
		elseif tonumber(TM_Code[i]) == 44724 then
			Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": Скрытый")
        else
            Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": ["..TM_Code[i].."]")
        end
    end
    Transmog_CopyBox:SetText(TM_Code[1].."#"..TM_Code[2].."#"..TM_Code[3].."#"..TM_Code[4].."#"..TM_Code[5].."#"..TM_Code[6].."#"..TM_Code[7].."#"..TM_Code[8].."#"..TM_Code[9].."#"..TM_Code[10].."#"..TM_Code[11].."#"..TM_Code[12].."#"..TM_Code[13].."#"..TM_Code[14])
    Transmog_CodeListFrame:Show()
end

--[[Обработчик данных с элуны. При TransmogElunaSave == true сохраняет в SaveVar, в ином случае обновляет базу таблицы с кодами трансмога.]]
ElunaSendAddon_Transmog = CreateFrame("Frame", "ElunaSendAddon_Transmog", UIParent);
ElunaSendAddon_Transmog: RegisterEvent("CHAT_MSG_ADDON")
ElunaSendAddon_Transmog: SetScript("OnEvent", function(self, event, ...)
local args = {...}
if args[1] == "ELUNA_TRANSMOG" and args[4] == playerName then
wipe(TM_Code)
TM_Code = {strsplit("#", args[2], 14)}
    if Transmog_EditVariable == true then
        for k,v in pairs(Transmog_save1) do
            if v == Transmog_SelectClickedButton1 then
                if (Transmog_save2[k] == Transmog_SelectClickedButton2) and (Transmog_save3[k] == Transmog_SelectClickedButton3) then
                       tremove(Transmog_save3,k)
                       tinsert(Transmog_save3,k, TM_Code[1].."#"..TM_Code[2].."#"..TM_Code[3].."#"..TM_Code[4].."#"..TM_Code[5].."#"..TM_Code[6].."#"..TM_Code[7].."#"..TM_Code[8].."#"..TM_Code[9].."#"..TM_Code[10].."#"..TM_Code[11].."#"..TM_Code[12].."#"..TM_Code[13].."#"..TM_Code[14])
                end
            end
        end
        Transmog_EditVariable = false
        Transmog_TableCashUpdate()
        Transmog_DataRefreshAll()
    else
        if TransmogElunaSave == true then
                    if tContains(Transmog_save1,tostring(Transmog_MacroPopupEditBox:GetText())) then
                        print("|cfff0ff00Облик с таким названием уже существует.|r")
                    else
                        tinsert(Transmog_save1,Transmog_MacroPopupEditBox:GetText())
                        tinsert(Transmog_save2,GetMacroIconInfo(Transmog_MacroPopupFrame.selectedIcon))
                        tinsert(Transmog_save3,TM_Code[1].."#"..TM_Code[2].."#"..TM_Code[3].."#"..TM_Code[4].."#"..TM_Code[5].."#"..TM_Code[6].."#"..TM_Code[7].."#"..TM_Code[8].."#"..TM_Code[9].."#"..TM_Code[10].."#"..TM_Code[11].."#"..TM_Code[12].."#"..TM_Code[13].."#"..TM_Code[14])
                        ---
                        Transmog_DataRefreshAll()
                        Transmog_MacroPopupEditBox:SetText("")
                        Transmog_MacroPopupFrame.selectedIcon = nil;
                    end
        else
                    for i = 1,14 do
                        if tonumber(TM_Code[i]) == 0  then
                            Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": -")
                        elseif tonumber(TM_Code[i]) == 44724 then
                            Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": Скрытый")
                        else
                            Transmog_CodeText[i]:SetText("\124TInterface\\GossipFrame\\TrainerGossipIcon:20\124t "..Transmog_ItemSetName2[i]..": ["..TM_Code[i].."]")
                        end
                    end
                    Transmog_CopyBox:SetText(TM_Code[1].."#"..TM_Code[2].."#"..TM_Code[3].."#"..TM_Code[4].."#"..TM_Code[5].."#"..TM_Code[6].."#"..TM_Code[7].."#"..TM_Code[8].."#"..TM_Code[9].."#"..TM_Code[10].."#"..TM_Code[11].."#"..TM_Code[12].."#"..TM_Code[13].."#"..TM_Code[14])
                    Transmog_CodeListFrame:Show()
                    Transmog_ListFramesOff()
        end
    end
    Transmog_EditVariable = false
end
end)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[Функции с правого клика по кнопкам. Дропменю.]]
local Transmog_DropDownMenu1 = CreateFrame("FRAME", "Transmog_DropDownMenu1", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(Transmog_DropDownMenu1, function(self, level, menuList)
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = "Меню";
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Применить код';
info.func = self.SetValue1
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Снять облик';
info.func = self.SetValue2
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Невидимость';
info.func = self.SetValue3
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Закрыть';
info.func = self.SetValue4
UIDropDownMenu_AddButton(info, level);

end)
function Transmog_DropDownMenu1:SetValue1()
Transmog_ItemInputEditbox:SetText("")
Transmog_ItemInputEditboxFrame:Show()
Transmog_ItemInputEditbox_text:SetText("Код облика для "..Transmog_ItemSetName[Transmog_ItemSlotID]..":")
CloseDropDownMenus()
end

function Transmog_DropDownMenu1:SetValue2()
ResetItemTransmog(Transmog_ItemSlotID)
CloseDropDownMenus()
end

function Transmog_DropDownMenu1:SetValue3()
TransmogItem(Transmog_ItemSlotID,44724)
CloseDropDownMenus()
end

function Transmog_DropDownMenu1:SetValue4()
CloseDropDownMenus()
end
----------------------------------------------------------------------------------------------------------------
local Transmog_DropDownMenu2 = CreateFrame("FRAME", "Transmog_DropDownMenu2", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(Transmog_DropDownMenu2, function(self, level, menuList)
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = "Меню";
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Сменить название/значок';
info.func = self.SetValue1
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Заменить текущим';
info.func = self.SetValue2
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Удалить облик';
info.func = self.SetValue3
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Скопировать код';
info.func = self.SetValue4
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Закрыть';
info.func = self.SetValue5
UIDropDownMenu_AddButton(info, level);

end)

function Transmog_DropDownMenu2:SetValue1()
PlaySound("gsTitleOptionOK");
Transmog_NameIconEdit = true
Transmog_MacroPopupFrame.selectedIcon = nil;
Transmog_MacroPopupFrame:Show()
CloseDropDownMenus()
end

function Transmog_DropDownMenu2:SetValue2()
Transmog_EditPresetFrameBack:Show()
Transmog_EditPresetFrame_text2:SetText(Transmog_SelectClickedButton1)
CloseDropDownMenus()
end

function Transmog_DropDownMenu2:SetValue3()
Transmog_EditPresetFrameBack:Hide()
    if SelectTabTransmog == 1 and SelectTab_MiniFaux == 0 then
        for k,v in pairs(Transmog_save1) do
            if v == Transmog_SelectClickedButton1 then
                if (Transmog_save2[k] == Transmog_SelectClickedButton2) and (Transmog_save3[k] == Transmog_SelectClickedButton3) then
                       tremove(Transmog_save1,k)
                       tremove(Transmog_save2,k)
                       tremove(Transmog_save3,k)
                end
            end
        end
        Transmog_TableCashUpdate()
        Transmog_DataRefreshAll()
    end
    
CloseDropDownMenus()
end

function Transmog_DropDownMenu2:SetValue4()
CodeTransmogRefresh()
CloseDropDownMenus()
end

function Transmog_DropDownMenu2:SetValue5()
CloseDropDownMenus()
end

-- Dropdown энчантов
Transmog_EnchantsDropDownMenu = CreateFrame("FRAME", "Transmog_EnchantsDropDownMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(Transmog_EnchantsDropDownMenu, function(self, level, menuList)
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = 'Зачарования';
UIDropDownMenu_AddButton(info, level);
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Правая рука';
info.func = self.SetValue1;
UIDropDownMenu_AddButton(info, level);
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Левая рука';
info.func = self.SetValue2
UIDropDownMenu_AddButton(info, level);

end)

function Transmog_EnchantsDropDownMenu:SetValue1()
	SendChatMessage(".setvisual 1 " .. enchantcode)
	CloseDropDownMenus()
end

function Transmog_EnchantsDropDownMenu:SetValue2()
	SendChatMessage(".setvisual 2 " .. enchantcode)
	CloseDropDownMenus()
end

-- Дезинчант DropDown
Transmog_DisEnchantsDropDownMenu = CreateFrame("FRAME", "Transmog_DisEnchantsDropDownMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(Transmog_DisEnchantsDropDownMenu, function(self, level, menuList)
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = 'Снять зачарования';
UIDropDownMenu_AddButton(info, level);
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Правая рука';
info.func = self.SetValue1;
UIDropDownMenu_AddButton(info, level);
---
info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Левая рука';
info.func = self.SetValue2
UIDropDownMenu_AddButton(info, level);

info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Обе руки';
info.func = self.SetValue3
UIDropDownMenu_AddButton(info, level);
end)

function Transmog_DisEnchantsDropDownMenu:SetValue1()
	SendChatMessage(".setvisual 1 0")
	CloseDropDownMenus()
end

function Transmog_DisEnchantsDropDownMenu:SetValue2()
	SendChatMessage(".setvisual 2 0")
	CloseDropDownMenus()
end

function Transmog_DisEnchantsDropDownMenu:SetValue3()
	SendChatMessage(".setvisual 1 0")
	SendChatMessage(".setvisual 2 0")
	CloseDropDownMenus()
end

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[Сборка фреймов для итемов.]]
 for i = 1,7 do
Transmog_UnitSlot[i] = CreateFrame("BUTTON", "Transmog_UnitSlot"..i, Transmog_MainPanel, "ItemButtonTemplate")
Transmog_UnitSlot[i]:SetSize(35,35)
Transmog_UnitSlot[i]:SetPoint("LEFT", 35, 170-45*i);
Transmog_UnitSlot[i]:RegisterForClicks("AnyDown")
Transmog_UnitSlot[i]:SetFrameStrata("MEDIUM")
Transmog_UnitSlot[i].TransmogTooltip_text = Transmog_ItemSetName2[i]
Transmog_UnitSlot[i]:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
Transmog_UnitSlot[i]:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
Transmog_UnitSlot[i]:SetScript("OnClick", function(self, button)
        if ( button == "LeftButton") then
            local infoType, info1, info2 = GetCursorInfo()
            PickupInventoryItem(Transmog_ItemSetID[i]);
        elseif ( button == "RightButton") then
            Transmog_ItemSlotID = Transmog_ItemSetID[i]
            ToggleDropDownMenu(1, nil, Transmog_DropDownMenu1, 'cursor', 0, 0);
        end
end)
SetItemButtonTexture(Transmog_UnitSlot[i], Transmog_ItemTexture[i]);
end

for i = 8,11 do
Transmog_UnitSlot[i] = CreateFrame("BUTTON", "Transmog_UnitSlot"..i, Transmog_MainPanel, "ItemButtonTemplate")
Transmog_UnitSlot[i]:SetSize(35,35)
Transmog_UnitSlot[i]:SetPoint("LEFT", 235, 410-45*i);
Transmog_UnitSlot[i]:RegisterForClicks("AnyDown")
Transmog_UnitSlot[i].TransmogTooltip_text = Transmog_ItemSetName2[i]
Transmog_UnitSlot[i]:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
Transmog_UnitSlot[i]:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
Transmog_UnitSlot[i]:SetScript("OnClick", function(self, button)
        if ( button == "LeftButton") then
            local infoType, info1, info2 = GetCursorInfo()
            PickupInventoryItem(Transmog_ItemSetID[i]);
        elseif ( button == "RightButton") then
            Transmog_ItemSlotID = Transmog_ItemSetID[i]
            ToggleDropDownMenu(1, nil, Transmog_DropDownMenu1, 'cursor', 0, 0);
        end
end)
SetItemButtonTexture(Transmog_UnitSlot[i], Transmog_ItemTexture[i]);
end

for i = 12,14 do
Transmog_UnitSlot[i] = CreateFrame("BUTTON", "Transmog_UnitSlot"..i, Transmog_MainPanel, "ItemButtonTemplate")
Transmog_UnitSlot[i]:SetSize(35,35)
Transmog_UnitSlot[i]:SetPoint("LEFT", -485+48*i, -190);
Transmog_UnitSlot[i]:RegisterForClicks("AnyDown")
Transmog_UnitSlot[i].TransmogTooltip_text = Transmog_ItemSetName2[i]
Transmog_UnitSlot[i]:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
Transmog_UnitSlot[i]:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
Transmog_UnitSlot[i]:SetScript("OnClick", function(self, button)
        if ( button == "LeftButton") then
            local infoType, info1, info2 = GetCursorInfo()
            PickupInventoryItem(Transmog_ItemSetID[i]);
        elseif ( button == "RightButton") then
            Transmog_ItemSlotID = Transmog_ItemSetID[i]
            ToggleDropDownMenu(1, nil, Transmog_DropDownMenu1, 'cursor', 0, 0);
        end
end)
SetItemButtonTexture(Transmog_UnitSlot[i], Transmog_ItemTexture[i]);
end

--[[Тексутры для фреймов итемов.]]
for i = 1,14 do
Transmog_UnitSlotArtTexture[i] = Transmog_UnitSlot[i]:CreateTexture("ARTWORK", 2)
Transmog_UnitSlotArtTexture[i]:SetTexture(nil)
Transmog_UnitSlotArtTexture[i]:SetPoint("CENTER",-1,1)
Transmog_UnitSlotArtTexture[i]:SetSize(64, 64)
end

--[[Апдейт текстур для фреймов итемов. При INV_Misc_Bag_19 или Spell_Shadow_Teleport применяет "Глаз" иначе пустая тексутра.]]
function Transmog_ItemUpdate()
    for i = 1,14 do
        if GetInventoryItemTexture("player", Transmog_ItemSetID[i]) ~= nil then
                if GetInventoryItemTexture("player", Transmog_ItemSetID[i]) == "Interface\\Icons\\INV_Misc_Bag_19" or GetInventoryItemTexture("player", Transmog_ItemSetID[i]) == "Interface\\Icons\\Spell_Shadow_Teleport" then
                    SetItemButtonTexture(Transmog_UnitSlot[i], Transmog_ItemTexture[i]);
                    Transmog_UnitSlotArtTexture[i]:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Eye.blp")
                else
                    SetItemButtonTexture(Transmog_UnitSlot[i], GetInventoryItemTexture("player", Transmog_ItemSetID[i]));
                    Transmog_UnitSlotArtTexture[i]:SetTexture(nil)
                end
        else
                SetItemButtonTexture(Transmog_UnitSlot[i], Transmog_ItemTexture[i]);
                Transmog_UnitSlotArtTexture[i]:SetTexture(nil)
        end
    end
end
Transmog_ItemUpdate()


function ToggleTransmogItemSlots(state)
    if state == 1 then
        for i = 1,14 do
            Transmog_UnitSlot[i]:Show()
        end
    else
        for i = 1,14 do
            Transmog_UnitSlot[i]:Hide()
        end
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[Смена таблиц для списка кнопок.]]
function Transmog_TableCashUpdate()
    if SelectTabTransmog == 1 and SelectTab_MiniFaux == 0 then
        Transmog_TableCash1 = Transmog_save1
        Transmog_TableCash2 = Transmog_save2
        Transmog_TableCash3 = Transmog_save3
    elseif SelectTabTransmog == 1 and SelectTab_MiniFaux == 1 then
        Transmog_TableCash1 = Transmog_BagsPresetName
        Transmog_TableCash3 = Transmog_BagsPresetCode   
    elseif SelectTabTransmog == 1 and SelectTab_MiniFaux == 2 then
        Transmog_TableCash1 = Transmog_BeltPresetName
        Transmog_TableCash3 = Transmog_BeltPresetCode
	elseif SelectTabTransmog == 1 and SelectTab_MiniFaux == 3 then
        Transmog_TableCash1 = Transmog_EnchantsPresetName
        Transmog_TableCash3 = Transmog_EnchantsPresetCode
    elseif SelectTabTransmog == 2 then
        Transmog_TableCash1 = Transmog_DefaultPresetName
        Transmog_TableCash3 = Transmog_DefaultPresetCode
	elseif SelectTabTransmog == 3 then
		Transmog_TableCash1 = {}
        Transmog_TableCash3 = {}
    end
end
Transmog_TableCashUpdate()
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[Первый список для сохраненных сетов. Transmog Custom Panel]]
local TCP_scrollFrame 
local TCP_numButtons = 6 
local TCP_buttonHeight = 70 
local function TCP_update()
    FauxScrollFrame_Update(TCP_scrollFrame,#Transmog_TemporaryData1,TCP_numButtons,TCP_buttonHeight)
  
  for index = 1,TCP_numButtons do
    local TCP_offset = index + FauxScrollFrame_GetOffset(TCP_scrollFrame)
        local TCP_button = TCP_scrollFrame.buttons[index]
        local TCP_button2 = TCP_scrollFrame.buttons2[index]
        local TCP_button3 = TCP_scrollFrame.buttons3[index]
        TCP_button.index = TCP_offset
            if TCP_offset<=#Transmog_TemporaryData1 then
                  TCP_button3:SetText(Transmog_TemporaryData1[TCP_offset])
                  TCP_button2:SetNormalTexture(Transmog_TemporaryData2[TCP_offset])
                  TCP_button:Show()
                  TCP_button2:Show()
            else
              TCP_button:Hide()
              TCP_button2:Hide()
            end
  end
end

local function  Transmog_DataRefresh()
    wipe(Transmog_TemporaryData1)
    wipe(Transmog_TemporaryData2)
    wipe(Transmog_TemporaryData3)
    
        for k,v in pairs(Transmog_TableCash1) do
                if string.find(strlower(v), strlower(Transmog_SearchKey)) then
                            tinsert(Transmog_TemporaryData1,Transmog_TableCash1[k])
                            tinsert(Transmog_TemporaryData2,Transmog_TableCash2[k])
                            tinsert(Transmog_TemporaryData3,Transmog_TableCash3[k])
                end
        end

        TCP_update()
end

local TCP_frame = CreateFrame("Frame","TCP_frame",Transmog_MainPanel)
TCP_frame:SetSize(296,TCP_numButtons*TCP_buttonHeight-15)
TCP_frame:SetPoint("CENTER", Transmog_MainPanel, "CENTER",130,-90)
TCP_frame:SetFrameLevel(2)
TCP_frame:Show()


TCP_scrollFrame = CreateFrame("ScrollFrame","TCP_scrollFrame",TCP_frame,"FauxScrollFrameTemplate")
TCP_scrollFrame:SetPoint("TOPLEFT",0,-8)
TCP_scrollFrame:SetPoint("BOTTOMRIGHT",-19.8,34)
TCP_scrollFrame:SetScript("OnVerticalScroll",function(self,TCP_offset)
  FauxScrollFrame_OnVerticalScroll(self, TCP_offset, TCP_buttonHeight, TCP_update)
end)


TCP_scrollFrame.buttons = {}
TCP_scrollFrame.buttons2 = {}
TCP_scrollFrame.buttons3 = {}
for i=1,TCP_numButtons do
  TCP_scrollFrame.buttons[i] = CreateFrame("BUTTON", nil, TCP_frame, "SecureHandlerClickTemplate")
  local TCP_button = TCP_scrollFrame.buttons[i]
  TCP_button:SetSize(256,66)
  TCP_button:SetFrameLevel(2)
  TCP_button:SetNormalFontObject("GameFontHighlightLeft")
  TCP_button:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\PresetButton.tga")
  TCP_button:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\PresetButtonH.tga")
  TCP_button:SetPushedTexture("Interface\\NobleProject\\Transmog\\IMG\\PresetButtonP.tga")
  TCP_button:SetPoint("TOPLEFT",10,-(i-1)*60-8)
  TCP_button:RegisterForClicks("AnyDown")
  TCP_button:SetScript("OnClick",function(self, button)
         if ( button == "LeftButton") and Transmog_button_block == false then
            Transmog_ChatFilter = true
            Transmog_ChatFilter_Animation:Play()
            if Transmog_Settings["weapon"] == true then
                TransmogSetOnCharacter(Transmog_TemporaryData3[self.index], 1)
            else
                TransmogSetOnCharacter(Transmog_TemporaryData3[self.index], 0)
            end
            Transmog_button_block = true
            Transmog_buttonBlock:Play()
            PlaySound("gsTitleOptionOK");
         elseif ( button == "LeftButton") and Transmog_button_block == true then
                 UIErrorsFrame:AddMessage("Нужно подождать.", 1.0, 0.0, 0.0, 53, 1);
         elseif ( button == "RightButton") then
             if SelectTabTransmog == 1 and SelectTab_MiniFaux == 0 then
                     Transmog_SelectClickedButton1 = Transmog_TemporaryData1[self.index]
                     Transmog_SelectClickedButton2 = Transmog_TemporaryData2[self.index]
                     Transmog_SelectClickedButton3 = Transmog_TemporaryData3[self.index]
                 ToggleDropDownMenu(1, nil, Transmog_DropDownMenu2, 'cursor', 0, 0);
              end
         end
	
        
 end)
	TCP_button:SetScript("OnEnter",function(self, button)
		ShowTmogPrewiew(self,Transmog_TemporaryData3[self.index])
	
	end)
	TCP_button:SetScript("OnLeave",function(self, button)
		HideTmogPrewiew()
	
	end)
 --------------
  TCP_scrollFrame.buttons2[i] = CreateFrame("BUTTON", nil, TCP_frame, "SecureHandlerClickTemplate")
  local TCP_button2 = TCP_scrollFrame.buttons2[i]
  TCP_button2:SetSize(35,35)
  TCP_button2:SetFrameLevel(2)
  TCP_button2:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\button.blp")
  TCP_button2:SetPoint("TOPLEFT",25,-(i-1)*60-23)
     --------------
    TCP_scrollFrame.buttons3[i] = TCP_scrollFrame.buttons[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    local TCP_button3 = TCP_scrollFrame.buttons3[i]
    TCP_button3:SetPoint("CENTER", 17,0.5)
    TCP_button3:SetText("Код облика")
    TCP_button3:SetAlpha(0.95)
    TCP_button3:SetWidth(190)
    TCP_button3:SetHeight(20)
 -----
end

Transmog_DataRefresh()
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Второй список для стандартных сетов и аур. Transmog Default Panel]]
local TDP_scrollFrame
local TDP_numButtons = 9
local TDP_buttonHeight = 70


local function HasSubAura(mainAura)
	if namesWithSubAuras[mainAura] then
		for name, id in pairs(namesWithSubAuras[mainAura]) do
			if tContains(Transmog_SavedAura, id) then
				return id
			end
		end
	else
		return false
	end
end


local function TDP_update()
  FauxScrollFrame_Update(TDP_scrollFrame,#Transmog_TemporaryData1,TDP_numButtons,TDP_buttonHeight)
  for index = 1,TDP_numButtons do
    local TDP_offset = index + FauxScrollFrame_GetOffset(TDP_scrollFrame)
    local TDP_button = TDP_scrollFrame.buttons[index]
    local TDP_button2 = TDP_scrollFrame.buttons2[index]
    local TDP_button3 = TDP_scrollFrame.buttons3[index]
    TDP_button.index = TDP_offset
    if TDP_offset<=#Transmog_TemporaryData1 then
      TDP_button:Show()
	  
      TDP_button2:SetText(Transmog_TemporaryData1[TDP_offset])
    else
      TDP_button:Hide()
    end
    
    if tContains(Transmog_SavedAura, Transmog_TemporaryData3[TDP_offset]) or HasSubAura(Transmog_TemporaryData3[TDP_offset]) then
        TDP_button3:Show()
    else
       TDP_button3:Hide()
    end
  end
end

local function  TDP_Transmog_DataRefresh()
    wipe(Transmog_TemporaryData1)
    wipe(Transmog_TemporaryData2)
    wipe(Transmog_TemporaryData3)
    
        for k,v in pairs(Transmog_TableCash1) do
                if string.find(strlower(v), strlower(Transmog_SearchKey)) then
                            tinsert(Transmog_TemporaryData1,Transmog_TableCash1[k])
                            tinsert(Transmog_TemporaryData2,Transmog_TableCash2[k])
                            tinsert(Transmog_TemporaryData3,Transmog_TableCash3[k])
                end
        end

        TDP_update()
end

local TDP_frame = CreateFrame("Frame","TDP_frame",Transmog_MainPanel)
TDP_frame:SetSize(296,6*70-15)
TDP_frame:SetPoint("CENTER", Transmog_MainPanel, "CENTER",130,-90)
TDP_frame:SetFrameLevel(2)

TDP_scrollFrame = CreateFrame("ScrollFrame","TDP_scrollFrame",TDP_frame,"FauxScrollFrameTemplate")
TDP_scrollFrame:SetPoint("TOPLEFT",0,-8)
TDP_scrollFrame:SetPoint("BOTTOMRIGHT",-19.8,34)
TDP_scrollFrame:SetScript("OnVerticalScroll",function(self,TDP_offset)
  FauxScrollFrame_OnVerticalScroll(self, TDP_offset, TDP_buttonHeight, TDP_update)
end)


local selectedAccessoryWithSubs = ""
local ChooseFrameDropDown = CreateFrame("FRAME", "Transmog_ChooseSubColor", UIParent, "UIDropDownMenuTemplate")

namesWithSubAuras = {
	[84083] = {
		["Коричневый"] = 84083,
		["Черный"] = 84106,
		["Голубой"] = 84107,
		["Голубой с золотым"] = 84108,
		["Голубой с белым"] = 84109,
		["Темно серый"] = 84110,
		["Коричневый с темным"] = 84111,
		["Зеленый"] = 84112,
		["Лаймовый"] = 84113,
		["Лордеронский"] = 84114,
		["Белый с золотым"] = 84115,
		["Фиолетовый"] = 84116,
		["Красный"] = 84117,
		["Красный с золотым"] = 84118,
		["Красный с серебряным"] = 84119,
		["Красный с белым"] = 84120,
		["Белый"] = 84121,
		["Белый с коричневым"] = 84122,	
	}
}
local function LoadSubcolorsButtons(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.hasArrow = false;
	info.isTitle = true;
	info.notCheckable = true;
	info.text = "Вариации";

	UIDropDownMenu_AddButton(info, level);
	for i,tab in pairs(namesWithSubAuras[selectedAccessoryWithSubs]) do
		local info = UIDropDownMenu_CreateInfo()
		info.hasArrow = false;
		info.notCheckable = true;
		info.text = i

		info.func = function(self)
			ApplyAccessory(tab)
			CloseDropDownMenus()
		end

		
		a = UIDropDownMenu_AddButton(info, level);

	end
end


local function ShowSubcolorsMenu(id)
	selectedAccessoryWithSubs = id
	UIDropDownMenu_Initialize(ChooseFrameDropDown,LoadSubcolorsButtons) 
	ToggleDropDownMenu(1, nil, ChooseFrameDropDown, 'cursor', 0, 0);
end

TDP_scrollFrame.buttons = {}
TDP_scrollFrame.buttons2 = {}
TDP_scrollFrame.buttons3 = {}
for i=1,TDP_numButtons do
  TDP_scrollFrame.buttons[i] = CreateFrame("BUTTON", nil, TDP_frame, "SecureHandlerClickTemplate")
  local TDP_button = TDP_scrollFrame.buttons[i]
  TDP_button:SetSize(256,32)
  TDP_button:SetFrameLevel(2)
  TDP_button:SetNormalFontObject("GameFontHighlightLeft")
  TDP_button:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\ButtonSmall.tga")
  TDP_button:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\ButtonSmallH.tga")
  TDP_button:SetPushedTexture("Interface\\NobleProject\\Transmog\\IMG\\ButtonSmallP.tga")
  TDP_button:SetPoint("TOPLEFT",10,-(i-0.75)*39-8)
  TDP_button:SetScript("OnClick", function(self, button)
    if ( button == "LeftButton" ) then
        if SelectTab_MiniFaux == 3 and SelectTabTransmog == 1 then
			function GetIndex(temp)
				enchantcode = temp[self.index]
			end
			if #Transmog_TemporaryData1 > 0 then
				GetIndex(Transmog_TemporaryData3)
			else
				GetIndex(Transmog_EnchantsPresetCode)
			end
			ToggleDropDownMenu(1, nil, Transmog_EnchantsDropDownMenu, 'cursor', 0, 0)
        elseif SelectTab_MiniFaux > 0 and SelectTab_MiniFaux ~= 3 and SelectTabTransmog == 1 then
            if namesWithSubAuras[Transmog_TemporaryData3[self.index]] then
                local id = HasSubAura(Transmog_TemporaryData3[self.index])
                if id then
                    ApplyAccessory(id)
                else
                    ShowSubcolorsMenu(Transmog_TemporaryData3[self.index])
                end
            else
                ApplyAccessory(Transmog_TemporaryData3[self.index])
            end
        else
            if Transmog_button_block == false then
                Transmog_ChatFilter = true
                Transmog_ChatFilter_Animation:Play()

                if Transmog_Settings["weapon"] == true then
                    TransmogSetOnCharacter(Transmog_TemporaryData3[self.index], 1)
                else
                    TransmogSetOnCharacter(Transmog_TemporaryData3[self.index], 0)
                end
            else
                UIErrorsFrame:AddMessage("Нужно подождать.", 1.0, 0.0, 0.0, 53, 1);
            end
        end
		Transmog_button_block = true
		Transmog_buttonBlock:Play()
		PlaySound("gsTitleOptionOK")
	end
end)

 TDP_button:SetScript("OnEnter",function(self, button)
		ShowTmogPrewiew(self,Transmog_TemporaryData3[self.index])
	
	end)
	TDP_button:SetScript("OnLeave",function(self, button)
		HideTmogPrewiew()
	
	end)
 -----
TDP_scrollFrame.buttons2[i] = TDP_scrollFrame.buttons[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local TDP_button2 = TDP_scrollFrame.buttons2[i]
TDP_button2:SetPoint("CENTER", 0,1.5)
TDP_button2:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
TDP_button2:SetText("Код облика")
TDP_button2:SetAlpha(0.70)
TDP_button2:SetWidth(210)
TDP_button2:SetHeight(20)
 -----
TDP_scrollFrame.buttons3[i] = CreateFrame("BUTTON", nil, TDP_frame, "SecureHandlerClickTemplate")
local TDP_button3 = TDP_scrollFrame.buttons3[i]
TDP_button3:SetPoint("TOPLEFT",228,-(i-0.68)*39-8)
TDP_button3:EnableMouse(false)
TDP_button3:SetSize(28,28)
TDP_button3:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\AuraCheck.blp")
TDP_button3:SetAlpha(0.90)
TDP_button3:Hide()
 -----
end

TDP_Transmog_DataRefresh()

----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Свитч между двумя списками и их апдейт.]]
function Transmog_DataRefreshAll()
    if SelectTabTransmog == 1 and SelectTab_MiniFaux == 0 then
        Transmog_DataRefresh()
        TCP_frame:Show()
        TDP_frame:Hide()
    else
        TDP_Transmog_DataRefresh()
        TDP_frame:Show()
        TCP_frame:Hide()
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Макрофрейм.]]
local NUM_TRANSMOG_ICONS_SHOWN = 20;
local NUM_TRANSMOG_ICONS_PER_ROW = 5;
local NUM_TRANSMOG_ICON_ROWS = 4;
TRANSMOG_ICON_ROW_HEIGHT = 36;

function Transmog_IconPopupFrame_OnShow(self)
	Transmog_MacroPopupEditBox:SetFocus();
	Transmog_IconPopupFrame_Update(self);
end

function Transmog_IconPopupFrame_Update(self)
	self = self or Transmog_MacroPopupFrame;
	local numMacroIcons = GetNumMacroIcons();
	local Transmog_macroPopupIcon, Transmog_macroPopupButton;
	local Transmog_macroPopupOffset = FauxScrollFrame_GetOffset(Transmog_MacroPopupScrollFrame);
	local Transmog_index;
	local texture;
	for i=1, NUM_TRANSMOG_ICONS_SHOWN do
		Transmog_macroPopupIcon = getglobal("Transmog_macroPopupButton"..i.."Icon");
		Transmog_macroPopupButton = getglobal("Transmog_macroPopupButton"..i);
		Transmog_index = (Transmog_macroPopupOffset * NUM_TRANSMOG_ICONS_PER_ROW) + i;
		texture = GetMacroIconInfo(Transmog_index);
		if ( Transmog_index <= numMacroIcons ) then
			Transmog_macroPopupIcon:SetTexture(texture);
			Transmog_macroPopupButton:Show();
		else
			Transmog_macroPopupIcon:SetTexture("");
			Transmog_macroPopupButton:Hide();
		end
		if ( Transmog_MacroPopupFrame.selectedIcon and (Transmog_index == Transmog_MacroPopupFrame.selectedIcon) ) then
			Transmog_macroPopupButton:SetChecked(1);
		elseif ( Transmog_MacroPopupFrame.selectedIconTexture ==  texture ) then
			Transmog_macroPopupButton:SetChecked(1);
		else
			Transmog_macroPopupButton:SetChecked(nil);
		end
	end

	FauxScrollFrame_Update(Transmog_MacroPopupScrollFrame, ceil(numMacroIcons / NUM_TRANSMOG_ICONS_PER_ROW) , NUM_TRANSMOG_ICON_ROWS, TRANSMOG_ICON_ROW_HEIGHT );
end

function Transmog_IconPopupFrame_CancelEdit()
	Transmog_MacroPopupFrame:Hide();
    Transmog_CodeInputEditBoxFrame:Hide()
	Transmog_MacroPopupFrame.selectedIcon = nil;
end

function Transmog_IconPopupButton_OnClick(self, button)
	Transmog_MacroPopupFrame.selectedIcon = self:GetID() + (FauxScrollFrame_GetOffset(Transmog_MacroPopupScrollFrame) * NUM_TRANSMOG_ICONS_PER_ROW);
	Transmog_MacroPopupFrame.selectedIconTexture = nil;
	Transmog_IconPopupFrame_Update(Transmog_MacroPopupFrame);
end

function Transmog_IconPopupOkayButton_OnClick(self, button)
	Transmog_MacroPopupFrame:Hide();
    Transmog_CodeInputEditBoxFrame:Hide()
    Transmog_CodeInputEditBox_GetText = Transmog_CodeInputEditBox:GetText()
    if Transmog_NameIconEdit == true then
            for k,v in pairs(Transmog_save1) do
                if v == Transmog_SelectClickedButton1 then
                    if (Transmog_save2[k] == Transmog_SelectClickedButton2) and (Transmog_save3[k] == Transmog_SelectClickedButton3) then
                           if tContains(Transmog_save1,tostring(Transmog_MacroPopupEditBox:GetText())) and v ~= tostring(Transmog_MacroPopupEditBox:GetText()) then
                              print("|cfff0ff00Облик с таким названием уже существует.|r")
                           else
                                if Transmog_MacroPopupEditBox:GetText() ~= nil and Transmog_MacroPopupEditBox:GetText() ~= "" then
                                    tremove(Transmog_save1,k)
                                    tinsert(Transmog_save1,k, Transmog_MacroPopupEditBox:GetText())
                                    print("|cfff0ff00Название обновлено.|r")
                                end
                                if Transmog_MacroPopupFrame.selectedIcon ~= nil then
                                    tremove(Transmog_save2,k)
                                    tinsert(Transmog_save2,k, GetMacroIconInfo(Transmog_MacroPopupFrame.selectedIcon))
                                    print("|cfff0ff00Значок обновлен.|r")
                                end
                                if Transmog_CodeInputEditBox_GetText ~= nil and Transmog_CodeInputEditBox_GetText ~= "" then
                                    local TM_v1, TM_v2, TM_v3, TM_v4, TM_v5, TM_v6, TM_v7, TM_v8, TM_v9, TM_v10, TM_v11, TM_v12, TM_v13, TM_v14 = strsplit("#", Transmog_CodeInputEditBox_GetText, 14)
                                        if TM_v14 == nil then
                                            print("|cfff0ff00Некорректный тип данных.|r")
                                        else
                                            if tonumber(TM_v1..TM_v2..TM_v3..TM_v4..TM_v5..TM_v6..TM_v7..TM_v8..TM_v9..TM_v10..TM_v11..TM_v12..TM_v13..TM_v14) then
                                                tremove(Transmog_save3,k)
                                                tinsert(Transmog_save3,k, TM_v1.."#"..TM_v2.."#"..TM_v3.."#"..TM_v4.."#"..TM_v5.."#"..TM_v6.."#"..TM_v7.."#"..TM_v8.."#"..TM_v9.."#"..TM_v10.."#"..TM_v11.."#"..TM_v12.."#"..TM_v13.."#"..TM_v14)
                                                print("|cfff0ff00Облик обновлен.|r")
                                            else
                                                print("|cfff0ff00Некорректный тип данных.|r")
                                            end
                                        end
                                           Transmog_CodeInputEditBox:SetText("")
                                           Transmog_CodeInputEditBox:ClearFocus()
                               end
                           end
                    end
                end
            end
        Transmog_TableCashUpdate()
        Transmog_DataRefreshAll()
        Transmog_MacroPopupEditBox:SetText("")
        Transmog_MacroPopupFrame.selectedIcon = nil;
    else
        if Transmog_MacroPopupEditBox:GetText() == nil or Transmog_MacroPopupEditBox:GetText() == "" or Transmog_MacroPopupFrame.selectedIcon == nil then
            print("|cfff0ff00Необходимо ввести название и выбрать значок.|r")
            Transmog_MacroPopupEditBox:SetText("")
            Transmog_CodeInputEditBox:SetText("")
            Transmog_MacroPopupFrame.selectedIcon = nil;
        else
            if Transmog_CodeInputEditBox_GetText ~= nil and Transmog_CodeInputEditBox_GetText ~= "" then
                local TM_v1, TM_v2, TM_v3, TM_v4, TM_v5, TM_v6, TM_v7, TM_v8, TM_v9, TM_v10, TM_v11, TM_v12, TM_v13, TM_v14 = strsplit("#", Transmog_CodeInputEditBox_GetText, 14)
                if TM_v14 == nil then
                print("|cfff0ff00Некорректный тип данных.|r")
                else
                    if tonumber(TM_v1..TM_v2..TM_v3..TM_v4..TM_v5..TM_v6..TM_v7..TM_v8..TM_v9..TM_v10..TM_v11..TM_v12..TM_v13..TM_v14) then
                        if tContains(Transmog_save1,tostring(Transmog_MacroPopupEditBox:GetText())) then
                            print("|cfff0ff00Облик с таким названием уже существует.|r")
                        else
                            tinsert(Transmog_save1,Transmog_MacroPopupEditBox:GetText())
                            tinsert(Transmog_save2,GetMacroIconInfo(Transmog_MacroPopupFrame.selectedIcon))
                            tinsert(Transmog_save3, TM_v1.."#"..TM_v2.."#"..TM_v3.."#"..TM_v4.."#"..TM_v5.."#"..TM_v6.."#"..TM_v7.."#"..TM_v8.."#"..TM_v9.."#"..TM_v10.."#"..TM_v11.."#"..TM_v12.."#"..TM_v13.."#"..TM_v14)
                            ---/ Апдейт кнопок списка
                            FauxScrollFrame_Update(TCP_scrollFrame,#Transmog_save1,TCP_numButtons,TCP_buttonHeight)
                            local scrollBar = _G[TCP_scrollFrame:GetName().."ScrollBar"]
                            scrollBar:SetValue(select(2,scrollBar:GetMinMaxValues()))
                            Transmog_DataRefreshAll()
                            ---/
                            print("|cfff0ff00Облик добавлен.|r")
                        end
                    else
                        print("|cfff0ff00Некорректный тип данных.|r")
                    end
                end
                   Transmog_CodeInputEditBox:SetText("")
                   Transmog_CodeInputEditBox:ClearFocus()
                   Transmog_MacroPopupEditBox:SetText("")
                   Transmog_MacroPopupFrame.selectedIcon = nil;
            else
                TransmogElunaSave = true
                CallIds()	
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Инфо-текст для стандартных пресетов..]]
Transmog_DefaultText = TDP_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Transmog_DefaultText:SetPoint("CENTER", 3,255)
Transmog_DefaultText:SetFont("Fonts\\FRIZQT__.ttf", 17, "OUTLINE")
Transmog_DefaultText:SetText("Рекомендуемые стандартные\nоблики от сообщества\nNoblegarden")
Transmog_DefaultText:SetAlpha(0.70)
Transmog_DefaultText:Hide()

--[[Переключение вкладок от стандартных к сохраненным пресетам.]]
 local Transmog_SelectButtonFirst = CreateFrame("BUTTON", "Transmog_SelectButtonFirst", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_SelectButtonFirst:Show()
 Transmog_SelectButtonFirst:SetSize(34,34)
 Transmog_SelectButtonFirst:SetPoint("CENTER", Transmog_MainPanel, "CENTER", -180, 218)
 Transmog_SelectButtonFirst:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\garrison_armorupgrade_result.blp")
 Transmog_SelectButtonFirst:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\garrison_armorupgrade_result.blp")
 Transmog_SelectButtonFirst:RegisterForClicks("AnyUp")
 Transmog_SelectButtonFirst.TransmogTooltip_text = "Сохраненные облики"
 Transmog_SelectButtonFirst:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_SelectButtonFirst:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_SelectButtonFirst:SetScript("OnClick", function(self, button)
     ---
     Transmog_ToggleTabButtons(1)
     Transmog_DefaultText:Hide()
     TransmogFrameSearchFrame:Show()
     ToggleTransmogItemSlots(1)
	 Transmog_DisEnchantsButton:Show()
     BarberParent:Hide()
     ---
 SelectTabTransmog = 1
 Transmog_SelectFunc()
 UpdateTransmogModel()
 PlaySound("igCharacterInfoTab");
 if Transmog_CodeListFrame:IsVisible() then
     TDP_frame:Hide()
     TCP_frame:Hide()
 end
end)

 local  Transmog_SelectButtonSecond = CreateFrame("BUTTON", "Transmog_SelectButtonSecond", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_SelectButtonSecond:Show()
 Transmog_SelectButtonSecond:SetSize(34,34)
 Transmog_SelectButtonSecond:SetPoint("CENTER", Transmog_SelectButtonFirst, "CENTER", 45, 0)
 Transmog_SelectButtonSecond:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\inv_misc_scrollunrolled04_CB.blp")
 Transmog_SelectButtonSecond:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\inv_misc_scrollunrolled04_result.blp")
 Transmog_SelectButtonSecond:RegisterForClicks("AnyUp")
 Transmog_SelectButtonSecond.TransmogTooltip_text = "Стандартные облики"
 Transmog_SelectButtonSecond:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_SelectButtonSecond:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_SelectButtonSecond:SetScript("OnClick", function(self, button)
     ---
     Transmog_ToggleTabButtons(0)
     Transmog_DefaultText:Show()
     TransmogFrameSearchFrame:Show()
     ToggleTransmogItemSlots(1)
     BarberParent:Hide()
	 Transmog_DisEnchantsButton:Show()
     ---
 SelectTabTransmog = 2
 Transmog_SelectFunc()
 UpdateTransmogModel()
 PlaySound("igCharacterInfoTab");
 if Transmog_CodeListFrame:IsVisible() then
     TDP_frame:Hide()
     TCP_frame:Hide()
 end
end)

 local  Transmog_SelectButtonThird = CreateFrame("BUTTON", "Transmog_SelectButtonThird", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_SelectButtonThird:SetSize(34,34)
 Transmog_SelectButtonThird:SetPoint("CENTER", Transmog_SelectButtonFirst, "CENTER", 90, 0)
 Transmog_SelectButtonThird:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\Barber_CB.blp")
 Transmog_SelectButtonThird:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\Barber_CB.blp")
 Transmog_SelectButtonThird:RegisterForClicks("AnyUp")
 Transmog_SelectButtonThird.TransmogTooltip_text = "Парикмахерская"
 Transmog_SelectButtonThird:SetScript("OnEnter", Transmog_GameTooltipOnEnter)
 Transmog_SelectButtonThird:SetScript("OnLeave", Transmog_GameTooltipOnLeave)
 Transmog_SelectButtonThird:SetScript("OnClick", function(self, button)
     ---
     Transmog_ToggleTabButtons(0)
     Transmog_DefaultText:Hide()
     TransmogFrameSearchFrame:Hide()
     ToggleTransmogItemSlots(0)
     UpdateBarberModel()
	 Transmog_DisEnchantsButton:Hide()
     BarberParent:Show()
     ---
 SelectTabTransmog = 3
 Transmog_SelectFunc()
 UpdateTransmogModel()
 PlaySound("igCharacterInfoTab");
 BarberModelRotate()
 

 ----------------
 -- * * * * * * *
 ----------------
TDP_frame:Hide()
TCP_frame:Hide()
Transmog_CodeListFrame:Hide()
end)

local Transmog_SelectLeft = Transmog_SelectButtonFirst:CreateTexture("ARTWORK", 1) --// Стрелка влево.
Transmog_SelectLeft:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\left.blp")
Transmog_SelectLeft:SetPoint("CENTER", Transmog_SelectButtonFirst, "CENTER", -30, 0)
Transmog_SelectLeft:SetSize(45,45)

local Transmog_SelectRight = Transmog_SelectButtonThird:CreateTexture("ARTWORK", 1) --// Стрелка вправо.
Transmog_SelectRight:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\right.blp")
Transmog_SelectRight:SetPoint("CENTER", Transmog_SelectButtonThird, "CENTER", 30, 0)
Transmog_SelectRight:SetSize(45,45)

--[[Обводка золотой рамкой.]]
 local Transmog_SelectFrame1 = CreateFrame("BUTTON", "Transmog_SelectFrame1", Transmog_SelectButtonFirst, "SecureHandlerClickTemplate");
 Transmog_SelectFrame1:SetSize(43,43)
 Transmog_SelectFrame1:SetPoint("CENTER", Transmog_SelectButtonFirst, "CENTER", 0, 0)
 Transmog_SelectFrame1:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\GoldFrame.blp")
----------------------------------------------------------------------------------------------------------------------------------------------------
--[["Деактивация" иконок на табах переключения.]]
function Transmog_SelectFunc()
    Transmog_SelectButtonFirst:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\garrison_armorupgrade_CB.blp")
    Transmog_SelectButtonSecond:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\inv_misc_scrollunrolled04_CB.blp")
    Transmog_SelectButtonThird:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\Barber_CB.blp")
 if SelectTabTransmog == 1 then
     Transmog_SelectFrame1:SetPoint("CENTER", Transmog_SelectButtonFirst, "CENTER", 0, 0)
     Transmog_SelectButtonFirst:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\garrison_armorupgrade_result.blp")
 elseif SelectTabTransmog == 2 then
     Transmog_SelectFrame1:SetPoint("CENTER", Transmog_SelectButtonSecond, "CENTER", 0, 0)
     Transmog_SelectButtonSecond:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\inv_misc_scrollunrolled04_result.blp")
 elseif SelectTabTransmog == 3 then
     Transmog_SelectFrame1:SetPoint("CENTER", Transmog_SelectButtonThird, "CENTER", 0, 0)
     Transmog_SelectButtonThird:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\Icons\\Barber.blp")
 end
 Transmog_TableCashUpdate()
 Transmog_DataRefreshAll()
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Применяет бэкграунд при открытии окна в зависимости от локации/расы персонажа.]]
local function Transmog_BackTextureChange()
local Transmog_BackTexture = "Interface\\NobleProject\\Transmog\\IMG\\Background\\transmogbackground"
local ZoneName = GetZoneText()
    if ZoneName == "Гилнеас" then
        Transmog_UnitModel_texture1:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Background\\transmogbackgroundworgen.blp")
    else
        local race, raceEN = UnitRace("player");
        Transmog_UnitModel_texture1:SetTexture("Interface\\NobleProject\\Transmog\\IMG\\Background\\transmogbackground"..raceEN)
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------
function Transmog_ListFramesOff()
     TDP_frame:Hide()
     TCP_frame:Hide()
end
----------------------------------------------------------------------------------------------------------------------------------------------------
SLASH_NOBLETRANSMOG1 = "/transmog"
SlashCmdList["NOBLETRANSMOG"] = function(msg, editbox)
local msg, arg = msg:match("^(%S*)%s*(.-)$");
   if msg == "" or msg == "show" then
       Transmog_UnitModel:SetUnit("player");
       Transmog_ItemUpdate()
       Transmog_TableCashUpdate()
       Transmog_DataRefreshAll()
       Transmog_BackTextureChange()
       Transmog_MainPanel:Show()
       BarberTextCorrect()
       SetWeaponChecked()
   elseif msg == "reset" and arg == "all" then
       wipe(Transmog_save1)
       wipe(Transmog_save2)
       wipe(Transmog_save3)
   else
       Transmog_ChatFilter = true
       Transmog_ChatFilter_Animation:Play()
        if Transmog_Settings["weapon"] == true then
            TransmogSetOnCharacter(tostring(msg, arg), 1)
        else
            TransmogSetOnCharacter(tostring(msg, arg), 0)
        end
   end
end





----Эзил делает рост <3

CharStatsInterface = CharStatsInterface or {}
local WHITE_COLOR = '|cffffffff'
local HEIGHT_COOLDOWN_SECONDS = 5
TransmogHeight = {}
TransmogHeight.lastUpdate = TransmogHeight.lastUpdate or 0 

local HeightButton = CreateFrame("BUTTON", "Transmog_HeightButton", Transmog_MainPanel, "SecureHandlerClickTemplate");
HeightButton:SetSize(85, 32)
HeightButton:SetFrameStrata("MEDIUM")
HeightButton:SetFrameLevel(2)
HeightButton:SetPoint("CENTER", Transmog_MainPanel, "CENTER",-72,170)
HeightButton:SetNormalTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\button4.tga")
HeightButton:SetHighlightTexture("Interface\\NobleProject\\Transmog\\IMG\\New\\ButtonH.tga")
HeightButton:RegisterForClicks("AnyUp")
HeightButton:SetAlpha(0.8)

local HeightButton_text = HeightButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
HeightButton_text:SetPoint("CENTER", HeightButton, "CENTER", 0, 0)
HeightButton_text:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
HeightButton_text:SetText("Рост")
HeightButton_text:SetAlpha(0.9)
--simple round number func  ------------------Жесткий с3.14здинг кода.
  local SimpleRound = function(val,valStep)
    return floor(val/valStep)*valStep
  end
 
  --basic slider func
  local CreateBasicSlider = function(parent, name, title, minVal, maxVal, valStep)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    --slider:SetValue(0)
    slider:SetValueStep(valStep)
    slider.text = _G[name.."Text"]
	slider.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	slider:SetWidth(200)
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(tostring(minVal))
    slider.textHigh:SetText(tostring(1.15))
    slider.textLow:SetTextColor(0.4,0.4,0.4)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)
    editbox:SetSize(50,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self,value)
      self.editbox:SetText(SimpleRound (value,valStep))
    end)
    editbox:SetScript("OnTextChanged", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
      end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
         self:ClearFocus()
      end
    end)
    slider.editbox = editbox
    return slider
  end
 
local HeightSlider = CreateBasicSlider(Transmog_MainPanel, "Transmog_HeightSlider", "Изменение роста", 0.85, 1.1501, 0.001)
HeightSlider:SetPoint("CENTER", Transmog_MainPanel, "CENTER",100,170)
HeightSlider:HookScript("OnValueChanged", function(self,value)
	
end)

HeightSlider:SetPoint("CENTER", Transmog_MainPanel, "CENTER",100,170)

local HeightInfo = Transmog_MainPanel:CreateFontString("Transmog_HeightInfo", "OVERLAY", "GameFontHighlightLarge")
HeightInfo:SetPoint("CENTER", Transmog_MainPanel, "CENTER",110,137)
HeightInfo:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
HeightInfo:SetWidth(250)
HeightInfo:SetHeight(250)
HeightInfo:SetText("1.15 - Крайне высокий \n1 - Стандартный\n0.85 - Очень низкий")
HeightInfo:SetJustifyH("CENTER")
HeightInfo:SetAlpha(0.6)
local HeightApplyEdit =  CreateFrame("Button", "HeightApplyEdit", Transmog_MainPanel)
HeightApplyEdit:SetWidth(25)
HeightApplyEdit:SetHeight(25)

HeightApplyEdit.SelectTexture = HeightApplyEdit:CreateTexture("ARTWORK")
HeightApplyEdit.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\readycheck-ready.blp")
HeightApplyEdit.SelectTexture:SetPoint("CENTER",HeightApplyEdit,0,0)
HeightApplyEdit.SelectTexture:SetSize(25, 25)
HeightApplyEdit:SetPoint("CENTER", Transmog_MainPanel, "CENTER",250,140)
HeightApplyEdit:SetFrameLevel(6)
HeightApplyEdit:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")

HeightApplyEdit:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine("Установить")
    GameTooltip:Show()
  end)
  HeightApplyEdit:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	

local HeightDeclineEdit =  CreateFrame("Button", "HeightDeclineEdit", Transmog_MainPanel)
HeightDeclineEdit:SetWidth(25)
HeightDeclineEdit:SetHeight(25)

HeightDeclineEdit.SelectTexture = HeightDeclineEdit:CreateTexture("ARTWORK")
HeightDeclineEdit.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\readycheck-notready.blp")
HeightDeclineEdit.SelectTexture:SetPoint("CENTER",HeightDeclineEdit,0,0)
HeightDeclineEdit.SelectTexture:SetSize(25, 25)
HeightDeclineEdit:SetPoint("CENTER", Transmog_MainPanel, "CENTER",220,140)
HeightDeclineEdit:SetFrameLevel(6)
HeightDeclineEdit:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")

HeightDeclineEdit:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine("Отменить")
    GameTooltip:Show()
  end)
  HeightDeclineEdit:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	



local function HideTopButtons()
	Transmog_CodeOutfit:Hide()
	Transmog_SaveOutfits:Hide()
	Transmog_OutfitsMiniButton:Hide()
	Transmog_BagMiniButton:Hide()
	Transmog_BeltsMiniButton:Hide()
	Transmog_EnchantsMiniButton:Hide()
	HeightApplyEdit:Show()
	HeightDeclineEdit:Show()
	HeightSlider:Show()
	HeightInfo:Show()
end
local function ShowTopButtons()
	Transmog_CodeOutfit:Show()
	Transmog_SaveOutfits:Show()
	Transmog_OutfitsMiniButton:Show()
	Transmog_BagMiniButton:Show()
	Transmog_BeltsMiniButton:Show()
	Transmog_EnchantsMiniButton:Show()
	HeightApplyEdit:Hide()
	HeightDeclineEdit:Hide()
	HeightSlider:Hide()
	HeightInfo:Hide()

end

function CharStatsInterface.HandleHeightUpdate(height)
	HeightSlider:SetValue(tonumber(height))
	HeightSlider.editbox:SetText(height)
end

HeightApplyEdit:Hide()
HeightDeclineEdit:Hide()
HeightSlider:Hide()
HeightInfo:Hide()
HeightApplyEdit:SetScript("OnClick",function(self)
	local newValue = HeightSlider.editbox:GetText()
	if tonumber(newValue) > 1.15 or tonumber(newValue) < 0.85 then
		print("Некорректное значение")
		return false
	end
	CharStatsInterface.SendNewHeight(newValue)
	ShowTopButtons()
	TransmogHeight.lastUpdate = GetTime()
end)
HeightDeclineEdit:SetScript("OnClick",function(self)
	ShowTopButtons()
end)
HeightButton:SetScript("OnClick", function(self, button)
	if GetTime() - TransmogHeight.lastUpdate > HEIGHT_COOLDOWN_SECONDS then
		CharStatsInterface.GetHeight()
		HideTopButtons()
	else
		print("Вы можете менять ваш рост чаще чем раз в 5 секунд.")
	end
	
end)


function Transmog_MainPanelOnOff()
	ShowTopButtons()
    if Transmog_MainPanel:IsVisible() then
        Transmog_MainPanel:Hide()
    else
       Transmog_UnitModel:SetUnit("player");
       Transmog_ItemUpdate()
       Transmog_TableCashUpdate()
       Transmog_DataRefreshAll()
       Transmog_BackTextureChange()
       Transmog_MainPanel:Show()
       BarberTextCorrect()
       if SelectTabTransmog == 3 then
        UpdateBarberModel()
       end
       SetWeaponChecked()
    end
end




---Эзил делает превью <3

local PreviewFrame = CreateFrame("Frame", "Tmog_Preview", UIParent)
PreviewFrame:SetWidth(210)
PreviewFrame:SetHeight(280)
PreviewFrame:SetPoint("CENTER", MainFrame, "CENTER",0,0)
PreviewFrame:SetBackdrop( { bgFile="Interface/FrameGeneral/UI-Background-Marble", insets={left=8,right=8,top=8,bottom=8}, tileSize=256, tile=true, edgeFile="Interface\\AddOns\\GameObjectShop\\assets\\f_edge.blp", edgeSize = 32 } )
PreviewFrame.Model = CreateFrame("DressUpModel", "TmogModelPreview",PreviewFrame) ---// Фрейм модели игрока
PreviewFrame.Model:SetSize(185, 200)
PreviewFrame.Model:SetScale(2)
PreviewFrame.Model:SetPoint("CENTER", 0,0)
PreviewFrame:SetFrameLevel(10)
PreviewFrame:Hide()


function ShowTmogPrewiew(parent,code)
	if string.len(code) < 14 then
		return false
	end
	PreviewFrame:Show()
	PreviewFrame.Model:SetUnit("Player")
	PreviewFrame.Model:RefreshUnit()
	PreviewFrame.Model:SetScale(1.3)
	PreviewFrame.Model:Undress()
	items = {strsplit("#", code, 14)}
    for i = 14,1,-1 do
		
		if items[i] ~= '0' and items[i] ~= '44724' then
			PreviewFrame.Model:TryOn(items[i])
		end
    end
	
	PreviewFrame:SetPoint("CENTER",parent,220,110)
end

function HideTmogPrewiew()
	PreviewFrame:Hide()
end

-- Дебаг

--[[ function PrintFunc()
	print("Temp 1:")
	for i = 1,#Transmog_TemporaryData1 do
		print(Transmog_TemporaryData1[i])
	end
	print("Temp 2:")
	for i = 1,#Transmog_TemporaryData2 do
		print(Transmog_TemporaryData2[i])
	end
	print("Temp 3:")
	for i = 1,#Transmog_TemporaryData3 do
		print(Transmog_TemporaryData3[i])
	end
end ]]