local race, raceEn = UnitRace("player");
local PlayerSex = UnitSex("player")
Transmog_SavedBarber = {}

local BarberRaceCorrect = {
[2]= {
    ["Human"]= {2.3,0.03,-0.75},
    ["Orc"]= {1.8, 0.03, -0.6},
    ["Dwarf"]= {2.3, 0.0, -0.5},
    ["NightElf"]= {2.9, 0.0, -0.8},
    ["Scourge"]= {1.9, 0.04, -0.6},
    ["Tauren"]= {2.6, 0.0, -0.4},
    ["Gnome"]= {1.1,0,-0.2},
    ["Troll"]= {2.7, -0.04, -0.45},
    ["Goblin"]= {1.5, 0.0, -0.15},
    ["BloodElf"]= {2.6, 0.0, -0.75},
    ["Draenei"]= {3.1, 0.0, -0.75},
    ["Worgen"]= {2.7,0,-0.75},
    ["Pandaren"]= {2.8, 0.035, -0.65},
    ["VoidElf"]= {2.8, 0.0, -0.75},
    ["NightElfN"]= {2.9, 0.0, -0.8},
	["HumanN"]= {2.3,0.03,-0.75},
    ["Vulpera"]= {2.5, 0.0, -0.15},
    ["DarkIronDwarf"]= {2.3, 0.0, -0.35},
    ["ZandalariTroll"]= {3.6, 0.035, -0.90},
    ["Nightborne"]= {3.2, 0.0, -0.60},
    ["Naga"]= {4,0,-0.75},
	["BloodElfN"]= {2.6, 0.0, -0.75},
},
[3]= {
    ["Human"]= {1.9,0.03,-0.64},
    ["Orc"]= {1.95, 0.0, -0.55},
    ["Dwarf"]= {1.3, -0.03, -0.3},
    ["NightElf"]= {2.9, -0.02, -0.7},
    ["Scourge"]= {2.7, 0.02, -0.5},
    ["Tauren"]= {2.1, 0.02, -0.2},
    ["Gnome"]= {0.9,0,-0.15},
    ["Troll"]= {2.7, 0.0, -0.55},
    ["Goblin"]= {1.5, 0.0, -0.15},
    ["BloodElf"]= {2.0, 0.06, -0.55},
    ["Draenei"]= {2.6, -0.04, -0.75},
    ["Worgen"]= {3.5,0.6,-0.60},
    ["Pandaren"]= {2.2, 0, -0.65},
    ["VoidElf"]= {2.2, 0.06, -0.55},
    ["NightElfN"]= {2.9, -0.02, -0.7},
	["HumanN"]= {1.9,0.03,-0.64},
    ["Vulpera"]= {2.5, 0.0, -0.15},
    ["DarkIronDwarf"]= {1.3, -0.03, -0.3},
    ["ZandalariTroll"]= {3.6, 0.03, -0.58},
    ["Nightborne"]= {3.2, 0.05, -0.75},
    ["Naga"]= {3,0.03,-0.7},
	["BloodElfN"]= {2.0, 0.06, -0.55},
},
}
 
local BarberValidation = {
["hair"] = {
[2]= {
    ["Human"]= 15,
    ["Goblin"]= 17,
    ["Gnome"]= 11,
    ["Dwarf"]= 15,
    ["NightElf"]= 11,
    ["BloodElf"]= 15,
    ["Orc"]= 11,
    ["Draenei"]= 13,
    ["Scourge"]= 14,
    ["Tauren"]= 12,
    ["Troll"]= 9,
	["HumanN"]= 22,
    ["Worgen"]= 12,
    ["Pandaren"]= 4,
    ["VoidElf"]= 12,
    ["NightElfN"]= 11,
    ["Vulpera"]= 6,
    ["DarkIronDwarf"]= 9,
    ["ZandalariTroll"]= 11,
    ["Nightborne"]= 7,
    ["Naga"]= 5,
	["BloodElfN"]= 14,
    },
[3]= {
    ["Human"]= 23,
    ["Orc"]= 12,
    ["Dwarf"]= 18,
    ["NightElf"]= 11,
    ["Scourge"]= 14,
    ["Tauren"]= 11,
    ["Gnome"]= 11,
    ["Troll"]= 9,
    ["Goblin"]= 16,
    ["BloodElf"]= 18,
    ["Draenei"]= 15,
	["NightElfN"]= 14,
    ["Worgen"]= 14,
    ["Pandaren"]= 4,
    ["VoidElf"]= 9,
	["HumanN"]= 28,
    ["Vulpera"]= 6,
    ["DarkIronDwarf"]= 10,
    ["ZandalariTroll"]= 8,
    ["Nightborne"]= 6,
    ["Naga"]= 8,
	["BloodElfN"]= 16,
    },
},
["color"] = {
[2]= {
    ["Human"]= 11,
    ["Orc"]= 9,
    ["Dwarf"]= 11,
    ["NightElf"]= 12,
    ["Scourge"]= 8,
    ["Tauren"]= 2,
    ["Gnome"]= 10,
    ["Troll"]= 11,
    ["Goblin"]= 10,
    ["BloodElf"]= 11,
    ["Draenei"]= 8,
	["HumanN"]= 13,
    ["Worgen"]= 4,
    ["Pandaren"]= 5,
    ["VoidElf"]= 7,
    ["NightElfN"]= 10,
    ["Vulpera"]= 0,
    ["DarkIronDwarf"]= 6,
    ["ZandalariTroll"]= 5,
    ["Nightborne"]= 5,
    ["Naga"]= 6,
	["BloodElfN"]= 16,
    },
[3]= {
    ["Human"]= 29,
    ["Orc"]= 9,
    ["Dwarf"]= 11,
    ["NightElf"]= 11,
    ["Scourge"]= 8,
    ["Tauren"]= 2,
    ["Gnome"]= 10,
    ["Troll"]= 11,
    ["Goblin"]= 10,
    ["BloodElf"]= 11,
    ["Draenei"]= 8,
	["HumanN"]= 29,
    ["Worgen"]= 4,
    ["Pandaren"]= 3,
    ["VoidElf"]= 7,
    ["NightElfN"]= 101,
    ["Vulpera"]= 0,
    ["DarkIronDwarf"]= 6,
    ["ZandalariTroll"]= 5,
    ["Nightborne"]= 5,
    ["Naga"]= 6,
	["BloodElfN"]= 16,
    },
},
["facial"] = {
[2]= {
    ["Human"]= 8,
    ["Orc"]= 10,
    ["Dwarf"]= 10,
    ["NightElf"]= 5,
    ["Scourge"]= 16,
    ["Tauren"]= 6,
    ["Gnome"]= 7,
    ["Troll"]= 10,
    ["Goblin"]= 24,
    ["BloodElf"]= 9,
    ["Draenei"]= 7,
	["HumanN"]= 255,
    ["Worgen"]= 21,
    ["Pandaren"]= 20,
    ["VoidElf"]= 6,
    ["NightElfN"]= 243,
    ["Vulpera"]= 11,
    ["DarkIronDwarf"]= 34,
    ["ZandalariTroll"]= 6,
    ["Nightborne"]= 27,
    ["Naga"]= 20,
	["BloodElfN"]= 39,
    },
[3]= {
    ["Human"]= 20,
    ["Orc"]= 6,
    ["Dwarf"]= 5,
    ["NightElf"]= 9,
    ["Scourge"]= 7,
    ["Tauren"]= 4,
    ["Gnome"]= 6,
    ["Troll"]= 5,
    ["Goblin"]= 24,
    ["BloodElf"]= 10,
    ["Draenei"]= 6,
	["HumanN"]= 254,
    ["Worgen"]= 21,
    ["Pandaren"]= 0,
    ["VoidElf"]= 4,
    ["NightElfN"]= 254,
    ["Vulpera"]= 15,
    ["DarkIronDwarf"]= 6,
    ["ZandalariTroll"]= 6,
    ["Nightborne"]= 27,
    ["Naga"]= 4,
	["BloodElfN"]= 255,
    },
},
["skin"] = {
[2]= {
    ["Tauren"]= 18,
    },
[3]= {
    ["Tauren"]= 10,
     },
},
}

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Scripts                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function UpdateBarberModel()
Transmog_UnitModel:SetPosition( 0, 0, 0);
Transmog_UnitModel:RefreshUnit()
Transmog_UnitModel:SetPosition( BarberRaceCorrect[PlayerSex][raceEn][1], BarberRaceCorrect[PlayerSex][raceEn][2], BarberRaceCorrect[PlayerSex][raceEn][3]);
end
 
local Transmog_BarberUpdater = CreateFrame("Frame")
local Transmog_BarberUpdater_AnimationGroup = Transmog_BarberUpdater:CreateAnimationGroup()
local Transmog_BarberUpdater_Animation = Transmog_BarberUpdater_AnimationGroup:CreateAnimation("Alpha")
Transmog_BarberUpdater_Animation:SetDuration(0.3)
Transmog_BarberUpdater_AnimationGroup:SetScript("OnFinished", function(self)
    UpdateBarberModel()
end)

local BarberCooldown = false
local Transmog_BarberCooldown = CreateFrame("Frame")
local Transmog_BarberCooldown_AnimationGroup = Transmog_BarberCooldown:CreateAnimationGroup()
local Transmog_BarberCooldown_Animation = Transmog_BarberCooldown_AnimationGroup:CreateAnimation("Alpha")
Transmog_BarberCooldown_Animation:SetDuration(0.7)
Transmog_BarberCooldown_AnimationGroup:SetScript("OnFinished", function(self)
    BarberCooldown = false
end)

local function BarberLeftFunc(variable, number)
if BarberCooldown == true then
    UIErrorsFrame:AddMessage("Нужно подождать.", 1.0, 0.0, 0.0, 53, 1);
    return
end
if not Transmog_SavedBarber[variable] then Transmog_SavedBarber[variable] = 0 end
if not tonumber(Transmog_SavedBarber[variable]) then Transmog_SavedBarber[variable] = 0 end

if Transmog_SavedBarber[variable] == 0 then
    if (Transmog_SavedBarber[variable] - 1) < 0 then
        Transmog_SavedBarber[variable] = BarberValidation[variable][PlayerSex][raceEn]
        ChangeVisual(number, BarberValidation[variable][PlayerSex][raceEn])
    else
        Transmog_SavedBarber[variable] = 0
        ChangeVisual(number, 0)
    end
else
    Transmog_SavedBarber[variable] = Transmog_SavedBarber[variable] - 1
    if raceEn == "NightElf" and variable == "color" and (Transmog_SavedBarber[variable] == 8 or Transmog_SavedBarber[variable] == 9) then Transmog_SavedBarber[variable] = 7 end
    ChangeVisual(number, Transmog_SavedBarber[variable])
end
Transmog_BarberUpdater_Animation:Play()
BarberCooldown = true
Transmog_BarberCooldown_Animation:Play()
end
 
 
local function BarberRightFunc(variable, number)
if BarberCooldown == true then
    UIErrorsFrame:AddMessage("Нужно подождать.", 1.0, 0.0, 0.0, 53, 1);
    return
end
if not Transmog_SavedBarber[variable] then Transmog_SavedBarber[variable] = 0 end
if not tonumber(Transmog_SavedBarber[variable]) then Transmog_SavedBarber[variable] = 0 end

    if Transmog_SavedBarber[variable] >= BarberValidation[variable][PlayerSex][raceEn] then
        if (Transmog_SavedBarber[variable] + 1) > BarberValidation[variable][PlayerSex][raceEn] then
            Transmog_SavedBarber[variable] = 0
            ChangeVisual(number, Transmog_SavedBarber[variable])
        else
            Transmog_SavedBarber[variable] = BarberValidation[variable][PlayerSex][raceEn]
            ChangeVisual(number, BarberValidation[variable][PlayerSex][raceEn])
        end
    else
        Transmog_SavedBarber[variable] = Transmog_SavedBarber[variable] + 1
        if raceEn == "NightElf" and variable == "color" and (Transmog_SavedBarber[variable] == 8 or Transmog_SavedBarber[variable] == 9) then Transmog_SavedBarber[variable] = 10 end
        ChangeVisual(number, Transmog_SavedBarber[variable])
    end
Transmog_BarberUpdater_Animation:Play()
BarberCooldown = true
Transmog_BarberCooldown_Animation:Play()
end
 
 
 
 
function BarberTextCorrect()
BarberParent.Hair.Text:SetText(getglobal("HAIR_"..GetHairCustomization().."_STYLE"))
BarberParent.Color.Text:SetText(getglobal("HAIR_"..GetHairCustomization().."_COLOR"))
BarberParent.Facial.Text:SetText(getglobal("FACIAL_HAIR_"..GetFacialHairCustomization()))
if raceEn == "Goblin" then BarberParent.Facial.Text:SetText("Уши и украшения") end
end 
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Frames                                  ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
local BarberParent = CreateFrame("Frame", "BarberParent", Transmog_MainPanel) ---// Мейнфрейм
BarberParent:SetSize(370,670)
BarberParent:Hide()
BarberParent:SetPoint("CENTER", Transmog_MainPanel, "CENTER", 120, -80)
BarberParent:SetFrameStrata("MEDIUM")
BarberParent:SetFrameLevel(2)

BarberParent_DefaultText = BarberParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BarberParent_DefaultText:SetPoint("CENTER", 10,245)
BarberParent_DefaultText:SetFont("Fonts\\FRIZQT__.ttf", 17, "OUTLINE")
BarberParent_DefaultText:SetText("Парикмахерская\n Вы можете изменить прическу,\nцвет волос и отличительные\nособенности.")
BarberParent_DefaultText:SetAlpha(0.70)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Hair                                    ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
BarberParent.Hair = CreateFrame("Frame", "BarberParentHair", BarberParent)
BarberParent.Hair:SetSize(1,1)
BarberParent.Hair:SetPoint("CENTER", BarberParent, "CENTER", 0, 150)

BarberParent.Hair.Text = BarberParent.Hair:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BarberParent.Hair.Text:SetPoint("CENTER", BarberParent.Hair, "CENTER", 0, 0)
BarberParent.Hair.Text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
BarberParent.Hair.Text:SetText(getglobal("HAIR_"..GetHairCustomization().."_STYLE"))
BarberParent.Hair.Text:SetAlpha(0.70)

BarberParent.Hair.Left = CreateFrame("BUTTON", "BarberParent_HairLeft", BarberParent.Hair, "BarberButtonLeftTemplate");
BarberParent.Hair.Left:SetScript("OnClick", function(self, button)
    BarberLeftFunc("hair", 1)
end)

BarberParent.Hair.Right = CreateFrame("BUTTON", "BarberParent_HairRight", BarberParent.Hair, "BarberButtonRightTemplate");
BarberParent.Hair.Right:SetScript("OnClick", function(self, button)
    BarberRightFunc("hair", 1)
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                 Color                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
BarberParent.Color = CreateFrame("Frame", "BarberParentColor", BarberParent)
BarberParent.Color:SetSize(1,1)
BarberParent.Color:SetPoint("CENTER", BarberParent, "CENTER", 0, 100)

BarberParent.Color.Text = BarberParent.Color:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BarberParent.Color.Text:SetPoint("CENTER", BarberParent.Color, "CENTER", 0, 0)
BarberParent.Color.Text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
BarberParent.Color.Text:SetText(getglobal("HAIR_"..GetHairCustomization().."_COLOR"))
BarberParent.Color.Text:SetAlpha(0.70)

BarberParent.Color.Left = CreateFrame("BUTTON", "BarberParent_ColorLeft", BarberParent.Color, "BarberButtonLeftTemplate");
BarberParent.Color.Left:SetScript("OnClick", function(self, button)
    BarberLeftFunc("color", 2)
end)

BarberParent.Color.Right = CreateFrame("BUTTON", "BarberParent_ColorRight", BarberParent.Color, "BarberButtonRightTemplate");
BarberParent.Color.Right:SetScript("OnClick", function(self, button)
    BarberRightFunc("color", 2)
end)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Facial                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
BarberParent.Facial = CreateFrame("Frame", "BarberParentFacial", BarberParent)
BarberParent.Facial:SetSize(1,1)
BarberParent.Facial:SetPoint("CENTER", BarberParent, "CENTER", 0, 50)

BarberParent.Facial.Text = BarberParent.Facial:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BarberParent.Facial.Text:SetPoint("CENTER", BarberParent.Facial, "CENTER", 0, 0)
BarberParent.Facial.Text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
BarberParent.Facial.Text:SetText(getglobal("FACIAL_HAIR_"..GetFacialHairCustomization()))
BarberParent.Facial.Text:SetAlpha(0.70)

BarberParent.Facial.Left = CreateFrame("BUTTON", "BarberParent_FacialLeft", BarberParent.Facial, "BarberButtonLeftTemplate");
BarberParent.Facial.Left:SetScript("OnClick", function(self, button)
    BarberLeftFunc("facial", 3)
end)

BarberParent.Facial.Right = CreateFrame("BUTTON", "BarberParent_FacialRight", BarberParent.Facial, "BarberButtonRightTemplate");
BarberParent.Facial.Right:SetScript("OnClick", function(self, button)
    BarberRightFunc("facial", 3)
end)

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                Tauren                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if raceEn == "Tauren" then
BarberParent.SkinColor = CreateFrame("Frame", "BarberParentSkinColor", BarberParent)
BarberParent.SkinColor:SetSize(1,1)
BarberParent.SkinColor:SetPoint("CENTER", BarberParent, "CENTER", 0, 0)

BarberParent.SkinColor.Text = BarberParent.SkinColor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BarberParent.SkinColor.Text:SetPoint("CENTER", BarberParent.SkinColor, "CENTER", 0, 0)
BarberParent.SkinColor.Text:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
BarberParent.SkinColor.Text:SetText("Цвет кожи")
BarberParent.SkinColor.Text:SetAlpha(0.70)

BarberParent.SkinColor.Left = CreateFrame("BUTTON", "BarberParent_SkinColorLeft", BarberParent.SkinColor, "BarberButtonLeftTemplate");
BarberParent.SkinColor.Left:SetScript("OnClick", function(self, button)
    BarberLeftFunc("skin", 5)
end)

BarberParent.SkinColor.Right = CreateFrame("BUTTON", "BarberParent_SkinColorRight", BarberParent.SkinColor, "BarberButtonRightTemplate");
BarberParent.SkinColor.Right:SetScript("OnClick", function(self, button)
    BarberRightFunc("skin", 5)
end)
end