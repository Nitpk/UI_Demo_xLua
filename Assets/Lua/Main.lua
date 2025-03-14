--[[
作者：阳贻凡
--]]
--lua主入口
require("Dependence")


UIManager.GetInstance():InitFramework(
    function()
        UIManager.GetInstance():ShowUI(UINames.CharacterBagMenu)
    end
)



