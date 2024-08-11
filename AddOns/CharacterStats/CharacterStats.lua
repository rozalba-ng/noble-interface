
local BarberRaceCorrect = {
[2]= {
    ["Human"]= {2.3,0.03,-0.75},
    ["Orc"]= {1.8, 0.03, -0.6},
    ["Dwarf"]= {2.3, 0.0, -0.5},
    ["NightElf"]= {2.9, 0.0, -0.8},
    ["Scourge"]= {1.9, 0.04, -0.6},
    ["Tauren"]= {2.6, 0.0, -0.4},
    ["Gnome"]= {1.1,0,-0.2},
    ["Troll"]= {2.7, -0.04, -0.45},
    ["Goblin"]= {1.5, 0.0, -0.15},
    ["BloodElf"]= {2.6, 0.0, -0.75},
    ["Draenei"]= {3.1, 0.0, -0.75},
    ["Worgen"]= {2.7,0,-0.75},
    ["Pandaren"]= {2.8, 0.035, -0.65},
    ["VoidElf"]= {2.8, 0.0, -0.75},
    ["NightElfN"]= {2.9, 0.0, -0.8},
	["HumanN"]= {2.3,0.03,-0.75},
    ["Vulpera"]= {2.5, 0.0, -0.15},
    ["DarkIronDwarf"]= {2.3, 0.0, -0.35},
    ["ZandalariTroll"]= {3.6, 0.035, -0.90},
    ["Nightborne"]= {3.2, 0.0, -0.60},
    ["Naga"]= {4,0,-0.75},
	["BloodElfN"]= {2.6, 0.0, -0.75},
	["Upright"]= {1.8, 0.03, -0.6},
},
[3]= {
    ["Human"]= {1.9,0.03,-0.64},
    ["Orc"]= {1.95, 0.0, -0.55},
    ["Dwarf"]= {1.3, -0.03, -0.3},
    ["NightElf"]= {2.9, -0.02, -0.7},
    ["Scourge"]= {2.7, 0.02, -0.5},
    ["Tauren"]= {2.1, 0.02, -0.2},
    ["Gnome"]= {0.9,0,-0.15},
    ["Troll"]= {2.7, 0.0, -0.55},
    ["Goblin"]= {1.5, 0.0, -0.15},
    ["BloodElf"]= {2.0, 0.06, -0.55},
    ["Draenei"]= {2.6, -0.04, -0.75},
    ["Worgen"]= {3.5,0.6,-0.60},
    ["Pandaren"]= {2.2, 0, -0.65},
    ["VoidElf"]= {2.2, 0.06, -0.55},
    ["NightElfN"]= {2.9, -0.02, -0.7},
	["HumanN"]= {1.9,0.03,-0.64},
    ["Vulpera"]= {2.5, 0.0, -0.15},
    ["DarkIronDwarf"]= {1.3, -0.03, -0.3},
    ["ZandalariTroll"]= {3.6, 0.03, -0.58},
    ["Nightborne"]= {3.2, 0.05, -0.75},
    ["Naga"]= {3,0.03,-0.7},
	["BloodElfN"]= {2.0, 0.06, -0.55},
	["Upright"]= {1.95, 0.0, -0.55},
},
}

local WHITE_COLOR = '|cffffffff'
local GREEN_COLOR = "|cff2ae619"

local CHAR_CHANGE_COOLDOWN_MINUTES = 1 -- было 5 часов: 60*5, ставлю 2 минуты, чтобы менять скилы во время теста

CharacterStats = CharacterStats or {}
ServerData = ServerData or {}
ServerData.LastStatUpdate = ServerData.LastStatUpdate or 0 
local freePoints = {0,0}
local currentMenuId = 1
CharStatsInterface = CharStatsInterface or {}
local race, raceEn = UnitRace("player");
local PlayerSex = UnitSex("player")
local inEditMode = false
local MainFrame =  CreateFrame("Frame", "CharStats_MainFrame", UIParent)
MainFrame:SetWidth(600)
MainFrame:SetHeight(300)
MainFrame:SetPoint("CENTER", UIParent, "CENTER",90,0)
MainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
MainFrame.Background = MainFrame:CreateTexture("ARTWORK")
MainFrame.Background:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\main_shadow.blp")
MainFrame.Background:SetPoint("CENTER",MainFrame,-5,-30)
MainFrame.Background:SetSize(400, 400)
MainFrame.Name = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainFrame.Name:SetHeight(100)
MainFrame.Name:SetWidth(300)
MainFrame.Name:SetPoint("CENTER",MainFrame.Background,0,-18)
MainFrame.Name:SetFont("Fonts\\MORPHEUS.TTF", 22, "OUTLINE")
MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." 12")
MainFrame:SetClampedToScreen( true )
MainFrame:EnableMouse()
MainFrame:SetMovable(true)
MainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
MainFrame:SetScript("OnDragStart", function(self) self:StartMoving() MainFrame.isMoving = true end)
MainFrame:SetScript("OnMouseDown", function(self) self:StartMoving() MainFrame.isMoving = false end)
MainFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)

MainFrame:Hide()

--statBar.Title:SetFontObject("GameFontNormal"
local CharacterPreview = CreateFrame("Frame", "CharStats_CharPreview", MainFrame)
CharacterPreview:SetWidth(210)
CharacterPreview:SetHeight(280)
CharacterPreview:SetPoint("CENTER", MainFrame, "CENTER",0,119)
CharacterPreview.Model = CreateFrame("PlayerModel", "CharStats_CharPreviewModel",CharacterPreview)
CharacterPreview.Model:SetSize(300, 300)

CharacterPreview.Model:SetUnit("player")	
CharacterPreview.Model:SetPoint("CENTER", 0,-61)
CharacterPreview.Model:SetPosition( 0, 0, 0);
CharacterPreview.Model:RefreshUnit()
CharacterPreview.Model:SetRotation(0.4)
CharacterPreview.Model:SetPosition( BarberRaceCorrect[PlayerSex][raceEn][1], BarberRaceCorrect[PlayerSex][raceEn][2], BarberRaceCorrect[PlayerSex][raceEn][3]);
CharacterPreview.Model:SetScale(0.7)
CharacterPreview:SetFrameLevel(2)

CharStatsInterface.lastClick = time()

local editData = {0,0,0,0,0,0,0,0,0,0,0,0,0}
local editMainFreePoints = 0
local editSocialFreePoints = 0


local mainStatsList = {
			{name = "Сила",x=-190,y=120,id=1,image="StrAttack",mirror=false},
			{name = "Ловкость",x=-230,y=80,id=2,image="DexAttack",mirror=false},
			{name = "Интеллект",x=-190,y=40,id=3,image="IntAttack",mirror=false},
			{name = "Дух",x=-230,y=0,id=7,image="HealAttack",mirror=false},
			
			--{name = "Выносливость",x=170,y=120,id=4,image="StrDef",mirror=true},
			{name = "Физ. Броня",x=210,y=80,id=5,image="DexDef",mirror=true},
			{name = "Маг. Броня",x=170,y=40,id=6,image="IntDef",mirror=true},
			
			
}
local socialStatsList = {
			{name = "Харизма",x=-190,y=120,id=8,image="SocChar",mirror=false},
			{name = "Избегание",x=-230,y=80,id=9,image="SocAvoid",mirror=false},
			{name = "Удача",x=-190,y=40,id=10,image="SocLuck",mirror=false},
			
			{name = "Скрытность",x=170,y=120,id=11,image="SocStealth",mirror=true},
			{name = "Инициатива",x=210,y=80,id=12,image="SocInit",mirror=true},
			{name = "Восприятие",x=170,y=40,id=13,image="SocPer",mirror=true},
			
			
}


local ButtonClose = CreateFrame("BUTTON", "ButtonClose", MainFrame, "SecureHandlerClickTemplate");
ButtonClose:SetNormalTexture("Interface\\AddOns\\CharacterStats\\assets\\close.blp")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
	ButtonClose:SetSize(39,39)
ButtonClose:SetPoint("TOPRIGHT",MainFrame,25,35)	
ButtonClose:SetScript("OnClick",function(self)
	MainFrame:Hide()
  end)
ButtonClose:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
  end)
  ButtonClose:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)


local function CreateStatMenu(statList,menuId)
	result = {}
	result.menuId = menuId
	for i,statData in ipairs(statList) do
			
		local statBar = CreateFrame("Button", nil, MainFrame)
		
		statBar.data = statData
		statBar:SetWidth(200)
		statBar:SetHeight(100)
		statBar:SetPoint("CENTER", MainFrame, "CENTER",statData.x,statData.y)
		statBar.Background = statBar:CreateTexture("ARTWORK")
		statBar.Background:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\"..statData.image..".blp")
		statBar.Background:SetPoint("CENTER",statBar)
		statBar.Background:SetSize(400, 100)
		statBar.Title = statBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		if statData.mirror == false then
			statBar.Title:SetPoint("CENTER",-95,0)
			statBar.Title:SetJustifyH("RIGHT")
		else
			statBar.Title:SetPoint("CENTER",95,0)
			statBar.Title:SetJustifyH("LEFT")
		end
		
		
		statBar.Title:SetHeight(100)
		statBar.Title:SetWidth(140)
		statBar.Title:SetFont("Fonts\\MORPHEUS.TTF", 18, "OUTLINE")
		--statBar.Title:SetFontObject("GameFontNormal"
		statBar.Title:SetText(WHITE_COLOR..statData.name)

		statBar.Points = statBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		statBar.Points:SetWidth(100)
		if statData.mirror == false then
			statBar.Points:SetPoint("CENTER",78,0)
			statBar.Points:SetJustifyH("LEFT")
		else
			statBar.Points:SetPoint("CENTER",-78,0)
			statBar.Points:SetJustifyH("RIGHT")
		end
		
		statBar.Points:SetFont("Fonts\\MORPHEUS.TTF", 20, "OUTLINE")
		--statBar.Title:SetFontObject("GameFontNormal"
		statBar.Points:SetText(WHITE_COLOR.."9")

		statBar.Remove =  CreateFrame("BUTTON", nil, statBar, "SecureHandlerClickTemplate");
		statBar.Remove:SetNormalTexture("Interface\\buttons\\ui-minusbutton-up")
		statBar.Remove:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")
		statBar.Remove:SetPushedTexture("Interface/BUTTONS/ui-minusbutton-down")
		statBar.Remove:SetDisabledTexture("Interface/BUTTONS/UI-MinusButton-Disabled")
		statBar.Remove:SetSize(18,18)
			
		statBar.Remove:SetFrameLevel(3)
		statBar.Remove:Hide()
		statBar.Remove.Parent = statBar
		statBar.Add =  CreateFrame("BUTTON", nil, statBar, "SecureHandlerClickTemplate");
		statBar.Add:SetNormalTexture("Interface\\buttons\\ui-plusbutton-up")
		statBar.Add:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")
		statBar.Add:SetPushedTexture("Interface/BUTTONS/ui-plusbutton-down")
		statBar.Add:SetDisabledTexture("Interface/BUTTONS/UI-PlusButton-Disabled")
		statBar.Add:SetSize(18,18)
		
		statBar.Add:SetFrameLevel(3)
		
		if statData.mirror == false then
			statBar.Remove:SetPoint("CENTER",statBar,65,-10)
			statBar.Add:SetPoint("CENTER",statBar,65,10)	
		else
			statBar.Remove:SetPoint("CENTER",statBar,-65,-10)
			statBar.Add:SetPoint("CENTER",statBar,-65,10)
		end
		
		statBar.Add:Hide()
		statBar.Add.Parent = statBar
		
		statBar:SetScript("OnEnter",function(self)
			--self.Remove:Show()
			--self.Add:Show()
		end)
		statBar:SetScript("OnLeave",function(self)
			--self.Remove:Hide()
			--self.Add:Hide()
		end)
		statBar.Add:SetScript("OnClick",function(self,button)
			if inEditMode then
				CharStatsInterface.ChangeStat(self.Parent.data.id,1)
			end
		end)
		
		statBar.Remove:SetScript("OnClick",function(self,button)
			if inEditMode then
				CharStatsInterface.ChangeStat(self.Parent.data.id,-1)
			end
		end)

		statBar.anim_group = statBar:CreateAnimationGroup() 
		statBar.anim_trans = statBar.anim_group:CreateAnimation("Translation")
		statBar.anim_trans:SetOffset(300,0)
		statBar.anim_trans:SetDuration(0.3)
		statBar.anim_trans:SetSmoothing("IN_OUT")
		statBar.anim_trans:SetOrder(1)
		
		statBar.anim_trans_start = statBar.anim_group:CreateAnimation("Translation")
		statBar.anim_trans_start:SetOffset(300,0)
		statBar.anim_trans_start:SetDuration(0)
		statBar.anim_trans_start:SetSmoothing("IN_OUT")
		statBar.anim_trans_start:SetOrder(1)
		
		statBar.anim_alpha_start = statBar.anim_group:CreateAnimation("Alpha")
		statBar.anim_alpha_start:SetChange(-1)
		statBar.anim_alpha_start:SetDuration(0)
		statBar.anim_alpha_start:SetSmoothing("OUT")
		
		statBar.anim_alpha = statBar.anim_group:CreateAnimation("Alpha")
		statBar.anim_alpha:SetChange(1)
		statBar.anim_alpha:SetDuration(0.3)
		statBar.anim_alpha:SetSmoothing("OUT")
		
		
		statBar.out_anim_group = statBar:CreateAnimationGroup() 
		statBar.out_anim_trans = statBar.out_anim_group:CreateAnimation("Translation")
		statBar.out_anim_trans:SetOffset(300,-180)
		statBar.out_anim_trans:SetDuration(0.3)
		statBar.out_anim_trans:SetSmoothing("IN_OUT")
		statBar.out_anim_trans:SetOrder(1)

		statBar.out_anim_alpha_start = statBar.out_anim_group:CreateAnimation("Alpha")
		statBar.out_anim_alpha_start:SetChange(1)
		statBar.out_anim_alpha_start:SetDuration(0)
		statBar.out_anim_alpha_start:SetSmoothing("OUT")
		
		statBar.out_anim_alpha = statBar.out_anim_group:CreateAnimation("Alpha")
		statBar.out_anim_alpha:SetChange(-1)
		statBar.out_anim_alpha:SetDuration(0.3)
		statBar.out_anim_alpha:SetSmoothing("OUT")
		table.insert(result,statBar)


	end
	result.statShowed = true
	function result:ToggleMenu()
		
		for i, statBar in ipairs(self) do
			if self.statShowed then
				statBar.out_anim_trans:SetOffset(-statBar.data.x,0)
				statBar.out_anim_group:Play()
				statBar.out_anim_alpha:SetScript("OnFinished", function(self)
					statBar:Hide()
				end)
			else
				statBar:Show()
				statBar.anim_trans_start:SetOffset(-statBar.data.x,0)
				statBar.anim_trans:SetOffset(statBar.data.x,0)
				statBar.anim_group:Play()
				statBar.anim_alpha:SetScript("OnFinished", function(self)
					statBar:Show()
				end)
			end
		end
		self.statShowed = not self.statShowed
	end
	function result:Update(apply)
		apply = apply or false
		for i, statBar in ipairs(self) do
			statBar.Add:Hide()
			statBar.Remove:Hide()
			local pointStat = CharStatsInterface.points[statBar.data.id]
			if apply then
				pointStat = editData[statBar.data.id]
			end
			
			local allStat = CharStatsInterface.stats[statBar.data.id]
			local bonusText = ""
			if allStat - pointStat > 0 and not apply then
				bonusText = GREEN_COLOR.."+"..allStat-pointStat.."|r"
			end
			statBar.Points:SetText(WHITE_COLOR..(pointStat)..bonusText)
		end
	end
	function result:EditModeUpdate()
		CharStatsInterface.UpdatePoints()
		for i, statBar in ipairs(self) do
			if inEditMode then
				statBar.Add:Show()
				statBar.Remove:Show()
				local pointStat = editData[statBar.data.id]
				if (editMainFreePoints > 0 and (statBar.data.id <= 7 and pointStat < 15)) or (editSocialFreePoints > 0 and (statBar.data.id > 7 and pointStat < 15)) then
					statBar.Add:Enable()
				else
					statBar.Add:Disable()
				end
				
				if pointStat > 0 then
					statBar.Remove:Enable()
				else
					statBar.Remove:Disable()
				end

				statBar.Points:SetText(WHITE_COLOR..(pointStat))
			else
				statBar.Add:Hide()
				statBar.Remove:Hide()
			end
		end
	end
	return result

end




local mainStats = CreateStatMenu(mainStatsList,1)
local socialStats = CreateStatMenu(socialStatsList,2)
function CharStatsInterface.ChangeStat(id,diff)
	if diff > 0 then
		if id <= 7 and editMainFreePoints > 0  then
			editData[id] = editData[id] + diff
			editMainFreePoints = editMainFreePoints - 1
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editMainFreePoints)
		elseif id > 7 and editSocialFreePoints > 0 then
			editData[id] = editData[id] + diff
			editSocialFreePoints = editSocialFreePoints - 1
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editSocialFreePoints)
		end
		
	else
		if id <= 7 and editMainFreePoints < 50  then
			editData[id] = editData[id] + diff
			editMainFreePoints = editMainFreePoints + 1
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editMainFreePoints)
		elseif id > 7 and editSocialFreePoints < 50 then
			editData[id] = editData[id] + diff
			editSocialFreePoints = editSocialFreePoints + 1
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editSocialFreePoints)
		end
	end
	mainStats:EditModeUpdate()
	socialStats:EditModeUpdate()
	
end

function CharStatsInterface.UpdatePoints()
	if not inEditMode then
		MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..freePoints[currentMenuId])
	else
		if currentMenuId == 1 then
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editMainFreePoints)
		else
			MainFrame.Name:SetText("Доступно очков:"..(WHITE_COLOR).." "..editSocialFreePoints)
		end
	end

end

socialStats:ToggleMenu()
function CharStatsInterface.ChangeMenu()
	mainStats:ToggleMenu()
	socialStats:ToggleMenu()
	CharStatsInterface.UpdatePoints()
end

local categoriesData = {
	{name="Основные",func = CharStatsInterface.ChangeMenu,just="RIGHT",xofs=0,menuId=1},
	{name="Социальные",func=CharStatsInterface.ChangeMenu,just="LEFT",xofs=0,menuId=2}	
}
local categories = {}
local CategoryFrame =  CreateFrame("Frame", "CharStats_CategoryFrame", MainFrame)
CategoryFrame:SetWidth(200)
CategoryFrame:SetHeight(100)
CategoryFrame:SetPoint("CENTER", MainFrame, "CENTER",-50,-20)
CategoryFrame.Background = CategoryFrame:CreateTexture("ARTWORK")
CategoryFrame.Background:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\back_shadow.blp")
CategoryFrame.Background:SetPoint("CENTER",CategoryFrame,50,0)
CategoryFrame.Background:SetSize(300, 18)
CategoryFrame.Background:SetAlpha(0.4)
CategoryFrame:SetFrameLevel(6)
local CATEGORY_PAD = 100
local curCategory = 1

local function OnFadeOut(frame)
	frame.par.Title:SetAlpha(.75)
end


local ChangePoints =  CreateFrame("Button", "Stat_category", MainFrame)
ChangePoints:SetWidth(130)
ChangePoints:SetHeight(25)
--ChangePoints:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )

ChangePoints.Title = ChangePoints:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ChangePoints.Title:SetPoint("CENTER",ChangePoints,0,0)
ChangePoints.Title:SetJustifyH("CENTER")
ChangePoints.Title:SetHeight(50)
ChangePoints.Title:SetWidth(150)
ChangePoints:SetHighlightTexture("Interface/PAPERDOLLINFOFRAME/UI-Character-Tab-Highlight-yellow")
ChangePoints.Title:SetFont("Fonts\\MORPHEUS.TTF", 18, "OUTLINE")
ChangePoints.Title:SetText(WHITE_COLOR.."Распределить")
ChangePoints.SelectTexture = ChangePoints:CreateTexture("ARTWORK")
ChangePoints.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\Inspect.blp")
ChangePoints.SelectTexture:SetPoint("CENTER",ChangePoints,0,-10)
ChangePoints.SelectTexture:SetSize(128, 4)
ChangePoints:SetPoint("CENTER", MainFrame, "CENTER",0,-85)
ChangePoints:SetFrameLevel(6)


local ApplyEdit =  CreateFrame("Button", "CharStats_ApplyEdit", MainFrame)
ApplyEdit:SetWidth(25)
ApplyEdit:SetHeight(25)

ApplyEdit.SelectTexture = ApplyEdit:CreateTexture("ARTWORK")
ApplyEdit.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\readycheck-ready.blp")
ApplyEdit.SelectTexture:SetPoint("CENTER",ApplyEdit,0,0)
ApplyEdit.SelectTexture:SetSize(25, 25)
ApplyEdit:SetPoint("CENTER", MainFrame, "CENTER",25,-90)
ApplyEdit:SetFrameLevel(6)
ApplyEdit:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")

ApplyEdit:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine("Принять")
    GameTooltip:Show()
  end)
  ApplyEdit:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)

local DeclineEdit =  CreateFrame("Button", "CharStats_ApplyEdit", MainFrame)
DeclineEdit:SetWidth(25)
DeclineEdit:SetHeight(25)

DeclineEdit.SelectTexture = DeclineEdit:CreateTexture("ARTWORK")
DeclineEdit.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\readycheck-notready.blp")
DeclineEdit.SelectTexture:SetPoint("CENTER",DeclineEdit,0,0)
DeclineEdit.SelectTexture:SetSize(25, 25)
DeclineEdit:SetPoint("CENTER", MainFrame, "CENTER",-25,-90)
DeclineEdit:SetFrameLevel(6)
DeclineEdit:SetHighlightTexture("Interface/BUTTONS/ui-plusbutton-hilight")

DeclineEdit:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:AddLine("Отменить")
    GameTooltip:Show()
  end)
  DeclineEdit:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)
	
ApplyEdit:Hide()
DeclineEdit:Hide()

function table.copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

local function EnterEditMode()
	if not inEditMode then
		inEditMode = true
		editData = table.copy(CharStatsInterface.points)
		editMainFreePoints = freePoints[1]
		editSocialFreePoints = freePoints[2]
		mainStats:EditModeUpdate()
		socialStats:EditModeUpdate()
		ApplyEdit:Show()
		DeclineEdit:Show()
		ChangePoints:Hide()
		
		
	
	end
end
local function LeaveEditMode()
	inEditMode = false
	ApplyEdit:Hide()
	DeclineEdit:Hide()
	ChangePoints:Show()
	
end
ChangePoints:SetScript("OnClick",function(self,button)
	if time() - (ServerData.LastStatUpdate or -10000000) > 60*CHAR_CHANGE_COOLDOWN_MINUTES then
		EnterEditMode()
	else
		local seconds = (60*CHAR_CHANGE_COOLDOWN_MINUTES) - (time() - ServerData.LastStatUpdate)
		local minutes = math.floor(seconds/60)
		local hours = math.floor(minutes/60)
		local minutesLeft = minutes % 60
		--print("Вы сможете обновить ваши характеристики через: "..hours.." ч. "..minutesLeft.." м.")
		print("Вы сможете обновить ваши характеристики через: "..seconds.." секунд.")
	end
end)
ApplyEdit:SetScript("OnClick",function(self,button)
	CharStatsInterface.SendNewStats(editData)
	LeaveEditMode()
	CharStatsInterface.UpdatePoints()
	mainStats:Update(true)
	socialStats:Update(true)
end)
DeclineEdit:SetScript("OnClick",function(self,button)
	LeaveEditMode()
	mainStats:Update()
	socialStats:Update()
	CharStatsInterface.UpdatePoints()
end)
for i,categoryData in ipairs(categoriesData) do
	local category =  CreateFrame("Button", "Stat_category", CategoryFrame)
	category:SetWidth(130)
	category:SetHeight(25)
	category.data = categoryData
	category.index = i
	--category:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )

	category.Title = category:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	category.Title:SetPoint("CENTER",category,0+categoryData.xofs,0)
	category.Title:SetJustifyH("CENTER")
	category.Title:SetHeight(100)
	category.Title:SetWidth(150)
	category.Title:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	category.Title:SetText(WHITE_COLOR..categoryData.name)
	category:SetHighlightTexture("Interface/PAPERDOLLINFOFRAME/UI-Character-Tab-Highlight-yellow")
	category.SelectTexture = category:CreateTexture("ARTWORK")
	category.SelectTexture:SetTexture("Interface\\AddOns\\CharacterStats\\assets\\Inspect.blp")
	--category.SelectTexture:SetPoint("CENTER",category,0,-10)
	category.SelectTexture:SetSize(64, 4)
	
	category.anim_group = category:CreateAnimationGroup() 
	category.anim_group.par = category

	
	category.anim_alpha = category.anim_group:CreateAnimation("Alpha")
	category.anim_alpha:SetChange(0.5)
    category.anim_alpha:SetDuration(0.13)
	category.anim_alpha:SetSmoothing("IN_OUT")
	category.anim_alpha_start = category.anim_group:CreateAnimation("Alpha")
	category.anim_alpha_start:SetChange(-0.5)
	category.anim_alpha_start:SetDuration(0)
	category.anim_alpha_start:SetSmoothing("IN_OUT")

	category.out_anim_group = category:CreateAnimationGroup() 
	category.out_anim_group.par = category

	
	category.out_anim_alpha = category.out_anim_group:CreateAnimation("Alpha")
	category.out_anim_alpha:SetChange(-0.5)
    category.out_anim_alpha:SetDuration(0.3)
	category.out_anim_alpha_start = category.out_anim_group:CreateAnimation("Alpha")
	category.out_anim_alpha_start:SetChange(0.5)
	category.out_anim_alpha_start:SetDuration(0)
	category.out_anim_alpha_start:SetSmoothing("IN")
    category.out_anim_alpha:SetSmoothing("IN")
	category:SetScript("OnClick",function(self,button)
		if time() - CharStatsInterface.lastClick > 0.3 and curCategory ~= self.index then
			self:SetAlpha(1)
			currentMenuId = self.data.menuId
			CharStatsInterface.lastClick = time()
			self.anim_group:Play()
			self.data.func()
			categories[curCategory]:SetAlpha(0.5)
			categories[curCategory].out_anim_group:Play()
			curCategory = self.index
		end
	end)
	if i > 1 then
		category:SetAlpha(0.5)
	end

	category.out_anim_group:SetScript("OnFinished", OnFadeOut)
	category:SetPoint("CENTER", CategoryFrame, "CENTER",(i-1)*CATEGORY_PAD,0)
	table.insert(categories,category)
end



function CharStatsInterface.HandleStatUpdate(statData,pointData,freeStats)
	
	local totalMainPoints = pointData[1]+pointData[2]+pointData[3]+pointData[4]+pointData[5]+pointData[6]+pointData[7]
	local totalSocialPoints = pointData[8]+pointData[9]+pointData[10]+pointData[11]+pointData[12]+pointData[13]
	freePoints = freeStats
	CharStatsInterface.UpdatePoints()
	mainStats:Update()
	socialStats:Update()
end

function CharStatsInterface.Open()
	if MainFrame:IsShown() then
		MainFrame:Hide()
		return
	end
	CharStatsInterface.GetStats()
	MainFrame:Show()
	CharacterPreview.Model:SetUnit("player")	
	CharacterPreview.Model:SetPosition( 0, 0, 0);
	CharacterPreview.Model:RefreshUnit()
	CharacterPreview.Model:SetRotation(0.4)
	CharacterPreview.Model:SetPosition( BarberRaceCorrect[PlayerSex][raceEn][1], BarberRaceCorrect[PlayerSex][raceEn][2], BarberRaceCorrect[PlayerSex][raceEn][3]);
	CharacterPreview.Model:SetScale(0.7)

end


