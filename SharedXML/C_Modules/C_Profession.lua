------------
--// Modified by: Harusha
------------

C_Profession = {}


local C_Proff = {}
C_Proff.AllSpells = {}
C_Proff.ButtonData = {}
C_Proff.Cooldown = 0
C_Proff.Page = 1
C_Proff.Mod = 0
C_Proff.LeftButtonData ={
["Выплавка металлов"] = {"Поиск минералов", 0, 0, 0, 0},			
["Травничество"] = {"Поиск трав", 0, 0, 0, 0},
}

C_Proff.ValidProfessions ={
"Инженерное дело",
"Кожевничество",
"Портняжное дело",
"Алхимия",
"Кузнечное дело",
"Ювелирное дело",
"Наложение чар",
"Начертание",
"Горное дело",
"Травничество",
"Кулинария",
"Рыбная ловля",
"Первая помощь",
"Плотничество",
"Снятие шкур",
"Выплавка металлов"
}

local AbrTable
local ProfFrame

---------------------------------------------///
--///            Other funcs
---------------------------------------------///


---------------------------------------------///
--///         All Spells Index Table
---------------------------------------------///

function C_Profession:CreateSpellTable()
wipe(C_Proff.AllSpells)
i = 1
	while true do
	   local spell, rank = GetSpellName(i, "spell")
	   if (not spell) then
		  break
	   end
	   table.insert(C_Proff.AllSpells, tostring(spell))
	   i = i + 1
	end
end


---------------------------------------------///
--///            Cash Table SkillRank
---------------------------------------------///

C_Proff.SkillRank = {}
function C_Profession:CreateSkillRankTable()
wipe(C_Proff.SkillRank)
for skillIndex = 1, GetNumSkillLines() do
  local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,
    skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType,
    skillDescription = GetSkillLineInfo(skillIndex)
  if not isHeader then
	 C_Proff.SkillRank[skillName] = {skillRank, skillMaxRank}
  end
end
end

function C_Profession:GetSkillRank(skillName)
if not C_Proff.SkillRank[skillName] and skillName ~= "Выплавка металлов" then print("Error: skillRank not found.") return end
	if skillName == "Выплавка металлов" then
		return C_Proff.SkillRank["Горное дело"][1]
	else
		return C_Proff.SkillRank[skillName][1]
	end
end

function C_Profession:GetSkillMaxRank(skillName)
if not C_Proff.SkillRank[skillName] and skillName ~= "Выплавка металлов" then print("Error: skillRank not found.") return end
	if skillName == "Выплавка металлов" then
		return C_Proff.SkillRank["Горное дело"][2]
	else
		return C_Proff.SkillRank[skillName][2]
	end
end

---------------------------------------------///
--///            Cash Table ButtonData
---------------------------------------------///

function C_Profession:CreateProfessionTable()
self:CreateSpellTable()
self:CreateSkillRankTable()
wipe(C_Proff.ButtonData)
k = 1
for i = 1, #C_Proff.AllSpells do
	if tContains(C_Proff.ValidProfessions, C_Proff.AllSpells[i]) then
		C_Proff.ButtonData["SecondaryProfession" .. k .. "SpellButtonRight"] = {
			C_Proff.AllSpells[i], -- Name
			self:GetSkillRank(C_Proff.AllSpells[i]) .. "/" .. self:GetSkillMaxRank(C_Proff.AllSpells[i]), -- SkillRank ex 1/75
			select(2, GetSpellName(i, "spell")), -- SkillRank Text ex Ученик
			i, -- Skill Index
			select(3, GetSpellInfo(C_Proff.AllSpells[i])), -- Icon
			select(1, GetSpellInfo(C_Proff.AllSpells[i])),  -- Name
			self:GetSkillRank(C_Proff.AllSpells[i]), -- Skill Rank
			self:GetSkillMaxRank(C_Proff.AllSpells[i]), -- Max Skill Rank
		}
		k = k + 1
	end
end
end


function C_Profession:UpdateAdditionalProfessionsTable()
	for k,v in pairs(C_Proff.LeftButtonData) do
		v[4] = tIndexOf(C_Proff.AllSpells, v[1])
		v[5] = select(3,GetSpellInfo(v[1]))
	end
end
---------------------------------------------///
--///            Buttons set funs
---------------------------------------------///



function C_Profession:SetProfessions()
	for i=1,7 do
		if C_Proff.Page == 1 then C_Proff.Mod = 0 else C_Proff.Mod = 7 end
		if C_Proff.ButtonData["SecondaryProfession" .. i+C_Proff.Mod .. "SpellButtonRight"] then
			ProfFrame = _G["SecondaryProfession" .. i]
			AbrTable = C_Proff.ButtonData["SecondaryProfession" .. i+C_Proff.Mod .. "SpellButtonRight"]
			if C_Proff.Page == 2 then C_Proff.ButtonData["SecondaryProfession" .. i .. "SpellButtonRight"] = C_Proff.ButtonData["SecondaryProfession" .. i+7 .. "SpellButtonRight"] end
			-- Нужно перезаписывать таблицу на позиции более ранние +7
			
			ProfFrame:Show()
			ProfFrame.button1.spellIcon:SetTexture(AbrTable[5])
			ProfFrame.button1.spellString:SetText(AbrTable[6])
			
			if AbrTable[1] == "Выплавка металлов" then
				ProfFrame.professionName:SetText("Горное дело")
			else
				ProfFrame.professionName:SetText(AbrTable[1])
			end
			ProfFrame.rank:SetText(AbrTable[3])
			
			ProfFrame.statusBar:SetMinMaxValues(1, AbrTable[8]);
			ProfFrame.statusBar:SetValue(AbrTable[7]);
			if AbrTable[7] == AbrTable[8] then
				ProfFrame.statusBar.capRight:Show();
			else
				ProfFrame.statusBar.capRight:Hide();
			end
			ProfFrame.statusBar.rankText:SetText(AbrTable[2])
			
			self:SetAdditionalProfessions(AbrTable[1], i)
		else
			_G["SecondaryProfession" .. i]:Hide()
		end
	end
end


function C_Profession:SetAdditionalProfessions(proff, index)
	if C_Proff.LeftButtonData[proff] then
		C_Proff.ButtonData["SecondaryProfession" .. index .. "SpellButtonLeft"] = C_Proff.LeftButtonData[proff]
		ProfFrame2 = _G["SecondaryProfession" .. index]
		ProfFrame2.button2.spellIcon:SetTexture(C_Proff.ButtonData["SecondaryProfession" .. index .. "SpellButtonLeft"][5])
		ProfFrame2.button2.spellString:SetText(C_Proff.ButtonData["SecondaryProfession" .. index .. "SpellButtonLeft"][1])
		ProfFrame2.button2.subSpellString:SetText(nil)
		
		_G["SecondaryProfession" .. index .. "SpellButtonLeft"]:Show()
	else
		C_Proff.ButtonData["SecondaryProfession" .. index .. "SpellButtonLeft"] = nil
		_G["SecondaryProfession" .. index .. "SpellButtonLeft"]:Hide()
	end
end


function C_Profession:UpdateProfessionsSpells()
	if (C_Proff.Cooldown + 1) < GetTime() then
		self:CreateProfessionTable()
		self:UpdateAdditionalProfessionsTable()
		C_Proff.Cooldown = GetTime();
	end
self:SetProfessions()
end

function C_Profession:ForceUpdateProfessionsSpells(page)
C_Profession:SetProfessions()
C_Proff.Page = tonumber(page)
self:CreateProfessionTable()
self:UpdateAdditionalProfessionsTable()
self:SetProfessions()
end

---------------------------------------------///
--///            SpellBook Scripts
---------------------------------------------///


function C_Profession:GetProfessionIndex(name)
	if not C_Proff.ButtonData[name] then
		return false
	else
		return tonumber(C_Proff.ButtonData[name][4])
	end
end

function C_Profession:HasSecondPage()
	if not C_Proff.ButtonData["SecondaryProfession8SpellButtonRight"] then
		return false
	else
		return true
	end
end



