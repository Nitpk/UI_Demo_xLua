--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
--视图基类
local ViewBase = BaseClass("ViewBase", Object)
--为UI的字符串拼接节省开销，所有视图共用一个
ViewBase.strBuilder = CS.System.Text.StringBuilder(20)

ViewBase.Name = "ViewBase"
function ViewBase:__init(prefabPath,parentTrans)
    --暂时先用Resources同步加载
    self.gameObject = GameObject.Instantiate(Resources.Load(prefabPath,typeof(GameObject)))
    self.transform = self.gameObject.transform
    self.transform:SetParent(parentTrans,false)
    self:InitComponents()
end
--显示
function ViewBase:Show()
    self.gameObject:SetActive(true)
    self:OnShow()
end
--显示时调用
function ViewBase:OnShow() end
--隐藏
function ViewBase:Hide()
    self.gameObject:SetActive(false)
    self:OnHide()
end
--隐藏时调用
function ViewBase:OnHide() end
--初始化组件
function ViewBase:InitComponents() end
--销毁时调用
function ViewBase:OnDestroy()
    GameObject.Destroy(self.gameObject)
end


return ViewBase
