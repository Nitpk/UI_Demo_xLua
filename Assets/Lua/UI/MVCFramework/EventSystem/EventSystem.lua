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
function EventSystem:Register(eventName, callback,c_self)
    if eventName == nil or callback == nil then
        return
    end

    if EventSystem.events[eventName] == nil then
        EventSystem.events[eventName] = {}
    end

    table.insert(EventSystem.events[eventName], {_callback=callback,_self = c_self})
end
--触发事件
function EventSystem:Trigger(eventName, ...)
    if eventName == nil then
        return
    end

    local listeners = EventSystem.events[eventName]
    if listeners ~= nil then
        for _, callbackTable in ipairs(listeners) do

            if callbackTable._self ~= nil then
                callbackTable._callback(callbackTable._self,...)
            else
                callbackTable._callback(...)
            end

        end
    end
end
--移除事件
function EventSystem:Remove(eventName, callback)
    if eventName == nil or callback == nil then
        return
    end

    local listeners = EventSystem.events[eventName]
    if listeners then
        for i = #listeners, 1, -1 do
            if listeners[i]._callback == callback then
                --TODO 这里事件如果不用保持有序，则可以把要移除的事件交换到数组末尾再移除，提高性能

                table.remove(listeners, i)

            end
        end
    end
end

--移除所有事件
function EventSystem:RemoveAll(eventName)
    if EventSystem.events[eventName] ~= nil then
        EventSystem.events[eventName]={}
    end
end


return EventSystem
