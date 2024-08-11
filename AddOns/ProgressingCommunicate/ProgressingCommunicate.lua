
-----Хак оригинальных близзовских функций
local OldUnitClass = UnitClass

function UnitClass(unit)
	if not UnitIsPlayer(unit) then
		return OldUnitClass(unit)
		
	end
	if ServerData then
		if ServerData.players_progressing then
			if ServerData.players_progressing[UnitName(unit)] then
				local class_name =ServerData.players_progressing[UnitName(unit)].class_name
				return class_name,class_name,class_name
			end
		else
			return -1
		end
	else
		return -1
	end


end

local OldGetRaidRosterInfo = GetRaidRosterInfo

local CurrentMana = UnitMana('player')


local OldUnitPower = UnitPower
function UnitPower(unit,id)

	if unit == 'player' and id == 0 then
		local aura = UnitAura("player", "В PvP бою") 
		if aura then
			return CurrentMana
		else
			return OldUnitPower(unit,id)
		end
	else
		return OldUnitPower(unit,id)
	end

end
function GetRaidRosterInfo(data)
	local name, rank, subgroup, level, class, fileName, zone, online, isDead, role = OldGetRaidRosterInfo(data);
	level,class = GetLevelClassData(name)
	return name, rank, subgroup, level, class, fileName, zone, online, isDead, role
end

local OldGetWhoInfo = GetWhoInfo
function GetWhoInfo(whoIndex)
	local name, guild, level, race, class, zone, classFileName = OldGetWhoInfo(whoIndex);
	level,class = GetLevelClassData(name)
	return name, guild, level, race, class, zone, classFileName
end
local OldGetGuildRosterInfo = GetGuildRosterInfo
function GetGuildRosterInfo(guid)
	local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = OldGetGuildRosterInfo(guid)
	level,class = GetLevelClassData(name)
	return name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName
end
local OldGetFriendInfo = GetFriendInfo
function GetFriendInfo(id)
	local name, level, class, area, connected, status, note = OldGetFriendInfo(id);
	level,class_ = GetLevelClassData(name)
	return name, level, class, area, connected, status, note
end
local OldBNGetToonInfo = BNGetToonInfo
function BNGetToonInfo(id)
	local hasFocus, toonName, client, realmName, faction, race, class, guild, zoneName, level, gameText = OldBNGetToonInfo(id);
	level,class = GetLevelClassData(name)
	return hasFocus, toonName, client, realmName, faction, race, class, guild, zoneName, level, gameText
end

local OldBNGetFriendToonInfo = BNGetFriendToonInfo
function BNGetFriendToonInfo(id,i)
	local hasFocus, toonName, client, realmName, faction, race, class, guild, zoneName, level, gameText = OldBNGetFriendToonInfo(id,i);
	level,class = GetLevelClassData(name)
	return hasFocus, toonName, client, realmName, faction, race, class, guild, zoneName, level, gameText
end




ProgressingData = ProgressingData or {}



local ProgressCommunicate = AIO.AddHandlers("ProgressCommunicate", {})
function ProgressCommunicate.UpdateClientProgressData(player)
	PlayerFrame_Update()
end

function ProgressCommunicate.UpdateCurrentMana(player,value)
	CurrentMana = value
end



function ProgressCommunicate.UpdateXPBar(player,currentXP)
	ProgressingData.char_xp = currentXP
	UpdateXPBar()
end
function ProgressCommunicate.UpdateXPReqs(player,new_xp_table)
	ProgressingData.xp_table = new_xp_table
	UpdateXPBar()
end



function ProgressCommunicate.OnLevelUp(player)
	PlaySound("LEVELUPSOUND")
end

function CallXPTable()
	AIO.Handle("ProgressCommunicate","CallXPTable")
end


local OldUnitXPMax = UnitXPMax
function UnitXPMax(unit)
	local name = UnitName(unit)
	local currentLevel = UnitLevel(unit)
	if ProgressingData.xp_table then
		return ProgressingData.xp_table[currentLevel+1]
	else
		CallXPTable()
		return 1
	end
end
local function split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end
local classDescription = {
	["Воитель.Воительница"] = "Боец ближнего боя, за счет своего здоровья фокусирующий на\nнанесении урона одной или нескольким целям мощными ударами. \nОсновные характеристики: Сила.",
	["Убийца"] = "Боец ближнего боя, скрывающийся в тенях, для нанесения подлых\nи точных ударов уязвимым целям.\nОсновные характеристики: Ловкость.",
	["Защитник.Защитница"] = "Cтойкий боец, использующий технику щита и меча\nдля силовых атак и защиты своих союзников.\nОсновные характеристики: Физическая броня, Сила.",
	["Стрелок"] = "Боец дальнего боя, специализирующий на нанесении урона на расстоянии.\nУлучшает свои атаки различными снарядами, дающие эффекты в бою. \nОсновные характеристики: Ловкость",
	["Арканист.Арканистка"] = "Маг, пользующийся секретами тайной магии, обрушивая град атакующих и контролирующих заклинаний.\nНакапливает свою энергию, для более гибкого использования способностей. \nОсновные характеристики: Интеллект",
	["Колдун.Колдунья"] = "Маг, использующий свою жизненную силу для нанесения урона\nи накладывания негативных проклятий. \nОсновные характеристики: Интеллект.",
	["Культист.Культистка"] = "Ритуалист, который может положительно и негативно влиять на\nобе стороны боя, накладывая и снимая различные эффекты с целей, исцеляя\n и нанося урон от сил тьмы. \nОсновные характеристики: Дух.",
	["Целитель.Целительница"] = "Магический лекарь, специализирующий на поддержании\nи исцелении союзников. \nОсновные характеристики: Дух.",
	["Паладин.Паладинша"] = "Рыцарь, использующий силу Света для уничтожения Зла, направляя все силы для.\nИспользует накопленные печати, для активации особо мощных способностей. \nОсновные характеристики: Сила, Дух.",
	["Механик"] = "Инженер, специализирующий на высокотехнологичных приборах, наносящих урон\nодной или нескольким целям в дальнем бою. Также спокойно может поддерживать союзников и сдерживать врагов своими\nэкспериментальными приборами.\nОсновные характеристики: Ловкость, Интеллект.",
	["Авантюрист.Авантюристка"] = "Хитрый боец ближнего боя, не стесняющийся использовать грязные приемы\nдля того чтобы разобраться с противником или же избежать боя с ним. \nОсновные характеристики: Ловкость.",
}
local function OnClassButtonEnter(self, motion)
	for classNamePair, text in pairs(classDescription) do
		for i,className in ipairs(split(classNamePair,".")) do
			if self:GetText() == className then
				GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
				GameTooltip:AddLine(className)
				GameTooltip:AddLine(text)
				GameTooltip:Show()
			
			end
		end
	end

end




for i=1,11 do
	local button = _G["GossipTitleButton"..i]:SetScript("OnEnter",OnClassButtonEnter)
	local button = _G["GossipTitleButton"..i]:SetScript("OnLeave",function() GameTooltip:Hide() end)
end

NEWBIE_TOOLTIP_XPBAR = 'Количество полученного опыта. Опыт начисляется за различную ролевую активность, добычу ресурсов и победу над врагами.'

-----------------------------


local ClassNames = {
	[0] = {m = "Тестовый",f = "Тестовая"},
	[1] = {m = "Проверочный",f = "Проверочная"},
}



local OldUnitXP = UnitXP
function UnitXP(unit)
	if ProgressingData.char_xp then
		return ProgressingData.char_xp
	else
		return 0
	end
end
function GetLevelClassData(name)
	level = 1
	class = "Без класса"
	if ServerData and ServerData.players_progressing and ServerData.players_progressing[name] then
		if ServerData.players_progressing[name].level then
			level = ServerData.players_progressing[name].level
		end
		if ServerData.players_progressing[name].class_name then
			class = ServerData.players_progressing[name].class_name
		end
	end
	return level, class
end

function UpdateXPBar()
	MainMenuExpBar_Update()
	MainMenuExpBar:Show()

end

function IsXPUserDisabled()
	return false
end

local EventRegisterFrame = CreateFrame("Frame")
EventRegisterFrame:RegisterEvent("ADDON_LOADED")
function EventRegisterFrame:OnEvent(event, arg1,arg2,arg3)
	if event == "ADDON_LOADED" and arg1 == "ProgressingCommunicate" then
		PlayerFrame_Update()
		UpdateXPBar()
		if not ProgressingData.xp_table then
			CallXPTable()
			
			UpdateXPBar()
		end
	end
end
EventRegisterFrame:SetScript("OnEvent", EventRegisterFrame.OnEvent);
