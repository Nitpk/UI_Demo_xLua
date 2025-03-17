--[[
作者：阳贻凡
--]]


--角色展示控制器
local DisplayController = BaseClass("DisplayController", ControllerBase)
DisplayController.Name = "DisplayController"

function DisplayController:RegisterEvents()
    --显示侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        DisplayController.ShowCharacter,self)
    --隐藏侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        DisplayController.HideCharacter,self)
    --高亮
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIGHLIGHT,
        DisplayController.Highlight,self)
    --点击上阵
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_UP_TEAM,
        DisplayController.ClickUpTeam,self)
end
--显示侠客界面
function DisplayController:ShowCharacter()
    self.view:Show()
end
--隐藏侠客界面
function DisplayController:HideCharacter()
    self.view:Hide()
end
--高亮
function DisplayController:Highlight()
    self.view:UpdateCharacter(self.model.characterDic[self.model.currentHighLightId])
end
--点击上阵
function DisplayController:ClickUpTeam()
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

end

function DisplayController:UnRegisterEvents()
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        DisplayController.ShowCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        DisplayController.HideCharacter)
    ventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIGHLIGHT,
        DisplayController.Highlight)
    ventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_UP_TEAM,
        DisplayController.ClickUpTeam)
end

return DisplayController