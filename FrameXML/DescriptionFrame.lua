DESCRIPTION_TEXTS = { "HeaderTextTitle", "HeaderText", "AppearanceText", "SpecialText", "StatusText", "OOCText"};
DESCRIPTION_LAST_ACTIVE_INDEX = 1;

function DescriptionFrame_OnLoad(self)
    self:RegisterEvent("CHAT_MSG_ADDON");   
end

function DescriptionFrame_OnShow(self)
    --DescriptionFrameSiteButton:Disable();
    SendAddonMessage("INSPECT_DESC_GET", GetUnitName("player"), "WHISPER", GetUnitName("player"));
end

function DescriptionFrame_OnEvent(self, event, ...)
	if ( event == "CHAT_MSG_ADDON" ) then
		if (arg4 == GetUnitName("player") and arg1 == "CHAR_DESC_RESP") then
            local index = 1;
            DESCRIPTION_LAST_ACTIVE_INDEX = 1;
            for temp in string.gmatch(arg2, "([^|]+)") do
                if (index <= #DESCRIPTION_TEXTS) then
                    DescriptionFrame_DrawText(index, temp);
                end
                index = index + 1;
            end            
            
            DescriptionFrameScrollChildFrame:SetAlpha(0);
            DescriptionFrameScrollChildFrame:Show();
            UIFrameFadeIn(DescriptionFrameScrollChildFrame, QUESTINFO_FADE_IN);
        elseif (arg4 == GetUnitName("player") and arg1 == "ELUNA_DRESSUP") then
        local Gob_path1, Gob_path2, Gob_path3, Gob_path4, Gob_path5 = strsplit("@", arg2, 5)
                  ShowUIPanel(DressUpFrame);
                  DressUpModel:SetModel(tostring(Gob_path1))
                  DressUpModel:SetModelScale(0.7)
                  DressUpModel:SetRotation(tonumber(Gob_path5))
                  _G[DressUpModel:GetName()].rotation = tonumber(Gob_path5)
                  DressUpModel:SetPosition(tonumber(Gob_path2), tonumber(Gob_path3), tonumber(Gob_path4))
                  NobleVar_DressUpXposition = tonumber(Gob_path2)
                  NobleVar_DressUpYposition = tonumber(Gob_path3)
                  NobleVar_DressUpZposition = tonumber(Gob_path4)
        elseif (arg4 == GetUnitName("player") and arg1 == "VALENTINE_INJECT") then
            RenderValentine(arg2);
        end
	end
end

function DescriptionFrameScrollChildFrame_OnShow()
    PlaySound("igQuestListOpen");
end

function DescriptionFrame_OnHide()
    for i,textFrame in pairs(DESCRIPTION_TEXTS) do
        local titleFrame = _G["Description" .. textFrame .. "Title"];
        if (titleFrame and titleFrame:IsShown()) then
            titleFrame:Hide();
        end
        
        local textFrame = _G["Description" .. textFrame];
        if (textFrame and textFrame:IsShown()) then
            textFrame:Hide();
        end
    end
    
    DescriptionFrameScrollChildFrame:Hide();
end

function DescriptionFrame_DrawText(index, text)
    text = string.sub(text, 2);
    if (text == "") then
        return;
    end
    
    local textFrame = _G["Description" .. DESCRIPTION_TEXTS[index]];    
    textFrame:SetText(text);
    textFrame:Show();
    
    local titleFrame = _G["Description" .. DESCRIPTION_TEXTS[index] .. "Title"];
    if (titleFrame and index > 2) then
        titleFrame:SetPoint("TOPLEFT", "Description" .. DESCRIPTION_TEXTS[DESCRIPTION_LAST_ACTIVE_INDEX], "BOTTOMLEFT", 0, -15);
        DESCRIPTION_LAST_ACTIVE_INDEX = index;
        titleFrame:Show();
    end
end

function RenderValentine(text)
    frame1 = CreateFrame("Frame", nil, UIParent);
    frame1:SetFrameStrata("BACKGROUND");
    frame1:SetWidth(170);
    frame1:SetHeight(170);
    frame1.bg = frame1:CreateTexture(nil,"BACKGROUND");
    frame1.bg:SetTexture("Interface/ItemTextFrame/ItemText-Valentine-TopLeft.png");
    frame1.bg:SetAllPoints(frame1)
    frame1:SetPoint("CENTER", -20, 80);

    frame2 = CreateFrame("Frame", nil, UIParent);
    frame2:SetFrameStrata("BACKGROUND");
    frame2:SetWidth(170);
    frame2:SetHeight(85);
    frame2.bg = frame2:CreateTexture(nil,"BACKGROUND");
    frame2.bg:SetTexture("Interface/ItemTextFrame/ItemText-Valentine-BotLeft.png");
    frame2.bg:SetAllPoints(frame2)
    frame2:SetPoint("CENTER", -20, -48);

    frame3 = CreateFrame("Frame", nil, UIParent);
    frame3:SetFrameStrata("BACKGROUND");
    frame3:SetWidth(42);
    frame3:SetHeight(170);
    frame3.bg = frame3:CreateTexture(nil,"BACKGROUND");
    frame3.bg:SetTexture("Interface/ItemTextFrame/ItemText-Valentine-TopRight.png");
    frame3.bg:SetAllPoints(frame3)
    frame3:SetPoint("CENTER", 86, 80);

    frame4 = CreateFrame("Frame", nil, UIParent);
    frame4:SetFrameStrata("BACKGROUND");
    frame4:SetWidth(42);
    frame4:SetHeight(85);
    frame4.bg = frame4:CreateTexture(nil,"BACKGROUND");
    frame4.bg:SetTexture("Interface/ItemTextFrame/ItemText-Valentine-BotRight.png");
    frame4.bg:SetAllPoints(frame4)
    frame4:SetPoint("CENTER", 86, -48);

    frame5 = CreateFrame("Frame", nil, UIParent);
    frame5:SetFrameStrata("DIALOG")
    frame5:SetWidth(185)
    frame5:SetHeight(230)
    frame5_string = frame5:CreateFontString(nil,"OVERLAY","GameFontNormal")
    frame5_string:SetFont("Fonts\\\\SKURRI.TTF",12);
    frame5_string:SetTextHeight(12)
    frame5_string:SetAllPoints(frame5)
    frame5_string:SetTextColor(1, 0.1, 0.5, 1)
    frame5.texture = frame5_string
    frame5_string:SetText(text);
    frame5:SetPoint("CENTER", -2.5, 45)

    frame1:Hide();
    frame2:Hide();
    frame3:Hide();
    frame4:Hide();
    frame5:Hide();

    legoz1 = CreateFrame("DressUpModel")
    legoz1:SetFrameStrata("BACKGROUND")
    legoz1:SetWidth(550)
    legoz1:SetHeight(550)
    legoz1:SetModel("World/Generic/passivedoodads/valentinesday/valentinesribbon01.mdx")
    legoz1:SetModelScale(1)
    legoz1:SetRotation(0)
    legoz1:SetPosition(-10, 0, -0.9)
    legoz1:SetLight(1, 0, 0, -0.707, -0.707, 1, 1, 1, 1.0, 1, 1, 1, 1)
    legoz1:SetPoint("CENTER",0,-30)
    legoz1:Show()

    mbut = CreateFrame("Button")
    mbut:SetFrameStrata("TOOLTIP")
    mbut:SetWidth(30)
    mbut:SetHeight(30)

    local tubut = mbut:CreateTexture(nil,"TOOLTIP")
    tubut:SetTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up.png")
    tubut:SetAllPoints(mbut)
    mbut.texture = tubut

    mbut:SetPoint("CENTER",130,182)
    mbut:Show()
    mbut:SetScript("OnClick", function(self, arg1)
           mbut:Hide();
           legoz1:Hide();
           frame1:Hide();
           frame2:Hide();
           frame3:Hide();
           frame4:Hide();
           frame5:Hide()
           ribbontimer:Hide();
           ribbontimer = nil;
    end)


    local total = 0
    legoz1.rot = 0;
    legoz1.alpha = 0;
    legoz1.enable1 = nil;

    local function onUpdate(self,elapsed)
       total = total + elapsed
       if total >= 0.03 and legoz1.rot <= 3.11 then
           legoz1.rot = legoz1.rot + 0.03
           legoz1:SetRotation(legoz1.rot)
           legoz1:Show()
           total = 0;
       elseif legoz1.rot >= 3.11 and legoz1.alpha == 0 and legoz1.enable1 == nil then
           PlaySoundFile("Sound/Music/Musical Moments/angelic/angelic01.mp3");
           PlaySoundFile("Sound/Item/UseSounds/UseCrinkLingPaper.wav");
           legoz1.enable1 = 1;
       elseif legoz1.rot >= 3.11 and total >= 0.06 and legoz1.alpha <= 1 then
           legoz1.alpha = legoz1.alpha + 0.05
           frame1:SetAlpha(legoz1.alpha)
           frame2:SetAlpha(legoz1.alpha)
           frame3:SetAlpha(legoz1.alpha)
           frame4:SetAlpha(legoz1.alpha)
           frame5:SetAlpha(legoz1.alpha)
           frame1:Show();
           frame2:Show();
           frame3:Show();
           frame4:Show();
           frame5:Show()
           total = 0;
       end
    end

    if ribbontimer == nil then
       ribbontimer = CreateFrame("frame")
       ribbontimer:SetScript("OnUpdate", onUpdate)
    end
end