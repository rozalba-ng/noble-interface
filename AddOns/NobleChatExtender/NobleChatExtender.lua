------------
--// Created by: Ezil
--// Modified by: Harusha
--// Date: 06.09.2020
--// 
--// [ДАННЫЕ УДАЛЕНЫ]
--// 10.08.2023
------------

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Variables                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local CHAR_INFO_COOLDOWN = {}
CHAR_INFO = CHAR_INFO or {}
CHAR_INFO.postfix = ""
CHAR_INFO.look = ""
CHAR_INFO.features = ""
CHAR_INFO.status = ""
CHAR_INFO.moment = ""
CHAR_INFO.role = ""
CHARS_INFO_LIST = {}

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                          MinimapIconButton                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local NCE_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("NCE_Minimap", {
    type = "data source",
    text = "NCE_Minimap",
    icon = "Interface\\Icons\\Ability_Mage_LivingBomb",
    OnClick = function()
                MinimapNobleChatExntenderButton_OnClick();
              end,
    OnEnter = function(self)
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(self,"CENTER");
				GameTooltip:AddLine("Описание вашего персонажа")
				GameTooltip:AddLine("Кликните чтобы изменить")
				GameTooltip:Show()
              end,
    })

local NCE_MinimapIconButton = LibStub("LibDBIcon-1.0")

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                     Init                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local Extender_AddonHandler = CreateFrame("Frame", "Extender_AddonHandler", UIParent);
Compressor = LibStub("AceSerializer-3.0")
NobleChatExtender = LibStub("AceAddon-3.0"):NewAddon("NobleChatExtender", "AceEvent-3.0")

function NobleChatExtender:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("NCE_MinMapDB", {
    profile = {
        minimap = {
            hide = false, },
                  },                               })
    NCE_MinimapIconButton:Register("NCE_Minimap", NCE_LDB, self.db.profile.minimap)
end

function NobleChatExtender:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON", "AddonMessageHandler")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "MouseOverHandler")
	
	ExtenderFrame.PostfixFrame.EditBox:SetText(CHAR_INFO.postfix)
	ExtenderFrame.LookFrame.EditBox:SetText(CHAR_INFO.look)
	ExtenderFrame.Feat.EditBox:SetText(CHAR_INFO.features)
	ExtenderFrame.Status.EditBox:SetText(CHAR_INFO.status)
	CurrentMomentFrame.EditBox:SetText(CHAR_INFO.moment)
	ExtenderFrame.RoleFrame.EditBox:SetText(CHAR_INFO.role)
	CHARS_INFO_LIST[UnitName("player")] = CHAR_INFO
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                    Funcs                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function IsInfoCooldown(player, state)
	if not player then return true end
	
	if not CHAR_INFO_COOLDOWN[player] then
		CHAR_INFO_COOLDOWN[player]= {};
	return false
	end
	
	if not CHAR_INFO_COOLDOWN[player][state] then
		return false
	end
	
	if (GetTime() - CHAR_INFO_COOLDOWN[player][state]) < 5 then
		return true
	else
		return false
	end
end

local function SaveLastCall(player, state)
	if not player then return true end
	if not CHAR_INFO_COOLDOWN[player] then
		CHAR_INFO_COOLDOWN[player]= {};
	end
	CHAR_INFO_COOLDOWN[player][state] = GetTime();
end

local function UnFoc(self)
	self:ClearFocus()
end

function NobleChatExtender:AddonMessageHandler(event, ...)
local args = {...}
local msgPrefix = args[1]
local data = args[2]
local sender = args[4]
	if msgPrefix == "POSTFIX_SEND" then
	local successor, newpostfix = Compressor:Deserialize(data)
		if successor then
			if CHARS_INFO_LIST[sender] then
				CHARS_INFO_LIST[sender].postfix = newpostfix
			else
				CHARS_INFO_LIST[sender] = {postfix = newpostfix}
			end
		end
	elseif msgPrefix == "CALL_TO_GET_CHAR_INFO" then --Send Serialize Data
		if IsInfoCooldown(sender, "GET") then return else SaveLastCall(sender, "GET") end
			local c_char_info = Compressor:Serialize(CHAR_INFO)
			SendAddonMessage("CHAR_INFO_SEND", c_char_info,"WHISPER",sender)
	elseif msgPrefix == "CHAR_INFO_SEND" then --Get Serialize Data
		if IsInfoCooldown(sender, "SEND") then return else SaveLastCall(sender, "SEND") end
		local successor, char_info = Compressor:Deserialize(data)
			if successor then
				CHARS_INFO_LIST[sender] = char_info
			end
	end
end

function NobleChatExtender:MouseOverHandler(self)
	if UnitIsPlayer("mouseover") then
		SendAddonMessage("CALL_TO_GET_CHAR_INFO", "","WHISPER",UnitName("mouseover"))
	end
end

function MinimapNobleChatExntenderButton_OnClick()
	if not ExtenderFrame:IsVisible() then
		ExtenderFrame:Show()
		ExtenderFrame.PostfixFrame.EditBox:SetText(CHAR_INFO.postfix)
		CurrentMomentFrame.EditBox:SetText(CHAR_INFO.moment)
		ExtenderFrame.RoleFrame.EditBox:SetText(CHAR_INFO.role)
		ExtenderFrame.LookFrame.EditBox:SetText(CHAR_INFO.look)
		ExtenderFrame.Feat.EditBox:SetText(CHAR_INFO.features)
		ExtenderFrame.Status.EditBox:SetText(CHAR_INFO.status)
	else
		ExtenderFrame:Hide()
	end
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Tooltip Hook                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function TooltipChanged(self)
	local unitName,unitId = self:GetUnit()
	if UnitIsPlayer(unitId) then
		local playerInfo = CHARS_INFO_LIST[unitName]
		local oldMainLine = _G["GameTooltipTextLeft1"]:GetText()
		local guildName = GetGuildInfo(unitId)
		if playerInfo then
			self:ClearLines()
			if playerInfo.postfix ~= "" then
				self:AddLine(oldMainLine.." ".. FullEscChar(string.utf8sub(playerInfo.postfix,0,15)))
			else
				self:AddLine(oldMainLine)
			end
			if guildName then
				self:AddLine(guildName)
			end
			if playerInfo.moment and playerInfo.moment ~= "" then
				self:AddLine("|cFFADFF2FНа данный момент:|r ".. EscChar(string.utf8sub(playerInfo.moment,0,400)) .. "\n",1,1,1,true)
			end
			if playerInfo.role and playerInfo.role ~= "" then
				self:AddLine("|cFFFFA500Роль:|r ".. EscChar(string.utf8sub(playerInfo.role,0,400)) .. "\n",1,1,1,true)
			end
			if playerInfo.look and playerInfo.look ~= "" then
				self:AddLine("|cff6374c2Внешность:|r ".. EscChar(string.utf8sub(playerInfo.look,0,400)) .. "\n",1,1,1,true)
			end
			if playerInfo.features and playerInfo.features ~= "" then
				self:AddLine("|cff6374c2Особенности:|r ".. EscChar(string.utf8sub(playerInfo.features,0,400)) .. "\n",1,1,1,true)
			end
			if playerInfo.status and playerInfo.status ~= "" then
				self:AddLine("|cFF87CEEBООС инфо:|r ".. EscChar(string.utf8sub(playerInfo.status,0,400)) .. "\n",1,1,1,true)
			end
		end
	end
end
GameTooltip:HookScript("OnTooltipSetUnit", TooltipChanged);

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Frames UI                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local ExtenderFrame = CreateFrame("Frame", "ExtenderFrame", UIParent)
ExtenderFrame:SetSize(750, 600)
ExtenderFrame:EnableMouse(true)
ExtenderFrame:SetPoint("CENTER",0,0)
ExtenderFrame:Hide()
ExtenderFrame:SetScript("OnShow", function() PlaySound("SPELLBOOKOPEN") end)
ExtenderFrame:SetScript("OnHide", function() PlaySound("SPELLBOOKCLOSE") end)

ExtenderFrame.Background = ExtenderFrame:CreateTexture("ARTWORK")
ExtenderFrame.Background:SetTexture("Interface\\AddOns\\NobleChatExtender\\Art\\book.blp")
ExtenderFrame.Background:SetPoint("CENTER",0,-13)
ExtenderFrame.Background:SetSize(800, 800)

ExtenderFrame.CloseButton = CreateFrame("BUTTON", "ExtenderFrame.CloseButton", ExtenderFrame,"UIPanelCloseButton")
ExtenderFrame.CloseButton:SetPoint("TOPRIGHT",4,-15)
ExtenderFrame.CloseButton:SetSize(40,40)

ExtenderFrame.RoleDesc = ExtenderFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ExtenderFrame.RoleDesc:SetFont("Fonts\\MORPHEUS.TTF", 23, "OUTLINE")
ExtenderFrame.RoleDesc:SetPoint("TOPLEFT",100,-80)
ExtenderFrame.RoleDesc:SetText("Описание персонажа")

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Frame UI Postfix                            ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ExtenderFrame.PostfixFrame = CreateFrame('Frame', 'ExtenderFrame.PostfixFrame', ExtenderFrame)
ExtenderFrame.PostfixFrame:SetWidth(190)
ExtenderFrame.PostfixFrame:SetHeight(50)
ExtenderFrame.PostfixFrame:SetPoint("CENTER", ExtenderFrame, "CENTER", -240, 130)
ExtenderFrame.PostfixFrame:SetToplevel(true)

local PostfixParent = ExtenderFrame.PostfixFrame

PostfixParent.postfixLabel = ExtenderFrame.PostfixFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PostfixParent.postfixLabel:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
PostfixParent.postfixLabel:SetPoint("TOP",4,0)
PostfixParent.postfixLabel:SetText("Фамилия")

PostfixParent.feather = ExtenderFrame.PostfixFrame:CreateTexture("ARTWORK")
PostfixParent.feather:SetTexture("Interface\\AddOns\\NobleChatExtender\\Art\\feather.blp")
PostfixParent.feather:SetPoint("CENTER", 420,-90)
PostfixParent.feather:SetWidth(240) 
PostfixParent.feather:SetHeight(240)
PostfixParent.feather:SetAlpha(0.4)

PostfixParent.Line = ExtenderFrame.PostfixFrame:CreateTexture("ARTWORK")
PostfixParent.Line:SetTexture("Interface\\AddOns\\NobleChatExtender\\Art\\line.blp")
PostfixParent.Line:SetPoint("CENTER",77,45)
PostfixParent.Line:SetWidth(270) 
PostfixParent.Line:SetHeight(135)
PostfixParent.Line:SetAlpha(0.7)

PostfixParent.EditBox = CreateFrame("EditBox", "PostfixParent.EditBox", ExtenderFrame.PostfixFrame,"InputBoxTemplate");
PostfixParent.EditBox:SetSize(140,30)
PostfixParent.EditBox:SetPoint("CENTER",ExtenderFrame.PostfixFrame,40,-10)	
PostfixParent.EditBox:SetAutoFocus(false)
PostfixParent.EditBox:SetMaxLetters(15)
PostfixParent.EditBox:SetScript("OnEscapePressed", UnFoc);
PostfixParent.EditBox:SetScript("OnEnterPressed", UnFoc);


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Frame UI Role                               ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ExtenderFrame.RoleFrame = CreateFrame('Frame', 'ExtenderFrame.RoleFrame', ExtenderFrame)
ExtenderFrame.RoleFrame:SetWidth(190)
ExtenderFrame.RoleFrame:SetHeight(100)
ExtenderFrame.RoleFrame:SetPoint("CENTER", ExtenderFrame, "CENTER", -200, 75)
ExtenderFrame.RoleFrame:EnableMouseWheel(true)

local RoleParent = ExtenderFrame.RoleFrame

RoleParent.Lable = ExtenderFrame.RoleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
RoleParent.Lable:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
RoleParent.Lable:SetPoint("TOP", -55, -25)
RoleParent.Lable:SetText("Роль")

RoleParent.Background = CreateFrame('Frame', 'ExtenderFrame.RoleFrame', ExtenderFrame.RoleFrame)
RoleParent.Background:SetWidth(240)
RoleParent.Background:SetHeight(65)
RoleParent.Background:EnableMouse(true)
RoleParent.Background:SetPoint("CENTER", ExtenderFrame.RoleFrame, "CENTER", 40, -25)
RoleParent.Background:SetBackdrop(
{
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom	 = 5 }
})

RoleParent.EditBox = CreateFrame('EditBox', 'RoleParent.EditBox', ExtenderFrame.RoleFrame)
RoleParent.EditBox:SetMultiLine(true)
RoleParent.EditBox:SetAutoFocus(false)
RoleParent.EditBox:EnableMouse(true)
RoleParent.EditBox:SetText(CHAR_INFO.role)
RoleParent.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 13)
RoleParent.EditBox:SetWidth(190)
RoleParent.EditBox:SetHeight(40)
RoleParent.EditBox:EnableMouseWheel(true)
RoleParent.EditBox:SetMaxLetters(75)
RoleParent.EditBox:SetScript("OnEscapePressed", UnFoc);

RoleParent.ScrollFrame = CreateFrame('ScrollFrame', 'RoleParent.ScrollFrame', RoleParent, 'UIPanelScrollFrameTemplate')
RoleParent.ScrollFrame:SetPoint('TOPLEFT', RoleParent, 'TOPLEFT', 25, -60)
RoleParent.ScrollFrame:SetPoint('BOTTOMRIGHT', RoleParent, 'BOTTOMRIGHT', 30, 5)
RoleParent.ScrollFrame:EnableMouseWheel(true)
RoleParent.ScrollFrame:SetScrollChild(RoleParent.EditBox)

RoleParent.Background:SetScript("OnMouseDown", 	function(self)
	RoleParent.EditBox:SetFocus()										
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Frame UI CurrentMoment                      ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Двигать фрейм
local function OnFrameMouseDown(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end

local function OnFrameMouseUp(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()
    end
end

CurrentMomentFrame = CreateFrame("Frame", "CurrentMomentFrame", UIParent)
CurrentMomentFrame:SetSize(160, 50)
CurrentMomentFrame:SetPoint("TOPLEFT", 400, -15)
CurrentMomentFrame:SetBackdropColor(0, 0, 0, 1)
CurrentMomentFrame:EnableMouse(true)
CurrentMomentFrame:SetMovable(true)
CurrentMomentFrame:RegisterForDrag("LeftButton")
CurrentMomentFrame:SetScript("OnMouseDown", OnFrameMouseDown)
CurrentMomentFrame:SetScript("OnMouseUp", OnFrameMouseUp)
CurrentMomentFrame:SetScript("OnHide", OnFrameLostFocus)
CurrentMomentFrame:SetClampedToScreen(true)

local CurrentMomentLabel = CurrentMomentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
CurrentMomentLabel:SetPoint("TOP", 0, -10)
CurrentMomentLabel:SetText("На данный момент")

function CurrentSave()
	CHAR_INFO.moment = CurrentMomentFrame.EditBox:GetText()
	CurrentMomentFrame.EditBox:ClearFocus()
end

CurrentMomentFrame.EditBox = CreateFrame("EditBox", nil, CurrentMomentFrame)
CurrentMomentFrame.EditBox:SetMultiLine(false)
CurrentMomentFrame.EditBox:SetAutoFocus(false)
CurrentMomentFrame.EditBox:SetFontObject("ChatFontNormal")
CurrentMomentFrame.EditBox:SetWidth(170)
CurrentMomentFrame.EditBox:SetHeight(25)
CurrentMomentFrame.EditBox:SetMaxLetters(50)
CurrentMomentFrame.EditBox:SetPoint("TOP", 0, -30)
CurrentMomentFrame.EditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
CurrentMomentFrame.EditBox:SetTextInsets(6, 0, 0, 0)
CurrentMomentFrame.EditBox:SetBackdropColor(0, 0, 0, 0.5)
CurrentMomentFrame.EditBox:SetScript("OnEscapePressed", UnFoc);
CurrentMomentFrame.EditBox:SetScript("OnEnterPressed", CurrentSave);
CurrentMomentFrame:Show()

-- Миникарта
CurrentMomentMinimapIcon = CreateFrame("Frame", "CurrentMomentMinimapIcon", Minimap);
CurrentMomentMinimapIcon:SetMovable(true);
CurrentMomentMinimapIcon:SetFrameStrata("LOW");
CurrentMomentMinimapIcon:SetClampedToScreen(true);
CurrentMomentMinimapIcon:SetSize(32, 32);
CurrentMomentMinimapIcon:SetPoint("CENTER", Minimap, "CENTER", 50, -90);
CurrentMomentMinimapIcon:EnableMouse(true);

CurrentMomentMinimapBtn = CreateFrame("Button", "CurrentMomentMinimapBtn", CurrentMomentMinimapIcon);
CurrentMomentMinimapBtn:SetMovable(true);
CurrentMomentMinimapBtn:SetSize(33, 33);
CurrentMomentMinimapBtn:SetPoint("TOPLEFT", CurrentMomentMinimapIcon, "TOPLEFT", 0, 0);

CurrentMomentMinimapIcon = CurrentMomentMinimapBtn:CreateTexture("$parentIcon", "BORDER");
CurrentMomentMinimapIcon:SetSize(20, 20);
CurrentMomentMinimapIcon:SetPoint("CENTER", -2, 1);
CurrentMomentMinimapIcon:SetTexture("Interface\\Icons\\trade_engineering");

CurrentMomentMinimapBorder = CurrentMomentMinimapBtn:CreateTexture("$parentBorder", "OVERLAY");
CurrentMomentMinimapBorder:SetSize(52, 52);
CurrentMomentMinimapBorder:SetPoint("TOPLEFT", 0, 0);
CurrentMomentMinimapBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");

CurrentMomentMinimapBtnHighlight = CurrentMomentMinimapBtn:CreateTexture(nil, "HIGHLIGHT");
CurrentMomentMinimapBtnHighlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
CurrentMomentMinimapBtnHighlight:SetBlendMode("ADD");
CurrentMomentMinimapBtnHighlight:SetAllPoints(CurrentMomentMinimapBtn);

-- Текст кнопки

CurrentMomentMinimapBtn:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	GameTooltip:SetText("На данный момент");
	GameTooltip:AddLine("ЛКМ: Показать/скрыть.", 0.9, 1, 0.5);
	GameTooltip:AddLine("ПКМ: Восстановить расположение.", 0.9, 1, 0.5);
	GameTooltip:Show();
end);
CurrentMomentMinimapBtn:SetScript("OnLeave", function()
	GameTooltip:Hide();
end);

-- Тогглер
local function CurrentToggler()
    if CurrentMomentFrame:IsShown() then
        CurrentMomentFrame:Hide()
    else
        CurrentMomentFrame:Show()
    end
end

-- Вернуть расположение
local function CurrentCenter()
	CurrentMomentFrame:ClearAllPoints()
	CurrentMomentFrame:SetPoint("CENTER", 0, 0)
end

-- Действия по кнопке у миникарты	
CurrentMomentMinimapBtn:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		CurrentToggler()
	elseif button == "RightButton" then
		CurrentCenter()
	end
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Frame UI Look                               ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ExtenderFrame.LookFrame = CreateFrame('Frame', 'ExtenderFrame.LookFrame', ExtenderFrame)
ExtenderFrame.LookFrame:SetWidth(190)
ExtenderFrame.LookFrame:SetHeight(185)
ExtenderFrame.LookFrame:SetPoint("CENTER", ExtenderFrame, "CENTER", -200, -50)
ExtenderFrame.LookFrame:EnableMouseWheel(true)

local LookParent = ExtenderFrame.LookFrame

LookParent.Lable = ExtenderFrame.LookFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
LookParent.Lable:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
LookParent.Lable:SetPoint("TOP",-33,-25)
LookParent.Lable:SetText("Внешность")

LookParent.Background = CreateFrame('Frame', 'ExtenderFrame.LookFrame', ExtenderFrame.LookFrame)
LookParent.Background:SetWidth(240)
LookParent.Background:SetHeight(150)
LookParent.Background:EnableMouse(true)
LookParent.Background:SetPoint("CENTER", ExtenderFrame.LookFrame, "CENTER", 40, -25)
LookParent.Background:SetBackdrop(
{
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom	 = 5 }
})

LookParent.EditBox = CreateFrame('EditBox', 'LookParent.EditBox', ExtenderFrame.LookFrame)
LookParent.EditBox:SetMultiLine(true)
LookParent.EditBox:SetAutoFocus(false)
LookParent.EditBox:EnableMouse(true)
LookParent.EditBox:SetText(CHAR_INFO.look)
LookParent.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 13)
LookParent.EditBox:SetWidth(190)
LookParent.EditBox:SetHeight(135)
LookParent.EditBox:EnableMouseWheel(true)
LookParent.EditBox:SetMaxLetters(400)
LookParent.EditBox:SetScript("OnEscapePressed", UnFoc);

LookParent.ScrollFrame = CreateFrame('ScrollFrame', 'LookParent.ScrollFrame', ExtenderFrame.LookFrame, 'UIPanelScrollFrameTemplate')
LookParent.ScrollFrame:SetPoint('TOPLEFT', ExtenderFrame.LookFrame, 'TOPLEFT', 25, -60)
LookParent.ScrollFrame:SetPoint('BOTTOMRIGHT', ExtenderFrame.LookFrame, 'BOTTOMRIGHT', 30, 8)
LookParent.ScrollFrame:EnableMouseWheel(true)
LookParent.ScrollFrame:SetScrollChild(LookParent.EditBox)

LookParent.Background:SetScript("OnMouseDown", 	function(self)
	LookParent.EditBox:SetFocus()										
end)

												
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Frame UI Feat                               ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::												
												
ExtenderFrame.Feat = CreateFrame('Frame', 'ExtenderFrame.Feat', ExtenderFrame)
ExtenderFrame.Feat:SetWidth(190)
ExtenderFrame.Feat:SetHeight(185)
ExtenderFrame.Feat:SetPoint("CENTER", ExtenderFrame, "CENTER", 130, 150)
ExtenderFrame.Feat:EnableMouseWheel(true)
ExtenderFrame.Feat:SetToplevel(true)

local FeatParent = ExtenderFrame.Feat

FeatParent.Label = ExtenderFrame.Feat:CreateFontString(nil, "OVERLAY", "GameFontNormal")
FeatParent.Label:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
FeatParent.Label:SetPoint("TOP",-25,-25)
FeatParent.Label:SetText("Особенности")

FeatParent.Background = CreateFrame('Frame', 'ExtenderFrame.Feat', ExtenderFrame.Feat)
FeatParent.Background:SetWidth(240)
FeatParent.Background:SetHeight(150)
FeatParent.Background:SetPoint("CENTER", ExtenderFrame.Feat, "CENTER", 40, -25)
FeatParent.Background:EnableMouse(true)
FeatParent.Background:SetBackdrop(
{
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom	 = 5 }
})

FeatParent.EditBox = CreateFrame('EditBox', 'FeatParent.EditBox', ExtenderFrame.Feat)
FeatParent.EditBox:SetMultiLine(true)
FeatParent.EditBox:SetAutoFocus(false)
FeatParent.EditBox:EnableMouse(true)
FeatParent.EditBox:SetText(CHAR_INFO.features)
FeatParent.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 13)
FeatParent.EditBox:SetWidth(190)
FeatParent.EditBox:SetHeight(135)
FeatParent.EditBox:EnableMouseWheel(true)
FeatParent.EditBox:SetMaxLetters(400)
FeatParent.EditBox:SetScript("OnEscapePressed", UnFoc);

FeatParent.ScrollFrame = CreateFrame('ScrollFrame', 'FeatParent.ScrollFrame', ExtenderFrame.Feat, 'UIPanelScrollFrameTemplate')
FeatParent.ScrollFrame:SetPoint('TOPLEFT', ExtenderFrame.Feat, 'TOPLEFT', 25, -60)
FeatParent.ScrollFrame:SetPoint('BOTTOMRIGHT', ExtenderFrame.Feat, 'BOTTOMRIGHT', 30, 8)
FeatParent.ScrollFrame:EnableMouseWheel(true)
FeatParent.ScrollFrame:SetScrollChild(FeatParent.EditBox)
FeatParent.Background:SetScript("OnMouseDown", 	function(self)
	FeatParent.EditBox:SetFocus()													
end)
										
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                              Frame UI Status                            ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::												
ExtenderFrame.Status = CreateFrame('Frame', 'ExtenderFrame.Status', ExtenderFrame)
ExtenderFrame.Status:SetWidth(190)
ExtenderFrame.Status:SetHeight(185)
ExtenderFrame.Status:SetPoint("CENTER", ExtenderFrame, "CENTER", 130, -50)
ExtenderFrame.Status:EnableMouseWheel(true)
ExtenderFrame.Status:SetToplevel(true)

local StatusParent = ExtenderFrame.Status

StatusParent.Label = ExtenderFrame.Status:CreateFontString(nil, "OVERLAY", "GameFontNormal")
StatusParent.Label:SetFont("Fonts\\MORPHEUS.TTF", 18, "OUTLINE")
StatusParent.Label:SetPoint("TOP", -33, -25)
StatusParent.Label:SetText("ООС инфо")

StatusParent.Background = CreateFrame('Frame', 'ExtenderFrame.Status', ExtenderFrame.Status)
StatusParent.Background:SetWidth(240)
StatusParent.Background:SetHeight(150)
StatusParent.Background:SetPoint("CENTER", ExtenderFrame.Status, "CENTER", 40, -25)	
StatusParent.Background:EnableMouse(true)
StatusParent.Background:SetBackdrop(
{
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom	 = 5 }
})

StatusParent.EditBox = CreateFrame('EditBox', 'StatusParent.EditBox', ExtenderFrame.Status)
StatusParent.EditBox:SetMultiLine(true)
StatusParent.EditBox:SetAutoFocus(false)
StatusParent.EditBox:EnableMouse(true)
StatusParent.EditBox:SetText(CHAR_INFO.status)
StatusParent.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 13)
StatusParent.EditBox:SetWidth(190)
StatusParent.EditBox:SetMaxLetters(400)
StatusParent.EditBox:SetHeight(135)
StatusParent.EditBox:EnableMouseWheel(true)
StatusParent.EditBox:SetScript("OnEscapePressed", UnFoc);

StatusParent.ScrollFrame = CreateFrame('ScrollFrame', 'StatusParent.ScrollFrame', ExtenderFrame.Status, 'UIPanelScrollFrameTemplate')
StatusParent.ScrollFrame:SetPoint('TOPLEFT', ExtenderFrame.Status, 'TOPLEFT', 25, -60)
StatusParent.ScrollFrame:SetPoint('BOTTOMRIGHT', ExtenderFrame.Status, 'BOTTOMRIGHT', 30, 8)
StatusParent.ScrollFrame:EnableMouseWheel(true)
StatusParent.ScrollFrame:SetScrollChild(StatusParent.EditBox)


StatusParent.Background:SetScript("OnMouseDown", function(self)
	StatusParent.EditBox:SetFocus()
end)

StatusParent.EditorAccept = CreateFrame("Button", "StatusParent.EditorAccept", ExtenderFrame, "UIPanelButtonTemplate")
StatusParent.EditorAccept:SetSize(100, 25)
StatusParent.EditorAccept:SetText("Применить")
StatusParent.EditorAccept:SetPoint("BOTTOMRIGHT",-55,120)
StatusParent.EditorAccept:SetScript("OnClick", function(self) if(self.OnClick) then self:OnClick(Frame) end end)

function StatusParent.EditorAccept:OnClick(self)
	ExtenderFrame:Hide()
	CHAR_INFO.postfix = PostfixParent.EditBox:GetText()
	CHAR_INFO.role = RoleParent.EditBox:GetText()
	CHAR_INFO.look = LookParent.EditBox:GetText()
	CHAR_INFO.features = FeatParent.EditBox:GetText()
	CHAR_INFO.status = StatusParent.EditBox:GetText()
end