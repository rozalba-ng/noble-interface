MAX_SPELLS = 1024;
MAX_SKILLLINE_TABS = 8;
SPELLS_PER_PAGE = 12;
MAX_SPELL_PAGES = ceil(MAX_SPELLS / SPELLS_PER_PAGE);
BOOKTYPE_SPELL = "spell";
BOOKTYPE_PET = "pet";
BOOKTYPE_PROFESSION = "professions";
BOOKTYPE_MOUNT = "mount";
BOOKTYPE_COMPANION = "companions";
SPELLBOOK_PAGENUMBERS = {};

local ceil = ceil;
local strlen = strlen;
local tinsert = tinsert;
local tremove = tremove;

function ToggleSpellBook(bookType)
if ( not HasPetSpells() and bookType == BOOKTYPE_PET ) then
		return;
	end
	
	local isShown = SpellBookFrame:IsShown();
	if ( isShown and (SpellBookFrame.bookType ~= bookType) ) then
		SpellBookFrame.suppressCloseSound = true;
	end
	
	HideUIPanel(SpellBookFrame);
	if ( (not isShown or (SpellBookFrame.bookType ~= bookType)) ) then
		SpellBookFrame.bookType = bookType;
		ShowUIPanel(SpellBookFrame);
	end
	SpellBookFrame_UpdatePages();

	SpellBookFrame.suppressCloseSound = nil;
	SpellBookFrame.PortraitMainBG:SetTexture("");
	collectgarbage("collect")
end

function SpellBookFrame_OnLoad(self)
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");
	self:RegisterEvent("CHAT_MSG_SKILL");

	SpellBookFrame.bookType = BOOKTYPE_SPELL;
	-- Init page nums
	SPELLBOOK_PAGENUMBERS[1] = 1;
	SPELLBOOK_PAGENUMBERS[2] = 1;
	SPELLBOOK_PAGENUMBERS[3] = 1;
	SPELLBOOK_PAGENUMBERS[4] = 1;
	SPELLBOOK_PAGENUMBERS[5] = 1;
	SPELLBOOK_PAGENUMBERS[6] = 1;
	SPELLBOOK_PAGENUMBERS[7] = 1;
	SPELLBOOK_PAGENUMBERS[8] = 1;
	SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] = 1;
	
	-- Set to the first tab by default
	SpellBookSkillLineTab_OnClick(nil, 1);

	-- Initialize tab flashing
	SpellBookFrame.flashTabs = nil;
	SetPortraitToTexture(self.portrait, "Interface\\Spellbook\\Spellbook-Icon")
end

function SpellBookFrame_OnEvent(self, event, ...)
	if ( event == "SPELLS_CHANGED" ) then
		if ( SpellBookFrame:IsVisible() ) then
			SpellBookFrame_Update();
		end
	elseif ( event == "CHAT_MSG_SKILL" ) then
		if ( SpellBookFrame:IsVisible() ) then
			C_Profession:UpdateProfessionsSpells()
		end
	elseif ( event == "LEARNED_SPELL_IN_TAB" ) then
		local arg1 = ...;
		local flashFrame = _G["SpellBookSkillLineTab"..arg1.."Flash"];
		if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
			return;
		else
			if ( flashFrame ) then
				flashFrame:Show();
				SpellBookFrame.flashTabs = 1;
			end
		end
	end
end

function SpellBookFrame_OnShow(self)
	SpellBookFrame_Update(1);
	
	-- If there are tabs waiting to flash, then flash them... yeah..
	if ( self.flashTabs ) then
		UIFrameFlash(SpellBookTabFlashFrame, 0.5, 0.5, 30, nil);
	end

	-- Show multibar slots
	MultiActionBar_ShowAllGrids();
	UpdateMicroButtons();
	C_Profession:UpdateProfessionsSpells()
	
	SpellBookFrame_PlayOpenSound();
end

function SpellBookFrame_Update(showing)
	-- Hide all tabs
	SpellBookFrameTabButton1:Hide();
	SpellBookFrameTabButton2:Hide();
	SpellBookFrameTabButton3:Hide();
	
	-- Setup skillline tabs
	if ( showing ) then
		SpellBookSkillLineTab_OnClick(nil, SpellBookFrame.selectedSkillLine);
		UpdateSpells();
	end

	local numSkillLineTabs = GetNumSpellTabs();
	local name, texture, offset, numSpells;
	local skillLineTab;
	for i=1, MAX_SKILLLINE_TABS do
		skillLineTab = _G["SpellBookSkillLineTab"..i];
		if ( i <= numSkillLineTabs and SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
			name, texture = GetSpellTabInfo(i);
			skillLineTab:SetNormalTexture(texture);
			skillLineTab.tooltip = name;
			skillLineTab:Show();

			-- Set the selected tab
			if ( SpellBookFrame.selectedSkillLine == i ) then
				skillLineTab:SetChecked(1);
			else
				skillLineTab:SetChecked(nil);
			end
		else
			_G["SpellBookSkillLineTab"..i.."Flash"]:Hide();
			skillLineTab:Hide();
		end
	end

	-- Setup tabs
	local hasPetSpells, petToken = HasPetSpells();
	SpellBookFrame.petTitle = nil;
	if ( hasPetSpells ) then
		SpellBookFrame_SetTabType(SpellBookFrameTabButton1, BOOKTYPE_SPELL);
		SpellBookFrame_SetTabType(SpellBookFrameTabButton2, BOOKTYPE_PROFESSION);
		SpellBookFrame_SetTabType(SpellBookFrameTabButton3, BOOKTYPE_PET, petToken);
	else
		SpellBookFrame_SetTabType(SpellBookFrameTabButton1, BOOKTYPE_SPELL);
		SpellBookFrame_SetTabType(SpellBookFrameTabButton2, BOOKTYPE_PROFESSION);
		SpellBookFrame_SetTabType(SpellBookFrameTabButton3, BOOKTYPE_COMPANION);
		SpellBookFrame_SetTabType(SpellBookFrameTabButton4, BOOKTYPE_MOUNT);
		if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
			-- if has no pet spells but trying to show the pet spellbook close the window;
			HideUIPanel(SpellBookFrame);
			SpellBookFrame.bookType = BOOKTYPE_SPELL;
		end
	end

	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		SpellBookPage1:SetTexture("Interface\\Spellbook\\Spellbook-Page-1");
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Spellbook-Page-2");
		SpellBookTitleText:SetText(SPELLBOOK);
		SpellBookFrame_ShowSpells();
		SpellBookFrame_UpdatePages();
		SpellBookCompanionsFrame:Hide()
		SpellBookProfessionFrame:Hide()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		SpellBookPage1:SetTexture("Interface\\Spellbook\\Spellbook-Page-1");
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Spellbook-Page-2");
		SpellBookTitleText:SetText(SpellBookFrame.petTitle);
		SpellBookFrame_ShowSpells();
		SpellBookFrame_UpdatePages();
		SpellBookCompanionsFrame:Hide()
		SpellBookProfessionFrame:Hide()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PROFESSION ) then
		SpellBookPage1:SetTexture("Interface\\Spellbook\\Professions-Book-Left");
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Professions-Book-Right");
		SpellBookTitleText:SetText("Профессии");
		SpellBookFrame_HideSpells();
		SpellBookFrame_UpdatePages();
		SpellBookCompanionsFrame:Hide()
		SpellBookProfessionFrame:Show()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_COMPANION ) then
		SpellBookPage1:SetTexture("Interface\\Spellbook\\Spellbook-Page-1");
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Spellbook-Page-2");
		SpellBookTitleText:SetText("Питомцы");
		SpellBookFrame_HideSpells();
		SpellBookFrame_UpdatePages();
		SpellBookProfessionFrame:Hide()
		SpellBookCompanionsFrame:Show()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_MOUNT ) then
		SpellBookPage1:SetTexture("Interface\\Spellbook\\Spellbook-Page-1");
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Spellbook-Page-2");
		SpellBookTitleText:SetText("Транспорт");
		SpellBookFrame_HideSpells();
		SpellBookFrame_UpdatePages();
		SpellBookProfessionFrame:Hide()
		SpellBookCompanionsFrame:Show()
	end
end

function SpellBookFrame_HideSpells ()
	for i = 1, SPELLS_PER_PAGE do
		_G["SpellButton" .. i]:Hide();
	end
	
	for i = 1, MAX_SKILLLINE_TABS do
		_G["SpellBookSkillLineTab" .. i]:Hide();
	end
	
	SpellBookPrevPageButton:Hide();
	SpellBookNextPageButton:Hide();
	SpellBookPageText:Hide();
end

function SpellBookFrame_ShowSpells ()
	for i = 1, SPELLS_PER_PAGE do
		_G["SpellButton" .. i]:Show();
	end
	
	SpellBookPrevPageButton:Show();
	SpellBookNextPageButton:Show();
	SpellBookPageText:Show();
end

function SpellBookFrame_UpdatePages()
	local currentPage, maxPages = SpellBook_GetCurrentPage();
	if ( maxPages == 0 ) then
		return;
	end
	if ( currentPage > maxPages ) then
		if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
			SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] = maxPages;
		else
			SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = maxPages;
		end
		currentPage = maxPages;
		UpdateSpells();
		if ( currentPage == 1 ) then
			SpellBookPrevPageButton:Disable();
		else
			SpellBookPrevPageButton:Enable();
		end
		if ( currentPage == maxPages ) then
			SpellBookNextPageButton:Disable();
		else
			SpellBookNextPageButton:Enable();
		end
	end
	if ( currentPage == 1 ) then
		SpellBookPrevPageButton:Disable();
	else
		SpellBookPrevPageButton:Enable();
	end
	if ( currentPage == maxPages ) then
		SpellBookNextPageButton:Disable();
	else
		SpellBookNextPageButton:Enable();
	end
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, currentPage);
	-- Hide spell rank checkbox if the player is a rogue or warrior
	local _, class = UnitClass("player");
	local showSpellRanks = true;
	if ( class == "ROGUE" or class == "WARRIOR" ) then
		showSpellRanks = false;
	end
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL and showSpellRanks ) then
		ShowAllSpellRanksCheckBox:Show();
	else
		ShowAllSpellRanksCheckBox:Hide();
	end
end

function SpellBookFrame_SetTabType(tabButton, bookType, token)
	if ( bookType == BOOKTYPE_SPELL ) then
		tabButton.bookType = BOOKTYPE_SPELL;
		tabButton:SetText(SPELLBOOK);
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1);
		tabButton.binding = "TOGGLESPELLBOOK";
	elseif ( bookType == BOOKTYPE_PET ) then
		tabButton.bookType = BOOKTYPE_PET;
		tabButton:SetText(_G["PET_TYPE_"..token]);
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1);
		tabButton.binding = "TOGGLEPETBOOK";
		SpellBookFrame.petTitle = _G["PET_TYPE_"..token];
	elseif ( bookType == BOOKTYPE_PROFESSION ) then
		tabButton.bookType = BOOKTYPE_PROFESSION;
		tabButton:SetText("Профессии");
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1);
		tabButton.binding = "TOGGLESPELLBOOK";
		--SpellBookFrame.petTitle = _G["PET_TYPE_"..token];
	elseif ( bookType == BOOKTYPE_COMPANION ) then
		tabButton.bookType = BOOKTYPE_COMPANION;
		tabButton:SetText("Питомцы");
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1);
		tabButton.binding = "TOGGLESPELLBOOK";
	elseif ( bookType == BOOKTYPE_MOUNT ) then
		tabButton.bookType = BOOKTYPE_MOUNT;
		tabButton:SetText("Транспорт");
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1);
		tabButton.binding = "TOGGLESPELLBOOK";
	else
		tabButton.bookType = INSCRIPTION;
		tabButton:SetText(GLYPHS);
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 2);
		tabButton.binding = "TOGGLEINSCRIPTION";
	end
	if ( SpellBookFrame.bookType == bookType ) then
		tabButton:Disable();
	else
		tabButton:Enable();
	end
	tabButton:Show();
end

function SpellBookFrame_PlayOpenSound()
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igSpellBookOpen");
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		-- Need to change to pet book open sound
		PlaySound("igAbilityOpen");
	else
		PlaySound("igSpellBookOpen");
	end
end

function SpellBookFrame_PlayCloseSound()
	if ( not SpellBookFrame.suppressCloseSound ) then
		if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
			PlaySound("igSpellBookClose");
		else
			-- Need to change to pet book close sound
			PlaySound("igAbilityClose");
		end
	end
end

function SpellBookFrame_OnHide(self)
	SpellBookFrame_PlayCloseSound();

	-- Stop the flash frame from flashing if its still flashing.. flash flash flash
	UIFrameFlashRemoveFrame(SpellBookTabFlashFrame);
	-- Hide all the flashing textures
	for i=1, MAX_SKILLLINE_TABS do
		_G["SpellBookSkillLineTab"..i.."Flash"]:Hide();
	end

	-- Hide multibar slots
	MultiActionBar_HideAllGrids();
	
	-- Do this last, it can cause taint.
	UpdateMicroButtons();
end

function SpellButton_OnLoad(self) 
	self:RegisterForDrag("LeftButton");
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function SpellButton_OnEvent(self, event, ...)
	if ( event == "SPELLS_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" or event == "UPDATE_SHAPESHIFT_FORM" ) then
		-- need to listen for UPDATE_SHAPESHIFT_FORM because attack icons change when the shapeshift form changes
		SpellButton_UpdateButton(self);
	elseif ( event == "CURRENT_SPELL_CAST_CHANGED" ) then
		SpellButton_UpdateSelection(self);
	elseif ( event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		SpellButton_UpdateSelection(self);
	elseif ( event == "PET_BAR_UPDATE" ) then
		if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
			SpellButton_UpdateButton(self);
		end
	end
end

function SpellButton_OnShow(self)
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
	self:RegisterEvent("TRADE_SKILL_SHOW");
	self:RegisterEvent("TRADE_SKILL_CLOSE");
	self:RegisterEvent("PET_BAR_UPDATE");

	SpellButton_UpdateButton(self);
end

function SpellButton_OnHide(self)
	self:UnregisterEvent("SPELLS_CHANGED");
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN");
	self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM");
	self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");
	self:UnregisterEvent("TRADE_SKILL_SHOW");
	self:UnregisterEvent("TRADE_SKILL_CLOSE");
	self:UnregisterEvent("PET_BAR_UPDATE");
end

function SpellButton_OnEnter(self)
	local id
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
	else
		id = SpellBook_GetSpellID(self:GetID());
	end
	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		if ( GameTooltip:SetSpell(id, SpellBookFrame.bookType) ) then
			self.UpdateTooltip = SpellButton_OnEnter;
		else
			self.UpdateTooltip = nil;
		end
end

function SpellButton_OnClick(self, button)
	local id
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
	else
		id = SpellBook_GetSpellID(self:GetID());	
	end
		if ( id > MAX_SPELLS ) then
			return;
		end
		if ( button ~= "LeftButton" and SpellBookFrame.bookType == BOOKTYPE_PET ) then
			ToggleSpellAutocast(id, SpellBookFrame.bookType);
		else
			CastSpell(id, SpellBookFrame.bookType);
			SpellButton_UpdateSelection(self);
		end
end

function SpellButton_OnModifiedClick(self, button) 
	local id
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
	else
		id = SpellBook_GetSpellID(self:GetID());
	end
	if ( id > MAX_SPELLS ) then
		return;
	end
	if ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			local spellName, subSpellName = GetSpellName(id, SpellBookFrame.bookType);
			if ( spellName and not IsPassiveSpell(id, SpellBookFrame.bookType) ) then
				if ( subSpellName and (strlen(subSpellName) > 0) ) then
					ChatEdit_InsertLink(spellName.."("..subSpellName..")");
				else
					ChatEdit_InsertLink(spellName);
				end
			end
			return;
		else
			local spellLink, tradeSkillLink = GetSpellLink(id, SpellBookFrame.bookType);
			if ( tradeSkillLink ) then
				ChatEdit_InsertLink(tradeSkillLink);
			elseif ( spellLink ) then
				ChatEdit_InsertLink(spellLink);
			end
			return;
		end
	end
	if ( IsModifiedClick("PICKUPACTION") ) then
		PickupSpell(id, SpellBookFrame.bookType);
		return;
	end
end

function SpellButton_OnDrag(self) 
	local id
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
	else
		id = SpellBook_GetSpellID(self:GetID());
	end
	if ( id > MAX_SPELLS or not _G[self:GetName().."IconTexture"]:IsShown() ) then
		return;
	end
	self:SetChecked(0);
	PickupSpell(id, SpellBookFrame.bookType);
end

function SpellButton_UpdateSelection(self)
	
	local temp, texture, offset, numSpells = SpellBook_GetTabInfo(SpellBookFrame.selectedSkillLine);
	
	--local id, displayID = SpellBook_GetSpellID(self:GetID());
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
		displayID = C_Profession:GetProfessionIndex(self:GetName())
	else
		id, displayID = SpellBook_GetSpellID(self:GetID());
	end
	if ( (SpellBookFrame.bookType ~= BOOKTYPE_PET) and (not displayID or displayID > (offset + numSpells)) ) then
		self:SetChecked("false");
		return;
	end

	if ( IsSelectedSpell(id, SpellBookFrame.bookType) ) then
		self:SetChecked("true");
	else
		self:SetChecked("false");
	end
end

function SpellButton_UpdateButton(self)
	--UpdateNextPrevProfessionButton()
	if ( not SpellBookFrame.selectedSkillLine ) then
		SpellBookFrame.selectedSkillLine = 1;
	end
	local temp, texture, offset, numSpells = SpellBook_GetTabInfo(SpellBookFrame.selectedSkillLine);
	SpellBookFrame.selectedSkillLineOffset = offset;

	local id
	local displayID
	if SpellBookFrame.bookType == "professions" then
		id = C_Profession:GetProfessionIndex(self:GetName())
		displayID = C_Profession:GetProfessionIndex(self:GetName())
	else
		id, displayID = SpellBook_GetSpellID(self:GetID());
	end
	
	local name = self:GetName();
	local iconTexture = _G[name.."IconTexture"];
	local spellString = _G[name.."SpellName"];
	local subSpellString = _G[name.."SubSpellName"];
	local cooldown = _G[name.."Cooldown"];
	local autoCastableTexture = _G[name.."AutoCastable"];

	if ( (SpellBookFrame.bookType ~= BOOKTYPE_PET) and (not displayID or displayID > (offset + numSpells)) ) then
		self:Disable();
		iconTexture:Hide();
		spellString:Hide();
		subSpellString:Hide();
		cooldown:Hide();
		autoCastableTexture:Hide();
		SpellBook_ReleaseAutoCastShine(self.shine)
		self.shine = nil;
		self:SetChecked(0);
		_G[name.."NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0);
		return;
	else
		self:Enable();
	end

	local texture = GetSpellTexture(id, SpellBookFrame.bookType);
	local highlightTexture = _G[name.."Highlight"];
	local normalTexture = _G[name.."NormalTexture"];
	-- If no spell, hide everything and return
	if ( not texture or (strlen(texture) == 0) ) then
		iconTexture:Hide();
		spellString:Hide();
		subSpellString:Hide();
		cooldown:Hide();
		autoCastableTexture:Hide();
		SpellBook_ReleaseAutoCastShine(self.shine);
		self.shine = nil;
		highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
		self:SetChecked(0);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		return;
	end

	local start, duration, enable = GetSpellCooldown(id, SpellBookFrame.bookType);
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
	if ( enable == 1 ) then
		iconTexture:SetVertexColor(1.0, 1.0, 1.0);
	else
		iconTexture:SetVertexColor(0.4, 0.4, 0.4);
	end

	local autoCastAllowed, autoCastEnabled = GetSpellAutocast(id, SpellBookFrame.bookType);
	if ( autoCastAllowed ) then
		autoCastableTexture:Show();
	else
		autoCastableTexture:Hide();
	end
	if ( autoCastEnabled and not self.shine ) then
		self.shine = SpellBook_GetAutoCastShine();
		self.shine:Show();
		self.shine:SetParent(self);
		self.shine:SetPoint("CENTER", self, "CENTER");
		AutoCastShine_AutoCastStart(self.shine);
	elseif ( autoCastEnabled ) then
		self.shine:Show();
		self.shine:SetParent(self);
		self.shine:SetPoint("CENTER", self, "CENTER");
		AutoCastShine_AutoCastStart(self.shine);
	elseif ( not autoCastEnabled ) then
		SpellBook_ReleaseAutoCastShine(self.shine);
		self.shine = nil;
	end

	local spellName, subSpellName = GetSpellName(id, SpellBookFrame.bookType);
	local isPassive = IsPassiveSpell(id, SpellBookFrame.bookType);
	if ( isPassive ) then
		normalTexture:SetVertexColor(0, 0, 0);
		highlightTexture:SetTexture("Interface\\Buttons\\UI-PassiveHighlight");
		--subSpellName = PASSIVE_PARENS;
		spellString:SetTextColor(PASSIVE_SPELL_FONT_COLOR.r, PASSIVE_SPELL_FONT_COLOR.g, PASSIVE_SPELL_FONT_COLOR.b);
	else
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
		spellString:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	iconTexture:SetTexture(texture);
	spellString:SetText(spellName);
	subSpellString:SetText(subSpellName);
	if ( subSpellName ~= "" ) then
		spellString:SetPoint("LEFT", self, "RIGHT", 4, 4);
	else
		spellString:SetPoint("LEFT", self, "RIGHT", 4, 2);
	end

	iconTexture:Show();
	spellString:Show();
	subSpellString:Show();
	SpellButton_UpdateSelection(self);
end

function SpellBookPrevPageButton_OnClick()
	local pageNum = SpellBook_GetCurrentPage() - 1;
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = pageNum;
	else
		SpellBookTitleText:SetText(SpellBookFrame.petTitle);
		-- Need to change to pet book pageturn sound
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] = pageNum;
	end
	SpellBook_UpdatePageArrows();
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, pageNum);
	UpdateSpells();
	
end

function SpellBookNextPageButton_OnClick()
	local pageNum = SpellBook_GetCurrentPage() + 1;
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = pageNum;
	else
		SpellBookTitleText:SetText(SpellBookFrame.petTitle);
		-- Need to change to pet book pageturn sound
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] = pageNum;
	end
	SpellBook_UpdatePageArrows();
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, pageNum);
	UpdateSpells();
	
end

local ProfessionPage = 1
function ProfessionNextPageButton_OnClick()
ProfessionPage = 2
C_Profession:ForceUpdateProfessionsSpells(ProfessionPage)
UpdateSpells();
UpdateNextPrevProfessionButton()
end

function ProfessionBookPrevPageButton_OnClick()
ProfessionPage = 1
C_Profession:ForceUpdateProfessionsSpells(ProfessionPage)
UpdateSpells();
UpdateNextPrevProfessionButton()
end

function UpdateNextPrevProfessionButton()
	if not C_Profession:HasSecondPage() then
		ProfessionNextPageButton:Disable()
		ProfessionPrevPageButton:Disable()
	return
	end
	if ProfessionPage == 2 then
		ProfessionNextPageButton:Disable()
		ProfessionPrevPageButton:Enable()
	end
	if ProfessionPage == 1 then
		ProfessionPrevPageButton:Disable()
		ProfessionNextPageButton:Enable()
	end
	ProfessionSpellBookPageText:SetFormattedText(PAGE_NUMBER, ProfessionPage);
end

function SpellBookSkillLineTab_OnClick(self, id)
	local update;
	if ( not id ) then
		update = 1;
		id = self:GetID();
	end
	if ( SpellBookFrame.selectedSkillLine ~= id ) then
		PlaySound("igAbiliityPageTurn");
	end
	SpellBookFrame.selectedSkillLine = id;
	local name, texture, offset, numSpells = SpellBook_GetTabInfo(SpellBookFrame.selectedSkillLine);
	SpellBookFrame.selectedSkillLineOffset = offset;
	SpellBookFrame.selectedSkillLineNumSpells = numSpells;
	SpellBook_UpdatePageArrows();
	SpellBookFrame_Update();
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, SpellBook_GetCurrentPage());
	if ( update ) then
		UpdateSpells();
	end
	-- Stop tab flashing
	if ( self ) then
		local tabFlash = _G[self:GetName().."Flash"];
		if ( tabFlash ) then
			tabFlash:Hide();
		end
	end
	if SpellBookFrame.bookType == BOOKTYPE_COMPANION then
		SpellBook_UpdateCompanionsFrame("CRITTER")
		SpellBookCompanionsFrame_UpdateCompanionPreview()
	elseif SpellBookFrame.bookType == BOOKTYPE_MOUNT then
		SpellBook_UpdateCompanionsFrame("MOUNT")
		SpellBookCompanionsFrame_UpdateCompanionPreview()
	end
end

function SpellBookFrameTabButton_OnClick(self)
	-- suppress the hiding sound so we don't play a hide and show sound simultaneously
	SpellBookFrame.suppressCloseSound = true;
	ToggleSpellBook(self.bookType, true);
	SpellBookFrame.suppressCloseSound = false;
end

function SpellBook_GetSpellID(id)
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		return id + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	else
		local slot = id + SpellBookFrame.selectedSkillLineOffset + ( SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] - 1));
		if ( not GetCVarBool("ShowAllSpellRanks") ) then
			return GetKnownSlotFromHighestRankSlot(slot), slot;
		end
		return slot, slot;
	end
end

function SpellBook_UpdatePageArrows()
	local currentPage, maxPages = SpellBook_GetCurrentPage();
	if ( currentPage == 1 ) then
		SpellBookPrevPageButton:Disable();
	else
		SpellBookPrevPageButton:Enable();
	end
	if ( currentPage == maxPages ) then
		SpellBookNextPageButton:Disable();
	else
		SpellBookNextPageButton:Enable();
	end
end

function SpellBook_GetCurrentPage()
	local currentPage, maxPages;
	local numPetSpells = HasPetSpells();
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		currentPage = SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET];
		maxPages = ceil(numPetSpells/SPELLS_PER_PAGE);
	else
		currentPage = SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine];
		local name, texture, offset, numSpells = SpellBook_GetTabInfo(SpellBookFrame.selectedSkillLine);
		maxPages = ceil(numSpells/SPELLS_PER_PAGE);
	end
	return currentPage, maxPages;
end

local maxShines = 1;
shineGet = {}
function SpellBook_GetAutoCastShine ()
	local shine = shineGet[1];
	
	if ( shine ) then
		tremove(shineGet, 1);
	else
		shine = CreateFrame("FRAME", "AutocastShine" .. maxShines, SpellBookFrame, "SpellBookShineTemplate");
		maxShines = maxShines + 1;
	end
	
	return shine;
end

function SpellBook_ReleaseAutoCastShine (shine)
	if ( not shine ) then
		return;
	end
	
	shine:Hide();
	AutoCastShine_AutoCastStop(shine);
	tinsert(shineGet, shine);
end

function SpellBook_GetTabInfo(skillLine)
	local name, texture, offset, numSpells, highestRankOffset, highestRankNumSpells = GetSpellTabInfo(skillLine);
	if ( not GetCVarBool("ShowAllSpellRanks")) then
		offset = highestRankOffset;
		numSpells = highestRankNumSpells;
	end
	return name, texture, offset, numSpells;
end









----------------------------------------------------------------------
--    Mounts/Companions
----------------------------------------------------------------------

function SpellBookCompanionsFrame_OnLoad(self)
	self:RegisterEvent("COMPANION_LEARNED");
	self:RegisterEvent("COMPANION_UNLEARNED");
	self:RegisterEvent("COMPANION_UPDATE");
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	self:RegisterEvent("UNIT_ENTERED_VEHICLE");
end

function SpellBookCompanionsFrame_OnEvent(self, event, ...)
	local arg1 = ...;
	if ( event == "SPELL_UPDATE_COOLDOWN" ) then
		if ( self:IsVisible() ) then
			SpellBook_UpdateCompanionCooldowns();
		end	
	elseif ( event == "COMPANION_LEARNED" ) then
		if ( not SpellBookFrame:IsVisible() ) then
			--SetButtonPulse(SpellbookMicroButton, 60);
			SetButtonPulse(SpellbookMicroButton, 15, 1);
		end
		-- FIXME
		--if ( not self:IsVisible() ) then
		--	SetButtonPulse(CharacterFrameTab2, 60, 1);
		--end
		if (SpellBookFrame:IsVisible() ) then
			SpellBookFrame_Update();
		end
	elseif ( event == "COMPANION_UNLEARNED" ) then
		local page;
		local numCompanions = GetNumCompanions(SpellBookCompanionsFrame.mode);
		if ( SpellBookCompanionsFrame.mode=="MOUNT" ) then
			page = SPELLBOOK_PAGENUMBERS[BOOKTYPE_MOUNT];
			if ( numCompanions > 0 ) then
				SpellBookCompanionsFrame.idMount = GetCompanionInfo("MOUNT", 1);
				SpellBookCompanionsFrame_UpdateCompanionPreview();
			else
				SpellBookCompanionsFrame.idMount = nil;
			end
		else
			page = SPELLBOOK_PAGENUMBERS[BOOKTYPE_COMPANION];
			if ( numCompanions > 0 ) then
				SpellBookCompanionsFrame.idCritter = GetCompanionInfo("CRITTER", 1);
				SpellBookCompanionsFrame_UpdateCompanionPreview();
			else
				SpellBookCompanionsFrame.idCritter = nil;
			end
		end
		if (SpellBookFrame:IsVisible()) then
			SpellBookFrame_Update();
		end
	elseif ( event == "COMPANION_UPDATE" ) then
		if ( not SpellBookCompanionsFrame.idMount ) then
			SpellBookCompanionsFrame.idMount = GetCompanionInfo("MOUNT", 1);
		end
		if ( not SpellBookCompanionsFrame.idCritter ) then
			SpellBookCompanionsFrame.idCritter = GetCompanionInfo("CRITTER", 1);
		end
		if (self:IsVisible()) then
			SpellBook_UpdateCompanionsFrame();
		end
	elseif ( (event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and (arg1 == "player")) then
		SpellBook_UpdateCompanionsFrame();
	end
end

function SpellBookCompanionsFrame_FindCompanionIndex(creatureID, mode)
	if ( not mode ) then
		mode = SpellBookCompanionsFrame.mode;
	end
	if (not creatureID ) then
		creatureID = (SpellBookCompanionsFrame.mode=="MOUNT") and SpellBookCompanionsFrame.idMount or SpellBookCompanionsFrame.idCritter;
	end
	for i=1,GetNumCompanions(mode) do
		if ( GetCompanionInfo(mode, i) == creatureID ) then
			return i;
		end
	end
	return nil;
end

function SpellBookCompanionsFrame_UpdateCompanionPreview()
	local selected = SpellBookCompanionsFrame_FindCompanionIndex();
	
	if (selected) then
		local creatureID, creatureName = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if (SpellBookCompanionModelFrame.creatureID ~= creatureID) then
			SpellBookCompanionModelFrame.creatureID = creatureID;
			SpellBookCompanionModelFrame:SetCreature(creatureID);
			SpellBookCompanionSelectedName:SetText(creatureName);
		end
	end
end

function SpellBook_UpdateCompanionsFrame(type)
	local button, iconTexture, id;
	local creatureID, creatureName, spellID, icon, active;
	local offset, selected;
	
	if (type) then
		SpellBookCompanionsFrame.mode = type;
	end
	
	if (not SpellBookCompanionsFrame.mode) then
		return;
	end
	
	SpellBookFrame_UpdatePages();
	
	--local currentPage, maxPages = SpellBook_GetCurrentPage();--*****************************
	local currentPage, maxPages = SpellBookCompanion_GetCurrentPage();--*****************************
	if (currentPage) then
		currentPage = currentPage - 1;
	end
	
	offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		selected = SpellBookCompanionsFrame_FindCompanionIndex(SpellBookCompanionsFrame.idCritter);
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		selected = SpellBookCompanionsFrame_FindCompanionIndex(SpellBookCompanionsFrame.idMount);
	end
	
	if (not selected) then
		selected = 1;
		creatureID = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
			SpellBookCompanionsFrame.idCritter = creatureID;
		elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
			SpellBookCompanionsFrame.idMount = creatureID;
		end
	end

	for i = 1, NUM_COMPANIONS_PER_PAGE do
		button = _G["SpellBookCompanionButton"..i];
		id = i + (offset or 0);
		creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, id);
		button.creatureID = creatureID;
		button.spellID = spellID;
		button.active = active;
		if ( creatureID ) then
			button.IconTexture:SetTexture(icon);
			button.IconTexture:Show();
			button.SpellName:SetText(creatureName);
			button.SpellName:Show();
			button:Enable();
		else
			button:Disable();
			button.IconTexture:Hide();
			button.SpellName:Hide();
		end
		if ( (id == selected) and creatureID ) then
			button:SetChecked(true);
		else
			button:SetChecked(false);
		end
		
		if ( active ) then
			button.ActiveTexture:Show();
		else
			button.ActiveTexture:Hide();
		end
		if (SpellBookCompanionsFrame.mode == "CRITTER") then
			button.Background:SetTexCoord(0.71093750, 0.79492188, 0.00390625, 0.17187500);
		else
			button.Background:SetTexCoord(0.62304688, 0.70703125, 0.00390625, 0.17187500);
		end
	end
	
	if ( selected ) then
		creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if ( active and creatureID ) then
			SpellBookCompanionSummonButton:SetText(SpellBookCompanionsFrame.mode == "MOUNT" and BINDING_NAME_DISMOUNT or PET_DISMISS);
		else
			SpellBookCompanionSummonButton:SetText(SpellBookCompanionsFrame.mode == "MOUNT" and MOUNT or SUMMON);
		end
	end
	
	SpellBook_UpdateCompanionCooldowns();
	SpellBookCompanionPageButton_Update()
end

function SpellBook_UpdateCompanionCooldowns()
	--local currentPage, maxPages = SpellBook_GetCurrentPage();--*****************************
	local currentPage, maxPages = SpellBookCompanion_GetCurrentPage();--*****************************
	if (currentPage) then
		currentPage = currentPage - 1;
	end
	local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
	
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i];
		local cooldown = _G[button:GetName().."Cooldown"];
		if ( button.creatureID ) then
			local start, duration, enable = GetCompanionCooldown(SpellBookCompanionsFrame.mode, offset + button:GetID());
			if ( start and duration and enable ) then
				CooldownFrame_SetTimer(cooldown, start, duration, enable);
			end
		else
			cooldown:Hide();
		end
	end
end

function SpellBookCompanionButton_OnLoad(self)
	self:RegisterForDrag("LeftButton");
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function SpellBookCompanionButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if ( GameTooltip:SetHyperlink("spell:"..self.spellID) ) then
		--GameTooltip:SetSpell(id, SpellBookFrame.bookType)
		self.UpdateTooltip = SpellBookCompanionButton_OnEnter;
	else
		self.UpdateTooltip = nil;
	end
	GameTooltip:Show()
end

function SpellBookCompanionButton_OnClick(self, button)
	local selectedID;
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		selectedID = SpellBookCompanionsFrame.idCritter;
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		selectedID = SpellBookCompanionsFrame.idMount;
	end

	if ( button ~= "LeftButton" or ( selectedID == self.creatureID) ) then
		--local currentPage, maxPages = SpellBook_GetCurrentPage();--*****************************
		local currentPage, maxPages = SpellBookCompanion_GetCurrentPage();--*****************************
		if (currentPage) then
			currentPage = currentPage - 1;
		end
		
		local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
		local index = self:GetID() + offset;
		if ( self.active ) then
			DismissCompanion(SpellBookCompanionsFrame.mode);
		else
			CallCompanion(SpellBookCompanionsFrame.mode, index);
		end
	else
		if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
			SpellBookCompanionsFrame.idCritter = self.creatureID;
			SpellBookCompanionsFrame_UpdateCompanionPreview();
		elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
			SpellBookCompanionsFrame.idMount = self.creatureID;
			SpellBookCompanionsFrame_UpdateCompanionPreview();
		end
	end
	
	SpellBook_UpdateCompanionsFrame();
end

function SpellBookCompanionButton_OnModifiedClick(self)
	local id = self.spellID;
	if ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			local spellName = GetSpellInfo(id);
			ChatEdit_InsertLink(spellName);
		else
			local spellLink = GetSpellLink(id)
			ChatEdit_InsertLink(spellLink);
		end
	elseif ( IsModifiedClick("PICKUPACTION") ) then
		SpellBookCompanionButton_OnDrag(self);
	end
end

function SpellBookCompanionButton_OnDrag(self)
	--local currentPage, maxPages = SpellBook_GetCurrentPage();--*****************************SpellBookCompanion_GetCurrentPage()
	local currentPage, maxPages = SpellBookCompanion_GetCurrentPage();--*****************************
	if (currentPage) then
		currentPage = currentPage - 1;
	end
	
	local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
	local dragged = self:GetID() + offset;
	PickupCompanion( SpellBookCompanionsFrame.mode, dragged );
end

function SpellBookCompanionSummonButton_OnClick()
	local selected = SpellBookCompanionsFrame_FindCompanionIndex();
	local creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
	if ( active ) then
		DismissCompanion(SpellBookCompanionsFrame.mode);
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		CallCompanion(SpellBookCompanionsFrame.mode, selected);
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
end


local CompanionCurrPage = {}
CompanionCurrPage.Critter = 1
CompanionCurrPage.Mount = 1

function SpellBookCompanion_GetPageNum(type)
local CashCount = GetNumCompanions(tostring(type));
if CashCount == 0 then return 1 end
	if math.fmod(CashCount, 12) == 0 then
		CompanionPageCount = round2(CashCount / 12)
	else
		CompanionPageCount = round2(CashCount / 12) + 1
	end
return CompanionPageCount
end

function SpellBookCompanion_GetCurrentPage()
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		return CompanionCurrPage.Critter, SpellBookCompanion_GetPageNum(SpellBookCompanionsFrame.mode)
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		return CompanionCurrPage.Mount, SpellBookCompanion_GetPageNum(SpellBookCompanionsFrame.mode)
	end
end


function SpellBookCompanionNextPageButton_OnClick()
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		CompanionCurrPage.Critter = CompanionCurrPage.Critter + 1
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		CompanionCurrPage.Mount = CompanionCurrPage.Mount + 1
	end
	SpellBook_UpdateCompanionsFrame(SpellBookCompanionsFrame.mode)
end

function SpellBookCompanionPrevPageButton_OnClick()
if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		CompanionCurrPage.Critter = CompanionCurrPage.Critter - 1
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		CompanionCurrPage.Mount = CompanionCurrPage.Mount - 1
	end
	SpellBook_UpdateCompanionsFrame(SpellBookCompanionsFrame.mode)
end

function SpellBookCompanionPageButton_Update()
local currentPage, maxPages = SpellBookCompanion_GetCurrentPage()
	if currentPage == maxPages then
		SpellBookCompanionNextPageButton:Disable();
	end
	if currentPage == 1 then
		SpellBookCompanionPrevPageButton:Disable();
	end
	if currentPage < maxPages then
		SpellBookCompanionNextPageButton:Enable();
	end
	if currentPage > 1 then
		SpellBookCompanionPrevPageButton:Enable();
	end
	SpellBookCompanionsPageText:SetFormattedText(PAGE_NUMBER, currentPage);
end

