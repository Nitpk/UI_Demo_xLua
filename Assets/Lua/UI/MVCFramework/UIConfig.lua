--[[
作者：阳贻凡
--]]

--UI配置表
local UIConfig = {
    [UINames.CharacterBagMenu] = {
        prefabPath = "UI/CharacterMenuPanel",
        modelClass = require("CharacterBagModel"),
        viewClass = require("MenuView"),
        controllerClass = require("MenuController")
    },
    [UINames.CharacterBagList] = {
        prefabPath = "UI/CharacterBagPanel",
        modelClass = require("CharacterBagModel"),
        viewClass = require("BagView"),
        controllerClass = require("BagController")
    },
    [UINames.CharacterDisplay] = {
        prefabPath = "UI/CharacterDisplayPanel",
        modelClass = require("CharacterBagModel"),
        viewClass = require("DisplayView"),
        controllerClass = require("DisplayController")
    },
    [UINames.TeamPanel] = {
        prefabPath = "UI/TeamPanel",
        modelClass = require("CharacterBagModel"),
        viewClass = require("TeamView"),
        controllerClass = require("TeamController")
    }
}

return UIConfig