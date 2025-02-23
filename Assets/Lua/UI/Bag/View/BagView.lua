--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local ViewBase = require("ViewBase")
local LuaUtil = CS.Demo.LuaUtil
local EventSystem = require("EventSystem")
local EventType= require("EventType")

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

return BagView
