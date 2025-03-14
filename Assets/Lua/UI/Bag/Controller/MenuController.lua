--[[
作者：阳贻凡
--]]


--菜单控制器
local MenuController =  BaseClass("MenuController",  ControllerBase)
MenuController.Name = "MenuController"

function MenuController:RegisterEvents()
     EventSystem.GetInstance():Register( EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION,
        function(isOn)
            if isOn then
                self.model.currentHighLightId = self.model.characterList[1].id
                self.model.pastHighLightId = self.model.currentHighLightId
                EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.SHOW_CHARACTER)
            else
                EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIDE_CHARACTER)
            end
        end)
end

function MenuController:UnRegisterEvents()
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION)
end

return MenuController