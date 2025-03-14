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
    for i=1,6 do
        self.typeToggles[i].onValueChanged:AddListener(
            function(inOn)
                for i=1,#self.typeToggles do
                    if self.typeToggles[i].isOn then
                        EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.UPDATE_CHARACTER_TYPE, i-1)
                        break
                    end
                end
            end)
    end
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


function BagView:OnShow()
    self.typeToggles[1].isOn = true
end

--更新背包容量UI
function BagView:UpdateBagNum(characterBagModel)
    if not characterBagModel then
        return
    end

    self.strBuilder:Clear()
    self.strBuilder:Append(tostring(characterBagModel.currentNum))
    self.strBuilder:Append(BagView.strBagNum)
    self.strBuilder:Append(tostring(characterBagModel.maxNum))
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
