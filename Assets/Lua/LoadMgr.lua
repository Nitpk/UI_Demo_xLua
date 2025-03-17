--[[
    作者：阳贻凡

    这里的资源加载类是简化版的，只是为了简单模拟一下延迟，
    没有做资源的缓存，
    也没有处理多个异步加载同一个资源、异步途中取消和加载失败等情况的处理。
]]


--资源加载
local LoadMgr = BaseClass("LoadMgr",Object)

--等待时间
LoadMgr.wait = CS.UnityEngine.WaitForSeconds(0.5)

--模拟异步加载
function LoadMgr.LoadAsync(assetPath,assetType,callBack)
    assert(type(assetPath)=="string" and #assetPath > 0 and assetType ~= nil)

    print(assetPath.."加载中,模拟假设需0.5秒")
    local asset = Resources.Load(assetPath,assetType)

    coroutine.yield(LoadMgr.wait)
    print("加载完成，执行回调")

    if callBack ~= nil then
        callBack(asset)
    end
    
end



return LoadMgr