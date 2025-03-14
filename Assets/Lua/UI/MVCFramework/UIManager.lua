--[[
作者：阳贻凡
--]]

--UI管理器
local UIManager = BaseClass("UIManager",Object)
UIManager.instance = nil

--得到单例
function UIManager.GetInstance()
    if UIManager.instance == nil then
        UIManager.instance = UIManager.New()
    end
    return UIManager.instance
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
end
--UI框架初始化
function UIManager:InitFramework(callBack)
    --实例化框架预制体
    StartCoroutine(LoadMgr.LoadAsync,"UIFrame",typeof(GameObject),
        function(asset)
            local frameObj = GameObject.Instantiate(asset)
            self.canvas = frameObj:GetComponentInChildren(typeof(Canvas))
            self.layerTrans = self.canvas.transform:Find("Layer")
            self.camera = frameObj:GetComponentInChildren(typeof(Camera))
            --加载UI
            StartCoroutine(self.InitUI,self,callBack)
        end
    )
end

--根据UI配置表初始化
function UIManager:InitUI(callBack)

    for k,v in pairs(UIConfig) do
        --依次等待加载
        coroutine.yield(StartCoroutine(self.RegisterUI,self,k, v))
    end

    if callBack ~= nil then
        callBack()
    end
end

--注册UI
function UIManager:RegisterUI(uiName, config )
    local uiObj = {}
    -------------
    --view
    local prefabGO = nil
    --等待资源加载完成后再执行后续步骤
    coroutine.yield(StartCoroutine(LoadMgr.LoadAsync,config.prefabPath,typeof(GameObject),
    function(asset)
            prefabGO = GameObject.Instantiate(asset)
        end
    ))
    uiObj.view = config.viewClass.New(prefabGO, self.layerTrans)
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
