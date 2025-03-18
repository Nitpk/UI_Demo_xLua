--[[
作者：阳贻凡
--]]

--UI配置表
local UIConfig = {
    [UINames.CharacterMenu] = {
        viewList = {
            MenuView = "UI/CharacterMenuPanel"
        },
        modelClass = nil,
        controllerClass = require("MenuController")
    },
    [UINames.CharacterPanel] = {
        viewList = {
            BagView = "UI/CharacterBagPanel",
            DisplayView = "UI/CharacterDisplayPanel",
            TeamView = "UI/TeamPanel"
        },
        modelClass = require("CharacterBagModel"),
        controllerClass = require("CharacterBagController")
    }
}

return UIConfig