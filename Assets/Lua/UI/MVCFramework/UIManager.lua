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
    --uiController字典
    self.uiCtrlDic = {}
    --画布
    self.canvas = nil
    self.canvasTrans = nil
    --ui相机
    self.camera = nil

end
--UI框架初始化
function UIManager:InitFramework(callBack)

    --实例化框架预制体
    LoadMgr.Instance:LoadAsync("UIFrame",typeof(GameObject),
        function(asset)
            local frameObj = GameObject.Instantiate(asset)
            self.canvas = frameObj:GetComponentInChildren(typeof(Canvas))
            self.layerTrans = self.canvas.transform:Find("Layer")
            self.camera = frameObj:GetComponentInChildren(typeof(Camera))
            GameObject.DontDestroyOnLoad(frameObj)

            --执行callBack
            if callBack ~= nil then
                callBack()
            end

        end)
end

--注册UI
function UIManager:RegisterUI(uiName)

    self.uiCtrlDic[uiName] = UIConfig[uiName].controllerClass.New(uiName,self.layerTrans)
    
end

--得到UI的Controller
function UIManager:GetUICtrl(uiName)
    return self.uiCtrlDic[uiName]
end

--显示UI
function UIManager:ShowUI(uiName)
    local uiCtrl = self.uiCtrlDic[uiName]
    if uiCtrl == nil then
        self:RegisterUI(uiName)
        uiCtrl = self.uiCtrlDic[uiName]
    end
    
    uiCtrl:Show()
end
--隐藏UI
function UIManager:HideUI(uiName)
    local uiCtrl = self.uiCtrlDic[uiName]
    if uiCtrl == nil then
        return 
    end
    
    uiCtrl:Hide()
end
--销毁UI
function UIManager:DestroyUI(uiName)
    local uiCtrl = self.uiCtrlDic[uiName]
    if uiCtrl == nil then return end

    --销毁controller
    uiCtrl:OnDestroy()

    self.uiCtrlDic[uiName] = nil
end
--清空UI
function UIManager:Clear()
    for uiName,_ in pairs(UIManager.uiCtrlDic) do
        self:DestroyUI(uiName)
    end
end


return UIManager
