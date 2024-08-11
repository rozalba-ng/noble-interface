--
--
--"Оставь надежду всяк сюда входящий." (c)
--
--
--		[prod. by A4 Family]
--
--
function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end
GoShop = GoShop or {}
local ModelFrameList = {}
local CurrentShop = {}
local numButtons = 21
local buttonHeight = 20

local MainFrame =  CreateFrame("Frame", "GoShop_MainFrame", UIParent)
MainFrame:SetWidth(800)
MainFrame:SetHeight(600)
MainFrame:SetPoint("CENTER", UIParent, "CENTER",-92,-4)
--MainFrame:EnableMouse()
MainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
MainFrame.Background = MainFrame:CreateTexture("ARTWORK")
MainFrame.Background:SetTexture("Interface\\AddOns\\GameObjectShop\\assets\\MainBackground.blp")
MainFrame.Background:SetPoint("CENTER",MainFrame)
MainFrame.Background:SetSize(1600, 800)
MainFrame:SetClampedToScreen( true )
MainFrame.isMoving = false

MainFrame:EnableMouse()
MainFrame:SetMovable(true)
MainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
MainFrame:SetScript("OnDragStart", function(self) self:StartMoving() MainFrame.isMoving = true end)
MainFrame:SetScript("OnMouseDown", function(self) self:StartMoving() MainFrame.isMoving = false end)
MainFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) MainFrame.isMoving = false end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                          MinimapIconButton                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local GoShop_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("GoShop_Minimap", {
    type = "data source",
    text = "GoShop_Minimap",
    icon = "Interface\\Icons\\garrison_silverchest",
    OnClick = function()
                GoShop.Open()
              end,
    OnEnter = function(self)
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(self,"CENTER");
				GameTooltip:AddLine("Магазин переносных объектов")
				GameTooltip:AddLine("Кликните чтобы открыть")
				GameTooltip:Show()
              end,
    })

GoShop_MinimapIconButton = LibStub("LibDBIcon-1.0")

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                     Init                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
GoShopExtender = LibStub("AceAddon-3.0"):NewAddon("GoShopExtender", "AceEvent-3.0")
function GoShopExtender:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GoShop_MinMapDB", {
    profile = {
        minimap = {
            hide = false, 
			minimapPos = minimapPos or 210,},
                  },                               })
    GoShop_MinimapIconButton:Register("GoShop_Minimap", GoShop_LDB, self.db.profile.minimap)
end
print(	)

local BuyNotificationFrame = CreateFrame("Frame","BuyNotificationFrame",MainFrame)
BuyNotificationFrame:SetSize(200,100)
BuyNotificationFrame:SetPoint("CENTER", 0, 0)
BuyNotificationFrame:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
BuyNotificationFrame:SetAlpha(0.9)
BuyNotificationFrame:Hide()
BuyNotificationFrame:SetFrameLevel(11)

BuyNotificationFrame.text = BuyNotificationFrame:CreateFontString(BuyNotificationFrame, "OVERLAY", "GameFontNormal")
BuyNotificationFrame.text:SetFont("Fonts\\MORPHEUS.TTF", 14, "OUTLINE")
BuyNotificationFrame.text:SetPoint("TOP",0,-20)
BuyNotificationFrame.text:SetJustifyH("CENTER")
BuyNotificationFrame.text:SetText("Вы желаете приобрести данную позицию?")
BuyNotificationFrame.text:SetWidth(200)

BuyNotificationFrame.yesButton = CreateFrame("Button", "yesButton", BuyNotificationFrame, "UIPanelButtonTemplate")
BuyNotificationFrame.yesButton:SetSize(68 ,22) -- width, height
BuyNotificationFrame.yesButton:SetText("Принять")
BuyNotificationFrame.yesButton:SetPoint("CENTER",-40,-25)

BuyNotificationFrame.noButton = CreateFrame("Button", "noButton", BuyNotificationFrame, "UIPanelButtonTemplate")
BuyNotificationFrame.noButton:SetSize(68 ,22) -- width, height
BuyNotificationFrame.noButton:SetText("Отменить")
BuyNotificationFrame.noButton:SetPoint("CENTER",40,-25)
BuyNotificationFrame.noButton:SetScript("OnClick",function(self,...)
	BuyNotificationFrame:Hide()
end)


MainFrame:Hide()
GoShopFavorite = GoShopFavorite or {}
local selectedCategoryIndex = nil

local categories = {
}

local function createData()
	local goShop_data = {}
	for index,category in ipairs(GoShopMemory.categories) do
		table.insert(goShop_data,{name=category.name,id = index,category = true})
		if category.opened then
			for j, subcategory in ipairs(category.subcategories) do
				table.insert(goShop_data,{name=subcategory,parent =category.name,id = j})
			end
		end
	
	end
	return goShop_data
end


local function update()

	FauxScrollFrame_Update(GoShop_scrollFrame,#goShop_data,numButtons,buttonHeight)
	for index = 1,numButtons do
		local offset = index + FauxScrollFrame_GetOffset(GoShop_scrollFrame)
		local button = GoShop_scrollFrame.buttons[index]
		button.index = offset
		
		if offset<=#goShop_data then
			local selectColor = ""
			local selectedPrefix = ""
			local selectedPostfix = ""
			local mainSelectedColor = ""
			if selectedCategoryIndex and goShop_data[selectedCategoryIndex].parent and goShop_data[selectedCategoryIndex].parent == goShop_data[offset].name then
				mainSelectedColor = "|cffffd100"
				selectedPostfix = "]"
				selectedPrefix = "["
			end
			if selectedCategoryIndex == offset then
				selectColor = "|cffffd100"
				selectedPostfix = "]"
				selectedPrefix = "["
			end
			if goShop_data[offset].parent then
				button:SetText(" — |cffc9c9c9"..selectColor..string.sub(goShop_data[offset].name,4,#goShop_data[offset].name).."|r")
			else
				button:SetText(selectColor..mainSelectedColor..selectedPrefix..string.sub(goShop_data[offset].name,4,#goShop_data[offset].name)..selectedPostfix.."|r")
			end
			button:Show()
		else
			button:Hide()
		end
	end
end


local CategoryFrame = CreateFrame("Frame", "GoShop_CategoryFrame",MainFrame)
CategoryFrame:SetSize(225,numButtons*buttonHeight+64)
CategoryFrame:SetPoint("CENTER", MainFrame, "LEFT",40,-8)
CategoryFrame:SetFrameLevel(3)
--CategoryFrame:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )

GoShop_scrollFrame = CreateFrame("ScrollFrame","Category_ScrollFrame",CategoryFrame,"FauxScrollFrameTemplate")
GoShop_scrollFrame:SetPoint("TOPLEFT",0,-8)
GoShop_scrollFrame:SetPoint("BOTTOMRIGHT",-30,8)
GoShop_scrollFrame:SetScript("OnVerticalScroll",function(self,offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, buttonHeight, update)
end)


GoShop_scrollFrame.buttons = {}
for i=1,numButtons do
	GoShop_scrollFrame.buttons[i] = CreateFrame("Button",nil,CategoryFrame)
	local button = GoShop_scrollFrame.buttons[i]
	button:SetSize(166,buttonHeight)
	local font  = GameFontHighlightMedium:GetFontObject()
	font:SetJustifyH("LEFT")
	font:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	button:SetNormalFontObject(font)
	button:SetHighlightTexture("Interface\\AddOns\\GameObjectShop\\assets\\UI-Listbox-Highlight.blp")

	button:SetPoint("TOPLEFT",40,(-(i-1)*buttonHeight-8)-15)
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick",function(self,button)
		ClickMenu:Hide()
		ClickMenu.favoriteButton:Hide()
		ClickMenu.buyButton:Hide()
		local index = i + FauxScrollFrame_GetOffset(GoShop_scrollFrame)
		if goShop_data[index].name == '01-Избранное' then
			GoShop.FindFavs()
		elseif(goShop_data[index].category) then
			GoShopMemory.categories[goShop_data[index].id].opened = not GoShopMemory.categories[goShop_data[index].id].opened
			goShop_data = createData()
			GoShop.FindByCategory(goShop_data[index].name,goShop_data[index].categories)
		else
			GoShop.FindByCategory(goShop_data[index].parent,goShop_data[index].name)
		end
		selectedCategoryIndex = index
		GoShop.CloseSeatch()
		update()
	end)
end
	

local ButtonClose = CreateFrame("BUTTON", "ButtonClose", MainFrame, "SecureHandlerClickTemplate");
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(32,32)
ButtonClose:SetPoint("TOPRIGHT",MainFrame,107,4)	
ButtonClose:SetScript("OnClick",function(self)
	MainFrame:Hide()
	ClickMenu:Hide()
	ClickMenu.favoriteButton:Hide()
	ClickMenu.buyButton:Hide()
	HideUIPanel(DressUpFrame);
  end)
ButtonClose:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
  end)
  ButtonClose:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
function GoShop.containsCheck(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end
function GoShop.compareSubs(a,b)
  return tonumber(string.sub(a,1,2)) < tonumber(string.sub(b,1,2))
end
function GoShop.compare(a,b)
  return tonumber(string.sub(a.name,1,2)) < tonumber(string.sub(b.name,1,2))
end
function GoShop.SaveShop(shop)
	GoShopMemory = {}
	GoShopMemory.gos = shop
	local cats = {}
	for i,gobData in ipairs(shop) do
		local catData = gobData.category
		cats[catData.category] = cats[catData.category] or {}
		if not GoShop.containsCheck(cats[catData.category],catData.subcategory) then
			table.insert(cats[catData.category],catData.subcategory)
		end
	end
	table.insert(categories,{name = "01-Избранное", subcategories = {},opened = false})
	for category,subcategories in pairs(cats) do
		table.sort(subcategories,GoShop.compareSubs)
		table.insert(categories,{name = category, subcategories = subcategories,opened = false})
	end	
	table.sort(categories,GoShop.compare)
	GoShopMemory.categories = categories
end



local PAGE_INFO_X = 25
local PAGE_INFO_Y = 8

local currentPage = 1


local PageNameLabel = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PageNameLabel:SetFont("Fonts\\MORPHEUS.TTF", 15, "OUTLINE")
PageNameLabel:SetPoint("BOTTOM",PAGE_INFO_X+0,PAGE_INFO_Y+25)
PageNameLabel:SetJustifyH("CENTER")
PageNameLabel:SetText("Страница 1 из 1")

local function ChangePage(n)
	local maxPage = math.ceil(#CurrentShop/18)
	currentPage = currentPage+n
	if currentPage < 1 then
		currentPage = 1
	elseif currentPage >= maxPage then
		currentPage = maxPage
	end
	PageNameLabel:SetText("Страница "..currentPage.." из "..maxPage)
	GoShop.Load()
end


local NextPage = CreateFrame("BUTTON", "NextPage", MainFrame, "SecureHandlerClickTemplate");
NextPage:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up.blp")
NextPage:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down.blp")
NextPage:SetSize(25,25)
NextPage:SetPoint("BOTTOM",MainFrame,PAGE_INFO_X+90,PAGE_INFO_Y+19)	
NextPage:SetScript("OnClick",function(self)
	ClickMenu:Hide()
	ClickMenu.favoriteButton:Hide()
	ClickMenu.buyButton:Hide()
	ChangePage(1)
  end)


local PrePage = CreateFrame("BUTTON", "PrePage", MainFrame, "SecureHandlerClickTemplate");
PrePage:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up.blp")
PrePage:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down.blp")
PrePage:SetSize(25,25)
PrePage:SetPoint("BOTTOM",MainFrame,PAGE_INFO_X+(-90),PAGE_INFO_Y+19)	
PrePage:SetScript("OnClick",function(self)
	ClickMenu:Hide()
	ClickMenu.favoriteButton:Hide()
	ClickMenu.buyButton:Hide()
	ChangePage(-1)
  end)
  

local PreviewFrame = CreateFrame("Frame", "Preview", MainFrame)
PreviewFrame:SetWidth(210)
PreviewFrame:SetHeight(280)
PreviewFrame:SetPoint("CENTER", MainFrame, "CENTER",0,0)
PreviewFrame:SetBackdrop( { bgFile="Interface/FrameGeneral/UI-Background-Marble", insets={left=8,right=8,top=8,bottom=8}, tileSize=256, tile=true, edgeFile="Interface\\AddOns\\GameObjectShop\\assets\\f_edge.blp", edgeSize = 32 } )
PreviewFrame.text = PreviewFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
PreviewFrame.text:SetPoint("CENTER", PreviewFrame, "CENTER", 0,105)
PreviewFrame.text:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
PreviewFrame.text:SetText("Test")
PreviewFrame.text:SetWidth(180)
PreviewFrame.text:SetHeight(100)
PreviewFrame.Model = CreateFrame("PlayerModel", "GobjectModelPreview",PreviewFrame) ---// Фрейм модели игрока
PreviewFrame.Model:SetSize(185, 200)
PreviewFrame.Model:SetScale(1)
PreviewFrame.Model:SetPoint("CENTER", 0,-15)
PreviewFrame.Model:SetModel("World\\expansion01\\doodads\\generic\\bloodelf\\merchantstand\\be_merchantstand02.mdx")
PreviewFrame.Model:SetPosition(-8.35, 0, 0.88);
PreviewFrame:SetFrameLevel(5)

PreviewFrame:Hide()

local MoneyFrame = CreateFrame("Frame","MoneyFrame",MainFrame,"InputBoxTemplate")
MoneyFrame:SetPoint("BOTTOMLEFT",-38,32)
MoneyFrame:SetWidth(100)
MoneyFrame:SetHeight(20)
local MoneyInfo = MoneyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyInfo:SetPoint("CENTER",0,0)
MoneyInfo:SetJustifyV("LEFT")
MoneyInfo:SetText(GetCoinTextureString(GetMoney()))
MoneyFrame:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Ваши монеты")
    GameTooltip:Show()
  end)
  MoneyFrame:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
local X_START_POINT = 28
local Y_START_POINT = 90
local X_PAD = 120
local Y_PAD = 160

local PREVIEW_REL_X = -160
local PREVIEW_REL_Y = 200

local function LoadGos(GoData)
	
	for i,GobjectFrame in ipairs(ModelFrameList) do
		shopData = GoData[i]
		if shopData then
			GobjectFrame:Show()
			GobjectFrame.ShopData = shopData
			GobjectFrame.Model:SetModel(GobjectFrame.ShopData.model_data.path)
			GobjectFrame.Model:SetPosition(GobjectFrame.ShopData.model_data.x,GobjectFrame.ShopData.model_data.y,GobjectFrame.ShopData.model_data.z)
			GobjectFrame.Model:SetRotation(GobjectFrame.ShopData.model_data.rotation)
			GobjectFrame.Cost:SetText(GetCoinTextureString(GobjectFrame.ShopData.price))
		else
			GobjectFrame:Hide()
		end
	
	end
end
function GoShop.FindByCategory(category,subcategory)
	local result = {}
	for i,goShop_data in ipairs(GoShopMemory.gos) do
		if goShop_data.category.category == category then
			if subcategory ~= nil then
				if goShop_data.category.subcategory == subcategory then
					table.insert(result,goShop_data)
				end
			else
				table.insert(result,goShop_data)
			end
		end
	end
	CurrentShop = result
	currentPage = 1
	GoShop.Load()
	ChangePage(0)
end
function GoShop.FindFavs(category,subcategory)
	CurrentShop = GoShopFavorite
	currentPage = 1
	GoShop.Load()
	ChangePage(0)
end
function GoShop.FindByNameOrTag(text)
	local result = {}
	for i,goShop_data in ipairs(GoShopMemory.gos) do
		if string.find(goShop_data.name:lower(),text:lower()) or string.find(goShop_data.category.taglist:lower(),text:lower())then
			table.insert(result,goShop_data)
		end
	end
	CurrentShop = result
	currentPage = 1
	selectedCategoryIndex = nil
	update()
	GoShop.Load()
	ChangePage(0)
end

function GoShop.FindAll()
	CurrentShop = GoShopMemory.gos
	currentPage = 1
	update()
	GoShop.Load()
	ChangePage(0)

end


local HoverFrame = CreateFrame("Frame", "HoverFrame", MainFrame)
HoverFrame:SetWidth(110)
HoverFrame:SetHeight(155)
HoverFrame:SetBackdrop( { edgeFile="Interface\\AddOns\\GameObjectShop\\assets\\Selection_edge.blp", edgeSize = 16 } )
HoverFrame:SetAlpha(0.55)
local ClickMenu = CreateFrame("Frame", "ClickMenu", MainFrame)
ClickMenu:SetWidth(110)
ClickMenu:SetHeight(155)

local DressUpItemLink_orig = DressUpItemLink;

ClickMenu:SetBackdrop( { edgeFile="Interface\\AddOns\\GameObjectShop\\assets\\Selection_edge.blp", edgeSize = 16 } )
ClickMenu:Hide()
ClickMenu:SetFrameLevel(3)
ClickMenu.favoriteButton =  CreateFrame("BUTTON", "FavoriteButton", MainFrame, "SecureHandlerClickTemplate");
ClickMenu.favoriteButton:SetNormalTexture("Interface\\AddOns\\GameObjectShop\\assets\\favorite.blp")
ClickMenu.favoriteButton:SetSize(32,32)
ClickMenu.favoriteButton:SetPoint("TOPRIGHT",ClickMenu,-2,-5)	
ClickMenu.favoriteButton:SetFrameLevel(3)
 
ClickMenu.favoriteButton:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("В избранное")
    GameTooltip:Show()
  end)
ClickMenu.favoriteButton:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)

ClickMenu.buyButton =  CreateFrame("BUTTON", "buyButton", MainFrame, "UIPanelButtonTemplate");

ClickMenu.buyButton:SetSize(68 ,22)
ClickMenu.buyButton:SetText("Купить")
ClickMenu.buyButton:SetPoint("BOTTOM",ClickMenu,0,26)	
ClickMenu.buyButton:SetFrameLevel(3)

function GoShop.TryAddToFav(data)
	if GoShop.containsCheck(GoShopFavorite, data) then
		table.remove(GoShopFavorite,GoShop.indexOfObject(GoShopFavorite,data))
		ClickMenu.favoriteButton:SetNormalTexture("Interface\\AddOns\\GameObjectShop\\assets\\unfavorite.blp")
		ClickMenu.favoriteButton:SetScript("OnEnter",function(self)
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:AddLine("В избранное")
		GameTooltip:Show()
		end)
	else
		table.insert(GoShopFavorite,data)
		ClickMenu.favoriteButton:SetNormalTexture("Interface\\AddOns\\GameObjectShop\\assets\\favorite.blp")
		ClickMenu.favoriteButton:SetScript("OnEnter",function(self)
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:AddLine("Убрать из избранного")
		GameTooltip:Show()
	  end)
	end
	if (selectedCategoryIndex == 1) then
		GoShop.FindFavs()
		ClickMenu:Hide()
		ClickMenu.favoriteButton:Hide()
		ClickMenu.buyButton:Hide()
	end
end


function GoShop.BuyNotification(data)
	BuyNotificationFrame:Show()
	BuyNotificationFrame.yesButton.shopData = data
	BuyNotificationFrame.yesButton:SetScript("OnClick",function(self, ...)
		GoShop.Buy(self.shopData.item_entry)
		BuyNotificationFrame:Hide()
		MoneyInfo:SetText(GetCoinTextureString(GetMoney()))
	end)
end

local frame = CreateFrame("Frame")

-- The minimum number of seconds between each update
local ONUPDATE_INTERVAL = 0.1

-- The number of seconds since the last update
local TimeSinceLastUpdate = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
		TimeSinceLastUpdate = 0
		MoneyInfo:SetText(GetCoinTextureString(GetMoney()))
	end
end)

function GoShop.containsCheck(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end
function GoShop.containsCheckFav(list, x)
	for _, v in pairs(list) do
		if v.item_entry == x.item_entry then return true end
	end
	return false
end
function GoShop.indexOfObject(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end
local CLICK_OFS_X = -335
local CLICK_OFS_Y = 222

for y=1,3 do
		for x=1,6 do
			local GobjectFrame = CreateFrame("BUTTON", "GobjectFrame", MainFrame)
			GobjectFrame.ShopData = {}
			GobjectFrame:SetWidth(130)
			GobjectFrame:SetHeight(160)
			GobjectFrame:SetPoint("TOPLEFT", X_START_POINT + x*X_PAD,Y_START_POINT - y*Y_PAD)
			GobjectFrame.Model = CreateFrame("PlayerModel", "GobjectModel",GobjectFrame) ---// Фрейм модели игрока
			GobjectFrame.Model:SetSize(100, 130)
			GobjectFrame.Model:SetScale(0.9)
			GobjectFrame.Model:SetPoint("CENTER", 0,15)
			GobjectFrame.Model:SetFrameLevel(2)
			GobjectFrame.Cost = GobjectFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
		
			GobjectFrame.Cost:SetPoint("CENTER", GobjectFrame, "CENTER", 0,-60)
			GobjectFrame.Cost:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
			GobjectFrame.Background = GobjectFrame:CreateTexture("ARTWORK")
			GobjectFrame.Background:SetTexture("Interface\\AddOns\\GameObjectShop\\assets\\ObjectFrame.blp")
			GobjectFrame.Background:SetPoint("CENTER",GobjectFrame)
			GobjectFrame.Background:SetSize(160, 160)
			GobjectFrame:SetFrameLevel(2)


			GobjectFrame:SetScript("OnEnter", function(self,...)
				local point, relativeTo, relativePoint, xOfs, yOfs = GobjectFrame:GetPoint(1)
				PreviewFrame:SetPoint("CENTER",MainFrame,"CENTER",xOfs+PREVIEW_REL_X,yOfs+PREVIEW_REL_Y)
				PreviewFrame:Show()
				PreviewFrame.Model:Show()
				--SetCursor("Interface\\cursor\\Cast.blp")
				HoverFrame:SetPoint("CENTER",MainFrame,"CENTER",xOfs+CLICK_OFS_X,yOfs+CLICK_OFS_Y)
				HoverFrame:Show()
				HoverFrame:SetFrameLevel(4)
				if GobjectFrame.ShopData ~= {} then
					PreviewFrame.Model:SetModel(GobjectFrame.ShopData.model_data.path)
					PreviewFrame.Model:SetPosition(GobjectFrame.ShopData.model_data.x,GobjectFrame.ShopData.model_data.y,GobjectFrame.ShopData.model_data.z)
					PreviewFrame.Model:SetRotation(GobjectFrame.ShopData.model_data.rotation)
					PreviewFrame.text:SetText(GobjectFrame.ShopData.name)
				end
			end)
			GobjectFrame:SetScript("OnLeave", function(self, ...)
				--SetCursor("Interface\\cursor\\Point.blp")
				HoverFrame:Hide()
				PreviewFrame:Hide()
			end)
			GobjectFrame:SetScript("OnClick", function(self, ...)
				local point, relativeTo, relativePoint, xOfs, yOfs = GobjectFrame:GetPoint(1)
				ClickMenu:SetPoint("CENTER",MainFrame,"CENTER",xOfs+CLICK_OFS_X,yOfs+CLICK_OFS_Y)
				ClickMenu:Show()
				ClickMenu.favoriteButton:Show()
				ClickMenu.buyButton:Show()
				if GetMoney() >= self.ShopData.price then
					ClickMenu.buyButton:Enable()
				
				else
					ClickMenu.buyButton:Disable()
					
				end
				if GoShop.containsCheckFav(GoShopFavorite, self.ShopData) then
					ClickMenu.favoriteButton:SetNormalTexture("Interface\\AddOns\\GameObjectShop\\assets\\favorite.blp")
					ClickMenu.favoriteButton:SetScript("OnEnter",function(self)
					GameTooltip:SetOwner(self,"ANCHOR_LEFT")
					GameTooltip:AddLine("Убрать из избранного")
					GameTooltip:Show()
				  end)
				else
					ClickMenu.favoriteButton:SetNormalTexture("Interface\\AddOns\\GameObjectShop\\assets\\unfavorite.blp")
					ClickMenu.favoriteButton:SetScript("OnEnter",function(self)
					GameTooltip:SetOwner(self,"ANCHOR_LEFT")
					GameTooltip:AddLine("В избранное")
					GameTooltip:Show()
				  end)
				end
				
				local shopData =self.ShopData
				ClickMenu.favoriteButton:SetScript("OnClick",function(self)
					GoShop.TryAddToFav(shopData)
				end)
				ClickMenu.buyButton.shopData = shopData
				ClickMenu.buyButton:SetScript("OnClick",function(self, ...)
					GoShop.Buy(self.shopData.item_entry)
					BuyNotificationFrame:Hide()
				end)
				SetDressUpBackground_gob()
				ShowUIPanel(DressUpFrame);
				DressUpFrame:ClearAllPoints()
				DressUpFrame:SetPoint("RIGHT",MainFrame,478,52)
				DressUpModel:SetModel(shopData.model_data.path)
				DressUpModel:SetModelScale(0.7)
				DressUpModel:SetRotation(shopData.model_data.rotation)
				_G[DressUpModel:GetName()].rotation = shopData.model_data.rotation
				NobleVar_DressUpXposition = shopData.model_data.x
				NobleVar_DressUpYposition = shopData.model_data.y
				NobleVar_DressUpZposition = shopData.model_data.z
				DressUpModel:SetPosition(shopData.model_data.x,shopData.model_data.y,shopData.model_data.z)
			end)
			GobjectFrame:Hide()
			table.insert(ModelFrameList,GobjectFrame)
		end 
	end
function GoShop.Load()
	LoadGos(table.slice(CurrentShop,1+((currentPage-1)*18),1+((currentPage-1)*18)+18,1))
end
--[[Фреймы поиска.]]
local GoShopSearchFrame = CreateFrame("EditBox","GoShopFrameSearchFrame",MainFrame,"InputBoxTemplate")
GoShopSearchFrame:SetAutoFocus(false)
GoShopSearchFrame:SetSize(225, 40)
GoShopSearchFrame:SetPoint("TOPRIGHT",65,-35)
GoShopSearchFrame:SetText("")
GoShopSearchFrame:SetScript("OnEnterPressed", function(self)
	GoShopSearchKey = GoShopSearchFrame:GetText()
	GoShopSearchFrame:ClearFocus()
end)
GoShopSearchFrame:SetScript("OnTextChanged", function(self)
GoShopSearchKey = GoShopSearchFrame:GetText()
	ClickMenu:Hide()
	ClickMenu.favoriteButton:Hide()
	ClickMenu.buyButton:Hide()
    if GoShopSearchKey == "" then
        GoShopSearchFrame.ItemSearchButtonClear:Hide()
		GoShop.FindAll()
    else
        GoShopSearchFrame.ItemSearchButtonClear:Show()
		GoShop.FindByNameOrTag(GoShopSearchKey)
		if GoShopSearchKey:lower() == "путин" then
			GoShopSearchFrame:SetText("Гном")
		elseif GoShopSearchKey:lower() == "cnek" then
			GoShopSearchFrame:SetText("снек)0)")
		end
	end
	
end)

GoShopSearchFrame:SetScript("OnMouseDown", function(self)
    GoShopSearchFrame.ItemSearchButtonIcon:Hide()
end)

GoShopSearchFrame:SetScript("OnEditFocusGained", function(self)
    if GoShopSearchKey == "" then
    GoShopSearchFrame.ItemSearchButtonIcon:Hide()
    end
end)

GoShopSearchFrame:SetScript("OnEditFocusLost", function(self)
    if GoShopSearchKey == "" then
        GoShopSearchFrame.ItemSearchButtonIcon:Show()
    end
end)

GoShopSearchFrame.ItemSearchButtonIcon = CreateFrame("BUTTON", "VendorItemSearchButtonIcon", GoShopSearchFrame, "SecureHandlerClickTemplate");
GoShopSearchFrame.ItemSearchButtonIcon:Show()
GoShopSearchFrame.ItemSearchButtonIcon:SetAlpha(0.5);
GoShopSearchFrame.ItemSearchButtonIcon:SetSize(15,15)
GoShopSearchFrame.ItemSearchButtonIcon:SetPoint("CENTER", GoShopSearchFrame, -105, -2)
GoShopSearchFrame.ItemSearchButtonIcon:SetNormalTexture("Interface\\NobleProject\\searchbox-icon.blp")

local GoShopSearchTitle = GoShopSearchFrame.ItemSearchButtonIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
GoShopSearchTitle:SetPoint("CENTER", GoShopSearchFrame.ItemSearchButtonIcon, "CENTER", 108, 2)
GoShopSearchTitle:SetText("Введите название или имя вендора")
----------///
function GoShop.CloseSeatch()
	GoShopSearchFrame.ItemSearchButtonIcon:Show()
    GoShopSearchFrame:SetText("")
    GoShopSearchFrame:ClearFocus()

end

GoShopSearchFrame.ItemSearchButtonClear = CreateFrame("BUTTON", "VendorItemSearchButtonClear", GoShopSearchFrame, "SecureHandlerClickTemplate");
GoShopSearchFrame.ItemSearchButtonClear:Hide()
GoShopSearchFrame.ItemSearchButtonClear:SetAlpha(0.6);
GoShopSearchFrame.ItemSearchButtonClear:SetSize(12,12)
GoShopSearchFrame.ItemSearchButtonClear:SetPoint("CENTER", GoShopSearchFrame, 97, 0)
GoShopSearchFrame.ItemSearchButtonClear:RegisterForClicks("AnyUp")
GoShopSearchFrame.ItemSearchButtonClear:SetNormalTexture("Interface\\NobleProject\\searchbox-close.blp")
GoShopSearchFrame.ItemSearchButtonClear:SetHighlightTexture("Interface\\NobleProject\\searchbox-close.blp")
GoShopSearchFrame.ItemSearchButtonClear:SetScript("OnClick", function()
    GoShop.CloseSeatch()
end)

-----------------------
function GoShopFindClose()
    if GoShopCodeListFrame:IsVisible() then
        GoShopSearchFrame:Hide()
    else
        GoShopSearchFrame:Show()
    end
end


function GoShop.Open()
	if MainFrame:IsShown() then
		MainFrame:Hide()
		return
	end
	MainFrame:Show()
	MainFrame:ClearAllPoints()
	MainFrame:SetPoint("CENTER", UIParent, "CENTER",-92,-4)
	MoneyInfo:SetText(GetCoinTextureString(GetMoney()))
	CurrentShop = GoShopMemory.gos
	currentPage = 1
	selectedCategoryIndex = nil
	ClickMenu:Hide()
	ClickMenu.favoriteButton:Hide()
	ClickMenu.buyButton:Hide()
	local cats = {}
	categories = {}
	for i,gobData in ipairs(CurrentShop) do
		local catData = gobData.category
		cats[catData.category] = cats[catData.category] or {}
		if not GoShop.containsCheck(cats[catData.category],catData.subcategory) then
			table.insert(cats[catData.category],catData.subcategory)
		end
	end
		table.insert(categories,{name = "01-Избранное", subcategories = {},opened = false})

	for category,subcategories in pairs(cats) do
		table.sort(subcategories,GoShop.compareSubs)
		table.insert(categories,{name = category, subcategories = subcategories,opened = false})
	end	
	table.sort(categories,GoShop.compare)
	GoShopMemory.categories = categories
	goShop_data = createData()
	update()
	GoShop.Load()
	ChangePage(0)
	GoShopSearchFrame:SetText("")
	GoShopSearchFrame.ItemSearchButtonIcon:Show()

end