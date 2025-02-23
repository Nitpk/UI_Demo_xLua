--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local ControllerBase = require("ControllerBase")
local EventSystem = require("EventSystem")
local EventType= require("EventType")
local CharacterType = require("CharacterType")
local CharacterCell = require("CharacterCell")
--角色背包控制器
local BagController = BaseClass("BagController", ControllerBase)
BagController.Name = "BagController"

function BagController:RegisterEvents()
    --背包容量增加
    self.view.addBagNumBtn.onClick:AddListener(
        function()
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_BAG_CAPACITY)
        end)
    --角色类型切换
    for i=1,6 do
        self.view.typeToggles[i].onValueChanged:AddListener(
            function(inOn)
                for i=1,#self.view.typeToggles do
                    if self.view.typeToggles[i].isOn then
                        EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, i-1)
                        break
                    end
                end
            end)
    end
    --设置格子初始化操作
    self.view.characterViewList:SetInitViewCellBundle(
        function (cellObj)
            local id = #self.view.cellDic + 1
            local cell = CharacterCell.New(cellObj)
            self.view.cellDic[id] = cell
            cell.characterBtn.onClick:AddListener(
                function()
                    self.model.currentHighLightId = cell.cId
                    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.HIGHLIGHT)
                end)
            return id
        end
    )
    --设置背包格子更新操作
    self.view.characterViewList:SetDataCallBack(
        function (cellID,characterID)
            self.view.cellDic[cellID]:UpdateCell(self.model.characterDic[characterID],self.model.currentHighLightId)
        end
    )
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
    
end

function BagController:UnRegisterEvents()
    self.view.addBagNumBtn.onClick:RemoveAllListeners()

    for i=1,6 do
        self.view.typeToggles[i].onValueChanged:RemoveAllListeners()
    end
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.SHOW_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIDE_CHARACTER)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.HIGHLIGHT)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE)
    EventSystem.GetInstance():RemoveAll(EventType.CHARACTER_BAG.UPDATE_TEAM)

    for i=1,#self.view.cellDic do
        self.view.cellDic[i].characterBtn.onClick:RemoveAllListeners()
    end
    self.view.characterViewList:SetInitViewCellBundle(nil)
    self.view.characterViewList:SetDataCallBack(nil)
    
end

return BagController