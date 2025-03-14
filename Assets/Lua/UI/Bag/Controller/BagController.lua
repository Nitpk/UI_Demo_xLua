--[[
作者：阳贻凡
--]]


--角色背包控制器
local BagController = BaseClass("BagController", ControllerBase)
BagController.Name = "BagController"

function BagController:RegisterEvents()
    --显示侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.SHOW_CHARACTER,
        function ()
            self.view:Show()
            self.view:UpdateBagNum(self.model)
            self.view:UpdateBagList(self.model:GetList(CharacterType.All),true)
            self.model.characterType = CharacterType.All
        end)
    --隐藏侠客界面
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIDE_CHARACTER,
        function ()
            self.view:Hide()
        end)
    --高亮
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.HIGHLIGHT,
        function ()
            self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
        end)
    --更新背包角色类型
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        function (type)
            self.model.characterType = type
            self.view:UpdateBagList(self.model:GetList(type),false)
        end)
    --阵容更新
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.UPDATE_TEAM,
        function ()
            self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
        end)
    --角色格点击
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.CLICK_CHARACTER,
        function (id)
            self.model.currentHighLightId = id
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT)
        end)
    --刷新格子
    EventSystem.GetInstance():Register(EventType.CHARACTER_BAG.REFRESH_GRID,
        function (cellID,characterID)
            self.view:UpdateCell(cellID,self.model.characterDic[characterID],self.model.currentHighLightId)
        end)
    
end

function BagController:UnRegisterEvents()
    
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.SHOW_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIDE_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIGHLIGHT)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.UPDATE_TEAM)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.CLICK_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.REFRESH_GRID)
    
    
end

return BagController