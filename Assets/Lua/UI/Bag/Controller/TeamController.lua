--[[
作者：阳贻凡
--]]


--阵容控制器
local TeamController =  BaseClass("TeamController",  ControllerBase)
TeamController.Name = "TeamController"

function TeamController:RegisterEvents()
    --显示侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        TeamController.ShowCharacter,self)
    --隐藏侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        TeamController.HideCharacter,self)
    --高亮
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIGHLIGHT,
        TeamController.Highlight,self)
    --点击阵容格
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_TEAM,
        TeamController.ClickTeam,self)
    
    --阵容更新
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_TEAM,
        TeamController.UpdateTeam,self)
end
--显示侠客界面
function TeamController:ShowCharacter()
    self.view:Show()
    for i =1,#self.model.teamList do
        self.view:SetTeam(self.model.teamList[i])
    end
    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT)

end
--隐藏侠客界面
function TeamController:HideCharacter()
    self.view:Hide()
end
--高亮
function TeamController:Highlight()
    local id = self.model.currentHighLightId
    local past_id = self.model.pastHighLightId
    self.view:Highlight(self.model.characterDic[past_id].type,
                        false,past_id)
    self.view:Highlight(self.model.characterDic[id].type,true,id)
    self.model.pastHighLightId= id
end
--点击阵容格
function TeamController:ClickTeam(id)
    self.model.currentHighLightId = id
    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT)
end
--阵容更新
function TeamController:UpdateTeam()
    --当前角色id
    local id = self.model.currentHighLightId
    self.view:SetTeam(self.model.teamList[self.model.characterDic[id].type])
end


function TeamController:UnRegisterEvents()
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        TeamController.ShowCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        TeamController.HideCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIGHLIGHT,
        TeamController.Highlight)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_TEAM,
        TeamController.ClickTeam)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.UPDATE_TEAM,
        TeamController.UpdateTeam)
end

return TeamController