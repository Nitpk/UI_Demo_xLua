--[[
作者：阳贻凡
--]]

--角色背包视图
local BagView = BaseClass("BagView", ViewBase)
BagView.Name = "BagView"

BagView.strBagNum = "/"

function BagView:InitComponents()
    --顶部区域组件
    local topTrans = self.transform:Find("Top")
    self.addBagNumBtn = LuaUtil.GetButton(topTrans, "AddBtn")
    self.bagNumText = LuaUtil.GetText(topTrans, "NumText")

    --角色列表组件
    self.characterViewList = self.transform:Find("Scroll View"):GetComponent(typeof(CS.Demo.CharacterViewList)) 
    --角色格子字典
    self.cellDic = {}


    --类型筛选Toggle组
    self.typeToggles = {}
    local togGroup = self.transform:Find("ToggleGroup")
    
    --按顺序添加Toggle
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "AllToggle"))
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "Type1Toggle"))
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "Type2Toggle"))
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "Type3Toggle"))
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "Type4Toggle"))
    table.insert(self.typeToggles, LuaUtil.GetToggle(togGroup, "Type5Toggle"))

end

function BagView:AddListener()
    --背包容量增加
    self.addBagNumBtn.onClick:AddListener(
        function()
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_BAG_CAPACITY)
        end)
    --角色类型切换
    self.typeToggles[1].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.All)
            
        end)
    self.typeToggles[2].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.Type1)
            
        end)
    self.typeToggles[3].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.Type2)
            
        end)
    self.typeToggles[4].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.Type3)
            
        end)
    self.typeToggles[5].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.Type4)
            
        end)
    self.typeToggles[6].onValueChanged:AddListener(
        function(isOn)
            if not isOn then return end

            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, CharacterType.Type5)
            
        end)
    
    --设置格子初始化操作
    self.characterViewList:SetInitViewCellBundle(
        function (cellObj)
            local id = #self.cellDic + 1
            local cell = CharacterCell.New(cellObj)
            self.cellDic[id] = cell
            cell.characterBtn.onClick:AddListener(
                function()
                    EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.CLICK_CHARACTER,cell.cId)
                end)
            return id
        end
    )
    --设置背包格子更新操作
    self.characterViewList:SetDataCallBack(
        function (cellID,characterID)
            EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.REFRESH_GRID,cellID,characterID)
        end
    )
end

function BagView:RemoveListener()
    self.addBagNumBtn.onClick:RemoveAllListeners()

    for i=1,6 do
        self.typeToggles[i].onValueChanged:RemoveAllListeners()
    end

    for i=1,#self.cellDic do
        self.cellDic[i].characterBtn.onClick:RemoveAllListeners()
    end
    self.characterViewList:SetInitViewCellBundle(nil)
    self.characterViewList:SetDataCallBack(nil)
end

--高亮类型Type
function BagView:HighlightType(characterType)
    self.typeToggles[characterType+1].isOn = true
end

--更新背包容量UI
function BagView:UpdateBagNum(currentNum,maxNum)
    self.strBuilder:Clear()
    self.strBuilder:Append(tostring(currentNum))
    self.strBuilder:Append(BagView.strBagNum)
    self.strBuilder:Append(tostring(maxNum))
    self.bagNumText.text = self.strBuilder:ToString()
end
--更新背包列表UI
function BagView:UpdateBagList(characterList,refresh)
    if not characterList then
        return
    end

    self.characterViewList:Initlize(characterList,refresh)
end

--刷新背包格子UI
function BagView:UpdateCell(cellID,cInfo,HighLightId)
    self.cellDic[cellID]:UpdateCell(cInfo,HighLightId)
end

return BagView
