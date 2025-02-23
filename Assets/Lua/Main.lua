--[[
作者：阳贻凡
--]]
--lua主入口
require("Needs")

local UINames = require("UINames")
local UIManager = require("UIManager")

UIManager.GetInstances():ShowUI(UINames.CharacterBagMenu)