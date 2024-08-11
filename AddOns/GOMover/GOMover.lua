
local GOM_ButtonHolder = CreateFrame("Frame", "GOM_ButtonHolder", UIParent)
GOM_ButtonHolder:SetSize(150, 285)
GOM_ButtonHolder:EnableMouse(true)
GOM_ButtonHolder:SetPoint("BOTTOM",-12,150)
GOM_ButtonHolder:SetMovable(true)
GOM_ButtonHolder:SetScript("OnDragStart", function(self) self:StartMoving() end)
GOM_ButtonHolder:SetScript("OnMouseDown", function(self) self:StartMoving() end)
GOM_ButtonHolder:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
GOM_ButtonHolder:RegisterForDrag("LeftButton","RightButton")
GOM_ButtonHolder:Hide()
GOM_ButtonHolder:SetClampedToScreen(true)
GOM_ButtonHolder:SetBackdrop(
{
    bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal-Desaturated",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
function GOB_OpenFrame()
	GOM_ButtonHolder:Show()
end
local ButtonClose = CreateFrame("BUTTON", "ButtonClose", GOM_ButtonHolder, "SecureHandlerClickTemplate");
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(25,25)
ButtonClose:SetPoint("TOPRIGHT",GOM_ButtonHolder,5,5)	
ButtonClose:SetScript("OnClick",function(self)
	GOM_ButtonHolder:Hide()
  end)
ButtonClose:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
  end)
  ButtonClose:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end) 
local ButtonReturn = CreateFrame("BUTTON", "ButtonReturn", GOM_ButtonHolder, "SecureHandlerClickTemplate");
ButtonReturn:SetNormalTexture("Interface/BUTTONS/Button-Backpack-Up")
ButtonReturn:SetHighlightTexture("Interface/BUTTONS/ButtonHilight-Square")
ButtonReturn:SetPushedTexture("Interface/BUTTONS/Button-Backpack-Up")
ButtonReturn:SetSize(26,26)
ButtonReturn:SetPoint("BOTTOMRIGHT",GOM_ButtonHolder,24,9)	
ButtonReturn:SetScript("OnClick",function(self)
	GOM_ReturnToInventory()
	GOM_ButtonHolder:Hide()
  end)
ButtonReturn:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Забрать в инвентарь")
    GameTooltip:Show()
  end)
  ButtonReturn:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
local function UnFoc(self)
	self:ClearFocus()
end
local CenterForButtons_X = -20

local CenterForButtons_Y = -35

local EditBox_Move = CreateFrame("EditBox", "EB_Move", GOM_ButtonHolder,"InputBoxTemplate");
EditBox_Move:SetSize(30,30)
EditBox_Move:SetPoint("CENTER",GOM_ButtonHolder,CenterForButtons_X +2 ,CenterForButtons_Y -40)	
EditBox_Move:SetAutoFocus(false)
EditBox_Move:Insert(15)
EditBox_Move:SetMaxLetters(2)
EditBox_Move:SetScript("OnEscapePressed", UnFoc);
EditBox_Move:SetScript("OnEnterPressed", UnFoc);
EditBox_Move:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Шаг движения")
    GameTooltip:Show()
  end)
local MoveLabel = GOM_ButtonHolder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoveLabel:SetFont("Fonts\\MORPHEUS.TTF", 14, "OUTLINE")
MoveLabel:SetPoint("CENTER",CenterForButtons_X+30,CenterForButtons_Y+40)
--MoveLabel:SetText("Передвижение")
MoveLabel:Show();


local Button_MoveToForward = CreateFrame("BUTTON", "B_Forward", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveToForward:SetNormalTexture("Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Up")
Button_MoveToForward:SetHighlightTexture("Interface/BUTTONS/ButtonHilight-Round")
Button_MoveToForward:SetPushedTexture("Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Down")
Button_MoveToForward:SetSize(35,35)
Button_MoveToForward:SetPoint("CENTER",GOM_ButtonHolder,CenterForButtons_X + 0, CenterForButtons_Y + 18)	

Button_MoveToForward:SetScript("OnClick",function(self)	
	if tonumber(EditBox_Move:GetText()) < 0 or tonumber(EditBox_Move:GetText()) > 30 then
		EditBox_Move:SetText(30)
	end
	MoveActiveGO(1,EditBox_Move:GetText())
  end)
Button_MoveToForward:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Движение вперед")
    GameTooltip:Show()
  end)
  Button_MoveToForward:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)

local Button_MoveToBackward = CreateFrame("BUTTON", "B_Backward", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveToBackward:SetNormalTexture("Interface/BUTTONS/UI-ScrollBar-ScrollDownButton-Up")
Button_MoveToBackward:SetHighlightTexture("Interface/BUTTONS/ButtonHilight-Round")
Button_MoveToBackward:SetPushedTexture("Interface/BUTTONS/UI-ScrollBar-ScrollDownButton-Down")
Button_MoveToBackward:SetSize(35,35)
Button_MoveToBackward:SetPoint("CENTER",GOM_ButtonHolder,CenterForButtons_X + 0,CenterForButtons_Y + -18)	
Button_MoveToBackward:SetScript("OnClick",function(self)
	if tonumber(EditBox_Move:GetText()) < 0 or tonumber(EditBox_Move:GetText()) > 15 then
		EditBox_Move:SetText(15)
	end
	MoveActiveGO(2,EditBox_Move:GetText())
  end)
Button_MoveToBackward:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Движение назад")
    GameTooltip:Show()
  end)
  Button_MoveToBackward:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	
local Button_MoveToRight = CreateFrame("BUTTON", "B_Right", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveToRight:SetNormalTexture("Interface\\AddOns\\GOMover\\img\\UI-ScrollBar-ScrollRightButton-Up.blp")
Button_MoveToRight:SetHighlightTexture("Interface\\AddOns\\GOMover\\img\\ButtonHilight-Round.blp")
Button_MoveToRight:SetPushedTexture("Interface\\AddOns\\GOMover\\img\\UI-ScrollBar-ScrollLeftButton-Down.blp")
Button_MoveToRight:SetSize(35,35)
Button_MoveToRight:SetPoint("CENTER",GOM_ButtonHolder,CenterForButtons_X + 18,CenterForButtons_Y + 0)	
Button_MoveToRight:SetScript("OnClick",function(self)
	if tonumber(EditBox_Move:GetText()) < 0 or tonumber(EditBox_Move:GetText()) > 15 then
		EditBox_Move:SetText(15)
	end
	MoveActiveGO(3,EditBox_Move:GetText())
  end)
Button_MoveToRight:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Движение направо")
    GameTooltip:Show()
  end)
  Button_MoveToRight:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	
local Button_MoveToLeft = CreateFrame("BUTTON", "B_Left", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveToLeft:SetNormalTexture("Interface\\AddOns\\GOMover\\img\\UI-ScrollBar-ScrollLeftButton-Up.blp")
Button_MoveToLeft:SetHighlightTexture("Interface\\AddOns\\GOMover\\img\\ButtonHilight-Round.blp")
Button_MoveToLeft:SetPushedTexture("Interface\\AddOns\\GOMover\\img\\UI-ScrollBar-ScrollLeftButton-Down.blp")
Button_MoveToLeft:SetSize(35,35)
Button_MoveToLeft:SetPoint("CENTER",GOM_ButtonHolder,CenterForButtons_X + -18, CenterForButtons_Y + 0)	
Button_MoveToLeft:SetScript("OnClick",function(self)
	if tonumber(EditBox_Move:GetText()) < 0 or tonumber(EditBox_Move:GetText()) > 15 then
		EditBox_Move:SetText(15)
	end
	MoveActiveGO(4,EditBox_Move:GetText())
  end)
Button_MoveToLeft:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Движение налево")
    GameTooltip:Show()
  end)
  Button_MoveToLeft:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	

local CenterForRotButtons_X = 0	
local CenterForRotButtons_Y = 63
local GOM_RotateHolder = CreateFrame("Frame", "GOM_RotateHolder", GOM_ButtonHolder)
GOM_RotateHolder:SetSize(130, 130)
GOM_RotateHolder:SetPoint("CENTER",GOM_ButtonHolder,0,CenterForRotButtons_Y+15)
--[[GOM_RotateHolder:SetBackdrop(
{
    bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal-Desaturated",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})]]
GOM_RotateHolder.Image = GOM_RotateHolder:CreateTexture(nil, "ARTWORK")
GOM_RotateHolder.Image:SetPoint("CENTER", GOM_RotateHolder)
GOM_RotateHolder.Image:SetSize(120, 120)
GOM_RotateHolder.Image:SetTexture("Interface\\AddOns\\GOMover\\img\\RotateImage2.blp")
--GOM_RotateHolder.Image:SetTexCoord(0, 0, 0, 0)
local EditBox_Rotate = CreateFrame("EditBox", "EditBox_Rotate", GOM_RotateHolder,"InputBoxTemplate");
EditBox_Rotate:SetSize(33,30)
EditBox_Rotate:SetPoint("CENTER",GOM_RotateHolder,CenterForRotButtons_X -5,CenterForRotButtons_Y -125)	
EditBox_Rotate:SetAutoFocus(false)
EditBox_Rotate:Insert(10)
EditBox_Rotate:SetMaxLetters(3)
EditBox_Rotate:SetScript("OnEscapePressed", UnFoc);
EditBox_Rotate:SetScript("OnEnterPressed", UnFoc);
EditBox_Rotate:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Шаг вращения в градусах")
    GameTooltip:Show()
  end)
  EditBox_Rotate:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
local B_Z= CreateFrame("BUTTON", "B_Z", GOM_RotateHolder, "SecureHandlerClickTemplate");
--B_Z:SetNormalTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollUp-Up")
B_Z:SetSize(60,45)
B_Z:SetPoint("CENTER",GOM_RotateHolder,CenterForRotButtons_X ,CenterForRotButtons_Y-30)	
B_Z:RegisterForClicks("AnyUp")
B_Z:SetScript("OnClick",function(self,button)

	value = tonumber(EditBox_Rotate:GetText())
	if value > 360 then
		 value = 360
		 EditBox_Rotate:SetText(360)
	end
	if button == "LeftButton" then
		value = value
	elseif button == "RightButton" then
		value = value*-1
	end
	RotateActiveGO(1,value)
  end)
B_Z:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Поворот X\nЛКМ: Против часовой\nПКМ: По часовой")
    GameTooltip:Show()
  end)
  B_Z:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	
local B_Y= CreateFrame("BUTTON", "B_Y", GOM_RotateHolder, "SecureHandlerClickTemplate");
--B_Y:SetNormalTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollUp-Up")
B_Y:SetSize(45,60)
B_Y:SetPoint("CENTER",GOM_RotateHolder,CenterForRotButtons_X-38,CenterForRotButtons_Y-78)	
B_Y:RegisterForClicks("AnyUp")
B_Y:SetScript("OnClick",function(self,button)
	value = tonumber(EditBox_Rotate:GetText())
	if value > 360 then
		 value = 360
		 EditBox_Rotate:SetText(360)
	end
	if button == "LeftButton" then
		value = value
	elseif button == "RightButton" then
		value = value*-1
	end
	RotateActiveGO(2,value)
  end)
B_Y:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Поворот Z\nЛКМ: Против часовой\nПКМ: По часовой")
    GameTooltip:Show()
  end)
  B_Y:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)


local B_RotateReset = CreateFrame("BUTTON", "B_RotateReset", GOM_RotateHolder, "SecureHandlerClickTemplate");
B_RotateReset:SetNormalTexture("Interface/BUTTONS/CancelButton-Up")
B_RotateReset:SetHighlightTexture("Interface/BUTTONS/CancelButton-Highlight")
B_RotateReset:SetPushedTexture("Interface/BUTTONS/CancelButton-Down")
B_RotateReset:SetPoint("CENTER",GOM_RotateHolder,CenterForRotButtons_X +20,CenterForRotButtons_Y -125)	
B_RotateReset:SetSize(30,30)	
B_RotateReset:RegisterForClicks("AnyUp")
B_RotateReset:SetScript("OnClick",function(self,button)
	ResetActiveGO()
  end)
B_RotateReset:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Сбросить поворот")
    GameTooltip:Show()
  end)
  B_RotateReset:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)

local B_X= CreateFrame("BUTTON", "B_X", GOM_RotateHolder, "SecureHandlerClickTemplate");
--B_X:SetNormalTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollUp-Up")
B_X:SetSize(45,60)
B_X:SetPoint("CENTER",GOM_RotateHolder,CenterForRotButtons_X+38,CenterForRotButtons_Y-85)	
B_X:RegisterForClicks("AnyUp")
B_X:SetScript("OnClick",function(self,button)
	value = tonumber(EditBox_Rotate:GetText())
	if value > 360 then
		 value = 360
		 EditBox_Rotate:SetText(360)
	end
	if button == "LeftButton" then
		value = value
	elseif button == "RightButton" then
		value = value*-1
	end
	RotateActiveGO(3,value)
  end)
B_X:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Поворот Y\nЛКМ: Против часовой\nПКМ: По часовой")
    GameTooltip:Show()
  end)
  B_X:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	
GOMOBER_GOBName = GOM_ButtonHolder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
GOMOBER_GOBName:SetFont("Fonts\\MORPHEUS.TTF", 11, "OUTLINE")
GOMOBER_GOBName:SetPoint("TOPLEFT",0,10)
GOMOBER_GOBName:SetText("Ничего")


local CenterForHighButtons_X = 30
local CenterForHighButtons_Y = -35
local EditBox_High = CreateFrame("EditBox", "EB_High", GOM_ButtonHolder,"InputBoxTemplate");
EditBox_High:SetSize(33,30)
EditBox_High:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X +2 ,CenterForHighButtons_Y -40)	
EditBox_High:SetAutoFocus(false)
EditBox_High:Insert(30)
EditBox_High:SetMaxLetters(3)
EditBox_High:SetScript("OnEscapePressed", UnFoc);
EditBox_High:SetScript("OnEnterPressed", UnFoc);

EditBox_High:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Шаг поднятия")
    GameTooltip:Show()
  end)
local EditBox_Scale = CreateFrame("EditBox", "EditBox_Scale", GOM_ButtonHolder,"InputBoxTemplate");
EditBox_Scale:SetSize(33,30)
EditBox_Scale:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X -25 ,CenterForHighButtons_Y -75)	
EditBox_Scale:SetAutoFocus(false)
EditBox_Scale:Insert(1)
EditBox_Scale:SetMaxLetters(4)
EditBox_Scale:SetScript("OnEscapePressed", UnFoc);
EditBox_Scale:SetScript("OnEnterPressed", UnFoc);

EditBox_Scale:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Кратность размера")
    GameTooltip:Show()
  end)
local Button_PlusScale = CreateFrame("BUTTON", "Button_PlusScale", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_PlusScale:SetNormalTexture("Interface/BUTTONS/UI-PlusButton-Up")
Button_PlusScale:SetHighlightTexture("Interface/BUTTONS/UI-PlusButton-Hilight")
Button_PlusScale:SetPushedTexture("Interface/BUTTONS/UI-PlusButton-Down")
Button_PlusScale:SetSize(20,20)
Button_PlusScale:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X+2 ,CenterForHighButtons_Y -74)	
Button_PlusScale:SetScript("OnClick",function(self)
	--SendAddonMessage("MOVE_GO_DOWN",EditBox_High:GetText(),"WHISPER",UnitName("player"))
	if tonumber(EditBox_Scale:GetText()) < 0 or tonumber(EditBox_Scale:GetText()) > 100 then
		EditBox_Scale:SetText(100)
	end
	ChangeScale(1,EditBox_Scale:GetText())
  end)
--[[local Button_MinusScale = CreateFrame("BUTTON", "Button_PlusScale", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MinusScale:SetNormalTexture("Interface/BUTTONS/UI-MinusButton-Up")
Button_MinusScale:SetHighlightTexture("Interface/BUTTONS/UI-PlusButton-Hilight")
Button_MinusScale:SetPushedTexture("Interface/BUTTONS/UI-MinusButton-Down")
Button_MinusScale:SetSize(20,20)
Button_MinusScale:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X-58 ,CenterForHighButtons_Y -74)	
Button_MinusScale:SetScript("OnClick",function(self)
	--SendAddonMessage("MOVE_GO_DOWN",EditBox_High:GetText(),"WHISPER",UnitName("player"))
	if tonumber(EditBox_Scale:GetText()) < 0 or tonumber(EditBox_Scale:GetText()) > 200 then
		EditBox_Scale:SetText(200)
	end
	ChangeScale(2,EditBox_Scale:GetText())
  end)
Button_MinusScale:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Уменьшить объект")
    GameTooltip:Show()
  end)
  Button_MinusScale:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)  ]]
local Button_MoveUp = CreateFrame("BUTTON", "B_Up", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveUp:SetNormalTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollUp-Up")
Button_MoveUp:SetHighlightTexture("Interface/CHATFRAME/UI-ChatIcon-BlinkHilight")
Button_MoveUp:SetPushedTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollUp-Down")
Button_MoveUp:SetSize(30,30)
Button_MoveUp:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X ,CenterForHighButtons_Y + 13)	
Button_MoveUp:SetScript("OnClick",function(self)
	--SendAddonMessage("MOVE_GO_UP",EditBox_High:GetText(),"WHISPER",UnitName("player"))
	if tonumber(EditBox_High:GetText()) < 0 or tonumber(EditBox_High:GetText()) > 100 then
		EditBox_High:SetText(100)
	end
	MoveActiveGO(5,EditBox_High:GetText())
  end)
	
Button_MoveUp:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Поднять объект")
    GameTooltip:Show()
  end)
  Button_MoveUp:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)	
local Button_MoveDown = CreateFrame("BUTTON", "B_Down", GOM_ButtonHolder, "SecureHandlerClickTemplate");
Button_MoveDown:SetNormalTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollDown-Up")
Button_MoveDown:SetHighlightTexture("Interface/CHATFRAME/UI-ChatIcon-BlinkHilight")
Button_MoveDown:SetPushedTexture("Interface/CHATFRAME/UI-ChatIcon-ScrollDown-Down")
Button_MoveDown:SetSize(30,30)
Button_MoveDown:SetPoint("CENTER",GOM_ButtonHolder,CenterForHighButtons_X ,CenterForHighButtons_Y - 13)	
Button_MoveDown:SetScript("OnClick",function(self)
	--SendAddonMessage("MOVE_GO_DOWN",EditBox_High:GetText(),"WHISPER",UnitName("player"))
	if tonumber(EditBox_High:GetText()) < 0 or tonumber(EditBox_High:GetText()) > 100 then
		EditBox_High:SetText(100)
	end
	MoveActiveGO(6,EditBox_High:GetText())
  end)
	
Button_MoveDown:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Опустить объект")
    GameTooltip:Show()
  end)
  Button_MoveDown:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)	
local Eluna_AddonHandler = CreateFrame("Frame", "Eluna_AddonHandler", UIParent);
Eluna_AddonHandler: RegisterEvent("CHAT_MSG_ADDON")
Eluna_AddonHandler: SetScript("OnEvent", function(self, event, ...)
local args = {...}
	if args[1] == "GOM_OPENFRAME" and args[4] == UnitName("player") then
		GOM_ButtonHolder:Show()
		local name = args[2]
		GOBName:SetText(name)
	end
end)