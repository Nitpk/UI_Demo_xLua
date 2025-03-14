--[[
作者：阳贻凡
--]]


--角色展示控制器
local DisplayController = BaseClass("DisplayController", ControllerBase)
DisplayController.Name = "DisplayController"

function DisplayController:RegisterEvents()
    --显示侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        function ()
            self.view:Show()
        end)
    --隐藏侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        function ()
            self.view:Hide()
        end)
    --高亮
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIGHLIGHT,
        function ()
            self.view:UpdateCharacter(self.model.characterDic[self.model.currentHighLightId])
        end)
    --点击上阵
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_UP_TEAM,
        function ()
            --当前角色id
            local id = self.model.currentHighLightId
            if self.model.characterDic[id].isOnTeam then 
                return 
            end
            
            --更新数据
            self.model.characterDic[id].isOnTeam = true
            --之前上阵的角色id
            local past_id = self.model.teamList[self.model.characterDic[id].type].id
            self.model.characterDic[past_id].isOnTeam = false
            self.model.teamList[self.model.characterDic[id].type]=self.model.characterDic[id]

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_TEAM)      
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT,self.model.currentHighLightId)
        end)
end

function DisplayController:UnRegisterEvents()
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.SHOW_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIDE_CHARACTER)
    ventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIGHLIGHT)
    ventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.CLICK_UP_TEAM)
end

return DisplayController