---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Начальные переменные
SpellGroup = {
}
SortList = {
"Все заклинания",
"Избранное",
"Свет",
"Тьма",
"Аркана",
"Лёд",
"Огонь",
"Природа",}
SpellFavourites = {}
Sort_Type = {1, 2, 3}
Save_tool = {}
local SpellSorting = "Все заклинания"
local data = {}
local TableSelect = SpellGroup;
local scrollFrame
local numButtons = 5
local buttonHeight = 25
local playerName = UnitName("player")
local CheckButtonVar1 = true;
local CheckButtonVar2 = true;
local SearchBlock = true;
local Search_textbox1 = "";
local FirstLoad = true
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Захватчик-обработчик

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Мейнфрейм
local VSN_MainPanel = CreateFrame("Frame", "VSN_MainPanel", UIParent)
VSN_MainPanel:SetWidth(250)
VSN_MainPanel:SetHeight(175)
VSN_MainPanel:Hide()
VSN_MainPanel:SetPoint("CENTER", UIParent, "CENTER")
VSN_MainPanel:EnableMouse()
VSN_MainPanel:SetMovable(true)
VSN_MainPanel:SetFrameStrata("FULLSCREEN_DIALOG")
VSN_MainPanel:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
VSN_MainPanel:SetBackdropColor(0, 0, 0, 1)
VSN_MainPanel:SetScript("OnDragStart", function(self) self:StartMoving() end)
VSN_MainPanel:SetScript("OnMouseDown", function(self) self:StartMoving() end)
VSN_MainPanel:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
VSN_MainPanel:RegisterForDrag("LeftButton","RightButton")
VSN_MainPanel:SetClampedToScreen(true)

local VSN_MainPanel_texture = VSN_MainPanel:CreateTexture("ARTWORK") -- задать текстурку
VSN_MainPanel_texture:SetTexture("Interface\\NobleProject\\VisualSpell\\1.blp")
VSN_MainPanel_texture:SetPoint("CENTER",0,-13)
VSN_MainPanel_texture:SetWidth(260) 
VSN_MainPanel_texture:SetHeight(260)
VSN_MainPanel_texture:SetAlpha(1)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Апдейт-дата
local function update()
  FauxScrollFrame_Update(scrollFrame,#data,numButtons,buttonHeight)
  for index = 1,numButtons do
    local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
    local button = scrollFrame.buttons[index]
    button.index = offset
    if offset<=#data then
      button:SetText(data[offset])
      button:Show()
    else
      button:Hide()
    end
  end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ КД на заклинания
local Skill_block = false;
local SkillBlockPanel = CreateFrame("Frame")
local SkillBlockPanel_AnimationGroup = SkillBlockPanel:CreateAnimationGroup()
local ButtonSkillBlockPanel = SkillBlockPanel_AnimationGroup:CreateAnimation("Alpha")
ButtonSkillBlockPanel:SetDuration(1)
SkillBlockPanel_AnimationGroup:SetScript("OnFinished", function(self)
        Skill_block = false;
            end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Скролл-меню
local Base_frame = CreateFrame("frame","NobleSpellFrame",VSN_MainPanel)
Base_frame:SetSize(220,numButtons*buttonHeight+16)
Base_frame:SetPoint("CENTER", 0, -5)
Base_frame:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
Base_frame:SetAlpha(0.9)
scrollFrame = CreateFrame("ScrollFrame","NobleSpellScrollFrame",Base_frame,"FauxScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",0,-8)
scrollFrame:SetPoint("BOTTOMRIGHT",-30,8)
scrollFrame:SetScript("OnVerticalScroll",function(self,offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, buttonHeight, update)
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Основной лист кнопок
scrollFrame.buttons = {}
for i=1,numButtons do
  scrollFrame.buttons[i] = CreateFrame("Button",nil,Base_frame)
  local button = scrollFrame.buttons[i]
  button:SetSize(166,buttonHeight)
  button:SetNormalFontObject("GameFontHighlightLeft")
  button:SetPoint("TOPLEFT",8,-(i-1)*buttonHeight-8)
  button:RegisterForClicks("AnyUp")
  button:SetScript("OnEnter",function(self)
        ----------// Описание скила
    if Save_tool["Tooltip"] == nil or Save_tool["Tooltip"] == "ON" then
        SpellName = data[self.index]
            for k,v in pairs(TableSelect) do
            iconTexture = GetMacroIconInfo(v.Icon)
               if "\124T"..tostring(iconTexture)..":25\124t  "..v.Name == SpellName then
                SpellTooltip1 = v.Name
                SpellTooltip2 = v.Description
               end
            end
        -------
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine(SpellTooltip1)
    GameTooltip:AddLine(SpellTooltip2, 1, 1, 1, true)
    GameTooltip:Show()
    end
  end)
  button:SetScript("OnLeave",function(self)
    GameTooltip:Hide()
  end)
 button:SetScript("OnClick",function(self)
 buttonName = GetMouseButtonClicked();
      SpellName = data[self.index]
            for k,v in pairs(TableSelect) do
               iconTexture = GetMacroIconInfo(v.Icon)
               if "\124T"..tostring(iconTexture)..":25\124t  "..v.Name == SpellName then
                   if buttonName == "RightButton" then
                        ToggleDropDownMenu(1, nil, SpellNoble_dropDown, 'cursor', 0, 0); ------// Дроп меню
                        New_favourite = k
                   else
                        if Skill_block == false then
                            SendChatMessage(".castvisualspell "..TableSelect[k].ID, "WHISPER", nil, playerName);
                            Skill_block = true;
                            ButtonSkillBlockPanel:Play()
                        else
                            UIErrorsFrame:AddMessage("Заклинание еще недоступно.", 1.0, 0.0, 0.0, 53, 1);
                        end
                   end
               end
            end
end)
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Рефреш
function  DataRefresh()
    wipe(data)
    
        for k,v in pairs(TableSelect) do
        iconTexture = GetMacroIconInfo(v.Icon)
            if SearchBlock == false then
                if string.find(string.lower(v.Name), string.lower(Search_textbox1)) then
                        if tContains(Sort_Type, v.Sort) then
                            tinsert(data,"\124T"..tostring(iconTexture)..":25\124t  "..v.Name)
                        end
                end
            else
            ---
                if SpellSorting == "Все заклинания" then 
                        if tContains(Sort_Type, v.Sort) then
                            tinsert(data,"\124T"..tostring(iconTexture)..":25\124t  "..v.Name)
                        end
                elseif SpellSorting == "Избранное" then
                                if tContains(Sort_Type, v.Sort) then
                                    tinsert(data,"\124T"..tostring(iconTexture)..":25\124t  "..v.Name)
                                end
                else
                    if v.School == SpellSorting then
                                if tContains(Sort_Type, v.Sort) then
                                    tinsert(data,"\124T"..tostring(iconTexture)..":25\124t  "..v.Name)
                                end
                    end
                end
            ---
            end
        end   
  FauxScrollFrame_Update(scrollFrame,#data,numButtons,buttonHeight)
  update()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Правый клик, избранное
local SpellNoble_dropDown = CreateFrame("FRAME", "SpellNoble_dropDown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(SpellNoble_dropDown, function(self, level, menuList)
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
function SpellNoble_dropDown:SetValue()
    for k,v in pairs(SpellFavourites) do
        if TableSelect[New_favourite].ID == SpellFavourites[k].ID then
            print("|cffff9716Заклинание уже есть в избранном.|r")
            return
        end
    end
    print("|cffff9716Заклинание добавлено в избранное.|r")
    table.insert(SpellFavourites, TableSelect[New_favourite])
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Удалить из избранного
function SpellNoble_dropDown:SetValue2()
SpellFavourites[New_favourite] = nil
DataRefresh()
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------// Создать макрос
function SpellNoble_dropDown:SetValue3()
local global, perChar = GetNumMacros()
local macroIndex = GetMacroIndexByName(SpellGroup[New_favourite].Name)
    if macroIndex == 0 then
        if perChar <18 then
            CreateMacro(SpellGroup[New_favourite].Name, SpellGroup[New_favourite].Icon, ".castvisualspell "..SpellGroup[New_favourite].ID, 1)
            print("|cffff9716Макрос создан: "..SpellGroup[New_favourite].Name..".|r")
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
function SpellNoble_dropDown:SetValue4()
CloseDropDownMenus()
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Лист школ
local scrollSortFramePanel

local function ListUpdate()
  FauxScrollFrame_Update(scrollSortFramePanel,#SortList,6,16)
  for index2 = 1,6 do
    local offset2 = index2 + FauxScrollFrame_GetOffset(scrollSortFramePanel)
    local NVS_buttonSpell = scrollSortFramePanel.buttons[index2]
    NVS_buttonSpell.index2 = offset2
    if offset2<=#SortList then
      NVS_buttonSpell:SetText(SortList[offset2])
      NVS_buttonSpell:Show()
    else
      NVS_buttonSpell:Hide()
    end
  end
end

local SortFramePanel = CreateFrame("Frame","NVSAddon2",VSN_MainPanel)
SortFramePanel:SetSize(220,6*16+16)
SortFramePanel:SetPoint("CENTER", 0, 10)
SortFramePanel:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
SortFramePanel:SetAlpha(0.9)
SortFramePanel:Hide()

scrollSortFramePanel = CreateFrame("ScrollFrame","NVSAddonScrollSortFramePanel",SortFramePanel,"FauxScrollFrameTemplate")
scrollSortFramePanel:SetPoint("TOPLEFT",0,-8)
scrollSortFramePanel:SetPoint("BOTTOMRIGHT",-30,8)
scrollSortFramePanel:Show()
scrollSortFramePanel:SetScript("OnVerticalScroll",function(self,offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, 16, ListUpdate)
end)

scrollSortFramePanel.buttons = {}
for i=1,6 do
  scrollSortFramePanel.buttons[i] = CreateFrame("Button",nil,SortFramePanel)
  local NVS_buttonSpell = scrollSortFramePanel.buttons[i]
  NVS_buttonSpell:SetSize(166,16)
  NVS_buttonSpell:SetNormalFontObject("GameFontHighlightMedium")
  NVS_buttonSpell:SetPoint("TOPLEFT",27,-(i-1)*16-8)
  NVS_buttonSpell:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine(SortList[self.index])
    GameTooltip:Show()
  end)
  NVS_buttonSpell:SetScript("OnLeave",function(self)
    GameTooltip:Hide()
  end)
 NVS_buttonSpell:SetScript("OnClick",function(self)
 TitleText = SortList[self.index2]
 SpellSorting = SortList[self.index2]
    if SortList[self.index2] == "Избранное" then
        TableSelect = SpellFavourites;
    else
        TableSelect = SpellGroup;
    end
 SearchBlock = true;
 GButton_3_click()
 SetTextNobleFrame()
 end)
end

ListUpdate()
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Интерфейс

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Чекбокс 1
 local CheckButtonSort = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 CheckButtonSort:Hide()
 CheckButtonSort:SetSize(23,23)
 CheckButtonSort:SetPoint("CENTER", -95, -60);
 CheckButtonSort:RegisterForClicks("AnyUp")
 CheckButtonSort:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox2.blp")
 CheckButtonSort:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\CheckBox3.blp", 0.1)
 CheckButtonSort:SetScript("OnEnter", OnEnter);
 CheckButtonSort:SetScript("OnLeave",OnLeave);
 CheckButtonSort:SetScript("OnClick", function(self)
  if CheckButtonVar1 == true then
     CheckButtonVar1 = false
     for k,v in pairs(Sort_Type) do
            if v == 1 then
                table.remove(Sort_Type , k)
            end
     end
     CheckButtonSort:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox1.blp")
 else
     CheckButtonVar1 = true
     table.insert(Sort_Type,  1)
     CheckButtonSort:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox2.blp")
 end
 end)
 
local Title2 = CheckButtonSort:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Title2:SetPoint("CENTER", CheckButtonSort, "TOP", 48, -11)
Title2:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Title2:SetText("Разовые")
Title2:SetAlpha(0.7)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Чекбокс 2
 local CheckButtonSort2 = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 CheckButtonSort2:Hide()
 CheckButtonSort2:SetSize(23,23)
 CheckButtonSort2:SetPoint("CENTER", 5, -60);
 CheckButtonSort2:RegisterForClicks("AnyUp")
 CheckButtonSort2:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox2.blp")
 CheckButtonSort2:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\CheckBox3.blp", 0.1)
 CheckButtonSort2:SetScript("OnEnter", OnEnter);
 CheckButtonSort2:SetScript("OnLeave",OnLeave);
 CheckButtonSort2:SetScript("OnClick", function(self)
  if CheckButtonVar2 == true then
     CheckButtonVar2 = false
     for k,v in pairs(Sort_Type) do
            if v == 2 then
                table.remove(Sort_Type , k)
            end
     end
     CheckButtonSort2:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox1.blp")
 else
     CheckButtonVar2 = true
     table.insert(Sort_Type,  2)
     CheckButtonSort2:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\CheckBox2.blp")
 end
 end)
 
local Title3 = CheckButtonSort2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Title3:SetPoint("CENTER", CheckButtonSort2, "TOP", 58, -11)
Title3:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Title3:SetText("Длительные")
Title3:SetAlpha(0.7)


---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Панель ввода
local EditBox1 = CreateFrame("EditBox", "SearchEditBox1", VSN_MainPanel)
EditBox1:SetPoint("CENTER", VSN_MainPanel, "CENTER", 5, 20)
EditBox1:SetHeight(5)
EditBox1:SetWidth(170)
EditBox1:SetAltArrowKeyMode(false)
EditBox1:SetAutoFocus(true)
EditBox1:SetFontObject(GameFontHighlightLarge)
EditBox1:SetMaxLetters(0)
EditBox1:SetFont("Fonts\\MORPHEUS.TTF", 20, "OUTLINE")
EditBox1:SetScript("OnEnterPressed", function(self)
    end);
EditBox1:Hide()

local EditBox1_texture = EditBox1:CreateTexture("ARTWORK")
EditBox1_texture:SetTexture("Interface\\NobleProject\\VisualSpell\\Editbox2.blp")
EditBox1_texture:SetPoint("CENTER",0,0)
EditBox1_texture:SetWidth(205) 
EditBox1_texture:SetHeight(51)
EditBox1_texture:SetAlpha(1)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Кнопка "поиск"
 local  OK_SearchButton = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 OK_SearchButton:Hide()
 OK_SearchButton:SetSize(154,77)
 OK_SearchButton:SetPoint("CENTER", 0, -20);
 OK_SearchButton:RegisterForClicks("AnyUp")
 OK_SearchButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\SearchClick.blp")
 OK_SearchButton:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture2.blp")
 OK_SearchButton:SetScript("OnEnter", OnEnter);
 OK_SearchButton:SetScript("OnLeave",OnLeave);
 OK_SearchButton:SetScript("OnClick", function(self)
SearchBlock = false;
Search_textbox1 = EditBox1:GetText()
        Base_frame:Show()
        SortFramePanel:Hide()
        CheckButtonSort:Hide()
        CheckButtonSort2:Hide()
        EditBox1:Hide()
        OK_SearchButton:Hide()
DataRefresh()
 end)
 
local TitleSearchButton = OK_SearchButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
TitleSearchButton:SetPoint("CENTER", OK_SearchButton, "TOP", 0, -38)
TitleSearchButton:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
TitleSearchButton:SetText("Поиск")
TitleSearchButton:SetAlpha(0.8)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Кнопка включения панели поиска
local function Button_1_click()
--
EditBox1:Show()
OK_SearchButton:Show()
CheckButtonSort:Show()
CheckButtonSort2:Show()
TitleText = "Поиск по названию"
SetTextNobleFrame()
--
 if Base_frame:IsVisible() then
        Base_frame:Hide()
    else
        SortFramePanel:Hide()
    end
end
  
 local  VSN_MainPanel_button_1 = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 VSN_MainPanel_button_1:SetSize(25,25)
 VSN_MainPanel_button_1:SetPoint("CENTER", -92, 80);
 VSN_MainPanel_button_1:RegisterForClicks("AnyUp")
 VSN_MainPanel_button_1:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\Search.blp")
 VSN_MainPanel_button_1:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture3.blp")
 VSN_MainPanel_button_1:SetScript("OnEnter", OnEnter);
 VSN_MainPanel_button_1:SetScript("OnLeave",OnLeave);
 VSN_MainPanel_button_1:SetScript("OnClick", Button_1_click)
 VSN_MainPanel_button_1:Show()
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Кнопка закрытия
local function Button_2_click()
        VSN_MainPanel:Hide()
end
  
 local  VSN_MainPanel_button_2 = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 VSN_MainPanel_button_2:SetSize(25,25)
 VSN_MainPanel_button_2:SetPoint("CENTER", 95, 80);
 VSN_MainPanel_button_2:RegisterForClicks("AnyUp")
 VSN_MainPanel_button_2:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\close.blp")
 VSN_MainPanel_button_2:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture4.blp")
 VSN_MainPanel_button_2:SetScript("OnEnter", OnEnter);
 VSN_MainPanel_button_2:SetScript("OnLeave",OnLeave);
 VSN_MainPanel_button_2:SetScript("OnClick", Button_2_click)
 VSN_MainPanel_button_2:Show()
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Центральная кнопка
function GButton_3_click()
    if Base_frame:IsVisible() then
        Base_frame:Hide()
        SortFramePanel:Show()
        CheckButtonSort:Show()
        CheckButtonSort2:Show()
        TitleText = "Сортировка"
        EditBox1:Hide()
        OK_SearchButton:Hide()
    else
        Base_frame:Show()
        SortFramePanel:Hide()
        CheckButtonSort:Hide()
        CheckButtonSort2:Hide()
        TitleText = SpellSorting
        EditBox1:Hide()
        OK_SearchButton:Hide()
    end
SearchBlock = true;
SetTextNobleFrame()
DataRefresh()
end
  
 local  VSN_MainPanel_button_3 = CreateFrame("BUTTON", nil, VSN_MainPanel, "SecureHandlerClickTemplate");
 VSN_MainPanel_button_3:SetSize(179,90)
 VSN_MainPanel_button_3:SetPoint("CENTER", 0, 80);
 VSN_MainPanel_button_3:RegisterForClicks("AnyUp")
 VSN_MainPanel_button_3:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\2.blp")
 VSN_MainPanel_button_3:SetPushedTexture("Interface\\NobleProject\\VisualSpell\\2.blp", 0.1)
 VSN_MainPanel_button_3:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture1.blp", 0.1)
 VSN_MainPanel_button_3:SetScript("OnEnter", OnEnter);
 VSN_MainPanel_button_3:SetScript("OnLeave",OnLeave);
 VSN_MainPanel_button_3:SetScript("OnClick", GButton_3_click)
 VSN_MainPanel_button_3:Show()
 
local Title1 = VSN_MainPanel_button_3:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
Title1:SetPoint("CENTER", VSN_MainPanel_button_3, "TOP", 0, -42)
Title1:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
Title1:SetText("Все заклинания")
Title1:SetAlpha(0.9)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Текст на кнопке
 function SetTextNobleFrame()
 Title1:SetText(TitleText)
 end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ Кнопка на ободке миникарты
Spell_NobleMiniMapButtonPosition = {
	locationAngle = -45,
	x = 52-(80*cos(-15)),
	y = ((80*sin(-15))-52)
}

function SpNobleMiniMapButton_Reposition()
	Spell_NobleMiniMapButtonPosition.x = 52-(80*cos(Spell_NobleMiniMapButtonPosition.locationAngle))
	Spell_NobleMiniMapButtonPosition.y = ((80*sin(Spell_NobleMiniMapButtonPosition.locationAngle))-52)
	SpNobleMiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",Spell_NobleMiniMapButtonPosition.x,Spell_NobleMiniMapButtonPosition.y)
end

function Spell_NobleMiniMapButtonPosition_LoadFromDefaults()
	SpNobleMiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",Spell_NobleMiniMapButtonPosition.x,Spell_NobleMiniMapButtonPosition.y)
end
function SpNoble_Minimap_Update()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 
	ypos = ypos/UIParent:GetScale()-ymin-70

	Spell_NobleMiniMapButtonPosition.locationAngle = math.deg(math.atan2(ypos,xpos))
	SpNobleMiniMapButton_Reposition()
end

function SpNobleMiniMapButton_OnClick()
	ToggleDropDownMenu(1, nil, ChooseFrameDropDown, 'cursor', 0, 0);
end

local ChooseFrameDropDown = CreateFrame("FRAME", "ChooseFrameDropDown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(ChooseFrameDropDown, function(self, level, menuList)
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = "Меню";
UIDropDownMenu_AddButton(info, level);

local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Анимации';
info.func = self.SetValue
UIDropDownMenu_AddButton(info, level);

---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Визуальные эффекты';
info.func = self.SetValue2
UIDropDownMenu_AddButton(info, level);
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Мелодии барда';
info.func = self.SetValue4
UIDropDownMenu_AddButton(info, level);
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Закрыть';
info.func = self.SetValue3
UIDropDownMenu_AddButton(info, level);
end)

function ChooseFrameDropDown:SetValue()
	Noble_AnimlistMainPanel:Show()
CloseDropDownMenus()
end
function ChooseFrameDropDown:SetValue2()
	Handle_SpNobleGUI()
CloseDropDownMenus()
end
function ChooseFrameDropDown:SetValue4()
	BardAddon.ShowInterface()
CloseDropDownMenus()
end

function ChooseFrameDropDown:SetValue3()
CloseDropDownMenus()
end



function Handle_SpNobleGUI()
    if VSN_MainPanel:IsVisible() then
        VSN_MainPanel:Hide()
    else
        if FirstLoad == true then
            TableSelect = SpellGroup;
            FirstLoad = false
        end
        VSN_MainPanel:Show()
        DataRefresh()
        ListUpdate()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------/ CMD
function castvisualspell(msg, editbox)
local msg, arg = msg:match("^(%S*)%s*(.-)$");
    if msg == "tooltip" then
        if arg == "on" then
            Save_tool["Tooltip"] = "ON"
            print("|cffff9716Всплывающие подсказки включены.|r")
        elseif arg == "off" then
            Save_tool["Tooltip"] = "OFF"
            print("|cffff9716Всплывающие подсказки отключены.|r")
        end
    elseif msg == "reset" then
        if arg == "all" then
                VSN_MainPanel:ClearAllPoints();
                VSN_MainPanel:SetPoint("CENTER", UIParent, "CENTER");
                wipe(SpellGroup)
                wipe(SortList)
                wipe(SpellFavourites)
				wipe(AnimFavourites)
                wipe(Save_tool)
            print("|cffff9716Настройки сброшены.|r")
        elseif arg == "position" then
                VSN_MainPanel:ClearAllPoints();
                VSN_MainPanel:SetPoint("CENTER", UIParent, "CENTER");
                VSN_MainPanel:Show()
                DataRefresh()
                ListUpdate()
        end
    elseif msg == "on" then
        if FirstLoad == true then
            TableSelect = SpellGroup;
            FirstLoad = false
        end
        VSN_MainPanel:Show()
        DataRefresh()
        ListUpdate()
    elseif msg == "off" then
        VSN_MainPanel:Hide()
    else
        print("|cffff9716Настройки:|r")
        print("|cffff9716/vsn on/off - Включение/выключение аддона.|r")
        print("|cffff9716/vsn tooltip on/off - Включение/выключение подсказок.|r")
        print("|cffff9716/vsn reset all - Сброс всех настроек.|r")
        print("|cffff9716/vsn reset position - Сброс местоположения на экране.|r")
    end
end


SlashCmdList["SPELLVSTRINGS"] = castvisualspell;
SLASH_SPELLVSTRINGS1 = "/vsn";
SLASH_SPELLVSTRINGS2 = "/VSN";