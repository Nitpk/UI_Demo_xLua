--[[
作者：阳贻凡
--]]


--菜单controller
local MenuController =  BaseClass("MenuController",  ControllerBase)
MenuController.Name = "MenuController"

function MenuController:RegisterEvents()
     EventSystem.GetInstance():Register( EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION,
        MenuController.ClickCharacter,self)
end
function MenuController:UnRegisterEvents()
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_CHARACTER_OPTION,
        MenuController.ClickCharacter)
end
--点击侠客选项事件处理
function MenuController:ClickCharacter(isOn)
    if isOn then
        UIManager.GetInstance():ShowUI(UINames.CharacterPanel)
    else
        UIManager.GetInstance():HideUI(UINames.CharacterPanel)
    end
end

function MenuController:OnShow()
    --显示时，默认显示侠客背包界面
    self.viewDic[ViewNames.MenuView]:HighlightCharacter()
    --直接通过UIManager显示
    UIManager.GetInstance():ShowUI(UINames.CharacterPanel)
end

return MenuController