function DressUpItemLink(link)
----
NobleVar_DressUpXposition = 0
NobleVar_DressUpYposition = 0
NobleVar_DressUpZposition = 0
DressUpModel:SetPosition(0, 0, 0)
----
    if not link then
        return;
    elseif not IsDressableItem(link) then
        ---
        DressUp_gobCheck = true
        ---
        HideUIPanel(DressUpFrame);
        NobleGobItemId = select(2, strsplit(":", link));
            if tonumber(NobleGobItemId) >= 510000 then
                SendAddonMessage("ELUNA_DRESSUP_GET", tonumber(NobleGobItemId)-10000, "WHISPER", GetUnitName("player"));
            else
                SendAddonMessage("ELUNA_DRESSUP_GET", tonumber(NobleGobItemId), "WHISPER", GetUnitName("player"));
            end
        SetDressUpBackground_gob()
		return;
	end
	if ( not DressUpFrame:IsShown() ) then
        ---
        DressUp_gobCheck = false
        ---
        ShowUIPanel(DressUpFrame);
		DressUpModel:SetUnit("player");
        SetDressUpBackground()
	end
	DressUpModel:TryOn(link);
end

function DressUpTexturePath()
	-- HACK
	local race, fileName = UnitRace("player");
	if ( strupper(fileName) == "GNOME" ) then
		fileName = "Dwarf";
	elseif ( strupper(fileName) == "TROLL" ) then
		fileName = "Orc";
	end
	if ( not fileName ) then
		fileName = "Orc";
	end
	-- END HACK

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end

function SetDressUpBackground()
	local texture = DressUpTexturePath();
	DressUpBackgroundTopLeft:SetTexture(texture..1);
	DressUpBackgroundTopRight:SetTexture(texture..2);
	DressUpBackgroundBotLeft:SetTexture(texture..3);
	DressUpBackgroundBotRight:SetTexture(texture..4);
end

function SetDressUpBackground_gob()
	local texture = "Interface\\DressUpFrame\\DressUpBackground-gob"
	DressUpBackgroundTopLeft:SetTexture(texture..1);
	DressUpBackgroundTopRight:SetTexture(texture..2);
	DressUpBackgroundBotLeft:SetTexture(texture..3);
	DressUpBackgroundBotRight:SetTexture(texture..4);
end