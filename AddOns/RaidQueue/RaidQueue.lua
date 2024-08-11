--[[ 

 @    @@        @@@      &@     @@      @@  @@@@@@&        /@#    @@      @@   @
 @    @(@      @@@@     @@ @     %@    @@   @@     @@     /@ @/    ,@*   @@    @
 @    @ *@    @@ @@    @@   @      @@#@     @@      @&   ,@   @/     @@ @.     @
 @    @. .@  @@  @@   #@%%%%%@      @@      @@      @*   @%%%%%@*     @@       @
 @    @.   @@@   @@  (@      ,@     @@      @@    @@*  .@       @.    @@       @
 
--]]

-- RaidQueue

function GetRandomSelection(t, howMany)
	local result = {}
	for i = 1, howMany do
		local r = t[math.random(1, #t)]
		while tIndexOf(result, r) ~= nil do
			r = t[math.random(1, #t)]
		end
		table.insert(result, r)
	end
	return result
end

function PrintRandomMembersOrder()
	local ChatChannel = ""
	local raidlist = {}
	raidmembers = GetNumRaidMembers()
	partymembers = GetNumPartyMembers()
	if (raidmembers > 0) then
		for i = 1, raidmembers do
			name, rank = GetRaidRosterInfo(i)
			if (rank == 0) then
				table.insert(raidlist, name)
			end
		end
		ChatChannel = "RAID"
	else
		for i = 1, partymembers do
			name, rank = GetGroupRosterInfo(i)
			if (rank == 0) then
				table.insert(raidlist, name)
			end
		end
		ChatChannel = "PARTY"
	end
	local randomOrder = GetRandomSelection(raidlist, #raidlist)
	SendChatMessage("Ход игроков: " ..table.concat(randomOrder, ", ").. ".", ChatChannel, null, null)
end

SLASH_RAIDQUEUECOMMAND1 = "/rq"
SlashCmdList["RAIDQUEUECOMMAND"] = PrintRandomMembersOrder

-- Инициатива

-- Таблица значений игроков
local playerResults = {}

local function OnEvent(_, _, message, sender)
    local playerName, rollResult = message:match("^Специальное %(инициатива%) действие (.+)%. Результат: (%d+) %((%d+)%+(%d+)%)$")
    if playerName and rollResult then
        local result = tonumber(rollResult)
        if result then
            -- Если результат уже существует для игрока, перезаписываем его
            if playerResults[playerName] then
                playerResults[playerName] = result
            else
                -- Если результата нет, добавляем его в таблицу
                playerResults[playerName] = result
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", OnEvent)

local function Init()
    local sortedPlayers = {}
    for player, _ in pairs(playerResults) do
        table.insert(sortedPlayers, player)
    end

    -- Сортировка игроков
    table.sort(sortedPlayers, function(a, b)
        return (playerResults[a] or 0) > (playerResults[b] or 0)
    end)

    if #sortedPlayers > 0 then
        local output = table.concat(sortedPlayers, ", ")
        SendChatMessage("Ход игроков: " ..output.. ".", "RAID", null, null)
    else
        print("Никто не бросил инициативу.")
    end

	-- Очистка результатов после вывода
    wipe(playerResults)
end

SLASH_INITROLL1 = "/init"
SlashCmdList["INITROLL"] = Init

