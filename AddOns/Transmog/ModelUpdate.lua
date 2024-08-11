----------------------------------------------------------------------------------------------------------------------------------------------------
 --[[Серые(неактивные) кнопки скроллфрейма.]]
 local  Transmog_ScrollDownButton = CreateFrame("BUTTON", "Transmog_ScrollDownButton", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_ScrollDownButton:Show()
 Transmog_ScrollDownButton:SetSize(32,32)
 Transmog_ScrollDownButton:SetPoint("CENTER", TCP_scrollFrameScrollBarScrollDownButton, "CENTER")
 Transmog_ScrollDownButton:SetNormalTexture("interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Disabled")
 
 local  Transmog_ScrollUpButton = CreateFrame("BUTTON", "Transmog_ScrollUpButton", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_ScrollUpButton:Show()
 Transmog_ScrollUpButton:SetSize(32,32)
 Transmog_ScrollUpButton:SetPoint("CENTER", TCP_scrollFrameScrollBarScrollUpButton, "CENTER")
 Transmog_ScrollUpButton:SetNormalTexture("interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
 
 --[[Поворот  модели персонажа.]]
 local  Transmog_RotateLeft = CreateFrame("BUTTON", "Transmog_RotateLeft", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_RotateLeft:Show()
 Transmog_RotateLeft:SetSize(35,35)
 Transmog_RotateLeft:SetPoint("CENTER", -170, 170);
 Transmog_RotateLeft:RegisterForClicks("AnyUp")
 Transmog_RotateLeft:SetNormalTexture("interface\\BUTTONS\\UI-RotationLeft-Button-Up")
 Transmog_RotateLeft:SetPushedTexture("interface\\BUTTONS\\UI-RotationLeft-Button-Down")
 Transmog_RotateLeft:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
 
 local  Transmog_RotateRight = CreateFrame("BUTTON", "Transmog_RotateRight", Transmog_MainPanel, "SecureHandlerClickTemplate");
 Transmog_RotateRight:Show()
 Transmog_RotateRight:SetSize(35,35)
 Transmog_RotateRight:SetPoint("CENTER", -135, 170);
 Transmog_RotateRight:RegisterForClicks("AnyUp")
 Transmog_RotateRight:SetNormalTexture("interface\\BUTTONS\\UI-RotationRight-Button-Up")
 Transmog_RotateRight:SetPushedTexture("interface\\BUTTONS\\UI-RotationRight-Button-Down")
 Transmog_RotateRight:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
 
local Transmog_Rototation = 0
function Transmog_Model_OnUpdate(self,Transmog_elapsed)
	if ( getglobal("Transmog_RotateLeft"):GetButtonState() == "PUSHED" ) then
		Transmog_Rototation = Transmog_Rototation + (Transmog_elapsed * 2 * 3.14 * 0.3);
        Transmog_UnitModel:SetRotation(Transmog_Rototation)
	end
    if ( getglobal("Transmog_RotateRight"):GetButtonState() == "PUSHED" ) then
		Transmog_Rototation = Transmog_Rototation - (Transmog_elapsed * 2 * 3.14 * 0.3);
        Transmog_UnitModel:SetRotation(Transmog_Rototation)
	end
end

local Transmog_RotateFrame = CreateFrame("frame")
Transmog_RotateFrame:SetScript("OnUpdate", Transmog_Model_OnUpdate)

function BarberModelRotate()
Transmog_Rototation = -0.5
Transmog_UnitModel:SetRotation(-0.5)
end
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
function UpdateTransmogModel()
Transmog_UnitModel:SetPosition( 0, 0, 0);
Transmog_UnitModel:RefreshUnit()
        if SelectTabTransmog == 3 then
            UpdateBarberModel()
        else
          local race, raceEn = UnitRace("player");
            if raceEn == "BloodElf" and UnitSex("player") == 3 then --/ Выправляет эльфиек
                Transmog_UnitModel:SetPosition( 0, 0.15, 0);
            elseif raceEn == "Dwarf" and UnitSex("player") == 2 then --/ Выправляет дворфов
                Transmog_UnitModel:SetPosition( 0.6, 0, -0.2);
            end
        end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Апдейт модели персонажа на актуальное состояние.]]        
local Transmog_ModelUpdateFrame = CreateFrame("Frame")
Transmog_ModelUpdateFrame:RegisterEvent("UNIT_MODEL_CHANGED");
Transmog_ModelUpdateFrame:SetScript("OnEvent", function(self, event)
        if Transmog_CodeListFrame:IsVisible() then
            TransmogElunaSave = false
            CallIds()
        end
        
        UpdateTransmogModel()
        Transmog_ItemUpdate()
end)
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[Апдейтит модель при логине.]]
local Transmog_load = CreateFrame("Frame")
Transmog_load:RegisterEvent("PLAYER_ENTERING_WORLD");
Transmog_load:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        Transmog_UnitModel:SetUnit("player");
    end
end)





