--[[
作者：阳贻凡
--]]


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

function MenuView:AddListener()
    --点击侠客选项，
    self.characterTog.onValueChanged:AddListener(
        function (isOn)
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION, isOn)
        end)
end
function MenuView:RemoveListener()
    self.characterTog.onValueChanged:RemoveAllListeners()
end
--高亮侠客选项
function MenuView:HighlightCharacter()
    self.characterTog.isOn = true
end
--高亮图鉴选项
function MenuView:HighlightBook()
    self.bookTog.isOn = true
end

return MenuView