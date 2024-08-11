
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Начальные переменные
AnimFavourites = {}
local SpellSorting = "Все"
local data = {}
local TableSelect = SpellGroup;
local scrollFrame
local numButtons = 5
local buttonHeight = 25
local playerName = UnitName("player")
local DMMode = false;
local FirstLoad = true;
local SearchBlock = true;
local Search_textbox1 = "";


local animList = {
	{id = 1, name = "Говорить", onlyHuman = false},
	{id = 2, name = "Поклон", onlyHuman = false},
	{id = 3, name = "Помахать рукой", onlyHuman = false},
	{id = 4, name = "Радость", onlyHuman = false},
	{id = 5, name = "Восклицать", onlyHuman = false},
	{id = 6, name = "Спрашивать", onlyHuman = false},
	{id = 7, name = "Есть", onlyHuman = false},
	{id = 10, name = "Танцевать", onlyHuman = false},
	{id = 11, name = "Смех", onlyHuman = false},
	{id = 14, name = "Неприличный жест", onlyHuman = false},
	{id = 15, name = "Ярость", onlyHuman = false},
	{id = 16, name = "Поклон", onlyHuman = false},
	{id = 17, name = "Поцелуй", onlyHuman = false},
	{id = 18, name = "Плач", onlyHuman = false},
	{id = 19, name = "Цыпа-цыпа", onlyHuman = false},
	{id = 20, name = "Молить о прощении", onlyHuman = false},
	{id = 21, name = "Апплодировать", onlyHuman = false},
	{id = 22, name = "Кричать", onlyHuman = false},
	{id = 23, name = "Мускулы", onlyHuman = false},
	{id = 24, name = "Флиртовать", onlyHuman = false},
	{id = 25, name = "Указать", onlyHuman = false},
	{id = 27, name = "Стойка на кулаках", onlyHuman = false},
	{id = 28, name = "Добыча киркой", onlyHuman = false},
	{id = 33, name = "Получение удара", onlyHuman = false},
	{id = 34, name = "Получение удара 2", onlyHuman = false},
	{id = 35, name = "Кулачный бой", onlyHuman = false},
	{id = 36, name = "Удары одноручным", onlyHuman = false},
	{id = 37, name = "Удары двуручным", onlyHuman = false},
	{id = 38, name = "Удары двуручным 2", onlyHuman = false},
	{id = 39, name = "Заблокировать кулаками", onlyHuman = false},
	{id = 44, name = "Блок кулаками", onlyHuman = false},
	{id = 43, name = "Заблокировать щитом", onlyHuman = false},
	{id = 45, name = "Боевая стойка", onlyHuman = false},
	{id = 48, name = "Стойка с луком", onlyHuman = false},
	{id = 51, name = "Атака кулаками", onlyHuman = false},
	{id = 54, name = "Удар с разворота", onlyHuman = false},
	{id = 60, name = "Удар ногой", onlyHuman = false},
	{id = 61, name = "Одиночный удар рукой", onlyHuman = false},
	{id = 64, name = "Оглушение", onlyHuman = false},
	{id = 69, name = "Действие/крафт", onlyHuman = false},
	{id = 233, name = "Добыча руды", onlyHuman = false},
	{id = 234, name = "Добыча дерева", onlyHuman = false},
	{id = 375, name = "Стойка с мечем", onlyHuman = false},
	{id = 381, name = "Изучать что-то на земле", onlyHuman = false},
	{id = 382, name = "Дикая мельница", onlyHuman = false},
	{id = 384, name = "Натянуть тетиву", onlyHuman = false},
	{id = 385, name = "Прицел с ружьем", onlyHuman = false},
	{id = 386, name = "Стойка с метательным", onlyHuman = false},
	{id = 389, name = "Рубящий удар одноручным оружием", onlyHuman = false},
	{id = 390, name = "Колющий удар одноручным оружием", onlyHuman = false},
	{id = 398, name = "Приклонить колено", onlyHuman = false},
	{id = 399, name = "Полет", onlyHuman = false},
	{id = 430, name = "Страх", onlyHuman = false},
	{id = 436, name = "Выстрел из ружья", onlyHuman = false},
	{id = 451, name = "Апперкот", onlyHuman = false},
	{id = 483, name = "Стойка \"в атаку\"", onlyHuman = true},
	{id = 486, name = "Каст левитируя", onlyHuman = true},
	{id = 488, name = "Стойка", onlyHuman = true},
	{id = 490, name = "Облокотиться о стену", onlyHuman = true},
	{id = 492, name = "Стоять с веслом", onlyHuman = true},
	{id = 495, name = "Забивать гвоздь", onlyHuman = true},
	{id = 497, name = "Опереться о сто", onlyHuman = true},
	{id = 485, name = "Оружее на плече", onlyHuman = true},
	{id = 487, name = "Пьяно покачиваться", onlyHuman = true},
	{id = 489, name = "Стоять на страже с оружием", onlyHuman = true},
	{id = 493, name = "Драить пол", onlyHuman = true},
	{id = 496, name = "Руки связаны за спиной", onlyHuman = true}
}
data = animList

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Мейнфрейм
Noble_AnimlistMainPanel = CreateFrame("Frame", "Noble_AnimlistMainPanel", UIParent)
Noble_AnimlistMainPanel:SetWidth(310)
Noble_AnimlistMainPanel:SetHeight(220)
Noble_AnimlistMainPanel:Hide()
Noble_AnimlistMainPanel:SetPoint("CENTER", UIParent, "CENTER")
Noble_AnimlistMainPanel:EnableMouse()
Noble_AnimlistMainPanel:SetMovable(true)
Noble_AnimlistMainPanel:SetFrameStrata("FULLSCREEN_DIALOG")
Noble_AnimlistMainPanel:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
Noble_AnimlistMainPanel:SetBackdropColor(0, 0, 0, 1)
Noble_AnimlistMainPanel:SetScript("OnDragStart", function(self) self:StartMoving() end)
Noble_AnimlistMainPanel:SetScript("OnMouseDown", function(self) self:StartMoving() end)
Noble_AnimlistMainPanel:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)

Noble_AnimlistMainPanel:RegisterForDrag("LeftButton","RightButton")
local Noble_AnimlistMainPanel_texture = Noble_AnimlistMainPanel:CreateTexture("ARTWORK") -- задать текстурку
Noble_AnimlistMainPanel_texture:SetTexture("Interface\\NobleProject\\VisualSpell\\1.blp")
Noble_AnimlistMainPanel_texture:SetPoint("CENTER",0,-18)
Noble_AnimlistMainPanel_texture:SetWidth(330) 
Noble_AnimlistMainPanel_texture:SetHeight(330)
Noble_AnimlistMainPanel_texture:SetAlpha(1)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Апдейт-дата
local function update()
	local race = UnitRace("player")

FauxScrollFrame_Update(scrollFrame,#data,numButtons,buttonHeight)
  for index = 1,numButtons do
    local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
    local button = scrollFrame.buttons[index]
    button.index = offset
    if offset<=#data then
		if race ~= "Человек" and data[offset].onlyHuman then
			button:SetText("|cff616161"..data[offset].id..". "..data[offset].name)
		  button:Show()
		else
		  button:SetText(data[offset].id..". "..data[offset].name)
		  button:Show()
		end
    else
      button:Hide()
    end
  end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Скролл-меню
local Base_frame = CreateFrame("frame","AnimFrame",Noble_AnimlistMainPanel)
Base_frame:SetSize(270,numButtons*buttonHeight+16)
Base_frame:SetPoint("CENTER", 0, -20)
Base_frame:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
Base_frame:SetAlpha(0.9)
scrollFrame = CreateFrame("ScrollFrame","NobleAnimScrollFrame",Base_frame,"FauxScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",0,-8)
scrollFrame:SetPoint("BOTTOMRIGHT",-30,8)
scrollFrame:SetScript("OnVerticalScroll",function(self,offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, buttonHeight, update)
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Основной лист кнопок

--	Часть кода для интеграции аддона на управление спутником.
PetControl = PetControl or {}
PetControl.Target = false
--	Всё.

scrollFrame.buttons = {}
for i=1,numButtons do
  scrollFrame.buttons[i] = CreateFrame("Button",nil,Base_frame)
  local button = scrollFrame.buttons[i]
  button:SetSize(166,buttonHeight)
  button:SetNormalFontObject("GameFontHighlightLeft")
  button:SetPoint("TOPLEFT",8,-(i-1)*buttonHeight-8)
  button:RegisterForClicks("AnyUp")
 button:SetScript("OnClick",function(self,button)
			animInfo = data[self.index]
		   if button == "RightButton" then
				ToggleDropDownMenu(1, nil, AnimatorNoble_dropDown, 'cursor', 0, 0); ------// Дроп меню
				New_favourite = animInfo
		   else
				if GMLevel > 0  and DMMode then
					SendChatMessage(".npc playemote "..animInfo.id, "WHISPER", nil, playerName);
				elseif DMLevel > 0 and DMMode then
					SendChatMessage(".npcplayemote "..animInfo.id.." 1", "WHISPER", nil, playerName);
				elseif PetControl.Target then
					SendChatMessage(".pet play "..animInfo.id.." 1", "WHISPER", nil, playerName);
				else
					SendChatMessage(".mod st "..animInfo.id, "WHISPER", nil, playerName);
				end
			   
		   end
          
end)
end
update()

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Правый клик, избранное
local AnimatorNoble_dropDown = CreateFrame("FRAME", "AnimatorNoble_dropDown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(AnimatorNoble_dropDown, function(self, level, menuList)
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = "Меню";
UIDropDownMenu_AddButton(info, level);
---
    if SpellSorting ~= "Избранное" then
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Добавить в избранное';
        info.func = self.SetValue
        UIDropDownMenu_AddButton(info, level);
    end
---
    if SpellSorting == "Избранное" then
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Удалить из избранного';
        info.func = self.SetValue2
        UIDropDownMenu_AddButton(info, level);
    end
---
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Создать макрос';
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
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Добавить в избранное
function AnimatorNoble_dropDown:SetValue()
AddBlock = false
for k,v in pairs(AnimFavourites) do
    if v.id == New_favourite.id then
        AddBlock = true
    end
end
    if AddBlock == true then
        print("|cffff9716Анимация уже в избранном.|r")
    else
        print("|cffff9716Анимация добавлена в избранное.|r")
        table.insert(AnimFavourites,  New_favourite)
    end
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Удалить из избранного
function AnimatorNoble_dropDown:SetValue2()
for k,v in pairs(AnimFavourites) do        
    if v.id == New_favourite.id then
	table.remove(AnimFavourites,k)
    --AnimFavourites[k] = nil
    end
end
data = AnimFavourites
update()
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Создать макрос
function AnimatorNoble_dropDown:SetValue3()
local global, perChar = GetNumMacros()
local macroIndex = GetMacroIndexByName(New_favourite.name)
    if macroIndex == 0 then
        if perChar <18 then
            CreateMacro(New_favourite.name, 3, ".mod st "..New_favourite.id, 1)
            print("|cffff9716Макрос создан: "..New_favourite.name..".|r")
        else
            print("|cffff9716У Вас слишком много макросов.|r")
        end
    else
        print("|cffff9716Макрос уже создан.|r")
    end
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Закрытие
function AnimatorNoble_dropDown:SetValue4()
CloseDropDownMenus()
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Панель ввода
local EditBox1 = CreateFrame("EditBox", "SearchEditBox1", Noble_AnimlistMainPanel)
EditBox1:SetPoint("TOP", Noble_AnimlistMainPanel, "TOP", 15, -30)
EditBox1:SetHeight(13)
EditBox1:SetWidth(140)
EditBox1:SetAltArrowKeyMode(false)
EditBox1:SetAutoFocus(false)
EditBox1:SetFontObject(GameFontHighlightLarge)
EditBox1:SetMaxLetters(0)
EditBox1:SetFont("Fonts\\MORPHEUS.TTF", 14, "OUTLINE")
EditBox1:SetScript("OnEnterPressed", function(self)
	EditBox1:ClearFocus()
    end)
local EditBoxLabel = EditBox1:CreateFontString(nil, "OVERLAY", "GameFontNormal")
EditBoxLabel:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
EditBoxLabel:SetPoint("LEFT",-75,0)
EditBoxLabel:SetText("|cffffffffПоиск")
EditBox1:SetScript("OnTextChanged", function(self)
	local newList = {}
	for k,v in pairs(data) do
		local text = EditBox1:GetText()
		if tonumber(EditBox1:GetText()) then
			if string.find(v.id,text) then
				table.insert(newList,v)
			end
		else
			if string.find(v.name:upper(),text:upper()) then
				table.insert(newList,v)
			end
		end
	end
	data = newList
	if EditBox1:GetText() == "" then
		if SpellSorting == "Избранное" then
			data = AnimFavourites
			
		elseif SpellSorting == "Все" then
			data = animList
			
		end
	end
	update()
    end)

local EditBox1_texture = EditBox1:CreateTexture("ARTWORK")
EditBox1_texture:SetTexture("Interface\\NobleProject\\VisualSpell\\Editbox2.blp")
EditBox1_texture:SetPoint("CENTER",0,0)
EditBox1_texture:SetWidth(175) 
EditBox1_texture:SetHeight(35)
EditBox1_texture:SetAlpha(1)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Кнопка закрытия
local function Button_2_click()
        Noble_AnimlistMainPanel:Hide()
end
  
 local  Noble_AnimlistMainPanel_button_2 = CreateFrame("BUTTON", nil, Noble_AnimlistMainPanel, "SecureHandlerClickTemplate");
 Noble_AnimlistMainPanel_button_2:SetSize(25,25)
 Noble_AnimlistMainPanel_button_2:SetPoint("TOP", 148, 4);
 Noble_AnimlistMainPanel_button_2:RegisterForClicks("AnyUp")
 Noble_AnimlistMainPanel_button_2:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\close.blp")
 Noble_AnimlistMainPanel_button_2:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture4.blp")
 Noble_AnimlistMainPanel_button_2:SetScript("OnEnter", OnEnter);
 Noble_AnimlistMainPanel_button_2:SetScript("OnLeave",OnLeave);
 Noble_AnimlistMainPanel_button_2:SetScript("OnClick", Button_2_click)
 Noble_AnimlistMainPanel_button_2:Show()
 

---------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------/ Кнопка избранного
local function Button_3_click(self)
		if SpellSorting == "Все" then
			SpellSorting = "Избранное"
			self:LockHighlight()
			data = AnimFavourites
			update()
		elseif SpellSorting == "Избранное" then
			SpellSorting = "Все"
			self:UnlockHighlight()
			data = animList
			update()
		end
		
end
  
local  btn_favorite = CreateFrame("BUTTON", nil, Noble_AnimlistMainPanel, "SecureHandlerClickTemplate");
btn_favorite:SetSize(25,25)
btn_favorite:SetPoint("TOPRIGHT", -25, -26);
btn_favorite:RegisterForClicks("AnyUp")
btn_favorite:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\favorite.blp")
btn_favorite:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\highlight_favorite.blp")
btn_favorite:SetScript("OnEnter", OnEnter);
btn_favorite:SetScript("OnLeave",OnLeave);
btn_favorite:SetScript("OnClick", Button_3_click)
btn_favorite:Show()
btn_favorite:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
	GameTooltip:AddLine("Избранное")
	GameTooltip:Show()
	
end)
btn_favorite:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)


---------------------------------------/ Кнопка сброса
local function Button_4_click(self)
	if GMLevel > 0  and DMMode then
		SendChatMessage(".npc playemote 0", "WHISPER", nil, playerName);
	elseif DMLevel > 0 and DMMode then
		SendChatMessage(".npcplayemote 0", "WHISPER", nil, playerName);
	elseif PetControl.Target then
		SendChatMessage(".pet play 0 1", "WHISPER", nil, playerName);
	else
		SendChatMessage(".mod st 0", "WHISPER", nil, playerName);
	end
end
  
local  btn_reset = CreateFrame("BUTTON", nil, Noble_AnimlistMainPanel, "SecureHandlerClickTemplate");
btn_reset:SetSize(30,30)
btn_reset:SetPoint("BOTTOM", -148, -4);
btn_reset:RegisterForClicks("AnyUp")
btn_reset:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\reset.blp")
btn_reset:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\highlight_reset.blp")
btn_reset:SetScript("OnEnter", OnEnter);
btn_reset:SetScript("OnLeave",OnLeave);
btn_reset:SetScript("OnClick", Button_4_click)
btn_reset:Show()
btn_reset:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
	GameTooltip:AddLine("Сбросить анимацию")
	GameTooltip:Show()
	
end)
btn_reset:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)

---------------------DMCheckbox

 local CheckButton = CreateFrame("BUTTON", nil, Noble_AnimlistMainPanel, "SecureHandlerClickTemplate");
 CheckButton:Hide()
 CheckButton:SetSize(23,23)
 CheckButton:SetPoint("TOP", -125, 18);
 CheckButton:RegisterForClicks("AnyUp")
 CheckButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox1.blp")
 CheckButton:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\CheckBox3.blp", 0.1)
 CheckButton:SetScript("OnEnter", OnEnter);
 CheckButton:SetScript("OnLeave",OnLeave);
 CheckButton:SetScript("OnClick", function(self)
  if DMMode == true then
     DMMode = false
     CheckButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox1.blp")
 else
     DMMode = true
     CheckButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox2.blp")
 end
 end)
 
local TitleCheckbox = CheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TitleCheckbox:SetPoint("CENTER", CheckButton, "TOP", 70, -11)
TitleCheckbox:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
TitleCheckbox:SetText("Запускать для НПС")
TitleCheckbox:SetAlpha(0.7)


Noble_AnimlistMainPanel:SetScript("OnShow", function(self)
	if DMLevel > 0 or GMLevel > 0 then
		CheckButton:Show()
	end
end)