function PlayerContainerFrameItemButton_OnClick(button)  
	if ( button == "LeftButton" ) then		
		if ( not IsModifierKeyDown() ) then
			local type, money = GetCursorInfo();
            if ( type == "item" ) then
                PlacePlayerContainerItem(this);
            else
                PickupPlayerContainerItem(this, 1)
			end			
			--StackSplitFrame:Hide();		
		end
	else
        -- RIGHT CLICK
        --if ( not IsModifierKeyDown() ) then
            --PlayerContainerItemToBag(this)
        --end		
	end
end

function PlayerContainerFrameItemButton_OnLoad()
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("AnyUp");
end

function PlayerContainerFrameItemButton_OnEnter(self)
	if ( this:GetRight() >= ( GetScreenWidth() / 2 ) ) then
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	else
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	end
    if ( this.hyperlink ) then
        GameTooltip:SetHyperlink(this.hyperlink);
        GameTooltip:Show();
    end
	this.UpdateTooltip = nil;
end

function PlayerContainerFrameItemButton_OnUpdate(arg1)

	if ( GameTooltip:IsOwned(this) ) then
		PlayerContainerFrameItemButton_OnEnter(this);
	end
end

function PlayerContainerFrame_OnEvent()
	if ( event == "BAG_UPDATE" ) then
		if ( this:IsShown() and this:GetID() == arg1 ) then
 			PlayerContainerFrame_Update(this);
		end
	elseif ( event == "BAG_UPDATE_COOLDOWN" or event == "UPDATE_INVENTORY_ALERTS" ) then
		if ( this:IsShown() ) then
			PlayerContainerFrame_Update(this);
		end
    elseif( event == "ITEM_LOCK_CHANGED" ) then
        if ( this:IsShown() ) then
			PlayerContainerFrame_Update(this);
            if(arg1 >= 0 and arg1 <= NUM_BAG_SLOTS)then
                this.playerBagId = arg1;
                this.playerSlotId = arg2;
            end
		end
	elseif ( event == "DISPLAY_SIZE_CHANGED" ) then
		if ( this:IsShown() ) then

		end
    elseif ( event == "CHAT_MSG_ADDON" ) then
        if ( arg4 == UnitName("player") and arg1 == "PLAYER_CONTAINER_OPEN") then
            this.containerSize = tonumber(string.sub(arg2, 1, 2));
            this.items = {};
            for temp in string.gmatch(string.sub(arg2, 3), "([^|]+)") do
                local item = {};
                local slot;
                item.link = string.match(temp, "(item:.*)%[");
                item.itemID = string.match(temp, "item:([0-9]+):");
                slot, item.name, item.count = string.split(",", string.match(temp, "%[(.*)%]"))
                this.items[tonumber(slot+1)] = item;
                --table.insert(this.items, item);
            end
            PlayerContainerFrame_GenerateFrame(this,this.containerSize,151)
            PlayerContainerFrame:Show();
        elseif ( arg4 == UnitName("player") and arg1 == "PLAYER_CONTAINER_UPDATE") then
            this.items = {};
            for temp in string.gmatch(arg2, "([^|]+)") do
                local item = {};
                local slot;
                item.link = string.match(temp, "(item:.*)%[");
                item.itemID = string.match(temp, "item:([0-9]+):");
                slot, item.name, item.count = string.split(",", string.match(temp, "%[(.*)%]"))
                this.items[tonumber(slot+1)] = item;                
            end 
            PlayerContainerFrame_Update(this) 
        end
    elseif ( event == "LOOT_OPENED" ) then           
      
	end
end

function PlayerContainerFrameItemButton_OnModifiedClick(arg1)

end

function PlayerContainerFrame_OnLoad()
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("BAG_CLOSED");
	this:RegisterEvent("BAG_OPEN");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	this:RegisterEvent("DISPLAY_SIZE_CHANGED");
    this:RegisterEvent("CHAT_MSG_ADDON");    
    this:RegisterEvent("LOOT_OPENED");
	this.bagsShown = 0;
	this.bags = {};
    this.containerSize = 1;
	if this:GetName() == "PlayerContainerFrame" then
		--PlayerContainerFrame_GenerateFrame(this,12,151)
	--else
	--	this.notInit = true;
	end
    this:SetPoint("CENTER", nil, "CENTER", 0, 0 );
end

function PlayerContainerFrame_OnHide()	
	--GHI_updateContainerFrameAnchors();
	LootFrame:EnableMouse(true); 
    for i=1,LootFrame:GetNumChildren() do 
        local f=select(i,LootFrame:GetChildren());
        if (f ~= this) then
            f:Show();
        end
    end; 
    for i=1,LootFrame:GetNumRegions() do 
        local f=select(i,LootFrame:GetRegions()); 
        f:Show(); 
    end;
    LootFrame.playerContainer = false;
end

function PlayerContainerFrame_OnShow(self)
    LootFrame.playerContainer = true;
	PlaySound("igBackPackOpen");
	PlayerContainerFrame_Update(this) 
end

function PlayerContainerFrame_Update(frame)
	local id = frame:GetID();
	local frameName = frame:GetName();
	local name,texture, itemCount, locked, quality, readablem, ID;
	--frame.size = 16;
	for j=1, frame.size, 1 do
		local itemButton = getglobal(frameName.."Item"..j);
        local data = frame.items[j];
		if type(data) == "table" then
			ID = tonumber(data.itemID);
            name = data.name;
            texture = GetItemIcon(ID)
			itemCount = tonumber(data.count);
			locked = data.locked;
			quality = 0;
			readable = nil;
            itemButton.hyperlink = data.link;
		else
            ID = 0;
			name = nil;			
			texture = ""
			itemCount = 0;
			locked = nil;
			quality = 0;
			readable = nil;
            itemButton.hyperlink = nil;
		end
		
		SetItemButtonTexture(itemButton, texture);
		SetItemButtonCount(itemButton, itemCount);
		--locked
		SetItemButtonDesaturated(itemButton, locked, 0.5, 0.5, 0.5);
		itemButton.ID = ID;
		itemButton.number = j;
		
		if ( name ) then
			itemButton.hasItem = 1;
		else
			getglobal(frameName.."Item"..j.."Cooldown"):Hide();
			itemButton.hasItem = nil;
		end

		itemButton.readable = readable;
	end
end

function PlayerContainerFrame_GenerateFrame(frame, size, id, item_id)
	frame.size = size;
	local name = frame:GetName();
	local bgTextureTop = getglobal(name.."BackgroundTop");
	local bgTextureMiddle = getglobal(name.."BackgroundMiddle1");
	local bgTextureBottom = getglobal(name.."BackgroundBottom");
	local columns = NUM_CONTAINER_COLUMNS;
	local rows = ceil(size / columns);
	frame.notInit = false;
	local bagTextureSuffix = "";
	local itemname,icon;
	local rc;
	if not(type(rc)=="table") then
		rc = {};
	end
	if rc.Type == "multible" then
		local i = rc.bag_index;
		if i then
			rc = rc[i];
		else 
			rc = {};
		end
	end
	if rc.texture == "-Bank" or rc.texture == "-Keyring" then 
		bagTextureSuffix = rc.texture;
	end
	
	
	bgTextureTop:SetTexture("Interface\\ContainerFrame\\UI-Bag-Components"..bagTextureSuffix);
	for i=1, MAX_BG_TEXTURES do
		getglobal(name.."BackgroundMiddle"..i):SetTexture("Interface\\ContainerFrame\\UI-Bag-Components"..bagTextureSuffix);
		getglobal(name.."BackgroundMiddle"..i):Hide();
	end
	--bgTextureBottom:SetTexture("Interface\\ContainerFrame\\UI-Bag-Components"..bagTextureSuffix);
    bgTextureBottom:SetTexture("Interface\ContainerFrame\UI-BackpackBackground");
	
	
	if size == 1 then
		
		local bgTextureTop = getglobal(name.."BackgroundTop");
		local bgTextureMiddle = getglobal(name.."BackgroundMiddle1");
		local bgTextureMiddle2 = getglobal(name.."BackgroundMiddle2");
		local bgTextureBottom = getglobal(name.."BackgroundBottom");
		local bgTexture1Slot = getglobal(name.."Background1Slot");
		
		bgTexture1Slot:Show();
		bgTextureTop:Hide();
		bgTextureMiddle:Hide();
		bgTextureMiddle2:Hide();
		bgTextureBottom:Hide();
		
		frame:SetHeight(70);	
		frame:SetWidth(99);
		getglobal(frame:GetName().."Name"):SetText("");
		--SetBagPortraitTexture(getglobal(frame:GetName().."Portrait"), id);
		local itemButton = getglobal(name.."Item1");
		itemButton:SetID(1);
		itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -10, 5);
		itemButton:Show();

	else
		local bgTextureTop = getglobal(name.."BackgroundTop");
		local bgTextureMiddle = getglobal(name.."BackgroundMiddle1");
		local bgTextureMiddle2 = getglobal(name.."BackgroundMiddle2");
		local bgTextureBottom = getglobal(name.."BackgroundBottom");
		local bgTexture1Slot = getglobal(name.."Background1Slot");
		
		bgTexture1Slot:Hide();
		bgTextureTop:Show();
		--bgTextureMiddle:Hide();
		--bgTextureMiddle2:Hide();
		--bgTextureBottom:Hide();
		-- 
		
		
		local bgTextureCount, height;
		local rowHeight = 41;

		local remainingRows = rows-1;
        
		local isPlusTwoBag;
		if ( mod(size,columns) == 2 ) then
			isPlusTwoBag = 1;
		end

		if ( isPlusTwoBag ) then
			bgTextureTop:SetTexCoord(0, 1, 0.189453125, 0.330078125);
			bgTextureTop:SetHeight(72);
		else
			if ( rows == 1 ) then
				bgTextureTop:SetTexCoord(0, 1, 0.00390625, 0.16796875);
				bgTextureTop:SetHeight(86);
			else
				bgTextureTop:SetTexCoord(0, 1, 0.00390625, 0.18359375);
				bgTextureTop:SetHeight(94);
			end
		end
		bgTextureCount = ceil(remainingRows/ROWS_IN_BG_TEXTURE);
		
		local middleBgHeight = 0;
		if ( rows == 1 ) then
			bgTextureBottom:SetPoint("TOP", bgTextureMiddle:GetName(), "TOP", 0, 0);
			bgTextureBottom:Show();

			for i=1, MAX_BG_TEXTURES do
				getglobal(name.."BackgroundMiddle"..i):Hide();
			end
		else

			local firstRowPixelOffset = 9;
			local firstRowTexCoordOffset = 0.353515625;
			for i=1, bgTextureCount do
				bgTextureMiddle = getglobal(name.."BackgroundMiddle"..i);
				
				if ( remainingRows > ROWS_IN_BG_TEXTURE ) then
					height = ( ROWS_IN_BG_TEXTURE*rowHeight ) + firstRowTexCoordOffset;
					bgTextureMiddle:SetHeight(height);
					bgTextureMiddle:SetTexCoord(0, 1, firstRowTexCoordOffset, ( height/BG_TEXTURE_HEIGHT + firstRowTexCoordOffset) );
					bgTextureMiddle:Show();
					remainingRows = remainingRows - ROWS_IN_BG_TEXTURE;
					middleBgHeight = middleBgHeight + height;
				else
					bgTextureMiddle:Show();
					height = remainingRows*rowHeight-firstRowPixelOffset;
					bgTextureMiddle:SetHeight(height);
					bgTextureMiddle:SetTexCoord(0, 1, firstRowTexCoordOffset, ( height/BG_TEXTURE_HEIGHT + firstRowTexCoordOffset) );
					middleBgHeight = middleBgHeight + height;
				end
				
			end
			-- Position bottom texture
			bgTextureBottom:SetPoint("TOP", bgTextureMiddle:GetName(), "BOTTOM", 0, 0);
			bgTextureBottom:Show();
		end
	
	
		-- Set the frame height
		frame:SetHeight(bgTextureTop:GetHeight()+bgTextureBottom:GetHeight()+middleBgHeight);	
		frame:SetWidth(CONTAINER_WIDTH);
		
		if itemname then
			getglobal(frame:GetName().."Name"):SetText(itemname);
			getglobal(frame:GetName().."Name"):SetJustifyH("CENTER");
		else
			getglobal(frame:GetName().."Name"):SetText("Сундук");
			getglobal(frame:GetName().."Name"):SetJustifyH("CENTER");
		end
	end
	
	frame:SetID(id);
    SetPortraitToTexture(frame:GetName().."Portrait", "Interface\\Icons\\INV_Box_01");
	
	for j=1, size, 1 do
		local index = size - j + 1;
		local itemButton =getglobal(name.."Item"..j);
		itemButton:SetID(j);  --- old: index
		if ( j == 1 ) then
			if ( id == 0 ) then
				itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -12, 30);
			else
				itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -12, 30);
			end
			
		else
			if ( mod((j-1), columns) == 0 ) then
				itemButton:SetPoint("BOTTOMRIGHT", name.."Item"..(j - columns), "TOPRIGHT", 0, 4);	
			else
				itemButton:SetPoint("BOTTOMRIGHT", name.."Item"..(j - 1), "BOTTOMLEFT", -5, 0);	
			end
		end

		local texture, itemCount, locked, quality, readable = GetContainerItemInfo(id, index);
		SetItemButtonTexture(itemButton, texture);
		SetItemButtonCount(itemButton, itemCount);
		SetItemButtonDesaturated(itemButton, locked, 0.5, 0.5, 0.5);

		--[[if ( texture ) then
			ContainerFrame_UpdateCooldown(id, itemButton);
			itemButton.hasItem = 1;
		else
			getglobal(name.."Item"..j.."Cooldown"):Hide();
			itemButton.hasItem = nil;
		end ]]
		
		--itemButton.readable = readable;
		itemButton:Show();
	end
	for j=size + 1, MAX_CONTAINER_ITEMS, 1 do
		getglobal(name.."Item"..j):Hide();
	end
end

PlayerContainerCursorInfo = nil;

function PickupPlayerContainerItem(frame,amount)
    local parent = frame:GetParent();
	local id = parent:GetID();
	local slot = frame.number;
	local data = parent.items[slot];	
	
	if type(data)=="table" then
		if(data.locked == 1) then return end; 
		if parent.items[slot].locked  == true then
			return;
		end
		local temp = {};

		temp.ItemOrigFrame = frame;
		temp.ItemOrigBag = id;
		temp.ItemAmount = amount;
		temp.id = frame.ID;
		
		parent.items[slot].locked = 1;

		PlayerContainerCursorInfo = temp;
        PickupItem(temp.ItemOrigFrame.hyperlink);
		PlayerContainerFrame_Update(parent)
	end
end

function PlacePlayerContainerItem(frame)
    local parent = frame:GetParent();
	if ( parent:GetName() == "PlayerContainerFrame" ) then
        local slot_item = parent.items[frame.number];
        if(PlayerContainerCursorInfo)then
            SendAddonMessage("PLAYER_CONTAINER_MOVE", PlayerContainerCursorInfo.ItemOrigFrame.number.."/b"..frame.number.."/b"..PlayerContainerCursorInfo.ItemAmount, "WHISPER", UnitName("player"))
            PlayerContainerCursorInfo = nil;
        else
            SendAddonMessage("PLAYER_CONTAINER_STORE_FROM_INV", parent.playerBagId.."/b"..parent.playerSlotId.."/b"..frame.number, "WHISPER", UnitName("player"))
            parent.playerBagId = nil;
            parent.playerSlotId = nil;
        end
            
        PlayerContainerFrame_Update(parent);
        ClearCursor();
        
        --[[parent.items[frame.number] = parent.items[PlayerContainerCursorInfo.ItemOrigFrame.number];
        parent.items[frame.number].locked = nil;
        if ( slot_item ) then
            parent.items[PlayerContainerCursorInfo.ItemOrigFrame.number] = slot_item;
        else
            parent.items[PlayerContainerCursorInfo.ItemOrigFrame.number] = nil;
        end
         ]]
    elseif ( string.match(parent:GetName(), "ContainerFrame.-") == "ContainerFrame" ) then        
        if(PlayerContainerCursorInfo)then
            SendAddonMessage("PLAYER_CONTAINER_TAKE", parent:GetID().."/b"..frame:GetID().."/b"..PlayerContainerCursorInfo.ItemOrigFrame.number.."/b"..PlayerContainerCursorInfo.ItemAmount, "WHISPER", UnitName("player"))
            PlayerContainerCursorInfo = nil;
            PlayerContainerFrame_Update(PlayerContainerFrame);
            ClearCursor();
        end
        
        --parent.items[frame.number].locked = nil;
        --PlayerContainerCursorInfo = nil;
        
        
    end
end
