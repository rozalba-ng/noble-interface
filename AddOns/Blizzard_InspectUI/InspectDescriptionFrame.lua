INSPECTDESCRIPTION_TEXTS = { "HeaderTextTitle", "HeaderText", "AppearanceText", "SpecialText", "StatusText", "OOCText"};
INSPECTDESCRIPTION_LAST_ACTIVE_INDEX = 1;

function InspectDescriptionFrame_OnLoad(self)
    self:RegisterEvent("CHAT_MSG_ADDON");   
end

function InspectDescriptionFrame_OnShow(self)
    --InspectDescriptionFrameSiteButton:Disable();
    InspectDescriptionFrame.unit = InspectFrame.unit;
    SendAddonMessage("INSPECT_DESC_GET", GetUnitName(InspectDescriptionFrame.unit), "WHISPER", GetUnitName("player"));
end

function InspectDescriptionFrame_OnEvent(self, event, ...)
	if ( event == "CHAT_MSG_ADDON" ) then
		if (arg4 == GetUnitName("player") and arg1 == "INSPECT_DESC_RESP") then
            local index = 1;
            INSPECTDESCRIPTION_LAST_ACTIVE_INDEX = 1;
            for temp in string.gmatch(arg2, "([^|]+)") do
                if (index <= #INSPECTDESCRIPTION_TEXTS) then
                    InspectDescriptionFrame_DrawText(index, temp);
                end
                index = index + 1;
            end            
            
            InspectDescriptionFrameScrollChildFrame:SetAlpha(0);
            InspectDescriptionFrameScrollChildFrame:Show();
            UIFrameFadeIn(InspectDescriptionFrameScrollChildFrame, QUESTINFO_FADE_IN);
        end
	end
end

function InspectDescriptionFrameScrollChildFrame_OnShow()
    PlaySound("igQuestListOpen");
end

function InspectDescriptionFrame_OnHide()
    for i,textFrame in pairs(INSPECTDESCRIPTION_TEXTS) do
        local titleFrame = _G["InspectDescription" .. textFrame .. "Title"];
        if (titleFrame and titleFrame:IsShown()) then
            titleFrame:Hide();
        end
        
        local textFrame = _G["InspectDescription" .. textFrame];
        if (textFrame and textFrame:IsShown()) then
            textFrame:Hide();
        end
    end
    
    InspectDescriptionFrameScrollChildFrame:Hide();
end

function InspectDescriptionFrame_DrawText(index, text)
    text = string.sub(text, 2);
    if (text == "") then
        return;
    end

    local textFrame = _G["InspectDescription" .. INSPECTDESCRIPTION_TEXTS[index]];    
    textFrame:SetText(text);
    textFrame:Show();
    
    local titleFrame = _G["InspectDescription" .. INSPECTDESCRIPTION_TEXTS[index] .. "Title"];
    if (titleFrame and index > 2) then
        titleFrame:SetPoint("TOPLEFT", "InspectDescription" .. DESCRIPTION_TEXTS[INSPECTDESCRIPTION_LAST_ACTIVE_INDEX], "BOTTOMLEFT", 0, -15);
        INSPECTDESCRIPTION_LAST_ACTIVE_INDEX = index;
        titleFrame:Show();
    end
end