--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                               Variables                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local EJ_NUM_INSTANCE_PER_ROW = 4;

EJ_ChashTable = {}
Roleplay_Centers = {}
EncounterJournalServerInfo = {}
EncounterJournalTechInfo = {}
EncounterJournalTechFirstPlace = {}
EncounterJournalServerFirstPlace = {}
EncounterJournalNewsTable ={
{
["texture"] = "inv_eng_mechanicalboomerang",
["text"] = [[
<!-- Комментарий для редакторов. Используйте предпросмотр перед сохранением.-->
<html><body>
<h1 align="center">Заголовок H1</h1>
<h2 align="center">Заголовок H2</h2>
<h3 align="center">Заголовок H3</h3>
<p align="center">Стандартный текст P</p>
<p align="center">|cffff8000|Hitem:13262::::::::20:257::::::|h[Испепелитель]|h|r</p>
<p align="center">|cffff1486Цветной текст P|r</p>

<!-- Не обволакивайте картинку в заголовки и текст!-->
<img src="Interface/FlavorImages/ScarletCrusadeLogo" width="100" height="100" align="center"/>
</body></html>
]],
},
{
["text"] = [[
<html><body>
<img src="Interface/HelpFrame/HelpIcon-ReportAbuse" width="70" height="70" align="center"/>
<br></br>
<br></br>
<h1 align="center">|cff386ad4Видите эту надпись?|r</h1>
<p align="center"></p>
<p align="center">У Вас не подгрузились данные о новостях либо произошла ошибка сохранения контрольных сумм.</p>
<p align="center">Воспользуйтесь кнопкой "Обновление данных" слева внизу окна.</p>
<p align="center">Кроме того, сделайте принудительный перезаход в игру через кнопку "Выйти из мира".</p>
<p align="center">Если проблема не решилась, то сообщите об ошибке отделу разработки проекта.</p>
</body></html>
]],
},
}
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                       NavigationBarFunc                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function HomeDataClick()
EncounterJournalInstanceSelectDungeonTab:Click()
EncounterJournalInstanceSelect:Show()
EncounterJournalEncounterFrame:Hide()

EncounterJournal_TabSwitch(1)
EncounterJournal_LoadTabs()
ResetEJHighlight()
end

local function PolygonTabButton()
    EncounterJournalInstanceSelect:Show()
    EncounterJournalEncounterFrame:Hide()
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                    LOAD                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function EncounterJournal_OnLoad(self)

	tinsert(UISpecialFrames, self:GetName());
    EncounterJournal_LoadTabs()
	EncounterJournalTitleText:SetText(ENCOUNTER_JOURNAL);
	SetPortraitToTexture(EncounterJournalPortrait, "Interface\\NobleProject\\EncounterJournal\\EncounterJournal\\UI-EJ-PortraitIcon");
    
    EncounterJournalNewsUpdate()

    local homeData = {
		name = "Главная",
		OnClick = HomeDataClick,
		listFunc = nil,
	}
	NavBar_Initialize(self.navBar, "NavButtonTemplate", homeData, self.navBar.HomeButton, self.navBar.OverflowButton);
     
    
	EncounterJournal_ListInstances();
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             News Update                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function EncounterJournalNewsUpdate()
	if EncounterJournalNewsTable[1] then
		SetPortraitToTexture(EncounterJournal.instanceSelect.NewsMainPanel.NewsArt4, "Interface\\Icons\\" .. EncounterJournalNewsTable[1]["texture"]);
	else
		SetPortraitToTexture(EncounterJournal.instanceSelect.NewsMainPanel.NewsArt4, "Interface\\Icons\\inv_eng_mechanicalboomerang");
	end
    if EncounterJournalNewsTable[1] then
		EncounterJournal.instanceSelect.NewsScroll.child:SetText(EncounterJournalNewsTable[1]["text"]);
	else
		EncounterJournal.instanceSelect.NewsScroll.child:SetText(" ");
	end
    EncounterJournal.instanceSelect.NewsScroll:SetVerticalScroll(0)
	if select(2, EncounterJournal.instanceSelect.NewsScroll.ScrollBar:GetMinMaxValues()) == 0 then
		EncounterJournal.instanceSelect.NewsScroll.ScrollBar:Hide()
	else
		EncounterJournal.instanceSelect.NewsScroll.ScrollBar:Show()
	end
	
	if EncounterJournalNewsTable[2] then
		EncounterJournal.instanceSelect.NewsSecondScroll.child:SetText(EncounterJournalNewsTable[2]["text"]);
	else
		EncounterJournal.instanceSelect.NewsSecondScroll.child:SetText(" ");
	end
    EncounterJournal.instanceSelect.NewsSecondScroll:SetVerticalScroll(0)
	if select(2, EncounterJournal.instanceSelect.NewsSecondScroll.ScrollBar:GetMinMaxValues()) == 0 then
		EncounterJournal.instanceSelect.NewsSecondScroll.ScrollBar:Hide()
	else
		EncounterJournal.instanceSelect.NewsSecondScroll.ScrollBar:Show()
	end
end

function ToggleNewsPanel(state)
    if state == 1 then
        EncounterJournal.instanceSelect.NewsMainPanel:Show()
        EncounterJournal.instanceSelect.NewsScroll:Show()
		EncounterJournal.instanceSelect.NewsSecondScroll:Show()
    else
        EncounterJournal.instanceSelect.NewsMainPanel:Hide()
        EncounterJournal.instanceSelect.NewsScroll:Hide()
		EncounterJournal.instanceSelect.NewsSecondScroll:Hide()
    end
end

function EncounterJournal_OnShow(self)
    EncounterJournalNewsUpdate()
	PlaySound("igCharacterInfoOpen");
end

function EncounterJournal_OnHide(self)
	PlaySound("igCharacterInfoClose");
    UpdateMicroButtons();
end

function EncounterJournal_LoadTabs()
    EncounterJournalInstanceSelectDungeonTab:Disable();
    EncounterJournalInstanceSelectDungeonTab:GetFontString():SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
    EncounterJournalInstanceSelectDungeonTab.selectedGlow:Show(); 
    
    EncounterJournalInstanceSelectRaidTab:Enable();
    EncounterJournalInstanceSelectRaidTab:GetFontString():SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    EncounterJournalInstanceSelectRaidTab.selectedGlow:Hide(); 
     
    EncounterJournalInstanceSelectTechTab:Enable();
    EncounterJournalInstanceSelectTechTab:GetFontString():SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    EncounterJournalInstanceSelectTechTab.selectedGlow:Hide(); 
     
    EncounterJournalInstanceSelectServerTab:Enable();
    EncounterJournalInstanceSelectServerTab:GetFontString():SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    EncounterJournalInstanceSelectServerTab.selectedGlow:Hide(); 
     
    EncounterJournal_TabSwitch(1)
end

function EncounterJournal_TabSwitch(id)
EncounterJournalEncounterFrameInstanceFrameTechServerFrameChild:Hide()
EncounterJournalInstanceSelectScrollFrame:Hide()

if id == 1 then
    ToggleNewsPanel(1)
    ToggleTechServerTab(2)
    EncounterJournalNewsUpdate()
elseif id == 2 then
    ToggleNewsPanel(2)
    ToggleTechServerTab(2)
    NavBar_Reset(EncounterJournal.navBar)
    EncounterJournal_ListInstances()
    EncounterJournalInstanceSelectScrollFrame:Show()
        NewButtonData1 = {
			name = "Сюжеты",
			OnClick = PolygonTabButton,
			listFunc = nil,
		}
    NavBar_AddButton(EncounterJournal.navBar, NewButtonData1)
elseif id == 3 then
EncounterJournalEncounterFrameInstanceFrameTechServerFrameChild:Show()
ShowTechButtonsList()
TechInfoSetUp()
    ToggleNewsPanel(2)
    ToggleTechServerTab(1)
    NavBar_Reset(EncounterJournal.navBar)
    EncounterJournalInstanceSelectScrollFrame:Hide()
        NewButtonData2 = {
			name = "Функционал",
			OnClick = TechInfoSetUp,
			listFunc = nil,
		}
    NavBar_AddButton(EncounterJournal.navBar, NewButtonData2)
elseif id == 4 then
EncounterJournalEncounterFrameInstanceFrameTechServerFrameChild:Show()
ShowServerButtonsList()
ServerInfoSetUp()
    ToggleNewsPanel(2)
    ToggleTechServerTab(1)
    NavBar_Reset(EncounterJournal.navBar)
    EncounterJournalInstanceSelectScrollFrame:Hide()
        NewButtonData3 = {
			name = "О сервере",
			OnClick = ServerInfoSetUp,
			listFunc = nil,
		}
    NavBar_AddButton(EncounterJournal.navBar, NewButtonData3)
end
end

function ToggleTechServerTab(state)
if state == 1 then
    EncounterJournalInstanceSelect:Hide()
    EncounterJournalEncounterFrame:Show()
    EncounterJournal.encounter.instance.loreScroll:Hide()
else
    EncounterJournalInstanceSelect:Show()
    EncounterJournalEncounterFrame:Hide()
    EncounterJournal.encounter.instance.loreScroll:Show()
end
end

function EncounterJournal_ListInstances()
	local self = EncounterJournal.instanceSelect.scroll.child;
	local index = 1;
	local instanceButton;
	for i=1,#Roleplay_Centers do
		instanceButton = self["instance"..index];
		if not instanceButton then -- create button
			instanceButton = CreateFrame("BUTTON", self:GetName().."instance"..index, self, "EncounterInstanceButtonTemplate");
			self["instance"..index] = instanceButton;
			if mod(index-1, EJ_NUM_INSTANCE_PER_ROW) == 0 then
				instanceButton:SetPoint("TOP", self["instance"..(index-EJ_NUM_INSTANCE_PER_ROW)], "BOTTOM", 0, -15);
			else
				instanceButton:SetPoint("LEFT", self["instance"..(index-1)], "RIGHT", 15, 0);
			end
		end
	
		instanceButton.name:SetText(Roleplay_Centers[i]["title"]);
		instanceButton.bgImage:SetTexture("Interface\\NobleProject\\EncounterJournal\\Bars\\".. Roleplay_Centers[i]["image"] ..".blp");
		instanceButton:Show();
        instanceButton:SetID(index)
        
        instanceButton.DeleteButton = CreateFrame("Button", "instanceButton_DeleteButton" .. index, instanceButton, "UIPanelButtonTemplate")
        instanceButton.DeleteButton:SetPoint("CENTER", instanceButton, "CENTER", 50, -25)
        instanceButton.DeleteButton:SetSize(50, 25)
        instanceButton.DeleteButton:SetText("Удал.")
        instanceButton.DeleteButton:Hide()
		
		instanceButton.RightButton = CreateFrame("Button", "instanceButton_RightButton" .. index, instanceButton, "UIPanelButtonTemplate")
        instanceButton.RightButton:SetPoint("CENTER", instanceButton, "CENTER", 5, -25)
        instanceButton.RightButton:SetSize(25, 25)
        instanceButton.RightButton:SetText(">")
        instanceButton.RightButton:Hide()
		
		instanceButton.LeftButton = CreateFrame("Button", "instanceButton_LeftButton" .. index, instanceButton, "UIPanelButtonTemplate")
        instanceButton.LeftButton:SetPoint("CENTER", instanceButton, "CENTER", -23, -25)
        instanceButton.LeftButton:SetSize(25, 25)
        instanceButton.LeftButton:SetText("<")
        instanceButton.LeftButton:Hide()
        
		index = index + 1;
	end

	--Hide old buttons needed.
	instanceButton = self["instance"..index];
	while instanceButton do
		instanceButton:Hide();
		index = index + 1;
		instanceButton = self["instance"..index];
	end
end

function EncounterJournal_TabClicked(self, button)
	PlaySound("igAbiliityPageTurn");
end

function OpenPolygonFrame(id)
    EncounterJournalInstanceSelect:Hide()
    EncounterJournalEncounterFrame:Show()
    EncounterJournalEncounterFrameInstanceFrameTechServerFrameScrollBar:Hide()
    
    
    EncounterJournal.encounter.instance.loreScroll.child:SetText(Roleplay_Centers[id]["texts"][1]);
    EncounterJournal.encounter.instance.loreScroll:SetVerticalScroll(0)
    
    EncounterJournal.encounter.info.detailsScroll.child:SetText(Roleplay_Centers[id]["texts"][2]);
    EncounterJournal.encounter.info.detailsScroll:SetVerticalScroll(0)
   
    
        NewButtonData3 = {
			name = Roleplay_Centers[id]["title"],
			OnClick = newHomeDataClick,
			listFunc = nil,
		}
    NavBar_AddButton(EncounterJournal.navBar, NewButtonData3)
end

function EncounterJournal_OpenJournal(difficulty, instanceID, encounterID, sectionID, creatureID, itemID)
	ShowUIPanel(EncounterJournal);
	EncounterJournal_ListInstances()
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                       TechServer Update                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function ResetEJHighlight()
for i=1, #EncounterJournalServerInfo do
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:UnlockHighlight()
end
for i=1, #EncounterJournalTechInfo do
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:UnlockHighlight()
end
end

function ShowServerButtonsList()
if #EncounterJournalTechInfo > 6 then
    EncounterJournalEncounterFrameInstanceFrameTechServerFrameScrollBar:Show()
else
    EncounterJournalEncounterFrameInstanceFrameTechServerFrameScrollBar:Hide()
end
HideAllTechButtons()
for i=1, #EncounterJournalServerInfo do
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:SetText(EncounterJournalServerInfo[i]["title"])
    SetPortraitToTexture(_G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i.."Creature"], "Interface\\icons\\" .. EncounterJournalServerInfo[i]["texture"]);
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:Show()
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:SetScript("OnClick", function()
        ResetEJHighlight()
        _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:LockHighlight()
        EncounterJournal.encounter.info.detailsScroll.child:SetText(EncounterJournalServerInfo[i]["text"]);
        EncounterJournal.encounter.info.detailsScroll:SetVerticalScroll(0)
        PlaySound("igMainMenuOptionCheckBoxOn");
        
            NavBar_ResetRow3(EncounterJournal.navBar)
            ServerButtonData = {
                        name = EncounterJournalServerInfo[i]["title"],
                        OnClick = ServerInfoSetUp,
                        listFunc = nil,
                    }
            NavBar_AddButton(EncounterJournal.navBar, ServerButtonData)
        end)
end
end

function ShowTechButtonsList()
if #EncounterJournalTechInfo > 6 then
    EncounterJournalEncounterFrameInstanceFrameTechServerFrameScrollBar:Show()
else
    EncounterJournalEncounterFrameInstanceFrameTechServerFrameScrollBar:Hide()
end
HideAllTechButtons()
for i=1, #EncounterJournalTechInfo do
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:SetText(EncounterJournalTechInfo[i]["title"])
    SetPortraitToTexture(_G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i.."Creature"], "Interface\\icons\\" .. EncounterJournalTechInfo[i]["texture"]);
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:Show()
    _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:SetScript("OnClick", function()
        ResetEJHighlight()
        _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:LockHighlight()
        EncounterJournal.encounter.info.detailsScroll.child:SetText(EncounterJournalTechInfo[i]["text"]);
        EncounterJournal.encounter.info.detailsScroll:SetVerticalScroll(0)
        PlaySound("igMainMenuOptionCheckBoxOn");
            
            NavBar_ResetRow3(EncounterJournal.navBar)
            TechButtonData = {
                        name = EncounterJournalTechInfo[i]["title"],
                        OnClick = ServerInfoSetUp,
                        listFunc = nil,
                    }
            NavBar_AddButton(EncounterJournal.navBar, TechButtonData)
        end)
end
end

function HideAllTechButtons()
    for i=1, 20 do
        _G["EncounterJournalEncounterFrameInstanceFrameTechServerFrameChildSelButton"..i]:Hide()    
    end
end

function ServerInfoSetUp()
    EncounterJournal.encounter.info.detailsScroll.child:SetText([[ <html><body>
<p align="left"></p>
<p align="left"></p>
<p align="left"></p>
<img src="interface/ICONS/inv_scroll_04" width="50" height="50" align="center"/>
<p align="left"></p>
<p align="left"></p>
<p align="left"></p>
<h1 align="center">Информация о сервере</h1>
<p align="left"></p>
<p align="left"></p>
<p align="left">В данном разделе Вы можете изучить основные правила поведения в игре, найти полезные руководства по созданию игры для мастеров, статьи и гайды по лору и истории Warcraft, а также многое другое.</p>
<p align="left"></p>
<p align="left"></p>
</body></html>]]);
    ResetEJHighlight()
end

function TechInfoSetUp()
    EncounterJournal.encounter.info.detailsScroll.child:SetText([[ <html><body>
<p align="left"></p>
<p align="left"></p>
<p align="left"></p>
<img src="interface/ICONS/inv_gizmo_02" width="50" height="50" align="center"/>
<p align="left"></p>
<p align="left"></p>
<p align="left"></p>
<h1 align="center">Технические особенности сервера</h1>
<p align="left"></p>
<p align="left"></p>
<p align="left">В данном разделе Вы можете узнать об уникальных возможностях серера, различных механиках и пользовательских командах, а также найти гайды и полезную информацию о внутриигровых доступах для мастеров.</p>
<p align="left"></p>
<p align="left"></p>
</body></html>]]);
    ResetEJHighlight()
end

function ToggleEncounterJournalFrame()
    if EncounterJournal:IsShown() then
	   HideUIPanel(EncounterJournal);
    else
		ShowUIPanel(EncounterJournal);
    end
    UpdateMicroButtons();
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                       Cash Update                                 ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function CashUpdate(CurrentServerCash)
    if EJ_ChashTable["EncounterJournalNewsTable"] ~= CurrentServerCash["EncounterJournalNewsTable"] then GetUpdateEJTable(1) end
    if EJ_ChashTable["EncounterJournalServerInfo"] ~= CurrentServerCash["EncounterJournalServerInfo"] then GetUpdateEJTable(2)  end
    if EJ_ChashTable["EncounterJournalTechInfo"] ~= CurrentServerCash["EncounterJournalTechInfo"] then GetUpdateEJTable(3) end
    if EJ_ChashTable["Roleplay_Centers"] ~= CurrentServerCash["Roleplay_Centers"] then GetUpdateEJTable(4) end
    if EJ_ChashTable["TechFirstPlace"] ~= CurrentServerCash["TechFirstPlace"] then GetUpdateEJTable(5) end
    if EJ_ChashTable["ServerFirstPlace"] ~= CurrentServerCash["ServerFirstPlace"] then GetUpdateEJTable(6) end
    EJ_ForceOpen(CurrentServerCash["ForceOpen"])
end


--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                           ForceOpen                                     ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            
function EJ_ForceOpen(indicator)
    if not EJ_ChashTable["ForceOpen"] or EJ_ChashTable["ForceOpen"] == nil or EJ_ChashTable["ForceOpen"] == 0 then
		EJ_ChashTable["ForceOpen"] = tonumber(indicator) or 0;
	elseif EJ_ChashTable["ForceOpen"] < tonumber(indicator) then
        C_Timer:After(1, function() EncounterJournal:Show() end)
        EJ_ChashTable["ForceOpen"] = tonumber(indicator)
    end
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                        Slash Commands                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SLASH_EJRESET1 = "/ejreset"
SlashCmdList["EJRESET"] = function(msg)
EJ_ChashTable = {}
Roleplay_Centers = {}
EncounterJournalServerInfo = {}
EncounterJournalTechInfo = {}
EncounterJournalTechFirstPlace = {}
EncounterJournalServerFirstPlace = {}
EncounterJournalNewsTable ={
{
["texture"] = "inv_eng_mechanicalboomerang",
["text"] = [[
<!-- Комментарий для редакторов. Используйте предпросмотр перед сохранением.-->
<html><body>
<h1 align="center">Заголовок H1</h1>
<h2 align="center">Заголовок H2</h2>
<h3 align="center">Заголовок H3</h3>
<p align="center">Стандартный текст P</p>
<p align="center">|cffff8000|Hitem:13262::::::::20:257::::::|h[Испепелитель]|h|r</p>
<p align="center">|cffff1486Цветной текст P|r</p>

<!-- Не обволакивайте картинку в заголовки и текст!-->
<img src="Interface/FlavorImages/ScarletCrusadeLogo" width="100" height="100" align="center"/>
</body></html>
]],
},
{
["text"] = [[
<html><body>
<img src="Interface/HelpFrame/HelpIcon-ReportAbuse" width="70" height="70" align="center"/>
<br></br>
<br></br>
<h1 align="center">|cff386ad4Видите эту надпись?|r</h1>
<p align="center"></p>
<p align="center">У Вас не подгрузились данные о новостях либо произошла ошибка сохранения контрольных сумм.</p>
<p align="center">Воспользуйтесь кнопкой "Обновление данных" слева внизу окна.</p>
<p align="center">Кроме того, сделайте принудительный перезаход в игру через кнопку "Выйти из мира".</p>
<p align="center">Если проблема не решилась, то сообщите об ошибке отделу разработки проекта.</p>
</body></html>
]],
},
}
   print("Данные удалены.")
end

--/script C_Timer:After(0.2, function() print("Тест.") end)