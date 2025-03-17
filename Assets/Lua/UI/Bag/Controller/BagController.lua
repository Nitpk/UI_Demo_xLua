--[[
作者：阳贻凡
--]]


--角色背包控制器
local BagController = BaseClass("BagController", ControllerBase)
BagController.Name = "BagController"

function BagController:RegisterEvents()
    --显示侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        BagController.ShowCharacter,self)
    --隐藏侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        BagController.HideCharacter,self)
    --高亮
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIGHLIGHT,
        BagController.Highlight,self)
    --更新背包角色类型
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        BagController.UpdateCharacterType,self)
    --阵容更新
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_TEAM,
        BagController.UpdateTeam,self)
    --角色格点击
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_CHARACTER,
        BagController.ClickCharacter,self)
    --刷新格子
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.REFRESH_GRID,
        BagController.UpdateCell,self)
    
end
--显示侠客界面
function BagController:ShowCharacter()
    self.view:Show()
    self.view:UpdateBagNum(self.model)
    self.view:UpdateBagList(self.model:GetList(CharacterType.All),true)
    self.model.characterType = CharacterType.All
end
--隐藏侠客界面
function BagController:HideCharacter()
    self.view:Hide()
end
--高亮
function BagController:Highlight()
    self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
end
--更新背包角色类型
function BagController:UpdateCharacterType(type)
    self.model.characterType = type
    self.view:UpdateBagList(self.model:GetList(type),false)
end
--阵容更新
function BagController:UpdateTeam()
    self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
end
--角色格点击
function BagController:ClickCharacter(id)
    self.model.currentHighLightId = id
    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT)
end
--刷新格子
function BagController:UpdateCell(cellID,characterID)
    self.view:UpdateCell(cellID,self.model.characterDic[characterID],self.model.currentHighLightId)
end

function BagController:UnRegisterEvents()
    
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        BagController.ShowCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        BagController.HideCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.HIGHLIGHT,
        BagController.Highlight)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        BagController.UpdateCharacterType)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.UPDATE_TEAM,
        BagController.UpdateTeam)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.CLICK_CHARACTER,
        BagController.ClickCharacter)
    EventSystem.GetInstance():Remove(EventType.CHARACTER_BAG.REFRESH_GRID,
        BagController.UpdateCell)
    
    
end

return BagController