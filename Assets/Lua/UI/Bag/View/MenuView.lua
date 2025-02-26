--[[
作者：阳贻凡
--]]
local Dependence = require("Dependence")

--菜单视图
local MenuView = Dependence.BaseClass("MenuView", Dependence.ViewBase)
MenuView.Name = "MenuView"

function MenuView:InitComponents()
    ----初始化组件
    --关闭按钮
    self.backBtn = Dependence.LuaUtil.GetButton(self.transform, "BackBtn")

    local toggleGroupTrans = self.transform:Find("ToggleGroup")
    --侠客选项
    self.characterTog = Dependence.LuaUtil.GetToggle(toggleGroupTrans, "CharacterToggle")
    --图鉴选项
    self.bookTog =  Dependence.LuaUtil.GetToggle(toggleGroupTrans, "BookToggle")

end

function MenuView:AddListener()
    --侠客选项
    self.characterTog.onValueChanged:AddListener(
        function (isOn)
            Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION, isOn)
        end)
end

function MenuView:RemoveListener()
    self.characterTog.onValueChanged:RemoveAllListeners()
end

function MenuView:OnShow()
    --显示时
    self.characterTog.isOn = true
    Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.SHOW_CHARACTER)
end

return MenuView