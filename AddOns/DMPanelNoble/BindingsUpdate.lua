local function BindingTextSplitter(BindingName)
  if BindingName:len() <=4 then
    BindingName = BindingName
  else
    BindingName = string.sub(BindingName, 0, 4) .. "..."
  end
  
  return BindingName
end

local function ConvertToBinding(ConvertedBind)
    return BindingTextSplitter(GetBindingText(GetBindingKey(ConvertedBind), "KEY_", 1))
end



function DMPanelNoble:SetBindings()
    MPA_SearchAndDelPanel.DeleteNPC.Icon:SetText(ConvertToBinding("MPA_DELNPC"))
    MPA_SearchAndDelPanel.DeleteNearNPC.Icon:SetText(ConvertToBinding("MPA_DELNEARNPC"))
    MPA_SearchAndDelPanel.UndoGob.Icon:SetText(ConvertToBinding("MPA_UNDOGOBJECT"))
    MPA_SearchAndDelPanel.LoObjButton:SetText(ConvertToBinding("MPA_LOOKUPGOBJECT"))
    MPA_SearchAndDelPanel.LoCrButton:SetText(ConvertToBinding("MPA_LOOKUPCREATURE"))
    MPA_SearchAndDelPanel.GobDelByNameButton.Icon:SetText(ConvertToBinding("MPA_UNDOGOBNAME"))
    MPA_SearchAndDelPanel.GobDelRadiusButton.Icon:SetText(ConvertToBinding("MPA_UNDOGOBRADIUS"))
    
    MPA_NPCPanel.NPCSay_Button:SetText(ConvertToBinding("MPA_NPCSAY"))
    MPA_NPCPanel.NPCYell_Button:SetText(ConvertToBinding("MPA_NPCYELL"))
    MPA_NPCPanel.NPCEmote_Button:SetText(ConvertToBinding("MPA_NPCEMOTE"))
    MPA_NPCPanel.Colour_Button:SetText(ConvertToBinding("MPA_COLOURCHAT"))
    MPA_NPCPanel.TalkingHead_Button:SetText(ConvertToBinding("MPA_TALKINGHEADCHAT"))
    
    MPA_AurasAndStatesPanel.SetAura.Icon:SetText(ConvertToBinding("MPA_SETAURA"))
    MPA_AurasAndStatesPanel.ClearAura.Icon:SetText(ConvertToBinding("MPA_CLEARAURA"))
    MPA_AurasAndStatesPanel.SetScale.Icon:SetText(ConvertToBinding("MPA_SETSCALE"))
    MPA_AurasAndStatesPanel.Morph:SetText(ConvertToBinding("MPA_SETMORPH"))
    MPA_AurasAndStatesPanel.DeMorph:SetText(ConvertToBinding("MPA_DEMORPH"))
    MPA_AurasAndStatesPanel.Phase.Icon:SetText(ConvertToBinding("MPA_SETPHASE"))
    MPA_AurasAndStatesPanel.InvisOnoff.Icon:SetText(ConvertToBinding("MPA_SETVISUALSPELL"))
    MPA_AurasAndStatesPanel.SpeedOnOff.Icon:SetText(ConvertToBinding("MPA_STOPVISUALSPELL"))
    MPA_AurasAndStatesPanel.FlyOnOff.Icon:SetText(ConvertToBinding("MPA_FLYONOFF"))
    
    MPA_ControlPanel.Waypoint:SetText(ConvertToBinding("MPA_WAYPOINTS"))
    MPA_ControlPanel.PossUnposs:SetText(ConvertToBinding("MPA_POSS"))
    MPA_ControlPanel.RollButton:SetText(ConvertToBinding("MPA_BATTLEPANEL"))
    MPA_ControlPanel.Summon.Icon:SetText(ConvertToBinding("MPA_SUMMON"))
    MPA_ControlPanel.EmoteST.Icon:SetText(ConvertToBinding("MPA_NPCPLAYEMOTE"))
    MPA_ControlPanel.EmoteStatement.Icon:SetText(ConvertToBinding("MPA_NPCSTATEMENT"))
    --MPA_ControlPanel.Army.Icon:SetText(ConvertToBinding("MPA_ARMYCONTROL"))
    
    MPA_BattlePanel.GetTargetRoll.Icon:SetText(ConvertToBinding("MPA_ROLLTARGET"))
    MPA_BattlePanel.RollStr.Icon:SetText(ConvertToBinding("MPA_ROLLSRT"))
    MPA_BattlePanel.RollAgila.Icon:SetText(ConvertToBinding("MPA_ROLLAGIL"))
    MPA_BattlePanel.RollInt.Icon:SetText(ConvertToBinding("MPA_ROLLINT"))
    
end