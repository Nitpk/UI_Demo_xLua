--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local ControllerBase = require("ControllerBase")
local EventSystem = require("EventSystem")
local EventType= require("EventType")
--菜单控制器
local MenuController = BaseClass("MenuController", ControllerBase)
MenuController.Name = "MenuController"

function MenuController:RegisterEvents()
    --侠客选项
    self.view.characterTog.onValueChanged:AddListener(
        function (isOn)
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
    self.view.characterTog.onValueChanged:RemoveAllListeners()
end

return MenuController