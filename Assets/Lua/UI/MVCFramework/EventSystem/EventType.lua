--[[
作者：阳贻凡
--]]
--事件类型
local EventType = {
    --角色背包
    CHARACTER_BAG = {
        --显示侠客界面
        SHOW_CHARACTER = "SHOW_CHARACTER",
        --隐藏侠客界面
        HIDE_CHARACTER = "HIDE_CHARACTER",
        --阵容更新
        UPDATE_TEAM = "UPDATE_TEAM",
        --背包容量更新
        UPDATE_BAG_CAPACITY = "UPDATE_BAG_CAPACITY",
        --背包角色类型更新
        UPDATE_CHARACTER_TYPE = "UPDATE_CHARACTER_TYPE",
        --高亮事件
        HIGHLIGHT = "HIGHLIGHT"
    }
}

return EventType
