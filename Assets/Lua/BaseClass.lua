--[[
作者：阳贻凡
--]]

--面向对象功能
local BaseClass = function(className, parent)
    -- 确保类名不为空
    assert(type(className) == "string" and #className > 0,"类名不合法")
    -- 检查父类是否正确
    if className == "Object" then
        --如果是Object类，父类必须为空
        parent = nil
    else
        parent = parent or nil
    end

    -- 创建新类表
    local newClass = {}
    newClass.__index = newClass
    newClass._classType = className
    newClass.base = parent

    -- 设置元表
    local mt = {}
    -- 设置继承关系
    if parent then
        mt.__index = parent
        mt.__newindex = parent.__newindex
    end

    -- 实现子类默认调用init方法
    -- 子类的init方法参数顺序需要和父类的一致，新加的参数需要放在后面
    mt.__newindex = function(t, k, v)
        if k == "__init" then
            local parent_init = parent and parent.__init
            rawset(t, k, function(self, ...)
                --先执行父类的构造函数
                if parent_init then
                    parent_init(self, ...)
                end
                v(self, ...)
            end)
        else
            rawset(t, k, v)
        end
    end  

    setmetatable(newClass, mt)

    -- 添加New方法
    function newClass.New(...)
        local instance = setmetatable({}, newClass)
        if newClass.__init then
            newClass.__init(instance, ...)
        end
        return instance
    end

    return newClass
end

-- Object基类定义
Object = BaseClass("Object",nil)
function Object:__init() end


return BaseClass