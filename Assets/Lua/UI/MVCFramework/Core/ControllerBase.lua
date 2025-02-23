--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
--控制器基类
local ControllerBase = BaseClass("ControllerBase", Object)
ControllerBase.Name = "ControllerBase"

function ControllerBase:__init(view, model)
    self.view = view
    self.model = model
    self:RegisterEvents()
end
--注册事件
function ControllerBase:RegisterEvents() end
--注销事件
function ControllerBase:UnRegisterEvents() end
--销毁
function ControllerBase:OnDestroy()
    self:UnRegisterEvents()
    self.view = nil
    self.model = nil
end

return ControllerBase
