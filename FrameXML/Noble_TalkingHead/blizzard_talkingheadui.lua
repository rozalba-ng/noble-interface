------------
--// Created by: Harusha
--// hsmichaeldn@gmail.com
--// Date: 23.09.2020
------------


--Modified GossipFrame.lua - added func MuteGossipSound(text)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 OnLoad                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function TalkingHeadFrame_OnLoad(self)

	self:RegisterForClicks("AnyUp");
	self.AuthorFrame.Text:SetFontObject(GameFontDisableSmall)
	self.NameFrame.Name:SetFont("Fonts\\MORPHEUS.TTF", 17, "OUTLINE")
	self.TextFrame.Text:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
	
	SetAtlas(self.MainFrame.Model.PortraitBg, "TalkingHeads-PortraitBg", 0.9)
	SetAtlas(self.BackgroundFrame.TextBackground, "TalkingHeads-TextBackground", 0.9)
	SetAtlas(self.MainFrame.Model.Portrait, "TalkingHeads-Alliance-PortraitFrame", 0.9)
	SetAtlas(self.MainFrame.Sheen, "TalkingHeads-Glow-Sheen", 0.9)
	SetAtlas(self.MainFrame.TextSheen, "TalkingHeads-Glow-TextSheen", 0.9)
	SetAtlas(self.MainFrame.Overlay.Glow_TopBar, "TalkingHeads-Glow-TopBarGlow", 0.9)
	SetAtlas(self.MainFrame.Overlay.Glow_LeftBar, "TalkingHeads-Glow-SideBarGlow", 0.9)
	SetAtlas(self.MainFrame.Overlay.Glow_RightBar, "TalkingHeads-Glow-SideBarGlow", 0.9)
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                              Variables                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local ModelPortraitCorrect = {
["character\\human\\female\\humanfemale_hd.m2"] = 1,
["character\\human\\female\\humanfemale_npc.m2"] = 1,
["character\\human\\female\\humanfemale.m2"] = 1,
["character\\dwarf\\male\\dwarfmale_hd.m2"] = 1,
["character\\dwarf\\male\\dwarfmale_npc.m2"] = 1,
["character\\dwarf\\male\\dwarfmale.m2"] = 1,
}

local Model_TalkGlitch = {
"character\\bloodelf\\female\\bloodelffemale.m2",
"creature\\ladysylvanaswindrunner\\ladysylvanaswindrunner.m2",
"creature\\alexstrasza\\ladyalexstrasa.m2",
"character\\bloodelf\\female\\bloodelffemalenpc.m2",
"character\\bloodelf\\female\\bloodelffemalehd.m2",
"character\\bloodelf\\female\\bloodelffemale_hd.m2",
"character\\bloodelf\\female\\bloodelffemale_npc.m2",
}

local TH_Temp ={}
TH_Temp.Cooldown = 0

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                               Splitter                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TH_Temp.Splitter = {}
TH_Temp.Splitter.Words = "";
TH_Temp.Splitter.Cash = {}
TH_Temp.Splitter.Saved = {}

local function StringSplitter(line)
TH_Temp.Splitter.Words = "";
TH_Temp.Splitter.Cash = {}
TH_Temp.Splitter.Saved = {}

    for SingleWord in line:gmatch("%S+") do
        table.insert(TH_Temp.Splitter.Cash, SingleWord);
    end

    if string.utf8len(line) <= (300) then
        table.insert(TH_Temp.Splitter.Saved, tostring(line));
    else
        for i=1 , table.getn(TH_Temp.Splitter.Cash) do
            TH_Temp.Splitter.Words = TH_Temp.Splitter.Words.." "..TH_Temp.Splitter.Cash[i];
            if i == table.getn(TH_Temp.Splitter.Cash) then
                table.insert(TH_Temp.Splitter.Saved, tostring(TH_Temp.Splitter.Words));
                break
            end
            if (string.utf8len(TH_Temp.Splitter.Words) + string.utf8len(TH_Temp.Splitter.Cash[i+1])) > 300 then
                table.insert(TH_Temp.Splitter.Saved, tostring(TH_Temp.Splitter.Words));
                TH_Temp.Splitter.Words = "";
            end 
        end

    end
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Duplicator                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local function SplitterDuplicator(name)
if not TH_Temp.Splitter.Saved then return end
if not TH_Temp.Splitter.Saved[1] or TH_Temp.Splitter.Saved[1] == "" then return end

	for i=1,table.getn(TH_Temp.Splitter.Saved) do
		if i==1 then
			print(ARTIFACT_BAR_COLOR:GenerateHexColorMarkup() .. name .. ": " .. TH_Temp.Splitter.Saved[i] .. FONT_COLOR_CODE_CLOSE)
		else
			print(ARTIFACT_BAR_COLOR:GenerateHexColorMarkup() .. TH_Temp.Splitter.Saved[i] .. FONT_COLOR_CODE_CLOSE)
		end
	end
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                       Model Animations                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function Model_ValidateAnimation(modelName, sequence)  -- Отключаем анимации для всех, кроме табличных во избежание глитчей кастомных моделей
	if ANIMATION_SEQUENCE_DURATION[tostring(modelName)] then
		return ANIMATION_SEQUENCE_DURATION[tostring(modelName)][tostring(sequence)] or false
	else
		return false
	end
end

local function Model_SetupAnimations(model, sequence, Repeats)
	
	model.timer = 0;
	model.animationDuration = tonumber(Model_ValidateAnimation(model:GetModel(), sequence)) or 0;
	
	if( tContains(Model_TalkGlitch, tostring(model:GetModel())) and sequence == 60) then
		sequence = 65
	end

	model:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer + elapsed);
		
		if(self.timer > self.animationDuration or sequence == 0 or sequence == 3 or Model_ValidateAnimation(model:GetModel(), sequence) == false) then
			self:SetScript("OnUpdate", nil);
		else
			self:SetSequenceTime(sequence, self.timer*1000);
		end;
		
	end)
	
	if tonumber(Model_ValidateAnimation(model:GetModel(), sequence)) and Repeats > 1 then
		C_Timer:After(tonumber(Model_ValidateAnimation(model:GetModel(), sequence)), function()
			Model_SetupAnimations(model, sequence, Repeats-1)
		end);
	end
end

local function Model_ApplyUICamera(model)
	if ModelPortraitCorrect[tostring(model:GetModel())] then
		model:SetCamera(ModelPortraitCorrect[tostring(TalkingHeadFrame.MainFrame.Model:GetModel())])
	else
		model:SetCamera(0)
	end
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[              Main Frame Open Animation                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local function TalkingHeadFrame_SetUpAnimation()
		TalkingHeadFrame.NameFrame.Fadein:Play();
		TalkingHeadFrame.TextFrame.Fadein:Play();
		TalkingHeadFrame.AuthorFrame.Fadein:Play();
		TalkingHeadFrame.MainFrame.Overlay.Glow_TopBar.Fadein:Play();
		TalkingHeadFrame.MainFrame.Overlay.Glow_LeftBar.Fadein:Play();
		TalkingHeadFrame.MainFrame.Overlay.Glow_RightBar.Fadein:Play();
		TalkingHeadFrame.MainFrame.Sheen.Fadein:Play();
		TalkingHeadFrame.MainFrame.TextSheen.Fadein:Play();
		TalkingHeadFrame.MainFrame.Model.Fadein:Play();
		TalkingHeadFrame.BackgroundFrame.Fadein:Play();
		TalkingHeadFrame.MainFrame.CloseButton.Fadein:Play();
		TalkingHeadFrame:Show()
end

local function PageCounter(creator)
	if not creator then
		creator = TH_Temp.Creator or "technical";
	else
		TH_Temp.Creator = tostring(creator);
	end
	
    if creator == "technical" then
		if table.getn(TH_Temp.Splitter.Saved) > 1 then
			TalkingHeadFrame.AuthorFrame.Text:SetText("Стр.: ".. TH_Temp.CurrentPage .. "/" .. table.getn(TH_Temp.Splitter.Saved));
		else
			TalkingHeadFrame.AuthorFrame.Text:SetText(nil);
		end
    else
        TalkingHeadFrame.AuthorFrame.Text:SetText("Ведущий: " .. creator .. ". Стр.: ".. TH_Temp.CurrentPage .. "/" .. table.getn(TH_Temp.Splitter.Saved));
    end
end

local function TalkingHeadSetNew(creator)
    TH_Temp.CurrentPage = 1
    TalkingHeadFrame.TextFrame.Text:SetText(TH_Temp.Splitter.Saved[1])
    PageCounter(creator)
    TH_Temp.OpenTime = GetTime()
	
	PlaySoundFile("sound/interface/achievementmenuopen.ogg")
end

function TalkingHeadFrame_CloseImmediately()
	TalkingHeadFrame:Hide()
end

local function Model_Debug(model)
	if type(model:GetModel()) ~= "string" then
		model:SetModel("Interface\\Buttons\\talktomequestionmark.mdx");
        model:SetPosition( 3.5, 0, 1.37 );
	end
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                             Page Functions                              ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local function TH_IsOnCooldown()
	if GetTime() - tonumber(TH_Temp.Cooldown) < 0.27 then
		return true
	else
		TH_Temp.Cooldown = GetTime();
		return false
	end
end

function TalkingHeadFrame_OnClick(self, button)
    if TH_IsOnCooldown() then return end
	if TH_Temp.CurrentPage <= table.getn(TH_Temp.Splitter.Saved) then
        TalkingHeadFrame.MainFrame.TextSheen.Fadein:Stop();
		TalkingHeadFrame.TextFrame.Fadeout:Stop();
		
		if button == "LeftButton" then
            if TH_Temp.CurrentPage == table.getn(TH_Temp.Splitter.Saved) then return end
				TalkingHeadFrame.TextFrame.Fadeout:Play();
				
				C_Timer:After(0.25, function()
					TalkingHeadFrame.TextFrame.Text:SetText(TH_Temp.Splitter.Saved[TH_Temp.CurrentPage+1])
					TH_Temp.CurrentPage = TH_Temp.CurrentPage + 1
					PageCounter()
				end);
        elseif button == "RightButton" then
            if TH_Temp.CurrentPage == 1 then return end
				TalkingHeadFrame.TextFrame.Fadeout:Play();
				
				C_Timer:After(0.25, function()
					TalkingHeadFrame.TextFrame.Text:SetText(TH_Temp.Splitter.Saved[TH_Temp.CurrentPage-1])
					TH_Temp.CurrentPage = TH_Temp.CurrentPage - 1
					PageCounter()
				end);
        end  
    end
	return true;
end

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                            RegisterEvent                                ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ElunaSendAddon_TalkingHead = CreateFrame("Frame", "ElunaSendAddon_TalkingHead", UIParent);
ElunaSendAddon_TalkingHead: RegisterEvent("GOSSIP_SHOW")
ElunaSendAddon_TalkingHead: SetScript("OnEvent", function(self, event, ...)
local args = {...}
   if GossipTitleButton1:GetText() == "TalkingHead" then
        TH_Temp.GossipTime = GetTime()
        TalkingHeadFrame.MainFrame.Model:SetUnit("npc");
        CloseGossip();
        GossipTitleButton1:SetText("")
    end
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                С_table                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
C_TalkingHead = {}

function C_TalkingHead.SetTalkingHead(line, UnitName, Creator, AnimState, Repeats, SoundKit)
	if TalkingHeadFrame:IsVisible() and TalkingHeadFrame.NameFrame.Name:GetText() == tostring(UnitName) then
		TalkingHeadFrame.TextFrame.Fadeout:Play();
			C_Timer:After(0.25, function()
				StringSplitter(line)
				SplitterDuplicator(UnitName)
				TalkingHeadSetNew(Creator)
			end);
	else
		TalkingHeadFrame_SetUpAnimation()
		StringSplitter(line)
		SplitterDuplicator(UnitName)
		TalkingHeadSetNew(Creator)
	end
	
	TalkingHeadFrame.NameFrame.Name:SetText(tostring(UnitName));
	Model_SetupAnimations(TalkingHeadFrame.MainFrame.Model, AnimState, Repeats)
	Model_ApplyUICamera(TalkingHeadFrame.MainFrame.Model);
	Model_Debug(TalkingHeadFrame.MainFrame.Model)
	
	if SoundKit then
		C_Timer:After(0.4, function()
			PlaySoundFile(tostring(SoundKit))
		end);
	end
	--print(TalkingHeadFrame.MainFrame.Model:GetModel())
end

function C_TalkingHead.TestGossip(AnimState, Repeats, SoundKit)
    C_TalkingHead.SetTalkingHead("Test TalkingHead text", "Unit Name", UnitName("player"), AnimState, Repeats, SoundKit)
	TalkingHeadFrame.MainFrame.Model:SetUnit("target");
	Model_ApplyUICamera(TalkingHeadFrame.MainFrame.Model);
	Model_SetupAnimations(TalkingHeadFrame.MainFrame.Model, AnimState, Repeats)
end

function C_TalkingHead.QuestModel(line, UnitName, Creator, SoundKit)
	C_TalkingHead.SetTalkingHead(line, UnitName, Creator, AnimState, Repeats, SoundKit)
	TalkingHeadFrame.MainFrame.Model:SetModel("Interface\\Buttons\\talktomequestionmark.mdx");
    TalkingHeadFrame.MainFrame.Model:SetPosition( 3.5, 0, 1.37 );
end

function C_TalkingHead.GobjectModel(line, UnitName, Creator, SoundKit, GobjectPath, Xpos, Ypos, Zpos, Rotation)
	C_TalkingHead.SetTalkingHead(line, UnitName, Creator, 0, 0, SoundKit)
	TalkingHeadFrame.MainFrame.Model:SetModel(tostring(GobjectPath));
    TalkingHeadFrame.MainFrame.Model:SetPosition( tonumber(Xpos), tonumber(Ypos), tonumber(Zpos) );
    TalkingHeadFrame.MainFrame.Model:SetFacing(tonumber(Rotation));
end

function C_TalkingHead.ModelByEntry(line, UnitName, Creator, AnimState, Repeats, SoundKit, creatureID)
	C_TalkingHead.SetTalkingHead(line, UnitName, Creator, 0, 0, SoundKit)
	TalkingHeadFrame.MainFrame.Model:SetCreature(tonumber(creatureID))
	Model_ApplyUICamera(TalkingHeadFrame.MainFrame.Model);
	Model_SetupAnimations(TalkingHeadFrame.MainFrame.Model, AnimState, Repeats)
end
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                       Old functions convert                             ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function ElunaGetTalkingHead(line, UnitName, creator)
    C_TalkingHead.SetTalkingHead(line, UnitName, creator, 60, 1, nil)
end

function TalkingHeadQuestModel(line, UnitName)
	C_TalkingHead.QuestModel(line, UnitName, "technical", nil)
end

function TalkingHeadGobjectModel(line, UnitName, GobjectPath, Xpos, Ypos, Zpos, Rotation)
	C_TalkingHead.GobjectModel(line, UnitName, "technical", nil, GobjectPath, Xpos, Ypos, Zpos, Rotation)
end

function TalkingHeadByEntry(line, UnitName, creatureID)
    C_TalkingHead.ModelByEntry(line, UnitName, "technical", 0, 0, nil, creatureID)
end

TalkingHead = CreateFrame("Frame", "TalkingHead", UIParent)
TalkingHead:SetSize(1, 1)
TalkingHead:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
TalkingHead:SetScript("OnHide", function()
	TalkingHeadFrame:Hide()
	TalkingHead:Show()
end)


-- /script C_TalkingHead.TestGossip(60, 2, "Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleFlirt01.ogg")
-- /script C_TalkingHead.QuestModel("Test TalkingHead text", "Unit Name", UnitName("player"), "Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleFlirt01.ogg")
-- /script C_TalkingHead.GobjectModel("Test TalkingHead text", "Unit Name", UnitName("player"), "Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleFlirt01.ogg", "World\\expansion03\\doodads\\worgen\\items\\worgen_mailbox.mdx", 0, 0, 0.36, 5.64)
-- /script C_TalkingHead.ModelByEntry("Test TalkingHead text", "Unit Name", UnitName("player"), 60, 2, "Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleFlirt01.ogg", 9922113)


