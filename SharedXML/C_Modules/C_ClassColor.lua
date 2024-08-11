------------
--// Modified by: Harusha aka Hestia
------------
C_ClassColor = {}

local RAID_CLASS_COLORS = {
	["HUNTER"] = {0.67, 0.83, 0.45, 1},  -- "ffabd473"
	["WARLOCK"] = {0.53, 0.53, 0.93, 1},  -- "ff8788ee"
	["PRIEST"] = {1.0, 1.0, 1.0, 1},  -- "ffffffff"
	["PALADIN"] = {0.96, 0.55, 0.73, 1},  -- "fff58cba"
	["MAGE"] = {0.25, 0.78, 0.92, 1},  -- "ff3fc7eb"
	["ROGUE"] = {1.0, 0.96, 0.41, 1},  -- "fffff569"
	["DRUID"] = {1.0, 0.49, 0.04, 1},  -- "ffff7d0a"
	["SHAMAN"] = {0.0, 0.44, 0.87, 1},  -- "ff0070de"
	["WARRIOR"] = {0.78, 0.61, 0.43, 1},  -- "ffc79c6e"
	["DEATHKNIGHT"] = {0.77, 0.12 , 0.23, 1},  -- "ffc41f3b"
	["MONK"] = {0.0, 1.00 , 0.59, 1},  -- "ff00ff96"
	["DEMONHUNTER"] = {0.64, 0.19, 0.79, 1},  -- "ffa330c9"
};

function C_ClassColor:GetClassColor(className)
	if RAID_CLASS_COLORS[className] then
		return CreateColor(RAID_CLASS_COLORS[className][1], RAID_CLASS_COLORS[className][2], RAID_CLASS_COLORS[className][3], RAID_CLASS_COLORS[className][4])
	end
end