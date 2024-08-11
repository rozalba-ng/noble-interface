

--[[──────────────────▄▄───▄▄▄▄▄▄▀▀▀▄──▄
────────────────▄▀──▀▀█▄▄──▄────█▄█▄▀▀▄▄▄▄
─Я РУССКИЙ ────▀█▀────▀▀▀▀█▄▄▄▄───▄▄────▀▀▀▀
─────────────▄▀▀▀▀▀──▀█▄▄▄▄▄─▀▀▀▀▀█▄███▀
──────────────▀█▄▄▄──▀▀─▄▄▄▄──────────▀▀▀▀█▀▀▀
───────▄▀▀▀▄▄▀▀████▀█▄▄▄▄▄▄▄▄▄▄▄───▄▄▄▄──▄█░▄█
────────▀▄▄▄▀▀██▀▀▀▄█─███▄──██─────▀██▀▀─█░░██
────────────▀█─▀▀█▄█▄─▀▀▀───█────────────▀█░▀█
─────────▄▄▀▀─▀▀▀▀░░▀█────▄█▄▀────────────█░░░
───▄▀▀▀▀▀░░░░░░░░░░░░░▀██▀▀▄▄▀▀──────────██░░░
▄▀▀▄████░░███████░░▄▄▄▄░░▀█▄─▀▀──────────▀█▄▄░
█░░█████▄▄███████▄██████▄▄░▀█──███▄▄────────█▄
█░░░▀▀▀▀▀▀▀▀▀▀▀░░░░░░░░░▀▀▀░░█─▀███▀───────▄█▀
─▀▀▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░▄▀─────────────▀█░
───▄▀▄▄▀░░░░░░░░░░░░░░░░░░░░█────────────────█
▀▀▀─▀▄▀█░░░░░░░░░░░░░░░░░░░░█───────────────▄▀
─▄▄▀▀──▀▄░░░░░░░░░░░░░░░░░░█────────────────█░
▀────────▀▄░░░░░░░░░░░░░░▄▀──────────▄█▄▄────█
───────────▀▄▄▄▄░░░░░▄▄▄▀────────────▀██▀────█
────────────█░░░▀▀▀▀██████████▀▀▀▀▀▀▄▄▄▄▄▄▄▄▄█
───────────▄▀░░░░░░░█▒▒▒▒▒▒▒▒█░░░░░░░░░▄▄░░░░█
───────────▀▄▄▄░░░░░█▒▒▒▒▒▒▒▒█░░░░░░░░░▀█▀░░░█ --]]



local elementsToHide = {}


local function MakeHideable(frame)
	frame.show = frame:CreateAnimationGroup() 
	frame.show_start = frame.show:CreateAnimation("Alpha")
	frame.show_start:SetChange(-1)
	frame.show_start:SetDuration(0)
	frame.show_start:SetSmoothing("OUT")
	frame.show_process = frame.show:CreateAnimation("Alpha")
	frame.show_process:SetChange(1)
	frame.showed = false
	frame.show_process:SetDuration(0.3)
	frame.show_process:SetSmoothing("OUT")
	frame.show_process:SetScript("OnFinished", function(self)
		frame:Show()
	end)

	frame.hide = frame:CreateAnimationGroup() 
	frame.hide_start = frame.hide:CreateAnimation("Alpha")
	frame.hide_start:SetChange(1)
	frame.hide_start:SetDuration(0)
	frame.hide_start:SetSmoothing("OUT")
	frame.hide_process = frame.hide:CreateAnimation("Alpha")
	frame.hide_process:SetChange(-1)
	frame.hide_process:SetDuration(0.3)
	frame.hide_process:SetSmoothing("OUT")
	frame.hide_process:SetScript("OnFinished", function(self)
		frame:Hide()
	end)

	table.insert(elementsToHide,frame)
end
MakeHideable(MultiBarRight)
MakeHideable(MultiBarLeft)
MakeHideable(WatchFrame)
MakeHideable(DurabilityFrame)

MasterAddon = MasterAddon or {}
MasterAddon.minimapIcons = MasterAddon.minimapIcons or false

SideMainAddon = SideMainAddon or {}

local function ShowOrHide(frame)
	if not frame:IsShown() then 
		frame:Show() 
	else 
		frame:Hide()
	end
end

local function CallChangeClassMenu()
	AIO.Handle("ProgressCommunicate","CallClassChangeMenu") --Хэндлер из аддона ProgressCommunicate
end





--[[ 

 @    @@        @@@      &@     @@      @@  @@@@@@&        /@#    @@      @@   @
 @    @(@      @@@@     @@ @     %@    @@   @@     @@     /@ @/    ,@*   @@    @
 @    @ *@    @@ @@    @@   @      @@#@     @@      @&   ,@   @/     @@ @.     @
 @    @. .@  @@  @@   #@%%%%%@      @@      @@      @*   @%%%%%@*     @@       @
 @    @.   @@@   @@  (@      ,@     @@      @@    @@*  .@       @.    @@       @
 
--]]

-- Команды

-- MainFrame
local CommandsMainFrame = CreateFrame("Frame", "CommandsMainFrame", UIParent)
CommandsMainFrame:SetSize(480, 250)
CommandsMainFrame:Hide()
CommandsMainFrame:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 10, 0)
CommandsMainFrame:EnableMouse()
CommandsMainFrame:SetFrameStrata("MEDIUM")
CommandsMainFrame:SetMovable(true)
CommandsMainFrame:SetClampedToScreen(true)

local texture = CommandsMainFrame:CreateTexture(nil, "BACKGROUND")
texture:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")
texture:SetAllPoints(CommandsMainFrame)

-- Заголовок
local CommandTitle = CommandsMainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
CommandTitle:SetPoint("CENTER", texture, "CENTER", 53, 110)
CommandTitle:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
CommandTitle:SetWidth(250)
CommandTitle:SetHeight(40)
CommandTitle:SetText("|cffff9716Полезные команды|r")
CommandTitle:SetJustifyH("CENTER")

-- Название категории
local CategoryTitle = CommandsMainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
CategoryTitle:SetPoint("CENTER", texture, "CENTER", 65, -99)
CategoryTitle:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
CategoryTitle:SetWidth(250)
CategoryTitle:SetHeight(40)
CategoryTitle:SetText(" ")
CategoryTitle:SetJustifyH("CENTER")

-- Кнопка закрытия
local ButtonClose = CreateFrame("BUTTON", "ButtonClose", CommandsMainFrame, "SecureHandlerClickTemplate")
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(32, 32)
ButtonClose:SetPoint("TOPRIGHT", CommandsMainFrame, 0, 0)
ButtonClose:SetScript("OnClick", function(self)
    CommandsMainFrame:Hide()
end)
ButtonClose:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
end)
ButtonClose:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Тогглер команд
function CommandsToggler()
    if not CommandsMainFrame:IsShown() then
        CommandsMainFrame:Show()
    else
        CommandsMainFrame:Hide()
    end
end

-- Категории
local CategoryFrame = CreateFrame("Frame", nil, CommandsMainFrame)
CategoryFrame:SetWidth(100)
CategoryFrame:SetHeight(480)
CategoryFrame:SetPoint("LEFT", CommandsMainFrame, "CENTER", 0, 0)

-- Рамка категорий
local CategoryFrameBackground = CreateFrame("Frame", nil, CategoryFrame)
CategoryFrameBackground:SetWidth(120)
CategoryFrameBackground:SetHeight(230)
CategoryFrameBackground:EnableMouse(true)
CategoryFrameBackground:SetPoint("LEFT", CommandsMainFrame, "CENTER", -230, 0)
CategoryFrameBackground:SetBackdrop(
    {
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        edgeSize = 20,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    }
)
CategoryFrameBackground:SetMovable(true)

-- Двигать окно
CommandsMainFrame:SetScript("OnMouseDown", function(self)
    self:StartMoving()
end)
CommandsMainFrame:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
end)

-- Названия страниц и список страниц
local pages = {
    [1] = {title = "Для игры"},
    [2] = {title = "Вспомогательные"},
    [3] = {title = "Объекты"},
}
local currentPage = 1

-- Стрелки и страницы
local function UpdateArrowVisibility()
    if currentPage == 1 then
        LeftArrow:Hide()
    else
        LeftArrow:Show()
    end

    if currentPage == #pages then
        RightArrow:Hide()
    else
        RightArrow:Show()
    end
end

-- Скопировать ссылку
local linkToCopy = "https://docs.google.com/spreadsheets/d/1r0slVSWi3LkoIizkq-OHWGNRBbFvX-DibWJXr5vZMEM/edit#gid=1118297735"

StaticPopupDialogs["COPY_SOUND_LINK"] = {
    text = "Скопируйте ссылку и вставьте в браузер.",
    button1 = "Закрыть",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    hasEditBox = true,
    OnShow = function(self, data)
        self.editBox:SetText(linkToCopy)
        self.editBox:SetFocus()
        self.editBox:HighlightText()
    end,
    OnAccept = function(self, data)
        self.editBox:HighlightText()
		self:Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
    end,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Окно ролла
StaticPopupDialogs["DICE_ROLL_VALUE"] = {
    text = "Введите значение.",
    button1 = "Бросить кость",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    hasEditBox = true,
    OnShow = function(self, data)
        self.editBox:SetFocus()
        self.editBox:HighlightText()
    end,
    OnAccept = function(self, data)
        self.editBox:HighlightText()
		SendChatMessage(".roll " ..self.editBox:GetText())
		self:Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
    end,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Кнопки первой страницы

-- .carry
local CarryBtn = CreateFrame("BUTTON", "CarryBtn", CommandsMainFrame, "UIPanelButtonTemplate")
CarryBtn:SetText("Поднять цель на плечо")
CarryBtn:SetSize(170, 25)
CarryBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 80)
CarryBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(CarryBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.carry] |rОтправляет игроку в цели запрос на поднятие его персонажа к Вам на плечо.\nРаботает не со всеми расами.")
    GameTooltip:Show()
end)
CarryBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
CarryBtn:SetScript("OnClick", function()
    SendChatMessage(".carry")
end)

-- .drop
local DropBtn = CreateFrame("BUTTON", "DropBtn", CommandsMainFrame, "UIPanelButtonTemplate")
DropBtn:SetText("Скинуть с плеча")
DropBtn:SetSize(170, 25)
DropBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 80)
DropBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(DropBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.drop] |rКоманда сбрасывает находящегося на плече персонажа.")
    GameTooltip:Show()
end)
DropBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
DropBtn:SetScript("OnClick", function()
    SendChatMessage(".drop")
end)

-- .roll
local RollBtn = CreateFrame("BUTTON", "RollBtn", CommandsMainFrame, "UIPanelButtonTemplate")
RollBtn:SetText("Бросить ролл")
RollBtn:SetSize(170, 25)
RollBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 50)
RollBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(RollBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.roll число] |rБросок кости, которую видят все в радиусе 20 метров.\nЧисло может быть любым.")
    GameTooltip:Show()
end)
RollBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
RollBtn:SetScript("OnClick", function()
    StaticPopup_Show("DICE_ROLL_VALUE")
end)

-- .playsound
local PlaySoundBtn = CreateFrame("BUTTON", "PlaySoundBtn", CommandsMainFrame, "UIPanelButtonTemplate")
PlaySoundBtn:SetText("Воспроизвести звук")
PlaySoundBtn:SetSize(170, 25)
PlaySoundBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 50)
PlaySoundBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(PlaySoundBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.playsound ID] |rКоманда для воспроизведения звука из файлов игры.\nПо нажатию можно будет скопировать ссылку со списком звуков.")
    GameTooltip:Show()
end)
PlaySoundBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
PlaySoundBtn:SetScript("OnClick", function()
    StaticPopup_Show("COPY_SOUND_LINK")
end)

-- .pet
local PetBtn = CreateFrame("BUTTON", "PetBtn", CommandsMainFrame, "UIPanelButtonTemplate")
PetBtn:SetText("Команды спутников")
PetBtn:SetSize(170, 25)
PetBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 20)
PetBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(PetBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.pet] |rИспользование команды позволит узнать все вспомогательные команды для взаимодействия со спутниками.")
    GameTooltip:Show()
end)
PetBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
PetBtn:SetScript("OnClick", function()
    SendChatMessage(".pet")
end)

-- Кнопки второй страницы

-- .gps
local GpsBtn = CreateFrame("BUTTON", "GpsBtn", CommandsMainFrame, "UIPanelButtonTemplate")
GpsBtn:SetText("Узнать координаты")
GpsBtn:SetSize(170, 25)
GpsBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 80)
GpsBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(GpsBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.gps] |rКоманда позволяет узнать технические координаты персонажа.")
    GameTooltip:Show()
end)
GpsBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
GpsBtn:SetScript("OnClick", function()
    SendChatMessage(".gps")
end)

-- .clearauras
local ClearAurasBtn = CreateFrame("BUTTON", "ClearAurasBtn", CommandsMainFrame, "UIPanelButtonTemplate")
ClearAurasBtn:SetText("Снять с себя ауры")
ClearAurasBtn:SetSize(170, 25)
ClearAurasBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 80)
ClearAurasBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(ClearAurasBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.clearauras] |rКоманда снимает с вашего персонажа все ауры.")
    GameTooltip:Show()
end)
ClearAurasBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
ClearAurasBtn:SetScript("OnClick", function()
    SendChatMessage(".clearauras")
end)

-- .leavephase
local LeavePhaseBtn = CreateFrame("BUTTON", "LeavePhaseBtn", CommandsMainFrame, "UIPanelButtonTemplate")
LeavePhaseBtn:SetText("Выйти из фазы")
LeavePhaseBtn:SetSize(170, 25)
LeavePhaseBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 50)
LeavePhaseBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(LeavePhaseBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.leavephase] |rКоманда выводит вашего персонажа из фазы.")
    GameTooltip:Show()
end)
LeavePhaseBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
LeavePhaseBtn:SetScript("OnClick", function()
    SendChatMessage(".leavephase")
end)

-- .charcust
local CharcustBtn = CreateFrame("BUTTON", "CharcustBtn", CommandsMainFrame, "UIPanelButtonTemplate")
CharcustBtn:SetText("Узнать внешность")
CharcustBtn:SetSize(170, 25)
CharcustBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 50)
CharcustBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(CharcustBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.charcust] |rКоманда выводит в чат технические значения внешности Вашего персонажа.")
    GameTooltip:Show()
end)
CharcustBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
CharcustBtn:SetScript("OnClick", function()
    SendChatMessage(".charcust")
end)

-- .weather cancel
local WeatherClearBtn = CreateFrame("BUTTON", "WeatherClearBtn", CommandsMainFrame, "UIPanelButtonTemplate")
WeatherClearBtn:SetText("Убрать погоду ведущего")
WeatherClearBtn:SetSize(170, 25)
WeatherClearBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 20)
WeatherClearBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(WeatherClearBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.weather cancel] |rКоманда выключит у Вас погоду, установленную ведущим.")
    GameTooltip:Show()
end)
WeatherClearBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
WeatherClearBtn:SetScript("OnClick", function()
    SendChatMessage(".weather cancel")
end)

-- .unstuck
local UnstuckBtn = CreateFrame("BUTTON", "UnstuckBtn", CommandsMainFrame, "UIPanelButtonTemplate")
UnstuckBtn:SetText("Персонаж застрял!")
UnstuckBtn:SetSize(170, 25)
UnstuckBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 20)
UnstuckBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(UnstuckBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.unstuck] |rИспользование команды поможет в случае, если Ваш персонаж застрял или способность телепортации на перезарядке.")
    GameTooltip:Show()
end)
UnstuckBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
UnstuckBtn:SetScript("OnClick", function()
    SendChatMessage(".unstuck")
end)

-- Кнопки третьей страницы

-- .gobinfo
local GobInfoBtn = CreateFrame("BUTTON", "GobInfoBtn", CommandsMainFrame, "UIPanelButtonTemplate")
GobInfoBtn:SetText("Информация об объекте")
GobInfoBtn:SetSize(170, 25)
GobInfoBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 80)
GobInfoBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(GobInfoBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.gobinfo] |rКоманда выводит в чат информацию по ближайшему к персонажу объекту.")
    GameTooltip:Show()
end)
GobInfoBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
GobInfoBtn:SetScript("OnClick", function()
    SendChatMessage(".gobinfo")
end)

-- .movego
local MoveGoBtn = CreateFrame("BUTTON", "MoveGoBtn", CommandsMainFrame, "UIPanelButtonTemplate")
MoveGoBtn:SetText("Двигать объект")
MoveGoBtn:SetSize(170, 25)
MoveGoBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 80)
MoveGoBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(MoveGoBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.movego] |rКоманда открывает интерфейс взаимодействия с объектом.\n|cffff9716Важно: |rкоманда будет применена к ближайшему к персонажу объекту.")
    GameTooltip:Show()
end)
MoveGoBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
MoveGoBtn:SetScript("OnClick", function()
    SendChatMessage(".movego")
end)

-- .gathergos
local GathergosBtn = CreateFrame("BUTTON", "GathergosBtn", CommandsMainFrame, "UIPanelButtonTemplate")
GathergosBtn:SetText("Забрать объекты")
GathergosBtn:SetSize(170, 25)
GathergosBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", -23, 50)
GathergosBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(GathergosBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffff9716[.gathergos] |rКоманда позволит собрать все свои объекты в радиусе.")
    GameTooltip:Show()
end)
GathergosBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
GathergosBtn:SetScript("OnClick", function()
    SendChatMessage(".gathergos")
end)

-- Режим строительства
local BuildModBtn = CreateFrame("Button", BuildModBtn, CommandsMainFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
BuildModBtn:SetText("Режим строительства")
BuildModBtn:SetSize(170, 25)
BuildModBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 50)
BuildModBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(BuildModBtn, "ANCHOR_RIGHT")
    GameTooltip:SetText("Позволит подсветить все объекты рядом, а также взаимодействовать со своими объектами.\nТакже можно найти в книге заклинаний - |cffff9716[Режим строительства]|r.")
    GameTooltip:Show()
end)
BuildModBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
BuildModBtn:SetAttribute("type", "macro")
BuildModBtn:SetAttribute("macrotext", "/cast Режим строительства")

--Кнопки четвёртой страницы

-- -- /rq
-- local RaidQueueBtn = CreateFrame("Button", RaidQueueBtn, CommandsMainFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
-- RaidQueueBtn:SetText("Случайная")
-- RaidQueueBtn:SetSize(80, 25)
-- RaidQueueBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 50, 80)
-- RaidQueueBtn:SetScript("OnEnter", function()
    -- GameTooltip:SetOwner(RaidQueueBtn, "ANCHOR_RIGHT")
    -- GameTooltip:SetText("|cffff9716[/rq] |rВыводит в рейд сообщение со случайной очередью игроков.\nНе вносит в список лидера рейда и помощников.")
    -- GameTooltip:Show()
-- end)
-- RaidQueueBtn:SetScript("OnLeave", function()
    -- GameTooltip:Hide()
-- end)
-- RaidQueueBtn:SetAttribute("type", "macro")
-- RaidQueueBtn:SetAttribute("macrotext", "/rq")

-- -- /init
-- local InitBtn = CreateFrame("Button", InitBtn, CommandsMainFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
-- InitBtn:SetText("Инициатива")
-- InitBtn:SetSize(80, 25)
-- InitBtn:SetPoint("CENTER", CommandsMainFrame, "CENTER", 150, 80)
-- InitBtn:SetScript("OnEnter", function()
    -- GameTooltip:SetOwner(InitBtn, "ANCHOR_RIGHT")
    -- GameTooltip:SetText("|cffff9716[/init] |rВыводит в рейд сообщение очереди игроков на основе значений куба Инициатива.\nВажно бросать куб без цели, а также убедиться, что вы в рейде.")
    -- GameTooltip:Show()
-- end)
-- InitBtn:SetScript("OnLeave", function()
    -- GameTooltip:Hide()
-- end)
-- InitBtn:SetAttribute("type", "macro")
-- InitBtn:SetAttribute("macrotext", "/init")

-- Отображение кнопок на страницах
local function UpdatePageButtonsVisibility()
    if currentPage == 1 then
        CarryBtn:Show()
		DropBtn:Show()
		RollBtn:Show()
		PlaySoundBtn:Show()
		PetBtn:Show()
		
        GpsBtn:Hide()
		ClearAurasBtn:Hide()
		LeavePhaseBtn:Hide()
		CharcustBtn:Hide()
		WeatherClearBtn:Hide()
		UnstuckBtn:Hide()
		
        GobInfoBtn:Hide()
		MoveGoBtn:Hide()
		GathergosBtn:Hide()
		BuildModBtn:Hide()
		
		-- RaidQueueBtn:Hide()
		-- InitBtn:Hide()
    elseif currentPage == 2 then
        CarryBtn:Hide()
		DropBtn:Hide()
		RollBtn:Hide()
		PlaySoundBtn:Hide()
		PetBtn:Hide()
		
        GpsBtn:Show()
		ClearAurasBtn:Show()
		LeavePhaseBtn:Show()
		CharcustBtn:Show()
		WeatherClearBtn:Show()
		UnstuckBtn:Show()

		
        GobInfoBtn:Hide()
		MoveGoBtn:Hide()
		GathergosBtn:Hide()
		BuildModBtn:Hide()
		
		-- RaidQueueBtn:Hide()
		-- InitBtn:Hide()
    elseif currentPage == #pages then
        CarryBtn:Hide()
		DropBtn:Hide()
		RollBtn:Hide()
		PlaySoundBtn:Hide()
		PetBtn:Hide()
		
        GpsBtn:Hide()
		ClearAurasBtn:Hide()
		LeavePhaseBtn:Hide()
		CharcustBtn:Hide()
		WeatherClearBtn:Hide()
		UnstuckBtn:Hide()
		
        GobInfoBtn:Show()
		MoveGoBtn:Show()
		GathergosBtn:Show()
		BuildModBtn:Show()
		-- RaidQueueBtn:Show()
		-- InitBtn:Show()
    end
end

-- Обновление названия страницы
local function UpdatePageTitle()
    CategoryTitle:SetText(pages[currentPage].title)

    -- Скрытие всех кнопок
    CarryBtn:Hide()
	DropBtn:Hide()
	RollBtn:Hide()
	PlaySoundBtn:Hide()
	PetBtn:Hide()
	
    GpsBtn:Hide()
	ClearAurasBtn:Hide()
	LeavePhaseBtn:Hide()
	CharcustBtn:Hide()
	WeatherClearBtn:Hide()
	UnstuckBtn:Hide()
	
	
    GobInfoBtn:Hide()
	MoveGoBtn:Hide()
	GathergosBtn:Hide()
	BuildModBtn:Hide()
	

	-- RaidQueueBtn:Hide()
	-- InitBtn:Hide()

    -- Кнопки на страницах
    if currentPage == 1 then
        CarryBtn:Show()
		DropBtn:Show()
		RollBtn:Show()
		PlaySoundBtn:Show()
		PetBtn:Show()
    elseif currentPage == 2 then
        GpsBtn:Show()
		ClearAurasBtn:Show()
		LeavePhaseBtn:Show()
		CharcustBtn:Show()
		WeatherClearBtn:Show()
		UnstuckBtn:Show()
	elseif currentPage == #pages then
		GobInfoBtn:Show()
		MoveGoBtn:Show()
		GathergosBtn:Show()
		BuildModBtn:Show()
    -- elseif currentPage == #pages then

		-- RaidQueueBtn:Show()
		-- InitBtn:Show()		
    end
end

-- Обновление категорий
local function UpdateCategoryList()
    for i, pageData in ipairs(pages) do
        local categoryName = pageData.title
        local categoryButton = CategoryFrameBackground[i]
        if not categoryButton then
            categoryButton = CreateFrame("Button", nil, CategoryFrameBackground)
            categoryButton:SetSize(180, 20)
            categoryButton:SetPoint("TOPLEFT", -30, -30 * i)
            categoryButton:SetNormalFontObject("GameFontHighlight")
            categoryButton:SetHighlightFontObject("GameFontNormal")
            categoryButton:SetText(categoryName)
            categoryButton:SetScript("OnClick", function()
                currentPage = i
                UpdatePageTitle()
                UpdateArrowVisibility()
            end)
            CategoryFrameBackground[i] = categoryButton
        end
        categoryButton:SetText(categoryName)
    end
end

-- Стрелка влево
local LeftArrow = CreateFrame("BUTTON", "LeftArrow", CommandsMainFrame)
LeftArrow:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up")
LeftArrow:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down")
LeftArrow:SetSize(32, 32)
LeftArrow:SetPoint("BOTTOMLEFT", 150, 10)
LeftArrow:SetScript("OnClick", function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        UpdatePageTitle()
        UpdateArrowVisibility()
    end
end)

-- Стрелка вправо
local RightArrow = CreateFrame("BUTTON", "RightArrow", CommandsMainFrame)
RightArrow:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up")
RightArrow:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down")
RightArrow:SetSize(32, 32)
RightArrow:SetPoint("BOTTOMRIGHT", -20, 10)
RightArrow:SetScript("OnClick", function()
    if currentPage < #pages then
        currentPage = currentPage + 1
        UpdatePageTitle()
        UpdateArrowVisibility()
    end
end)

LeftArrow:Hide()

-- Функции страниц и стрелок
UpdatePageTitle()
UpdateCategoryList()
UpdateArrowVisibility()
-------------------------------------------------------------------------------------------------------------------




SideMainAddon.tabs = {
{name = "Трансмогрификация",func = function() Transmog_MainPanelOnOff() Transmog_SelectButtonFirst:Click() end,icon="transmog"},
{name = "Описание персонажа",func = function() ShowOrHide(ExtenderFrame)  end,icon="char_disc"},
{name = "Характеристики",func = function() CharStatsInterface.Open() end,icon="char_stats"},
{name = "Выбор класса",func = CallChangeClassMenu,icon="class_change"},
{name = "Парикмахерская",func = function() Transmog_MainPanelOnOff() Transmog_SelectButtonThird:Click() end,icon="barber"},
{name = "Лавка объектов",func = function() GoShop.Open() end,icon="go_shop"},
{name = "Визуальные эффекты",func = function() Handle_SpNobleGUI()end,icon="visual"},
{name = "Анимации",func = function() ShowMainAnimFrame() end,icon="anims"},
{name = "Мелодии барда",func = function() BardAddon.ShowInterface() end,icon="bard"},
{name = "Полезные команды",func = CommandsToggler,icon="atlas"},
}


local ONUPDATE_INTERVAL = 0.05
local ANIM_SELECT_PAD = 5
local MainFrame =  CreateFrame("Button", "MA_MainFrame", UIParent)
MainFrame:SetWidth(55)
MainFrame:SetHeight(55)
MainFrame:SetPoint("CENTER", Minimap, "CENTER",0,-100)
MainFrame:SetNormalTexture ("Interface\\AddOns\\MasterAddon\\assets\\MasterIcon.blp")
MainFrame:SetPushedTexture ("Interface\\AddOns\\MasterAddon\\assets\\MasterIcon_Clicked.blp")
MainFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
MainFrame:SetFrameLevel(10)
MainFrame:EnableMouse()
MainFrame.buttons = {}
MainFrame:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Функционал Noblegarden")
	GameTooltip:AddLine("ЛКМ: Открыть")
	GameTooltip:AddLine("ПКМ: Быстрое меню")
    GameTooltip:Show()
  end)
MainFrame:SetScript("OnLeave",function(self)
GameTooltip:Hide()
end)
SideMainAddon.opened = false
SideMainAddon.lock = false
for i,tab in ipairs(SideMainAddon.tabs) do
	button =  CreateFrame("Button", "MA_button", MainFrame)
	button:SetWidth(200)
	button:SetHeight(30)
	button:SetPoint("CENTER", MainFrame, "CENTER",30,-30)
	button:SetScript("OnClick", tab.func)
	--button:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
	button.Background = button:CreateTexture(nil,"ARTWORK",nil,1)
	button.Background:SetTexture("Interface\\AddOns\\MasterAddon\\assets\\MenuItem.blp")
	button.Background:SetPoint("CENTER",button,-160,-25)
	button.Background:SetSize(400, 100)
	button.Background:SetDrawLayer("BACKGROUND",1)
	button.Icon = button:CreateTexture(nil,"ARTWORK",nil,5)
	button.Icon:SetTexture("Interface\\AddOns\\MasterAddon\\assets\\miniicons\\"..tab.icon..".blp")
	button.Icon:SetPoint("CENTER",button,19,-1)
	button.Icon:SetSize(50, 50)
	button.Icon:SetDrawLayer("ARTWORK",2)
	button.HighlightButton = CreateFrame("Button",nil,button)
	button.HighlightButton:SetPoint("CENTER",button,19,-1)
	button.HighlightButton:SetSize(25,25)
	button.HighlightButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	button.HighlightButton:Hide() 
	button.HighlightButton:LockHighlight() 
	button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	button.text:SetPoint("CENTER", button, "CENTER", -120, 0)
	button.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	button.text:SetWidth(250)
	button.text:SetHeight(40)
	button.text:SetText(tab.name)
	button.text:SetJustifyH("RIGHT")
	button.tab = tab
	button:SetFrameLevel(20)
	button:Hide()
	button.anim_select = button:CreateAnimationGroup() 
	button.anim_select_move = button.anim_select:CreateAnimation("Translation")
	button.anim_select_move:SetOffset(300,-180)
	button.anim_select_move:SetDuration(0.2)
	button.anim_select_move:SetSmoothing("IN_OUT")
	button.anim_select_move:SetOrder(1)
	button.select_move_step = 0
	button.hovered = false
	-- The minimum number of seconds between each update
	

	-- The number of seconds since the last update
	local TimeSinceLastUpdate = 0
	button.anim_select_move.papa = button
	button:SetScript("OnUpdate", function(self, elapsed)
		TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
		if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
		
			TimeSinceLastUpdate = 0
			local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
			if self.hovered and self.select_move_step == 0 then
				self.anim_select_move:SetOffset(-ANIM_SELECT_PAD,0)
				self.anim_select_move:Play()
				self.anim_select_move:SetScript("OnFinished", function(self)
					self.papa:SetPoint("CENTER",xOfs+(-ANIM_SELECT_PAD*1.111), yOfs)
					self.papa.select_move_step = 1
				end)
			elseif not self.hovered and self.select_move_step == 1 then
				self.anim_select_move:SetOffset(ANIM_SELECT_PAD,0)
				self.anim_select_move:Play()
				self.anim_select_move:SetScript("OnFinished", function(self)
					self.papa:SetPoint("CENTER",xOfs+(ANIM_SELECT_PAD*1.111), yOfs)
					self.papa.select_move_step = 0
				end)
			end
		end
	end)
	button:SetScript("OnEnter",function(self)
		self.text:SetText("|cffffd100"..self.tab.name)
		if(not SideMainAddon.lock) then
			self.hovered = true
			--self.HighlightButton:Show() 
			
		end
		--GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		--GameTooltip:AddLine("Закрыть")
		--GameTooltip:Show()
	  end)
	button:SetScript("OnLeave",function(self)
		self.text:SetText(self.tab.name)
		if(not SideMainAddon.lock) then
			self.hovered  = false
			self.HighlightButton:Hide() 
		end
		--GameTooltip:Hide()
	end)
	button.anim_group = button:CreateAnimationGroup() 
	button.anim_trans = button.anim_group:CreateAnimation("Translation")
	button.anim_trans:SetOffset(300,-180)
	button.anim_trans:SetDuration(0.5)
	button.anim_trans:SetSmoothing("IN_OUT")
	button.anim_trans:SetOrder(1)
	
	
	
	button.anim_alpha_start = button.anim_group:CreateAnimation("Alpha")
	button.anim_alpha_start:SetChange(-1)
    button.anim_alpha_start:SetDuration(0)
    button.anim_alpha_start:SetSmoothing("OUT")
	
	button.anim_alpha = button.anim_group:CreateAnimation("Alpha")
	button.anim_alpha:SetChange(1)
    button.anim_alpha:SetDuration(0.6)
    button.anim_alpha:SetSmoothing("OUT")
	
	
	button.out_anim_group = button:CreateAnimationGroup() 
	button.out_anim_trans = button.out_anim_group:CreateAnimation("Translation")
	button.out_anim_trans:SetOffset(300,-180)
	button.out_anim_trans:SetDuration(0.5)
	button.out_anim_trans:SetSmoothing("IN_OUT")
	button.out_anim_trans:SetOrder(1)
	
	button.out_anim_alpha_start = button.out_anim_group:CreateAnimation("Alpha")
	button.out_anim_alpha_start:SetChange(1)
    button.out_anim_alpha_start:SetDuration(0)
    button.out_anim_alpha_start:SetSmoothing("OUT")
	
	button.out_anim_alpha = button.out_anim_group:CreateAnimation("Alpha")
	button.out_anim_alpha:SetChange(-1)
    button.out_anim_alpha:SetDuration(0.6)
    button.out_anim_alpha:SetSmoothing("OUT")
	

	table.insert(MainFrame.buttons,button)
end



local function CheckMinimapIconStatus()
	return MasterAddon.minimapIcons
end
local ChooseFrameDropDown = CreateFrame("FRAME", "MasterAddon_ChooseFrameDropDown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(ChooseFrameDropDown, function(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.hasArrow = false;
	info.isTitle = true;
	info.notCheckable = true;
	info.text = "Меню";
	UIDropDownMenu_AddButton(info, level);
	for i,tab in ipairs(SideMainAddon.tabs) do
		local info = UIDropDownMenu_CreateInfo()
		info.hasArrow = false;
		info.notCheckable = true;
		info.text = tab.name

		info.func = function(self)
			tab.func()
			CloseDropDownMenus()
		end

		
		a = UIDropDownMenu_AddButton(info, level);

	end
	local info = UIDropDownMenu_CreateInfo()
	info.hasArrow = false;
	info.isTitle = true;
	info.notCheckable = true;
	info.text = "Настройки";
	UIDropDownMenu_AddButton(info, level);
	
	local info = UIDropDownMenu_CreateInfo()
	info.func = function(self)
		if MasterAddon.minimapIcons then
			SpNobleMiniMapButton:Hide()
			LibDBIcon10_GoShop_Minimap:Hide()
			LibDBIcon10_NCE_Minimap:Hide()
		else
			SpNobleMiniMapButton:Show()
			LibDBIcon10_GoShop_Minimap:Show()
			LibDBIcon10_NCE_Minimap:Show()
		end
		MasterAddon.minimapIcons = not MasterAddon.minimapIcons
		CloseDropDownMenus()
	end
	info.notCheckable = false;
	info.isNotRadio = true
	info.checked = CheckMinimapIconStatus
	info.text = "Иконки на миникарте";
	UIDropDownMenu_AddButton(info, level);
end)

MainFrame:RegisterForClicks("LeftButtonUp", "RightButtonDown");

local yPad = 26
MainFrame:SetScript("OnClick",function(self,mouse) 
	if mouse == "RightButton" then
		ToggleDropDownMenu(1, nil, ChooseFrameDropDown, 'cursor', 0, 0);
		return false
	end
	if SideMainAddon.lock  then
		return false
	else
		SideMainAddon.lock = true
	end
	y = -10

	for i,button in ipairs(MainFrame.buttons) do
		local point, relativeTo, relativePoint, xOfs, yOfs = button:GetPoint(1)
		if not SideMainAddon.opened then
			button.anim_trans:SetOffset(0,y)
			
			button:Show()
			button.anim_group:Play()
			button.start_y = tonumber(y)
			button.anim_alpha:SetScript("OnFinished", function(self)
				button:SetAlpha(1)
				button:SetPoint("CENTER",xOfs,yOfs+button.start_y + (button.start_y*0.111))
				if i == #MainFrame.buttons then
					SideMainAddon.lock = false
				end
			end)
			y = y - yPad
		else
			button.out_anim_trans:SetOffset(0,-1*y)
			
			button.out_anim_group:Play()
			button.start_y = tonumber(-1*y)
			button.out_anim_alpha:SetScript("OnFinished", function(self)
				button:SetAlpha(0)
				button:Hide()
				button:SetPoint("CENTER",30,-30)
				if i == #MainFrame.buttons then
					SideMainAddon.lock = false
				end
			end)
			y = y - yPad
		end
	end
	if not SideMainAddon.opened then
		MainFrame:LockHighlight() 
		for i, toHide in ipairs(elementsToHide) do
			if toHide:IsShown() ~= nil then
				toHide.hide:Play()
				toHide.hided = true
			end
		end
		SideMainAddon.opened = true
	else
		MainFrame:UnlockHighlight() 
		for i, toHide in ipairs(elementsToHide) do
			if toHide.hided ~= nil then
				toHide:Show()
				toHide.show:Play()
			end
			toHide.hided = nil
		end
		SideMainAddon.opened = false
	end
end)


MainFrame:RegisterEvent("ADDON_LOADED")
MainFrame:SetScript("OnEvent",function(self,arg,arg2)
	if MasterAddon.minimapIcons ~= true then
		if SpNobleMiniMapButton then
			SpNobleMiniMapButton:Hide()
		end
		if LibDBIcon10_GoShop_Minimap then
			LibDBIcon10_GoShop_Minimap:Hide()
		end
		if LibDBIcon10_NCE_Minimap then
			LibDBIcon10_NCE_Minimap:Hide()
		end
	end
end)