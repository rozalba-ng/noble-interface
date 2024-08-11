
BardAddon = BardAddon or {}
BardAddon.nearSongs = {}
local numButtons = 12
local buttonHeight = 25
local curCategory = 1

SELF_BARD_SONG_ID = 0
local curSongName = ""
local songList = {
	[1] = { name = "Лютня",
			{id = 900007, name = "Лесная фантазия"},
			{id = 900008, name = "Лордеронский ноктюрн"},
			{id = 900009, name = "Луна накрыта флёром"},
			{id = 900010, name = "Ночная дума"},
			{id = 900011, name = "Озорство волшебного дракончика"},
			{id = 900012, name = "Охота"},
			{id = 900013, name = "Последние блики заката"},
			{id = 900014, name = "Расцветающая лёгкость"},
			{id = 900015, name = "Рыцарская тоска"},
			{id = 900016, name = "Сказания Элвинского леса"},
		},
	[2] = { name = "Флейта",
			{id = 900017, name = "Баллада путника"},
			{id = 900018, name = "Как жили предки"},
			{id = 900019, name = "Рассвет в деревне"},
			{id = 900020, name = "Чарующие дали"},
			{id = 900021, name = "В ритме улочек на рынке"},
			{id = 900022, name = "Колыбельная дракона"},
			{id = 900023, name = "Томление девы"},

		},
	[3] = { name = "Шкатулка",
			{id = 900024, name = "Сон вещей ведьмы"},
			{id = 900025, name = "Ужасы Страхвилля"},
			{id = 900026, name = "Соната мертвецов"},
			{id = 900027, name = "Гул из темноты"},
		},
	[4] = { name = "Арфа",
			{id = 900029, name = "Земли Вечной Весны"},
			{id = 900030, name = "Танец дракондора"},
			{id = 900031, name = "Песнь Высокорожденных"},
		},
	[5] = { name = "Колокольчик",
			{id = 900032, name = "День Покрова"},
			{id = 900033, name = "Первые снежинки"},
			{id = 900034, name = "Шкатулка Зимы"},
			{id = 900035, name = "Празднование под омелой"},
		},
	[6] = { name = "Барабан",
			{id = 900036, name = "Боевой раж"},
			{id = 900037, name = "Зов старейшины"},
			{id = 900038, name = "Надвигающаяся буря"},
			{id = 900039, name = "Охота ящера"},
		}
	}


local categoryCount = #songList




local function Kabyak_A4Checking(self, event, msg, author, ...)
	
	local _38, _63 = string.byte(msg, 1, 2)
	if ( _38 == 38 ) and ( _63 == 63 ) then
		local msgType = string.sub(msg, 3,3)
		local songId = string.sub(msg, 4)
		
		if tonumber(msgType) == 0 then
			BardAddon.nearSongs[songId] = true
		end
		if BardAddon.nearSongs[songId] or BardAddon.aio_clientLoaded ~= true then
			return true
		end
		
		BardAddon.nearSongs[songId] = true
		BardAddon.CallToPlayNearBardSong(songId)
		return true
	end
	return false
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", Kabyak_A4Checking)


local MainFrame =  CreateFrame("Frame", "BardAddon_MainFrame", UIParent)
MainFrame:SetWidth(350)
MainFrame:SetHeight(440)
MainFrame:Hide()
MainFrame:SetPoint("CENTER", UIParent, "CENTER")
MainFrame:EnableMouse()
MainFrame:SetMovable(true)
MainFrame:SetFrameStrata("FULLSCREEN_DIALOG")
MainFrame.Background = MainFrame:CreateTexture("ARTWORK")
MainFrame.Background:SetTexture("Interface\\AddOns\\BardAddon\\img\\BardMainFrame.blp")
MainFrame.Background:SetPoint("TOPLEFT","BardAddon_MainFrame")
MainFrame.Background:SetSize(512, 512)
MainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
MainFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
MainFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() self:SetUserPlaced(true) end)
local TopLabel = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--TopLabel:SetFont("Fonts\\MORPHEUS.TTF", 14, "OUTLINE")
TopLabel:SetPoint("TOP",15,-19)
TopLabel:SetText("Мелодии барда")



function BardAddon.ShowInterface()
	if MainFrame:IsShown() then
		MainFrame:Hide()
	else
		MainFrame:Show()
	end
end

data = songList[curCategory]
local function update()

	FauxScrollFrame_Update(scrollFrame,#data,numButtons,buttonHeight)
	for index = 1,numButtons do
		local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
		local button = scrollFrame.buttons[index]
		button.index = offset
		
		if offset<=#data then	
			button:SetText(data[offset].name)
			if (data[offset].id == SELF_BARD_SONG_ID) then
				button:SetText("|cfff28a22"..data[offset].name.."|r")
				
			else
				button:SetText(data[offset].name)
			end
			button:Show()
		else
			button:Hide()
		end
	end
end
local CurSongName = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CurSongName:SetFont("Fonts\\MORPHEUS.TTF", 13, "OUTLINE")
CurSongName:SetPoint("TOP",-50,-49)
CurSongName:SetJustifyH("LEFT")

CurSongName:SetText("Играет:")

local CurSongName2 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CurSongName2:SetPoint("TOP",52,-36)
CurSongName2:SetWidth(150)
CurSongName2:SetHeight(40)
CurSongName2:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
CurSongName2:SetTextColor(255,255,255)	
CurSongName2:SetJustifyH("LEFT")
CurSongName2:SetJustifyV("CENTER")

CurSongName2:SetText(curSongName)
local function GetNameById(id)
	for i =1, #songList do
		for j =1, #songList[i] do
			if songList[i][j].id == id then
				return songList[i][j].name
			end
		end
	end
end

function BardAddon.UpdateInterface()
	if SELF_BARD_SONG_ID ~= 0 then
		CurSongName:Show()
		CurSongName2:Show()
		CurSongName2:SetText(GetNameById(SELF_BARD_SONG_ID))
		StopMusicButton:Show()
	
	else
		CurSongName:Hide()
		CurSongName2:Hide()
		CurSongName2:SetText("")
		StopMusicButton:Hide()
	
	end
	update()
end
local StopMusicButton = CreateFrame("BUTTON", "StopMusicButton", MainFrame, "SecureHandlerClickTemplate");
StopMusicButton:SetNormalTexture("Interface\\BUTTONS\\CancelButton-Up.blp")
StopMusicButton:SetHighlightTexture("Interface/BUTTONS/CancelButton-Highlight")
StopMusicButton:SetPushedTexture("Interface\\BUTTONS\\CancelButton-Down.blp")
StopMusicButton:SetSize(34,34)
StopMusicButton:SetPoint("TOPLEFT",MainFrame,70,-40)	
StopMusicButton:SetScript("OnClick",function(self)
	SELF_BARD_SONG_ID = 0
	BardAddon.StopPlayingSong()
	BardAddon.UpdateInterface()
	update()
  end)
StopMusicButton:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Остановить мелодию")
    GameTooltip:Show()
  end)
 StopMusicButton:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)


local Base_frame = CreateFrame("frame","SongList",MainFrame)
Base_frame:SetSize(350,numButtons*buttonHeight+64)
Base_frame:SetPoint("CENTER", -3, -30)
--Base_frame:SetBackdrop( { bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", insets={left=4,right=4,top=4,bottom=4}, tileSize=16, tile=true, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
Base_frame:SetAlpha(0.9)

scrollFrame = CreateFrame("ScrollFrame","BardAddon_ScrollFrame",Base_frame,"FauxScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT",0,-8)
scrollFrame:SetPoint("BOTTOMRIGHT",-30,8)
scrollFrame:SetScript("OnVerticalScroll",function(self,offset)
  FauxScrollFrame_OnVerticalScroll(self, offset, buttonHeight, update)
end)


scrollFrame.buttons = {}
for i=1,numButtons do
	scrollFrame.buttons[i] = CreateFrame("Button",nil,Base_frame)
	local button = scrollFrame.buttons[i]
	button:SetSize(166,buttonHeight)
	local font  = GameFontHighlightMedium:GetFontObject()
	font:SetJustifyH("LEFT")
	button:SetNormalFontObject(font)
	
	button:SetPoint("TOPLEFT",40,(-(i-1)*buttonHeight-8)-15)
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick",function(self,button)
					SELF_BARD_SONG_ID = data[i].id
					BardAddon.UpdateInterface()
					BardAddon.StartPlayingSong(SELF_BARD_SONG_ID)
					update()
			end)
end

BardAddon.UpdateInterface()
local CategoryNameLabel = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CategoryNameLabel:SetFont("Fonts\\MORPHEUS.TTF", 18, "OUTLINE")
CategoryNameLabel:SetPoint("BOTTOM",0,25)
CategoryNameLabel:SetJustifyH("CENTER")
CategoryNameLabel:SetText(songList[curCategory].name)

local function ChangeCategory(n)
	curCategory = curCategory + n
	if curCategory > categoryCount then
		curCategory = 1
	elseif curCategory < 1 then
		curCategory = categoryCount
	end
	data = songList[curCategory]
	CategoryNameLabel:SetText(songList[curCategory].name)
	update()
end


local NextCategory = CreateFrame("BUTTON", "NextCategory", MainFrame, "SecureHandlerClickTemplate");
NextCategory:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up.blp")
NextCategory:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down.blp")
NextCategory:SetSize(25,25)
NextCategory:SetPoint("BOTTOM",MainFrame,65,19)	
NextCategory:SetScript("OnClick",function(self)
	ChangeCategory(1)
  end)


local PrevCategory = CreateFrame("BUTTON", "PrevCategory", MainFrame, "SecureHandlerClickTemplate");
PrevCategory:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up.blp")
PrevCategory:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down.blp")
PrevCategory:SetSize(25,25)
PrevCategory:SetPoint("BOTTOM",MainFrame,-65,19)	
PrevCategory:SetScript("OnClick",function(self)
	ChangeCategory(-1)
  end)
  
  

local ButtonClose = CreateFrame("BUTTON", "ButtonClose", MainFrame, "SecureHandlerClickTemplate");
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(32,32)
ButtonClose:SetPoint("TOPRIGHT",MainFrame,4,-10)	
ButtonClose:SetScript("OnClick",function(self)
	MainFrame:Hide()
  end)
ButtonClose:SetScript("OnEnter",function(self)
    GameTooltip:SetOwner(self,"ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
  end)
  ButtonClose:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
	end)