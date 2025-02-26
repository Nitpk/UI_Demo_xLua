--[[
作者：阳贻凡
--]]

local Dependence = require("Dependence")
--菜单控制器
local MenuController = Dependence.BaseClass("MenuController", Dependence.ControllerBase)
MenuController.Name = "MenuController"

function MenuController:RegisterEvents()
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION,
        function(isOn)
            if isOn then
                self.model.currentHighLightId = self.model.characterList[1].id
                self.model.pastHighLightId = self.model.currentHighLightId
                Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.SHOW_CHARACTER)
            else
                Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.HIDE_CHARACTER)
            end
        end)
end

function MenuController:UnRegisterEvents()
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION)
end

return MenuController