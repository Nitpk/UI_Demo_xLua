--[[
作者：阳贻凡
]]

--角色背包controller
local CharacterBagController = BaseClass("CharacterBagController",ControllerBase)
CharacterBagController.Name = "CharacterBagController"

function CharacterBagController:RegisterEvents()
    ----背包部分
    --更新背包角色类型
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        CharacterBagController.UpdateCharacterType,self)
    --角色格点击事件处理
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_CHARACTER,
        CharacterBagController.ClickCharacter,self)
    --刷新背包格子
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.REFRESH_GRID,
        CharacterBagController.UpdateCell,self)
    --增加背包容量
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_BAG_CAPACITY,
        CharacterBagController.UpdateBagCapacity,self)

    ----Display部分
    --点击上阵事件处理
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_UP_TEAM,
        CharacterBagController.ClickUpTeam,self)

    ----Team部分
    --点击阵容格事件处理
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_TEAM,
        CharacterBagController.ClickTeam,self)
    
end

function CharacterBagController:UnRegisterEvents()
    ----背包部分
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        CharacterBagController.UpdateCharacterType)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_CHARACTER,
        CharacterBagController.ClickCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.REFRESH_GRID,
        CharacterBagController.UpdateCell)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.UPDATE_BAG_CAPACITY,
        CharacterBagController.UpdateBagCapacity)

    ----Display部分
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_UP_TEAM,
        CharacterBagController.ClickUpTeam)

    ----Team部分
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_TEAM,
        CharacterBagController.ClickTeam)
end

function CharacterBagController:OnShow()
    --全类型的角色列表
    local characterList = self.model:GetList(CharacterType.All)

    --显示时，默认高亮背包的第一个角色
    self.model:UpdateHighlightID(characterList[1].id)

    ----背包部分
    self.viewDic[ViewNames.BagView]:Show()
    self.viewDic[ViewNames.BagView]:HighlightType(CharacterType.All)
    self.viewDic[ViewNames.BagView]:UpdateBagNum(self.model:GetCurrentCharacterNum()
                                                ,self.model:GetBagCapacity())
    self.viewDic[ViewNames.BagView]:UpdateBagList(characterList,true)
    self.model:SetBagCharacterType(CharacterType.All)

    ----Display部分
    self.viewDic[ViewNames.DisplayView]:Show()

    ----Team部分
    self.viewDic[ViewNames.TeamView]:Show()
    local teamList = self.model:GetTeamList()
    for i =1, #teamList do
        self.viewDic[ViewNames.TeamView]:SetTeam(teamList[i])
    end

    self:Highlight()

end

--高亮角色
function CharacterBagController:Highlight()
    --背包部分的高亮
    self.viewDic[ViewNames.BagView]:UpdateBagList(self.model:GetList(self.model:GetBagCharacterType())
                                                    ,false)
    --Displayer高亮
    self.viewDic[ViewNames.DisplayView]:UpdateCharacter(
        self.model:GetCharacterInfo(self.model:GetHighlightID()))

    --Team高亮
    --当前高亮角色ID
    local id = self.model:GetHighlightID()
    --上次高亮角色ID
    local past_id = self.model:GetHighlightID_Past()
    self.viewDic[ViewNames.TeamView]:Highlight(self.model:GetCharacterInfo(past_id).type,
                        false,past_id)
    self.viewDic[ViewNames.TeamView]:Highlight(self.model:GetCharacterInfo(id).type,true,id)
end
--更新背包角色类型
function CharacterBagController:UpdateCharacterType(characterType)
    self.model:SetBagCharacterType(characterType)
    self.viewDic[ViewNames.BagView]:UpdateBagList(self.model:GetList(characterType),false)
end

--角色格点击事件处理
function CharacterBagController:ClickCharacter(characterID)
    self.model:UpdateHighlightID(characterID)
    self:Highlight()
end
--刷新背包格子
function CharacterBagController:UpdateCell(cellID,characterID)
    self.viewDic[ViewNames.BagView]:UpdateCell(cellID,self.model:GetCharacterInfo(characterID)
        ,self.model:GetHighlightID())
end
--增加背包容量
function CharacterBagController:UpdateBagCapacity()
    --model更新数据
    self.model:AddBagCapacity()
    --view更新显示
    self.viewDic[ViewNames.BagView]:UpdateBagNum(self.model:GetCurrentCharacterNum()
                                                ,self.model:GetBagCapacity())
end

--点击上阵按钮的事件处理
function CharacterBagController:ClickUpTeam()
    --当前角色id
    local id = self.model:GetHighlightID()
    --如果已经上阵，不再处理
    if self.model:GetCharacterInfo(id).isOnTeam then
        return 
    end
    
    --更新数据
    self.model:GetCharacterInfo(id).isOnTeam = true
    --同类型的之前上阵的角色id
    local pre_id = self.model:GetCharacterInfoOnTeam(self.model:GetCharacterInfo(id).type).id
    self.model:GetCharacterInfo(pre_id).isOnTeam = false
    self.model:SetCharacterOnTeam(id)

    --更新背包角色格子显示图标
    self.viewDic[ViewNames.BagView]:UpdateBagList(self.model:GetList(self.model:GetBagCharacterType())
                                                    ,false)
    self:UpdateTeam()

    --高亮更新
    self:Highlight()

end

--点击阵容格
function CharacterBagController:ClickTeam(characterID)
    self.model:UpdateHighlightID(characterID)
    self:Highlight()
end
--阵容更新
function CharacterBagController:UpdateTeam()
    --当前高亮角色id
    local id = self.model:GetHighlightID()
    self.viewDic[ViewNames.TeamView]:SetTeam(
        self.model:GetCharacterInfoOnTeam(self.model:GetCharacterInfo(id).type))
end

return CharacterBagController