--[[
作者：阳贻凡
--]]

--控制器基类
local ControllerBase = BaseClass("ControllerBase", Object)
ControllerBase.Name = "ControllerBase"


function ControllerBase:__init(uiName,parentTrans)
    --view需加载个数
    self.viewNeedNum = 0
    --view加载完成回调
    self.callBack = nil

    --view实例化
    self.viewDic = {}
    for viewName,viewPath in pairs(UIConfig[uiName].viewList) do
        if self.viewDic[viewName] == nil then
            --实例化UI预制体

            self.viewNeedNum = self.viewNeedNum + 1

            LoadMgr.Instance:LoadAsync(viewPath,typeof(GameObject),
                function(asset)
                    self.viewNeedNum = self.viewNeedNum - 1

                    local prefabGO = GameObject.Instantiate(asset)
                    local viewClass = require(viewName)
                    self.viewDic[viewName] = viewClass.New(prefabGO,parentTrans)
                    
                    --如果加载完成，执行回调
                    if self.viewNeedNum == 0 and self.callBack ~= nil then
                        self.callBack()
                    end

                end)
        end
    end
    
    --model实例化
    local modelClass = UIConfig[uiName].modelClass
    if modelClass ~= nil then
        self.model = modelClass.New()
    end

    self:RegisterEvents()
end
--view是否加载完成
function ControllerBase:IsViewInit()
    return self.viewNeedNum == 0
end

--显示界面
function ControllerBase:Show()
    if self.viewNeedNum ~= 0 then
        --如果还在加载中，将显示命令缓存
        self.callBack = function()
            self:Show()
            self.callBack = nil
        end
        return
    end

    for _,view in pairs(self.viewDic)do
        view:Show()
    end

    self:OnShow()
end
--显示时
function ControllerBase:OnShow() end
--隐藏时
function ControllerBase:OnHide() end

--隐藏界面
function ControllerBase:Hide()
    --如果还在加载中，忽略隐藏命令
    if self.viewNeedNum ~= 0 then
        return
    end

    for _,view in pairs(self.viewDic)do
        view:Hide()
    end

    self:OnHide()
end

--注册事件
function ControllerBase:RegisterEvents() end
--注销事件
function ControllerBase:UnRegisterEvents() end
--销毁
function ControllerBase:OnDestroy()
    self:UnRegisterEvents()
    
    --view
    --调用viewBase的Destroy方法
    if self.viewNeedNum ~= 0 then
        --如果view还在加载中，加载完成后再销毁
        self.callBack = function()
            for _,view in pairs(self.viewDic)do
                view:OnDestroy()
            end
            self.viewDic = nil
            self.callBack = nil
        end
    else
        for _,view in pairs(self.viewDic)do
            view:OnDestroy()
        end
        self.viewDic = nil
    end
    
    --model
    self.model = nil
end

return ControllerBase
