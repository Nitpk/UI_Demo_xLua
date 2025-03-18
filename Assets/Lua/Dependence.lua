--[[
作者：阳贻凡
--]]


local config = {
    --Lua内的类
    LuaDic = {
        BaseClass = "BaseClass",
        ControllerBase = "ControllerBase",
        ModelBase = "ModelBase",
        ViewBase = "ViewBase",
        EventSystem = "EventSystem",
        EventType= "EventType",
        CharacterType = "CharacterType",
        CharacterQuality = "CharacterQuality",
        CharacterQualityStr = "CharacterQualityStr",
        UIConfig = "UIConfig",
        UINames = "UINames",
        UIManager = "UIManager",
        TeamCharacterCell = "TeamCharacterCell",
        CharacterCell = "CharacterCell",
        ViewNames = "ViewNames"
    },
    --C#的类
    CSharpDic = {
        LuaUtil = CS.Demo.LuaUtil,
        --Unity
        --常用命名空间别名
        GameObject = CS.UnityEngine.GameObject,
        Transform = CS.UnityEngine.Transform,
        Vector3 = CS.UnityEngine.Vector3,
        Color = CS.UnityEngine.Color,
        Screen = CS.UnityEngine.Screen,
        Camera = CS.UnityEngine.Camera,
        Resources = CS.UnityEngine.Resources,

        -- UI相关
        RectTransform = CS.UnityEngine.RectTransform,
        Canvas = CS.UnityEngine.Canvas,
        Image = CS.UnityEngine.UI.Image,
        Text = CS.UnityEngine.UI.Text,
        Button = CS.UnityEngine.UI.Button,
        ScrollRect = CS.UnityEngine.UI.ScrollRect,
        Toggle = CS.UnityEngine.UI.Toggle,
        Sprite = CS.UnityEngine.Sprite,

        Events = CS.UnityEngine.Events,

        LoadMgr = CS.Demo.LoadMgr
    }
    
}

--为G表设置元表
local mt = 
{
    
    __index = function(table,key)
        assert(type(key)=="string" and #key > 0)

        if config.CSharpDic[key] then
            return config.CSharpDic[key]
        elseif config.LuaDic[key] then
            local module = require(config.LuaDic[key])
            table[key] = module
            return module
        else
            return nil
        end
    end
}

setmetatable(_G,mt)