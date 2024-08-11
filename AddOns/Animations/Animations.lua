--/ Discord: erlano#7703

-- КулТирас - Naga

------------------------------/
--/ ПЕРЕМЕННЫЕ
------------------------------/

--/ Статические переменные
local AddonName = "Animations"; -- Уникальный префикс аддона
local menu_button_x = 80; -- Длина кнопки меню
local menu_button_y = 24; -- Высота кнопки меню
local menu_button_margin = 0; -- Внешний отступ кнопок меню
local menu_button_reset = 15; -- Отступ кнопки "Сброс"
local menu_frame_margin = 7;  -- Внутренний отступ от границ фрейма к кнопкам
local menu_text_size = 13; -- Размер текста меню
local button_x = 80; -- Длина кнопки
local button_y = 22; -- Высота кнопки
local category_button_margin = 0; -- Внешний отступ кнопок
local category_button_x = 6; -- Сколько кнопок в строчке
local category_button_y = 4; -- Сколько кнопок в столпце
local category_frame_margin = 5;  -- Внутренний отступ от границ фрейма к кнопкам
local category_text_size = 11; -- Размер текста
local text_color = "|cfffff3d4"; -- Основной цвет текста
local text_color_hover = "|cfff5c056"; -- Основной цвет текста при наведении
--/ Динамические переменные
local menu_bx = 0;
local category_bx = 0;
local category_by = 0;
local frame_x = 0;
local frame_y = 0;
local menu_frame_x = 0;
local menu_frame_y = 0;
local button_name;
local all_show = false;
local category_show = {};


-- local race1, race2 = UnitRace("player");
-- print("Раса: "..race1..", "..race2);

-- Функция нажатия на кнопку анимации
function Anim(id)
-- button_name (LeftButton, RightButton, MiddleButton)
--SendChatMessage(".mod st "..id, "WHISPER", GetDefaultLanguage("player"), GetUnitName("player"));
if UnitIsPlayer("target") or UnitName("target") == nil then
	SendChatMessage(".mod st "..id);
else
	SendChatMessage(".npcplayemote "..id.." 1");
end
end


------------------------------/
--/ ФРЕЙМ МЕНЮ
------------------------------/
NobleAnimAddon = NobleAnimAddon or {}
NobleAnimAddon.category_name = {"Общение","Стойки", "Бой", "Прочее", "Открыть", "Сброс"};

menu_frame_x = ((menu_button_x+menu_button_margin)*(#NobleAnimAddon.category_name))+menu_frame_margin*2-menu_button_margin+menu_button_reset;
menu_frame_y = menu_button_y+menu_frame_margin*2;
AnimMainFrame =  CreateFrame("Frame", AddonName.."AnimMainFrame", UIParent)
AnimMainFrame:SetPoint("TOP", UIParent, "TOP", 0, -10)
AnimMainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
AnimMainFrame:SetSize(menu_frame_x,menu_frame_y)
AnimMainFrame:SetClampedToScreen(true)
AnimMainFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
AnimMainFrame:Show()

--/ Однотонная текстура цветом
local AnimMainFrameTexture = CreateFrame("Frame", nil, AnimMainFrame)
AnimMainFrameTexture:SetPoint("CENTER",0,0)
AnimMainFrameTexture:SetFrameStrata("FULLSCREEN_DIALOG")
AnimMainFrameTexture:SetSize(menu_frame_x-10,menu_frame_y-10)
AnimMainFrameTexture:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", })
AnimMainFrameTexture:SetBackdropColor(0.96, 0.79, 0.46, 0.8)
AnimMainFrameTexture:Show()

--/ Если текстура картинкой
-- local AnimMainFrameTexture = AnimMainFrame:CreateTexture("ARTWORK")
-- AnimMainFrameTexture:SetTexture("Interface\\AddOns\\Animations\\textures\\background.blp")
-- AnimMainFrameTexture:SetPoint("CENTER",0,0)
-- AnimMainFrameTexture:SetSize(menu_frame_x-10,menu_frame_y-10)
-- AnimMainFrameTexture:SetAlpha(0.9)

--/ Перемещение фрейма
AnimMainFrame:EnableMouse()
AnimMainFrame:SetMovable(true);
AnimMainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
AnimMainFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
AnimMainFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
AnimMainFrame:Hide()

--/ Кнопка закрытия
---------------------------------------------------------------------------------------------------------------------------------------------------------------

CloseButton = CreateFrame("BUTTON", nil, AnimMainFrame, "SecureHandlerClickTemplate");
CloseButton:SetSize(18,18)
CloseButton:SetPoint("TOPRIGHT", 7, 6);
CloseButton:RegisterForClicks("AnyUp")
CloseButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\close.blp")
CloseButton:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture4.blp")
CloseButton:Show()

----Вызов старого интерфейса
CallListboxButton = CreateFrame("BUTTON", nil, AnimMainFrame, "SecureHandlerClickTemplate");
CallListboxButton:SetSize(18,18)
CallListboxButton:SetPoint("BOTTOMRIGHT", 7, -6);
CallListboxButton:RegisterForClicks("AnyUp")
CallListboxButton:SetNormalTexture("Interface\\NobleProject\\VisualSpell\\Search.blp")
CallListboxButton:SetHighlightTexture("Interface\\NobleProject\\VisualSpell\\ButtonHighlightTexture3.blp")
CallListboxButton:SetScript("OnEnter", OnEnter);
CallListboxButton:SetScript("OnLeave",OnLeave);
CallListboxButton:Show()

CallListboxButton:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Поиск анимаций/Избранное")
    GameTooltip:Show()
  end)
CallListboxButton:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)

local function OpenListBox()
	Noble_AnimlistMainPanel:Show()
end
CallListboxButton:SetScript("OnClick", OpenListBox)

--/ Создание кнопок в меню
local button_menu = {};
local button_menu_sub = {};
local button_menu_text = {};
local button_menu_texture = {};
menu_bx = 0;
for b=1, #NobleAnimAddon.category_name do
	button_menu[b] = CreateFrame("Button", nil, AnimMainFrame)
	local button = button_menu[b]
	button_menu_sub[b] = CreateFrame("Button", nil, AnimMainFrame)
	local button_sub = button_menu_sub[b]
		button_menu_texture[b] = CreateFrame("Frame", nil, button_sub)
		local texture = button_menu_texture[b]
		texture:SetPoint("CENTER",0,0)
		texture:SetSize(menu_button_x-10,menu_button_y-10)
		texture:SetFrameStrata("FULLSCREEN_DIALOG")
		texture:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", })
		texture:SetBackdropColor(0.35, 0.35, 0.35, 1)
		texture:Show()
	button_menu_text[b] = texture:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	local button_text = button_menu_text[b]
	button:SetSize(menu_button_x,menu_button_y)
	button_sub:SetSize(menu_button_x,menu_button_y)
	if (b>=(#NobleAnimAddon.category_name-1)) then
		button:SetPoint("TOPLEFT", ((menu_button_x+menu_button_margin)*menu_bx)+menu_frame_margin+menu_button_reset, -menu_frame_margin)
		button_sub:SetPoint("TOPLEFT", ((menu_button_x+menu_button_margin)*menu_bx)+menu_frame_margin+menu_button_reset, -menu_frame_margin)
	else
		button:SetPoint("TOPLEFT", ((menu_button_x+menu_button_margin)*menu_bx)+menu_frame_margin, -menu_frame_margin)
		button_sub:SetPoint("TOPLEFT", ((menu_button_x+menu_button_margin)*menu_bx)+menu_frame_margin, -menu_frame_margin)
	end
	menu_bx = menu_bx + 1;
	button:RegisterForClicks("AnyUp")
	button:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
	button:SetAlpha(0.75)
	button:Show()
	button_sub:Show()
	button_text:SetPoint("CENTER", 0, 1)
	button_text:SetFont("Fonts\\FRIZQT__.ttf", menu_text_size, "OUTLINE")
	button_text:SetText(text_color..NobleAnimAddon.category_name[b].."|r")
	button_text:SetAlpha(1)
	button_text:Show()
	button:SetScript("OnEnter", function(self)
		button_text:SetText(text_color_hover..NobleAnimAddon.category_name[b].."|r")
		button:SetBackdrop( { edgeFile="Interface\\AddOns\\Animations\\textures\\hover.blp", edgeSize = 16 } )
		button:SetAlpha(1)
		if (b==(#NobleAnimAddon.category_name-1)) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -15, -10);
			GameTooltip:AddLine(text_color_hover.."Открыть/Свернуть|r");
			GameTooltip:AddLine(text_color.."Открыть или Свернуть все категории анимаций.|r", 1, 1, 1, true);
			GameTooltip:Show();
		elseif (b==(#NobleAnimAddon.category_name)) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -15, -10);
			GameTooltip:AddLine(text_color_hover.."Сброс|r");
			GameTooltip:AddLine(text_color.."Сбросить текущую анимацию и вернуться к изначальной анимации.|r", 1, 1, 1, true);
			GameTooltip:Show();
		end
	end)
	button:SetScript("OnLeave", function()
		button_text:SetText(text_color..NobleAnimAddon.category_name[b].."|r")
		button:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
		button:SetAlpha(0.75)
		GameTooltip:Hide();
	end)
end

local button_anim_info = {
{
	{"Говорить",1},
	{"Поклон",2},
	{"Помахать",3},
	{"Радость",4},
	{"Восклицать",5},
	{"Спрашивать",6},
	{"Есть",7},
	{"Танец 1",400},
	{"Танец 2",401},
	{"Смех",11},
	{"Жест",14},
	{"Ярость",15},
	{"Колено",398},
	{"Поцелуй",17},
	{"Плач",18},
	{"Цыпа-цыпа",19},
	{"Страх",430},
	{"Хлопать",21},
	{"Кричать",22},
	{"Мускулы",23},
	{"Флирт",24},
	{"Указать",25},
	{"Честь",66},
	{"Сидеть",415},
},
{
	{"Кулаки",27},
	{"Два меча",45},
	{"Лук 1",48},
	{"Лук 2",376},
	{"Прицел",384},
	{"Ружье",214},
	{"Прицел",385},
	{"Метатель 1",386},
	{"Метатель 2",465},
	{"Меч",375},
	{"Древковое",425},
	{"Каст 1",434},
	{"Каст 2",468},
	{"Каст 3",469},
	{"Каст 4",474},
	{"Каст 5",486},
	{"Красться",433},
	{"Изучать",381},
	{"На плече",485},
	{"Герой",483},
	{"Смирно 1",488},
	{"Смирно 2",489},
	{"На коне 1",424},
	{"На коне 2",471},
},
{
	{"Кирка",173},
	{"Кулаки",35},
	{"Апперкот",451},
	{"Хук",51},
	{"С разворота",54},
	{"Удар ногой",60},
	{"Одноручное",36},
	{"Двуручное",37},
	{"Двуручное",38},
	{"Метание",61},
	{"Мельница",382},
	{"Топот",388},
	{"Рубящий",389},
	{"Колящий",390},
	{"Выстрел 1",435},
	{"Выстрел 2",436},
	{"Урон 1",33},
	{"Урон 2",34},
	{"Блок 1",39},
	{"Блок 2",43},
	{"Блок 3",441},
	{"Блок 4",442},
	{"Уклон",440},
},
{
	{"Работать",69},
	{"Кирка",233},
	{"Топор",234},
	{"Рыбачить",379},
	{"Удочка",380},
	{"Утонул",383},
	{"Утопиться",387},
	{"Полет",399},
	{"Стучать",419},
	{"Распят",420},
	{"В воде",437},
	{"Оглушение",64},
	{"Удушение",473},
	{"Бежать",477},
	{"Пьяный",487},
	{"Весло",492},
	{"Грести",491},
	{"Забивать",495},
	{"К стене",490},
	{"Драить пол",493},
	{"Пленный",496},
	{"В баре",497},
	{"Смерть",445},
	{"Мертвый",7},
},
};

------------------------------/
--/ ФРЕЙМЫ КАТЕГОРИЙ
------------------------------/

--/ Создание переменных для фреймов и кнопок
local frame_category = {};
local frame_category_texture = {};
local button_anim = {};
local button_anim_sub = {};
local button_anim_text = {};
local button_anim_texture = {};
--/ Цикл создания категорий
frame_x = ((button_x+category_button_margin)*category_button_x)+category_frame_margin*2-category_button_margin;
frame_y = (button_y+category_button_margin)*category_button_y+category_frame_margin*2-category_button_margin;
for i=1, (#NobleAnimAddon.category_name-2) do
category_show[i] = false;
--/ Создание фрейма категории
frame_category[i] =  CreateFrame("Frame", AddonName.."frame_category"..i, UIParent)
local frame = frame_category[i];
frame:SetPoint("TOP", UIParent, "TOP", 0, -menu_frame_y-(frame_y*(i-1)))
frame:SetFrameStrata("FULLSCREEN")
frame:SetSize(frame_x,frame_y)
frame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:Hide()
--/ Однотонная текстура цветом для фрейма категории
frame_category_texture[i] =  CreateFrame("Frame", nil, frame)
local frame_texture = frame_category_texture[i];
frame_texture:SetPoint("CENTER",0,0)
frame_texture:SetFrameStrata("FULLSCREEN")
frame_texture:SetSize(frame_x-10,frame_y-10)
frame_texture:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", })
frame_texture:SetBackdropColor(0.96, 0.79, 0.46, 0.8)
frame_texture:Show()
--/ Перемещение фрейма категории
frame:EnableMouse()
frame:SetMovable(true)
frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
--/ Создание кнопок анимаций в фрейме категории
category_by = 1;
category_bx = 0;
for b=1, #button_anim_info[i] do
	category_by = (math.ceil(b/category_button_x))*-1;
	button_anim[b] = CreateFrame("Button", nil, frame_category[i])
	local button = button_anim[b]
	button_anim_sub[b] = CreateFrame("Button", nil, frame_category[i])
	local button_sub = button_anim_sub[b]
		button_anim_texture[b] = CreateFrame("Frame", nil, button_sub)
		local texture = button_anim_texture[b]
		texture:SetPoint("CENTER",0,0)
		texture:SetSize(button_x-10,button_y-10)
		texture:SetFrameStrata("FULLSCREEN")
		texture:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", })
		texture:SetBackdropColor(0.35, 0.35, 0.35, 1)
		texture:Show()
	button_anim_text[b] = texture:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	local button_text = button_anim_text[b]
	button:SetSize(button_x,button_y)
	button:SetPoint("TOPLEFT", ((button_x+category_button_margin)*category_bx)+category_frame_margin, (category_by+1)*(button_y+category_button_margin)-category_frame_margin)
	button_sub:SetSize(button_x,button_y)
	button_sub:SetPoint("TOPLEFT", ((button_x+category_button_margin)*category_bx)+category_frame_margin, (category_by+1)*(button_y+category_button_margin)-category_frame_margin)
	category_bx = category_bx + 1;
	if (category_bx > (category_button_x-1)) then category_bx = 0; end
	button:RegisterForClicks("AnyUp")
	button:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
	button:SetAlpha(0.75)
	button:Show()
	button_sub:Show()
	button_text:SetPoint("CENTER", 0, 1)
	button_text:SetFont("Fonts\\FRIZQT__.ttf", category_text_size, "OUTLINE")
	button_text:SetText(text_color..button_anim_info[i][b][1].."|r")
	button_text:SetAlpha(1)
	button_text:Show()
	button:SetScript("OnEnter", function(self)
		button_text:SetText(text_color_hover..button_anim_info[i][b][1].."|r")
		button:SetBackdrop( { edgeFile="Interface\\AddOns\\Animations\\textures\\hover.blp", edgeSize = 16 } )
		button:SetAlpha(1)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -15, -10);
		GameTooltip:AddLine(text_color_hover..button_anim_info[i][b][1].."|r");
		GameTooltip:AddLine(text_color.."Анимация №"..button_anim_info[i][b][2].."|r", 1, 1, 1, true);
		GameTooltip:Show();
	end)
	button:SetScript("OnLeave", function()
		button_text:SetText(text_color..button_anim_info[i][b][1].."|r")
		button:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
		button:SetAlpha(0.75)
		GameTooltip:Hide();
	end)
	button:SetScript("OnClick",function(self)
		button_name = GetMouseButtonClicked();
		Anim(button_anim_info[i][b][2]);
	end)
end

end -- Конец создания фрейма категорий



------------------------------/
--/ КЛИК НА КНОПКИ МЕНЮ
------------------------------/

for b=1, #NobleAnimAddon.category_name do
	button_menu[b]:SetScript("OnClick",function(self)
		button_name = GetMouseButtonClicked();
		if (b==#NobleAnimAddon.category_name) then Anim(0)
		elseif (b==(#NobleAnimAddon.category_name-1)) then
			if all_show then
				for k=1, (#NobleAnimAddon.category_name-2) do
				frame_category[k]:Hide();
				category_show[k] = false;
				all_show = false;
				end
				NobleAnimAddon.category_name[#NobleAnimAddon.category_name-1] = "Открыть";
				button_menu_text[b]:SetText(text_color_hover..NobleAnimAddon.category_name[b].."|r")
			else
				for k=1, (#NobleAnimAddon.category_name-2) do
				frame_category[k]:Show();
				category_show[k] = true;
				all_show = true;
				end
				NobleAnimAddon.category_name[#NobleAnimAddon.category_name-1] = "Свернуть";
				button_menu_text[b]:SetText(text_color_hover..NobleAnimAddon.category_name[b].."|r")
			end
		else
			if category_show[b] then
			frame_category[b]:Hide();
			category_show[b] = false;
			else
			frame_category[b]:Show();
			category_show[b] = true;
			end
		end
	end)
end





---------------------------------------/ Функция закрытия
local function CloseClick()
    AnimMainFrame:Hide()
	for k=1, (#NobleAnimAddon.category_name-2) do
		frame_category[k]:Hide();
		category_show[k] = false;
		all_show = false;
	end
	NobleAnimAddon.category_name[#NobleAnimAddon.category_name-1] = "Открыть";
	button_menu_text[#NobleAnimAddon.category_name-1]:SetText(text_color..NobleAnimAddon.category_name[#NobleAnimAddon.category_name-1].."|r")
	
		
end

function ShowMainAnimFrame()
	if AnimMainFrame:IsShown() then
		CloseClick()
	else
		AnimMainFrame:Show()
	end
end
CloseButton:SetScript("OnClick", CloseClick)
  