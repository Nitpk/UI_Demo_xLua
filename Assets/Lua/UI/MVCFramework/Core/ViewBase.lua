--[[
作者：阳贻凡
--]]

--视图基类
local ViewBase = BaseClass("ViewBase", Object)
--为UI的字符串拼接节省开销，所有视图共用一个
ViewBase.strBuilder = CS.System.Text.StringBuilder(20)

ViewBase.Name = "ViewBase"
function ViewBase:__init(gameObject,parentTrans)
    
    self.gameObject = gameObject--GameObject.Instantiate(Resources.Load(prefabPath,typeof(GameObject)))
    self.transform = gameObject.transform
    self.transform:SetParent(parentTrans,false)
    self:InitComponents()
    self:AddListener()
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
--添加监听
function ViewBase:AddListener() end
--移除监听
function ViewBase:RemoveListener() end
--销毁时调用
function ViewBase:OnDestroy()
    self:RemoveListener()
    GameObject.Destroy(self.gameObject)
end


return ViewBase
