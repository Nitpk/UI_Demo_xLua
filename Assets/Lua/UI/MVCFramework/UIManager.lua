--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local UIConfig = require("UIConfig")

--UI管理器
local UIManager = BaseClass("UIManager",Object)
UIManager.instances = nil

--得到单例
function UIManager.GetInstances()
    if UIManager.instances == nil then
        UIManager.instances = UIManager.New()
    end
    return UIManager.instances
end
function UIManager:__init()
    --ui字典
    self.uiDic = {}
    --模型字典
    self.modelDic = {}
    --画布
    self.canvas = nil
    self.canvasTrans = nil
    --ui相机
    self.camera = nil
    self:InitFramework()
    self:InitUI()
end
--UI框架初始化
function UIManager:InitFramework()
    --实例化框架预制体
    local frameObj = GameObject.Instantiate(Resources.Load("UIFrame",typeof(GameObject)))
    self.canvas = frameObj:GetComponentInChildren(typeof(Canvas))
    self.layerTrans = self.canvas.transform:Find("Layer")
    self.camera = frameObj:GetComponentInChildren(typeof(Camera))
end

--根据UI配置表初始化
function UIManager:InitUI()
    for k,v in pairs(UIConfig) do
        self:RegisterUI(k, v)
    end
end

--注册UI
function UIManager:RegisterUI(uiName, config )
    local uiObj = {}
    -------------
    --view
    uiObj.view = config.viewClass.New(config.prefabPath, self.layerTrans)
    ------------
    --model
    if self.modelDic[config.modelClass.Name] == nil then
        self.modelDic[config.modelClass.Name] = 
        {
            --引用计数
            cnt = 1,
            value = config.modelClass.New()
        }
    else --引用计数加1
        self.modelDic[config.modelClass.Name].cnt = self.modelDic[config.modelClass.Name].cnt + 1
    end
    uiObj.model = self.modelDic[config.modelClass.Name].value
    ------------
    --controller
    uiObj.controller = config.controllerClass.New(uiObj.view, uiObj.model)

    uiObj.view:Hide()

    self.uiDic[uiName] = uiObj
end

--显示UI
function UIManager:ShowUI(uiName)
    local uiObj = self.uiDic[uiName]
    if not uiObj then return end
    
    uiObj.view:Show()
end
--隐藏UI
function UIManager:HideUI(uiName)
    local uiObj = self.uiDic[uiName]
    if not uiObj then return end
    
    uiObj.view:Hide()
end
--销毁UI
function UIManager:DestroyUI(uiName)
    local uiObj = self.uiDic[uiName]
    if not uiObj then return end

    --view
    uiObj.view:OnDestroy() 

    --model
    self.modelDic[uiObj.model.Name].cnt = self.modelDic[uiObj.model.Name].cnt - 1
    if self.modelDic[uiObj.model.Name].cnt == 0 then
        self.modelDic[uiObj.model.Name] = nil
    end

    --controller
    uiObj.controller:OnDestroy()

    uiObj.view = nil
    uiObj.model = nil
    uiObj.controller = nil
    self.uiDic[uiName] = nil
end
--清空UI
function UIManager:Clear()
    for k,_ in pairs(UIManager.uiDic) do
        self:DestroyUI(k)
    end
end


return UIManager
