
function DMPanelNoble:TargetDeleteNPC()
    if UnitIsPlayer("target") or UnitName("target") == nil then
        print("|cffff9716[ГМ-аддон]: Возьмите в цель НПС.|r")
    else
        PlaySound(89)
        SendChatMessage(".npcdel","WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
    end
end



local function myChatFilter(self, event, msg, author, ...)
    if msg:find("^ID: (%d+)") then
        return false, msg .. " - |cffffffff|Hdelobj:" .. tonumber(string.match(msg, "^ID: (%d+)")) .."|h[Удалить]|r|h", author, ...
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter)




local DMPanelNoble_DropDown = CreateFrame("FRAME", "DMPanelNoble_DropDown", UIParent, "UIDropDownMenuTemplate")
DMPanelNoble_DropDown.CurrentText = nil
DMPanelNoble_DropDown.CurrentEntry = nil
DMPanelNoble_DropDown.CurrentState = nil
UIDropDownMenu_Initialize(DMPanelNoble_DropDown, function(self, level, menuList)
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.isTitle = true;
info.notCheckable = true;
info.text = DMPanelNoble_DropDown.CurrentText;
UIDropDownMenu_AddButton(info, level);
---

---
if DMPanelNoble_DropDown.CurrentState == "GobDM1" then
    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить предмет (Временно)';
    info.func = function() SendChatMessage(".gobadd " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);
elseif DMPanelNoble_DropDown.CurrentState == "GobDM2" then
    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить предмет (Временно)';
    info.func = function() SendChatMessage(".gobadd " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить предмет (Постоянно)';
    info.func = function() SendChatMessage(".gobput " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);
elseif DMPanelNoble_DropDown.CurrentState == "NPCDM1" then
    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить существо (Временно)';
    info.func = function() SendChatMessage(".npcadd " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);
elseif DMPanelNoble_DropDown.CurrentState == "NPCDM2" then
    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить существо (Временно)';
    info.func = function() SendChatMessage(".npcadd " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);

    local info = UIDropDownMenu_CreateInfo()
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Установить существо (Постоянно)';
    info.func = function() SendChatMessage(".npcput " .. DMPanelNoble_DropDown.CurrentEntry,"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player")); end
    UIDropDownMenu_AddButton(info, level);
end
---
local info = UIDropDownMenu_CreateInfo()
info.hasArrow = false;
info.notCheckable = true;
info.text = 'Закрыть';
info.func = self.Close
UIDropDownMenu_AddButton(info, level);

end)

function DMPanelNoble_DropDown:Close()
CloseDropDownMenus()
end

local OriginalChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
ChatFrame_OnHyperlinkShow = function(...)
local chatFrame, link, text, button = ...;
local type, value = link:match("(%a+):(.+)");
    if type == "delobj" then
        SendChatMessage(".gobdel " .. tonumber(value),"WHISPER" ,GetDefaultLanguage("player"),GetUnitName("player"));
        return
    elseif ( type == "entry" ) then
        if string.find(link,"creature_entry:") then
            DMPanelNoble_DropDown.CurrentText = tostring(string.match(text, "%[(.+)%]"))
            DMPanelNoble_DropDown.CurrentEntry = tonumber(value)
            if DMLevel == 1 then
                DMPanelNoble_DropDown.CurrentState = "NPCDM1"
                ToggleDropDownMenu(1, nil, DMPanelNoble_DropDown, 'cursor', 0, 0);
            elseif DMLevel > 1 then
                DMPanelNoble_DropDown.CurrentState = "NPCDM2"
                ToggleDropDownMenu(1, nil, DMPanelNoble_DropDown, 'cursor', 0, 0);
            end
            return
        elseif string.find(link,"gameobject_entry:") then
            DMPanelNoble_DropDown.CurrentText = tostring(string.match(text, "%[(.+)%]"))
            DMPanelNoble_DropDown.CurrentEntry = tonumber(value)
            if DMLevel == 1 then
                DMPanelNoble_DropDown.CurrentState = "GobDM1"
                ToggleDropDownMenu(1, nil, DMPanelNoble_DropDown, 'cursor', 0, 0);
            elseif DMLevel > 1 then
                DMPanelNoble_DropDown.CurrentState = "GobDM2"
                ToggleDropDownMenu(1, nil, DMPanelNoble_DropDown, 'cursor', 0, 0);
            end
            return
        else
            return OriginalChatFrame_OnHyperlinkShow(...);    
        end
    end
    return OriginalChatFrame_OnHyperlinkShow(...);
end