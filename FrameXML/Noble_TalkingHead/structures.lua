--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)

local EXCLAME_ID = "64";
local QUESTION_ID = "65";
local TALK_ID = "60";
local YES_ID = "185";
local NOPE_ID = "186";
local ACLAIM_ID = "76"; ---68

ANIMATION_SEQUENCE_DURATION = {
	-- NIGHT ELVES
	["character\\nightelf\\female\\nightelffemale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.9,
		[NOPE_ID] = 1.5,
		[ACLAIM_ID] = 2.4,
	},
	["character\\nightelf\\male\\nightelfmale.m2"] = {
		[TALK_ID] = 1.900,
		[EXCLAME_ID] = 1.9,
		[QUESTION_ID] = 1.900,
		[YES_ID] = 1.1,
		[NOPE_ID] = 1.3,
		[ACLAIM_ID] = 2,
	},
	-- DWARF
	["character\\dwarf\\male\\dwarfmale.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
		[YES_ID] = 1.9,
		[NOPE_ID] = 1.9,
		[ACLAIM_ID] = 3,
	},
	["character\\dwarf\\female\\dwarffemale.m2"] = {
		[TALK_ID] = 1.900,
		[EXCLAME_ID] = 2.00,
		[QUESTION_ID] = 1.800,
		[YES_ID] = 2.0,
		[NOPE_ID] = 1.9,
		[ACLAIM_ID] = 2,
	},
	-- GNOMES
	["character\\gnome\\male\\gnomemale.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
		[YES_ID] = 0.9,
		[NOPE_ID] = 1.0,
		[ACLAIM_ID] = 2.0,
	},
	["character\\gnome\\female\\gnomefemale.m2"] = {
		[EXCLAME_ID] = 1.850,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
		[YES_ID] = 0.9,
		[NOPE_ID] = 1.7, -- Multi anim ...
		[ACLAIM_ID] = 2.0,
	},
	-- HUMAN
	["character\\human\\male\\humanmale.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
		[YES_ID] = 2.6,
		[NOPE_ID] = 3.2,
		[ACLAIM_ID] = 2.400,
	},
	["character\\human\\female\\humanfemale.m2"] = {
		[EXCLAME_ID] = 2.700,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.650,
		[YES_ID] = 1.900,
		[NOPE_ID] = 1.900,
		[ACLAIM_ID] = 2.300,
	},
	-- DRAENEI
	["character\\draenei\\female\\draeneifemale.m2"] = {
		[TALK_ID] = 2.850,
		[QUESTION_ID] = 1.850,
		[EXCLAME_ID] = 2.000,
		[YES_ID] = 1.9,
		[NOPE_ID] = 2,
		[ACLAIM_ID] = 2,
	},
	["character\\draenei\\male\\draeneimale.m2"] = {
		[TALK_ID] = 3.200,
		[QUESTION_ID] = 1.850,
		[EXCLAME_ID] = 3.000,
		[YES_ID] = 1.3,
		[NOPE_ID] = 1.2,
		[ACLAIM_ID] = 1.8,
	},
	-- WORGEN
	["character\\worgen\\male\\worgenmale.m2"] = {
		[QUESTION_ID] = 3.7,
		[TALK_ID] = 4.000,
		[EXCLAME_ID] = 2.700,
		[YES_ID] = 1.7,
		[ACLAIM_ID] = 3.5,
		[NOPE_ID] = 1.8,
	},
	["character\\worgen\\female\\worgenfemale.m2"] = {
		[TALK_ID] = 4.000,
		[EXCLAME_ID] = 2.700,
		[QUESTION_ID] = 4.500,
		[YES_ID] = 2.55,
		[NOPE_ID] = 2.35,
		[ACLAIM_ID] = 2.4,
	},
	-- PANDAREN
	["character\\pandaren\\female\\pandarenfemale.m2"] = {
		[TALK_ID] = 3.000,
		[EXCLAME_ID] = 3,
		[QUESTION_ID] = 3.8,
		[ACLAIM_ID] = 3.200,
		[YES_ID] = 2.00,
		[NOPE_ID] = 3.50, -- Multi anim ...
	},
	["character\\pandaren\\male\\pandarenmale.m2"] = {
		[EXCLAME_ID] = 3.400,
		[QUESTION_ID] = 4.0,
		[TALK_ID] = 4.000,
		[YES_ID] = 4,
		[NOPE_ID] = 3.2,
		[ACLAIM_ID] = 2.400,
	},
	-- ORCS
	["character\\orc\\female\\orcfemale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.2,
		[NOPE_ID] = 1.3,
		[ACLAIM_ID] = 1.4,
	},
	["character\\orc\\male\\orcmale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.8,
		[NOPE_ID] = 1.8,
		[ACLAIM_ID] = 2.7,
	},
	-- GOBLIN
	["character\\goblin\\male\\goblinmale.m2"] = {
		[TALK_ID] = 1.7,
		[QUESTION_ID] = 1.7,
		[EXCLAME_ID] = 2.000,
		[YES_ID] = 0,
		[NOPE_ID] = 0,
		[ACLAIM_ID] = 3.2,
	},
	["character\\goblin\\female\\goblinfemale.m2"] = {
		[TALK_ID] = 1.7,
		[QUESTION_ID] = 1.7,
		[EXCLAME_ID] = 2.000,
		[YES_ID] = 0,
		[NOPE_ID] = 0,
		[ACLAIM_ID] = 1.8,
	},
	-- Blood elves
	["character\\bloodelf\\male\\bloodelfmale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 2.00,
		[TALK_ID] = 2.000,
		["185"] = 1.3,
		["68"] = 2.1,
		["186"] = 1.3,
	},
	["character\\bloodelf\\female\\bloodelffemale.m2"] = {
		["185"] = 1.4,
		["65"] = 1.4,
		["60"] = 1.8,
		["68"] = 1.5,
		["186"] = 2,
		["64"] = 2.8,
	},
	["creature\\bloodelfguard\\bloodelfmale_guard.m2"] = {
		[TALK_ID] = 2.000,
		[QUESTION_ID] = 2.00,
	},
	-- Taurene
	["character\\tauren\\female\\taurenfemale.m2"] = {
		["185"] = 1.5,
		["186"] = 1.8,
		[TALK_ID] = 2.90,
		["65"] = 1.7,
		["64"] = 1.9,
		["68"] = 1.8,
	},
	["character\\tauren\\male\\taurenmale.m2"] = {
		[TALK_ID] = 2.90,
		[EXCLAME_ID] = 2.0,
		[QUESTION_ID] = 1.8,
		["185"] = 1.9,
		["68"] = 1.9,
		["186"] = 2,
	},
	-- Troll
	["character\\troll\\female\\trollfemale.m2"] = {
		["185"] = 1.4,
		["186"] = 1.6,
		["65"] = 1.4,
		["60"] = 2.4,
		["64"] = 2,
		["68"] = 2.1,
	},
	["character\\troll\\male\\trollmale.m2"] = {
		[TALK_ID] = 2.400,
		[EXCLAME_ID] = 2.600,
		[QUESTION_ID] = 1.9,
		["185"] = 1.6,
		["68"] = 3,
		["186"] = 1.6,
	},
	-- Scourge
	["character\\scourge\\male\\scourgemale.m2"] = {
		["185"] = 1.8,
		["186"] = 1.8,
		[TALK_ID] = 2.500,
		["65"] = 2,
		["64"] = 2.2,
		["68"] = 2.1,
	},
	["character\\scourge\\female\\scourgefemale.m2"] = {
		["185"] = 1.8,
		["186"] = 1.8,
		[TALK_ID] = 2.0,
		["65"] = 2,
		["64"] = 2.2,
		["68"] = 2.1,
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- NPC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	["character\\broken\\male\\brokenmale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.7,
		[TALK_ID] = 3.000,
	},
	["creature\\rexxar\\rexxar.m2"] = {
		[TALK_ID] = 2.000,
		[QUESTION_ID] = 1.600,
	},
	["creature\\khadgar2\\khadgar2.m2"] = {
		[TALK_ID] = 2.000,
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.7,
	},
	["creature\\kingvarianwrynn\\kingvarianwrynn.m2"] = {
		[TALK_ID] = 2.000,
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.5,
	},
	-- ARRAKOA
	["creature\\arakkoaoutland\\arakkoaoutland.m2"] = {
		[TALK_ID] = 1.700,
	},
	["creature\\arakkoa2\\arakkoa2.m2"] = {
		[TALK_ID] = 4.300,
	},
	["creature\\ogredraenor\\ogredraenor.m2"] = {
		[TALK_ID] = 1.9,
	},
	["creature\\agronn\\agronn.m2"] = {
		[TALK_ID] = 3.2,
	},
	["creature\\furbolg\\furbolg.m2"] = {
		[TALK_ID] = 2.6,
	},
	["character\\tuskarr\\male\\tuskarrmale.m2"] = {
		[TALK_ID] = 3.0,
	},
	["creature\\ogre\\ogre.m2"] = {
		[TALK_ID] = 2.0,
	},
}

ANIMATION_SEQUENCE_DURATION["creature\\jinyu\\jinyu.m2"] = ANIMATION_SEQUENCE_DURATION["character\\nightelf\\male\\nightelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\taunka\\male\\taunkamale.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\male\\taurenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\taunka\\female\\taunkafemale.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\female\\taurenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["creature\\alexstrasza\\ladyalexstrasa.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["creature\\ladysylvanaswindrunner\\ladysylvanaswindrunner.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["creature\\ogre\\ogrewarlord.m2"] = ANIMATION_SEQUENCE_DURATION["creature\\ogre\\ogre.m2"];
ANIMATION_SEQUENCE_DURATION["creature\\ogre\\ogremage.m2"] = ANIMATION_SEQUENCE_DURATION["creature\\ogre\\ogre.m2"];

----//fixed HD/NPC
ANIMATION_SEQUENCE_DURATION["character\\nightelf\\female\\nightelffemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\nightelf\\female\\nightelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\nightelf\\female\\nightelffemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\nightelf\\female\\nightelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\nightelf\\male\\nightelfmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\nightelf\\male\\nightelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\nightelf\\male\\nightelfmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\nightelf\\male\\nightelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\dwarf\\male\\dwarfmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\dwarf\\male\\dwarfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\dwarf\\male\\dwarfmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\dwarf\\male\\dwarfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\dwarf\\female\\dwarffemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\dwarf\\female\\dwarffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\dwarf\\female\\dwarffemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\dwarf\\female\\dwarffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\gnome\\male\\gnomemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\gnome\\male\\gnomemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\gnome\\male\\gnomemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\gnome\\male\\gnomemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\gnome\\female\\gnomefemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\gnome\\female\\gnomefemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\gnome\\female\\gnomefemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\gnome\\female\\gnomefemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\human\\male\\humanmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\male\\humanmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\human\\male\\humanmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\male\\humanmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\draenei\\female\\draeneifemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\draenei\\female\\draeneifemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\human\\female\\humanfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\draenei\\male\\draeneimale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\draenei\\male\\draeneimale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\draenei\\male\\draeneimale_npc.m2_npc"] = ANIMATION_SEQUENCE_DURATION["character\\draenei\\male\\draeneimale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\worgen\\male\\worgenmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\worgen\\male\\worgenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\worgen\\male\\worgenmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\worgen\\male\\worgenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\worgen\\female\\worgenfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\worgen\\female\\worgenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\worgen\\female\\worgenfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\worgen\\female\\worgenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\pandaren\\female\\pandarenfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\pandaren\\female\\pandarenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\pandaren\\female\\pandarenfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\pandaren\\female\\pandarenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\pandaren\\male\\pandarenmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\pandaren\\male\\pandarenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\pandaren\\male\\pandarenmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\pandaren\\male\\pandarenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\orc\\female\\orcfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\orc\\female\\orcfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\orc\\female\\orcfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\orc\\female\\orcfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\orc\\male\\orcmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\orc\\male\\orcmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\orc\\male\\orcmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\orc\\male\\orcmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\goblin\\male\\goblinmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\goblin\\male\\goblinmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\goblin\\male\\goblinmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\goblin\\male\\goblinmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\goblin\\female\\goblinfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\goblin\\female\\goblinfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\goblin\\female\\goblinfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\goblin\\female\\goblinfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
---
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmalehd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmalenpc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\male\\bloodelfmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemalehd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemalenpc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\bloodelf\\female\\bloodelffemale.m2"];
--
ANIMATION_SEQUENCE_DURATION["character\\tauren\\female\\taurenfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\female\\taurenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\tauren\\female\\taurenfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\female\\taurenfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\tauren\\male\\taurenmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\male\\taurenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\tauren\\male\\taurenmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\tauren\\male\\taurenmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\troll\\male\\trollmale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\male\\trollmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\troll\\male\\trollmale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\male\\trollmale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\scourge\\male\\scourgemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\scourge\\male\\scourgemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\scourge\\male\\scourgemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\scourge\\male\\scourgemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\scourge\\female\\scourgefemale_hd.m2"] = ANIMATION_SEQUENCE_DURATION["character\\scourge\\female\\scourgefemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\scourge\\female\\scourgefemale_npc.m2"] = ANIMATION_SEQUENCE_DURATION["character\\scourge\\female\\scourgefemale.m2"];
----------------------------
ANIMATION_SEQUENCE_DURATION["character\\foresttroll\\female\\foresttrollfemale.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale.m2"];
ANIMATION_SEQUENCE_DURATION["character\\foresttroll\\male\\foresttrollmale.m2"] = ANIMATION_SEQUENCE_DURATION["character\\troll\\female\\trollfemale.m2"];