--[[
作者：阳贻凡
--]]
--事件类型
local EventType = {
    --角色背包
    CHARACTER_BAG = {
        --背包容量更新
        UPDATE_BAG_CAPACITY = "UPDATE_BAG_CAPACITY",
        --背包角色类型更新
        UPDATE_CHARACTER_TYPE = "UPDATE_CHARACTER_TYPE",
        --点击角色格事件(int 角色id)
        CLICK_CHARACTER = "CLICK_CHARACTER",
        --点击阵容格事件(int 角色id)
        CLICK_TEAM = "CLICK_TEAM",
        --背包格子刷新事件（cellID,characterID）
        REFRESH_GRID = "REFRESH_GRID",
        --点击上阵按钮事件
        CLICK_UP_TEAM = "CLICK_UP_TEAM",
        --点击侠客选项(isOn)
        CLICK_CHARACTER_OPTION = "CLICK_CHARACTER_OPTION"
    }
}

return EventType
