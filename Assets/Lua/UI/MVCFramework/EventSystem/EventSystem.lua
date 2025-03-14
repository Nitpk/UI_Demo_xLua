--[[
作者：阳贻凡
--]]

--事件系统
local EventSystem = BaseClass("EventSystem", Object)
EventSystem.instance = nil

--得到单例
function EventSystem.GetInstance()
    if EventSystem.instance == nil then
        EventSystem.instance = EventSystem.New()
    end
    return EventSystem.instance
end
function EventSystem:__init()
    EventSystem.events = {}
end

--注册事件
function EventSystem:Register(eventName, callback)
    if not EventSystem.events[eventName] then
        EventSystem.events[eventName] = {}
    end
    table.insert(EventSystem.events[eventName], callback)
end
--触发事件
function EventSystem:Trigger(eventName, ...)
    local listeners = EventSystem.events[eventName]
    if listeners then
        for _, callback in ipairs(listeners) do
            callback(...)
        end
    end
end
--移除事件
function EventSystem:Remove(eventName, callback)
    local listeners = EventSystem.events[eventName]
    if listeners then
        for i = #listeners, 1, -1 do
            if listeners[i] == callback then
                table.remove(listeners, i)
            end
        end
    end
end

--移除所有事件
function EventSystem:RemoveAll(eventName)
    if EventSystem.events[eventName] then
        EventSystem.events[eventName]={}
    end
end


return EventSystem
