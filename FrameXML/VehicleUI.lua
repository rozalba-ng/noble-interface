local CustomVehicleButtonsPos = {
	[1] = { [1] = {0.4,0.3},  [2] = {0.58,0.3}, [3] = {0.58,0.9}, [4] = {0.4,0.9}, [5] = {0.4,0.1},  [6] = {0.58,0.1}, [7] = {0.4,0.5}, [8] = {0.58,0.7}, [9] = {0.58,0.5}, [10] = {0.4,0.7} },
    [2] = { },
    };

----------Seat Indicator--------------
--local numVehicleIndicatorButtons = 0;
function CustomVehicleSeatIndicator_SetUpVehicle(args)
    if(not args)then
        return;
    end
    local customVehicleID, subLevelCount, slotCount, playerList = string.split(";", args);
    VehicleSeatIndicator.playerList = {}
    for temp in string.gmatch(playerList, "([^|]+)") do
        local subLevel, slotID, playerName = string.split(",", temp);
        if ( VehicleSeatIndicator.playerList[tonumber(subLevel)] == nil) then
            VehicleSeatIndicator.playerList[tonumber(subLevel)] = {}
        end
        table.insert(VehicleSeatIndicator.playerList[tonumber(subLevel)], tonumber(slotID)+1, playerName);
    end
     
    vehicleIndicatorID = 222
	local backgroundTexture, numSeatIndicators = GetVehicleUIIndicator(vehicleIndicatorID);    
    VehicleSeatIndicator.customVehicleID = customVehicleID;
	--These have been hard-coded in for now. FIXME (need something returned from GetVehicleUIIndicator that gives height/width)
	local totalHeight = 128; --VehicleSeatIndicatorBackgroundTexture:GetFileHeight();
	local totalWidth = 128; --VehicleSeatIndicatorBackgroundTexture:GetFileWidth();
	VehicleSeatIndicator:SetHeight(totalHeight);
	VehicleSeatIndicator:SetWidth(totalWidth);
            
    VehicleSeatIndicatorBackgroundTexture:SetTexture("Interface\\Vehicles\\SeatIndicator\\Vehicle_Stagecoach.blp");
    local subLevel = 0;
    for i=1, tonumber(slotCount) do
        local button;
        if (math.fmod(i,8) == 0) then
            --subLevel = subLevel + 1;
        end
        if ( i > numVehicleIndicatorButtons ) then
            button = CreateFrame("Button", "VehicleSeatIndicatorButton"..i, VehicleSeatIndicator, "CustomVehicleSeatIndicatorButtonTemplate");
            button:SetID(i)
            numVehicleIndicatorButtons = i;
        else
            button = _G["VehicleSeatIndicatorButton"..i];
        end
        
        button.sublevel = subLevel;
        button.virtualID = i;
        button:SetPoint("CENTER", button:GetParent(), "TOPLEFT", CustomVehicleButtonsPos[tonumber(customVehicleID)][i][1]*totalWidth, -CustomVehicleButtonsPos[tonumber(customVehicleID)][i][2]*totalHeight);
        button:Show();
    end
	
	for i=tonumber(slotCount)+1, numVehicleIndicatorButtons do
		local button = _G["VehicleSeatIndicatorButton"..i];
		button:Hide();
	end
	
	VehicleSeatIndicator:Show();
	DurabilityFrame_SetAlerts();
	CustomVehicleSeatIndicator_Update(playerList);
	
	UIParent_ManageFramePositions();
end

function CustomVehicleSeatIndicator_Update(args)
	if ( not VehicleSeatIndicator.customVehicleID ) then
		return;
	end
    VehicleSeatIndicator.playerList = {}
    for temp in string.gmatch(args, "([^|]+)") do
        local subLevel, slotID, playerName = string.split(",", temp);
        if ( VehicleSeatIndicator.playerList[tonumber(subLevel)] == nil) then
            VehicleSeatIndicator.playerList[tonumber(subLevel)] = {}
        end
        table.insert(VehicleSeatIndicator.playerList[tonumber(subLevel)], tonumber(slotID)+1, playerName);
    end
	for i=1, numVehicleIndicatorButtons do
		local button = _G["VehicleSeatIndicatorButton"..i];
		if ( button:IsShown() ) then
			local occupantName = VehicleSeatIndicator.playerList[button.sublevel][button.virtualID];
			if ( occupantName ) then
				button.occupantName = occupantName;
				if ( occupantName == UnitName("player") ) then
					_G["VehicleSeatIndicatorButton"..i.."PlayerIcon"]:Show();
					_G["VehicleSeatIndicatorButton"..i.."AllyIcon"]:Hide();
					if ( not VehicleSeatIndicator.hasPulsedPlayer ) then
						SeatIndicator_Pulse(_G["VehicleSeatIndicatorButton"..i.."PulseTexture"], true);
						VehicleSeatIndicator.hasPulsedPlayer = true;
					end
				else
					_G["VehicleSeatIndicatorButton"..i.."PlayerIcon"]:Hide();
					_G["VehicleSeatIndicatorButton"..i.."AllyIcon"]:Show();
				end
			else
				_G["VehicleSeatIndicatorButton"..i.."PlayerIcon"]:Hide();
				_G["VehicleSeatIndicatorButton"..i.."AllyIcon"]:Hide();
			end
		end
	end
end

function CustomVehicleSeatIndicatorButton_OnClick(self, button)
	local seatIndex = self.virtualID;
	if ( button == "RightButton" and CanEjectPassengerFromSeat(seatIndex)) then
		ToggleDropDownMenu(1, seatIndex, VehicleSeatIndicatorDropDown, self:GetName(), 0, -5);
	else
		UnitSwitchToVehicleSeat("player", seatIndex);
	end
    --SendAddonMessage("PLAYER_CUSTOM_VEHICLE_MOVE", self.sublevel.. "}" ..seatIndex, "WHISPER", UnitName("player"))
end

function CustomVehicleSeatIndicatorButton_OnEnter(self)
	if ( not self:IsEnabled() ) then
		return;
	end
	
	local controlType, occupantName, serverName, ejectable, canSwitchSeats = UnitVehicleSeatInfo("player", self.virtualID);
	local highlight = _G[self:GetName().."Highlight"]
	
    occupantName = VehicleSeatIndicator.playerList[self.sublevel][self.virtualID];
    
	if ( not UnitUsingVehicle("player") ) then	--UnitUsingVehicle also returns true when we are transitioning between seats in a vehicle.
		highlight:Hide();
		if ( occupantName ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(occupantName);
		end
		return;
	end
	
	if ( not canSwitchSeats or not CanSwitchVehicleSeat() ) then
		highlight:Hide();
		SetCursor(nil);
		if ( occupantName ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(occupantName);
		end
	elseif ( controlType == "None" ) then
		if ( occupantName ) then
			highlight:Hide();
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(occupantName);
		else
			highlight:Show();
			SetCursor("Interface\\CURSOR\\vehichleCursor");
		end
	elseif ( controlType == "Root" ) then
		if ( occupantName ) then
			highlight:Hide();
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(occupantName);
		else
			highlight:Show();
			SetCursor("Interface\\CURSOR\\Driver");
		end
	elseif ( controlType == "Child" ) then
		if ( occupantName ) then
			highlight:Hide();
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(occupantName);
		else
			highlight:Show();
			SetCursor("Interface\\CURSOR\\Gunner");
		end
	end
end

function CustomVehicleSeatIndicatorButton_OnLeave(self)
	GameTooltip:Hide();
	SetCursor(nil);
end