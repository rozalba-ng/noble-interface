
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--[[                                  Init                                   ]]
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

C_Timer:After(3, function()
if not DMLevel then return end
    if DMLevel > 0 then
    local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo("DMPanelNoble");
        if loadable == 1 then
            EnableAddOn("DMPanelNoble")
            UIParentLoadAddOn("DMPanelNoble");
        end
    end
end)
