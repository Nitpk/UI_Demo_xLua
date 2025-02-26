--[[
作者：阳贻凡
--]]

local Dependence = require("Dependence")
local CharacterCell = require("CharacterCell")
--角色背包控制器
local BagController = Dependence.BaseClass("BagController", Dependence.ControllerBase)
BagController.Name = "BagController"

function BagController:RegisterEvents()
    --显示侠客界面
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.SHOW_CHARACTER,
        function ()
            self.view:Show()
            self.view:UpdateBagNum(self.model)
            self.view:UpdateBagList(self.model:GetList(Dependence.CharacterType.All),true)
            self.model.characterType = Dependence.CharacterType.All
        end)
    --隐藏侠客界面
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.HIDE_CHARACTER,
        function ()
            self.view:Hide()
        end)
    --高亮
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.HIGHLIGHT,
        function ()
            self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
        end)
    --更新背包角色类型
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE,
        function (type)
            self.model.characterType = type
            self.view:UpdateBagList(self.model:GetList(type),false)
        end)
    --阵容更新
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.UPDATE_TEAM,
        function ()
            self.view:UpdateBagList(self.model:GetList(self.model.characterType),false)
        end)
    --角色格点击
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.CLICK_CHARACTER,
        function (id)
            self.model.currentHighLightId = id
            Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.HIGHLIGHT)
        end)
    --刷新格子
    Dependence.EventSystem.GetInstance():Register(Dependence.EventType.CHARACTER_BAG.REFRESH_GRID,
        function (cellID,characterID)
            self.view:UpdateCell(cellID,self.model.characterDic[characterID],self.model.currentHighLightId)
        end)
    
end

function BagController:UnRegisterEvents()
    
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.SHOW_CHARACTER)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.HIDE_CHARACTER)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.HIGHLIGHT)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.UPDATE_TEAM)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.CLICK_CHARACTER)
    Dependence.EventSystem.GetInstance():RemoveAll(Dependence.EventType.CHARACTER_BAG.REFRESH_GRID)
    
    
end

return BagController