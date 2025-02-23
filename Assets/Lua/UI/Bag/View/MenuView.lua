--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local ViewBase = require("ViewBase")
local LuaUtil = CS.Demo.LuaUtil
local EventSystem = require("EventSystem")
local EventType= require("EventType")
--菜单视图
local MenuView = BaseClass("MenuView", ViewBase)
MenuView.Name = "MenuView"

function MenuView:InitComponents()
    ----初始化组件
    --关闭按钮
    self.backBtn = LuaUtil.GetButton(self.transform, "BackBtn")

    local toggleGroupTrans = self.transform:Find("ToggleGroup")
    --侠客选项
    self.characterTog = LuaUtil.GetToggle(toggleGroupTrans, "CharacterToggle")
    --图鉴选项
    self.bookTog =  LuaUtil.GetToggle(toggleGroupTrans, "BookToggle")

end


function MenuView:OnShow()
    --显示时
    self.characterTog.isOn = true
    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.SHOW_CHARACTER)
end

return MenuView