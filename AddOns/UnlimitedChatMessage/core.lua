-- GLOBAL --
UCM = select(2, ...); 
-- MODULE --
local _G = getfenv(0);
setmetatable(UCM, {__index = _G});
setfenv(1, UCM);
-- LOCAL --
title		= "UnlimitedChatMessage"
folder		= title;
version		= GetAddOnMetadata(folder, "X-Curse-Packaged-Version") or "";
titleFull	= title.." "..version

coreFrame = CreateFrame("Frame");
core	= LibStub("AceAddon-3.0"):NewAddon(coreFrame, title, "AceConsole-3.0", "AceHook-3.0") -- 
local L = LibStub("AceLocale-3.0"):GetLocale(title, true)
local P; --db.profile

-- Don't touch these.
defaultMaxLetters = 255;--blizzard's default limit.
defaultMaxBytes = 256;
queuedOutgoingMsgs = {};
warnTooManyMsgs = 10; --ChatThrottleLib pauses every 10 messages for 10 seconds to prevent disconnect.
tabSpaces = "    ";
tempMultiLine = false;

--Default Settings
db				= {};
defaultSettings	= {profile = {}}
defaultSettings.profile.confirmLongMsgs = true
--~ defaultSettings.profile.multiLines = false
defaultSettings.profile.slashMultiLine = true

--Globals
local table_getn 		= _G.table.getn;
local table_insert 		= _G.table.insert;
local tostring_ 		= _G.tostring;
local tonumber_ 		= _G.tonumber;
local StaticPopup_Show_	= _G.StaticPopup_Show;
local strsplit_ 		= _G.strsplit;


--	/script print(DEFAULT_CHAT_FRAME.editBoxGetFrameStrata())

-- Ace3 Functions
function core:OnInitialize()
	if _G.AddonLoader then
		if _G.AddonLoader.RemoveInterfaceOptions then
			_G.AddonLoader:RemoveInterfaceOptions("UCM")
		end
		
		_G["SLASH_UCM1"] = nil 
		_G.SlashCmdList["UCM"] = nil
		_G.hash_SlashCmdList["/ucm"] = nil
	end

	db = LibStub("AceDB-3.0"):New("UCM_DB", defaultSettings, true)
	CoreOptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)--save option profile or load another chars opts.
	db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")
	core:RegisterChatCommand("ucm", "MySlashProcessorFunc")

	local config = LibStub("AceConfig-3.0");
	local dialog = LibStub("AceConfigDialog-3.0");
	config:RegisterOptionsTable(title, CoreOptionsTable)
	coreOpts = dialog:AddToBlizOptions(title, "UCM "..version)
end


----------------------------------------------
function core:MySlashProcessorFunc(input)	--
-- /da function brings up the UI options.	--
----------------------------------------------
	InterfaceOptionsFrame_OpenToCategory(coreOpts)
end

function core:OnEnable()
	P = db.profile;
	
	self:RawHook("SendChatMessage", true)

--~ 	self:HookScript(editBox, "OnHide", "OnHide")
	self:Hook("ChatEdit_OnTextChanged", true)
	local editBox			= _G.DEFAULT_CHAT_FRAME.editBox
	
	defaultMaxLetters = editBox:GetMaxLetters()
	defaultMaxBytes = editBox:GetMaxBytes()
	
--~ 	editBox:SetMaxLetters(0)--0=unlimited
--~ 	editBox:SetMaxBytes(0)--0=unlimited
	
	self:CallHandler("SetMaxLetters", 0)
	self:CallHandler("SetMaxBytes", 0)
	

	
	self:HookSetAttribute()
end

function core:HookSetAttribute()
	local editBox
	for i=1, NUM_CHAT_WINDOWS do 
		editBox = _G["ChatFrame"..i.."EditBox"]
		self:SecureHook(editBox, "SetAttribute")
	end
end


function core:HookOnHide()
	local editBox
	for i=1, NUM_CHAT_WINDOWS do 
		editBox = _G["ChatFrame"..i.."EditBox"]
		self:HookScript(editBox, "OnHide", "OnHide")
	end
end


function core:CallHandler(handler, ...)
	local editBox
	for i=1, NUM_CHAT_WINDOWS do 
		editBox = _G["ChatFrame"..i.."EditBox"]
		editBox[handler](editBox, ...)
	end
end

function core:SetAttribute(frame, attribute, value)
	if attribute == "chatType" then
		if value:find("BN_") then --BN_CONVERSATION, BN_WHISPER
			frame:SetMaxLetters(defaultMaxLetters)
			frame:SetMaxBytes(defaultMaxBytes)
--~ 			print("SetAttribute A", attribute, value, "|| Setting default limits")
		else
			frame:SetMaxLetters(0)--0=unlimited
			frame:SetMaxBytes(0)--0=unlimited
--~ 			print("SetAttribute B", attribute, value, "|| Setting to unlimited")
		end
	end
end

function core:ChatEdit_OnTextChanged(...)
	local this, userInput = ...;
	local text = this:GetText();

	
	if userInput then
		if P.slashMultiLine == true then
			if text:len() > 0 and text:lower() == "/ml " then
				print(L["Editbox temporarily set to multiline."]);
				tempMultiLine = true;
				this:SetMultiLine(true)
				this:SetText("");
				return;
			end
		end
	else
		if this:IsMultiLine() and tempMultiLine == false then
			this:SetMultiLine(false)
		end
	end
end

function core:OnHide(this)
	tempMultiLine = false;
end

--[[
0
	1
		2
			3
				4
					5
					
#####
#   #
# # #
#   #
#####
]]

----------------------------------------------------------------------
function core:OnProfileChanged(...)									--
-- User has reset proflie, so we reset our spell exists options.	--
----------------------------------------------------------------------
	-- Shut down anything left from previous settings
	self:Disable()
	-- Enable again with the new settings
	self:Enable()
end

function core:OnDisable()
	--return chatbox maxs to defaults.
--~ 	editBox:SetMaxLetters(defaultMaxLetters)
--~ 	editBox:SetMaxBytes(defaultMaxBytes)
	
	self:CallHandler("SetMaxLetters", defaultMaxLetters)
	self:CallHandler("SetMaxBytes", defaultMaxBytes)
	
	--reset editbox to be single line.
--~ 	editBox:SetMultiLine(false)
	self:CallHandler("SetMultiLine", false)
end

------------------------------------------------------------------
function core:SendChatMessage(...)								--
-- Our hook to SendChatMessage. If msg is too long we split it.	--
------------------------------------------------------------------
	local msg, chatType ,language ,channel = ...;
	if msg:find("\n") then --P.multiLines == true and 
		local tSplit = { strsplit_("\n", msg) }
		local chunks = {};
		local tmpChunks = {};
		for i= 1, table_getn(tSplit) do 
			tmpChunks = SplitIntoChunks(tSplit[i])
			for o=1, table_getn(tmpChunks) do 
				table_insert(chunks, tmpChunks[o])
			end
		end
		
		if table_getn(chunks) > warnTooManyMsgs and P.confirmLongMsgs == true then
			for i=1, table_getn(chunks) do 
				table_insert(queuedOutgoingMsgs, {msg=chunks[i], chatType=chatType, language=language, channel=channel})
			end
			StaticPopup_Show_("UCM_CONFIRMMSG");
		else
			for i=1, table_getn(chunks) do 
				_G.ChatThrottleLib:SendChatMessage("ALERT", "UCM", chunks[i], chatType, language, channel);
			end
		end

		return;
	elseif msg:len() > defaultMaxLetters then
		local chunks = SplitIntoChunks(msg)

		--P.confirmLongMsgs
		if table_getn(chunks) > warnTooManyMsgs and P.confirmLongMsgs == true then
			for i=1, table_getn(chunks) do 
				table_insert(queuedOutgoingMsgs, {msg=chunks[i], chatType=chatType, language=language, channel=channel})
			end
			StaticPopup_Show_("UCM_CONFIRMMSG");
		else
			for i=1, table_getn(chunks) do 
				_G.ChatThrottleLib:SendChatMessage("ALERT", "UCM", chunks[i], chatType, language, channel);
			end
		end
		return;
	end

	core.hooks.SendChatMessage(...)
end


function paddString(str, paddingChar, minLength, paddRight)
    str = tostring_(str or "");
    paddingChar = tostring_(paddingChar or " ");
    minLength = tonumber_(minLength or 0);
    while(str:len() < minLength) do
        if(paddRight) then
            str = str..paddingChar;
        else
            str = paddingChar..str;
        end
    end
    return str;
end




function SplitIntoChunks(longMsg)
	local splitMessageLinks = {};
	
	--Replace links with long strings of zeroes.
	longMsg, results = longMsg:gsub( "(|H[^|]+|h[^|]+|h)", function(theLink)
			table_insert(splitMessageLinks, theLink);
			return "\001\002"..paddString(#splitMessageLinks, "0", theLink:len()-4).."\003\004";
	end);
	
	--WoW replaces tabs with 4 spaces, lets replace 4 spaces with '$tab' so that our splitting of words doesn't remove the tab spaces.
	if longMsg:find(tabSpaces) then
		while longMsg:find(tabSpaces) do
			longMsg = longMsg:gsub(tabSpaces, "$tab");
		end
	end
	
	local words = {}
	for v in longMsg:gmatch("[^ ]+") do
		--Check if 'word' is longer then 254 characters. (wtf?) anyway split long string at the 254 char mark.
		if v:len() > defaultMaxLetters then
			local shortPart, remainingPart = nil, v;
			local i=1;
			while remainingPart and remainingPart:len() > 0 do
				shortPart, remainingPart = GetShorterString(remainingPart);
				if shortPart and shortPart ~= "" then
					table_insert(words, shortPart)
				end
				
				if i>10 then break; end
				i=i+1;
			end
		else
			table_insert(words, v)
		end
	end

	local temp = "";
	local chunks = {}
	for i=1, table_getn(words) do 
		if temp:len() + words[i]:len() <= (defaultMaxLetters - 1) then
			if temp:len() > 0 then
				temp = temp.." "..words[i];
			else
				temp = words[i];
			end
			
		else
			temp = temp:gsub("\001\002%d+\003\004", function(link)
				local index = tonumber_(link:match("(%d+)"));
				return splitMessageLinks[index] or link;
			end);
			
			if temp:find("$tab") then
				while temp:find("$tab") do
					temp = temp:gsub("$tab", tabSpaces);
				end
			end
			
			table_insert(chunks, temp);
			temp = words[i];
		end
	end

	if temp:len() > 0 then
		temp = temp:gsub("\001\002%d+\003\004", function(link)
			local index = tonumber_(link:match("(%d+)"));
			return splitMessageLinks[index] or link;
		end);
		
		if temp:find("$tab") then
			while temp:find("$tab") do
				temp = temp:gsub("$tab", tabSpaces);
			end
		end
			
		table_insert(chunks, temp);
	end

	return chunks;
end

------------------------------------------------------------------------------------------
function GetShorterString(longMsg)														--
-- Used to split msgs from their spaces, now only used to split msgs with no spaces. =/	--
------------------------------------------------------------------------------------------
--~ 	local max = defaultMaxLetters;
--~ 	if max > longMsg:len() then
--~ 		max = longMsg:len()
--~ 	end
--~ 	
--~ 	if string.find(string.sub(longMsg, 1, max), " ") then
--~ 		for i=max, 1, -1 do 
--~ 			if string.sub(longMsg, i, i) == " " then
--~ 				local shortPart = string.sub(longMsg, 1, i-1);
--~ 				local remainingPart = string.sub(longMsg, i+1, longMsg:len());
--~ 				return shortPart, remainingPart;
--~ 			end
--~ 		end
--~ 	end
	
	local shortText = longMsg:sub(1, defaultMaxLetters-1)
	local remainingPart = longMsg:sub(defaultMaxLetters, longMsg:len())
	return shortText, remainingPart;
end

_G.StaticPopupDialogs["UCM_CONFIRMMSG"] = {
	text = "Send long msg?",
	button1 = YES,
	button2 = NO,
	OnAccept = function(this)
		for i=1, table_getn(queuedOutgoingMsgs) do 
			_G.ChatThrottleLib:SendChatMessage("BULK", "UCM", queuedOutgoingMsgs[i].msg, queuedOutgoingMsgs[i].chatType, queuedOutgoingMsgs[i].language, queuedOutgoingMsgs[i].channel);
		end
	end,
	
	OnHide = function(this)
		queuedOutgoingMsgs = {};
	end,
	OnShow = function(this)
		this.text:SetText(L["Your message will be split into %d parts.\nTo prevent flood disconnection, your outgoing messages may pause every 10 lines.\nContinue?"]:format(table_getn(queuedOutgoingMsgs)))
	end,
	timeout = 0,
	hideOnEscape = 1,
};

function histoyTest()--	/script UCM.histoyTest()
	print("GetHistoryLines", editBox:GetHistoryLines())
	print("GetAltArrowKeyMode", editBox:GetAltArrowKeyMode())
	print("IsKeyboardEnabled", editBox:IsKeyboardEnabled())
	--/script print(DEFAULT_CHAT_FRAME.editBox:IsKeyboardEnabled())
end

----------------
--     UI     --
----------------
CoreOptionsTable = {
	name = titleFull,
	type = "group",
	childGroups = "tab",

	args = {
		core={
			name = L["Core"],
			type = "group",
			order = 1,
			args={}
		},
	},
}

CoreOptionsTable.args.core.args.enable = {
	type = "toggle",	order	= 1,
	name	= L["Enable"],
	desc	= L["Enables / Disables the addon"],
	set = function(info,val) 
		if val == true then
			core:Enable();
		else
			core:Disable();
		end
	end,
	get = function(info) return core:IsEnabled() end
}

CoreOptionsTable.args.core.args.confirmLongMsgs = {
	type = "toggle",	order	= 2,
	name = L["Confirm Long Messages"],	
	desc = L["Show a confirm window when splitting message into %d+ lines."]:format(warnTooManyMsgs),
	set = function(info,val) 
		P.confirmLongMsgs = val;
	end,
	get = function(info) return P.confirmLongMsgs end
}

--[[
CoreOptionsTable.args.core.args.multiLines = {
	type = "toggle",	order	= 3,
	name = L["Multi-line support"],	
	desc = L["Permanently set chatbox to be multi-line, then send each new line as it's own message.\nNote this breaks chat history (alt+up)."],
	set = function(info,val) 
		P.multiLines = val;
		core:CallHandler("SetMultiLine", val)
		if val == true then
			print(L["Please note, enabing 'multi-line support' breaks the chatbox's previous message history (alt+up)."])
		end
	end,
	get = function(info) return P.multiLines end
}]]

CoreOptionsTable.args.core.args.slashMultiLine = {
	type = "toggle",	order	= 4,
	name = L["/ml temp multi-line"],	
	desc = L["Typing /ml temporarily sets chatbox to multi-line."],
	set = function(info,val) 
		P.slashMultiLine = val;
	end,
	get = function(info) return P.slashMultiLine end
}
