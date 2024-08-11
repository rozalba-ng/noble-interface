
PetControl = PetControl or {}

--[[	EDIT BOX	]]--

PetControl.EditBox = PetControl.EditBox or {}
PetControl.EditBox.Status = nil

function PetControl.EditBox.ScrollFrame( self )
	local frame = CreateFrame("ScrollFrame", "PetControlFrame_EditBox_ScrollFrame", PetControlFrame_EditBox_Frame, "UIPanelScrollFrameTemplate")
	frame:SetSize(276, 98)
	frame:SetPoint("TOPLEFT", PetControlFrame_EditBox_Frame, "TOPLEFT", 12, -15)
	frame:SetScrollChild(PetControlFrame_EditBox)
	
	
	self:SetScript('OnTextChanged', function(self)
		ScrollingEdit_OnTextChanged(self, self:GetParent())
	end)

	self:SetScript('OnCursorChanged', function(self, x, y, w, h)
		ScrollingEdit_OnCursorChanged(self, x, y, w, h)
	end)

	self:SetScript('OnUpdate', function(self, elapsed)
		ScrollingEdit_OnUpdate(self, elapsed, self:GetParent())
		PetControlFrame_EditBox_ScrollFrameScrollBar:Hide()
	end)
	
	self:SetScript('OnEnterPressed', function(self)
		PetControl.EditBox.Send()
	end)
end

function PetControl.EditBox.Send()
	local self = PetControlFrame_EditBox
	local text = self:GetText()
	if ( text ~= "" ) and ( text ~= " " ) then
		local status = PetControl.EditBox.Status
		if status then
			if status == "say" then
				PetControl.Say( text )
			elseif status == "emote" then
				PetControl.Emote( text )
			else
				status = nil
				return
			end
			PetControl.EditBox.Hide()
		end
	end
end

function PetControl.EditBox.Hide()
	PetControlFrame_EditBox:SetText("")
	PetControlFrame_EditBox:ClearFocus()
	PetControlFrame_EditBox_Frame:Hide()
end

function PetControl.EditBox.Show( status )
	PetControlFrame_ByteButton_Submenu:Hide()
	PetControlFrame_EditBox:SetText("")
	PetControl.EditBox.Status = status
	PetControlFrame_EditBox_Frame:Show()
	PetControlFrame_EditBox:SetFocus()
end

--[[	ВСПЛЫВАЮЩИЕ ПОДСКАЗКИ	]]--

function PetControl.GameTooltipOnEnter( self )
    GameTooltip:SetOwner( self, "ANCHOR_BOTTOMRIGHT" )
    GameTooltip:SetText( self.Tooltip, nil, nil, nil, nil, true )
    GameTooltip:Show()
end

function PetControl.GameTooltipOnLeave( self )
    GameTooltip:Hide()
end

function PetControl.Tooltip( self, text )
	self.Tooltip = text
	self:SetScript("OnEnter", PetControl.GameTooltipOnEnter)
	self:SetScript("OnLeave", PetControl.GameTooltipOnLeave)
end

--[[	ОТОБРАЖЕНИЕ "ЛАПКИ" ВЫЗОВА МЕНЮ		]]--

local frame = CreateFrame("FRAME", "PetControlEventFrame");
frame:RegisterEvent("PLAYER_TARGET_CHANGED");
local function eventHandler(self, event, ...)
	if UnitCreatureType("target") == "Спутник" then
		for i = 1, GetNumCompanions("CRITTER") do
			_, name, _, _, summoned = GetCompanionInfo("CRITTER", i)
			if summoned then
				if ( GetUnitName("target", false) == name ) then
					PlayerIsCompanionOwner()
				end
				break
			end
		end
		PetControlButton:Disable()
		PetControlFrame:Hide()
		PetControlButton:Show()
	else
		PetControlButton:Hide()
	end
	PetControl.Target = false
end
frame:SetScript("OnEvent", eventHandler);

--[[	УПРАВЛЕНИЕ СПУТНИКОМ	]]--

PetControl.status = {
	byte1 = 0, -- 0-Стоит, 1-Сидит, 3-Лежит.
	last_byte = 1,
	follow = 1,
}

function PetControl.ByteTexture( self, byte1 ) -- Смена Byte1
	if byte1 == 0 then -- Стоит
		self:SetTexCoord(0, 0.5, 0, 0.5 )
	elseif byte1 == 1 then -- Сидит
		self:SetTexCoord(0.5, 1, 0, 0.5 )
	else -- Лежит
		self:SetTexCoord(0, 0.5, 0.5, 0.9 )
	end
	PetControl.status.last_byte = PetControl.status.byte1
	PetControl.status.byte1 = byte1
	PetControlFrame_ByteButton_Submenu:Hide()
	PetControl.Byte1( byte1 )
end

function PetControl.FollowButton( self )
	if PetControl.status.follow == 0 then -- Стоит
		PetControl.status.follow = 1
		self:SetTexCoord( 0, 0.5, 0, 1 ) -- А теперь пошёл.
	else -- Идёт
		self:SetTexCoord( 0.5, 1, 0, 1 )
		PetControl.status.follow = 0 -- А теперь встал.
	end
	PetControl.Follow( PetControl.status.follow )
end
