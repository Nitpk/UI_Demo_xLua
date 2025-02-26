--[[
作者：阳贻凡
--]]

local Dependence = require("Dependence")
--角色展示视图
local DisplayView = Dependence.BaseClass("DisplayView", Dependence.ViewBase)
DisplayView.Name = "DisplayView"

--字符串常量
DisplayView.LevelStr = "Lv."
DisplayView.TypeStr = "类型"
DisplayView.OnTeamStr = "已上阵"
DisplayView.TeamStr = "上阵"

function DisplayView:InitComponents()
    --文本组件初始化 
    self.qualityText = Dependence.LuaUtil.GetText(self.transform,"QualityText")
    self.typeText = Dependence.LuaUtil.GetText(self.transform,"TypeText")
    self.levelText = Dependence.LuaUtil.GetText(self.transform,"LevelText")
    self.nameText = Dependence.LuaUtil.GetText(self.transform,"NameText")

    -- 星级组初始化
    local groupTrans = self.transform:Find("StarGroup")
    self.starGroup = {
        [1]=Dependence.LuaUtil.GetImage(groupTrans,"StarImage (4)"),
        [2]=Dependence.LuaUtil.GetImage(groupTrans,"StarImage (3)"),
        [3]=Dependence.LuaUtil.GetImage(groupTrans,"StarImage (2)"),
        [4]=Dependence.LuaUtil.GetImage(groupTrans,"StarImage (1)"),
        [5]=Dependence.LuaUtil.GetImage(groupTrans,"StarImage"),
    }

    -- 按钮组件初始化
    self.teamBtn = Dependence.LuaUtil.GetButton(self.transform,"TeamBtn")
    self.teamText = Dependence.LuaUtil.GetText(self.teamBtn.transform,"Text (Legacy)")
    
    --角色模型（临时）
    self.characterLoaded = nil

    --角色模型坐标
    self.pos ={}
    self.pos.x ,self.pos.y = Dependence.LuaUtil.GetUIZeroWorldPosition(self.transform)
end

function DisplayView:AddListener()
    --上阵按钮
    self.teamBtn.onClick:AddListener(
        function()
            Dependence.EventSystem.GetInstance():Trigger(Dependence.EventType.CHARACTER_BAG.CLICK_UP_TEAM)
        end)
end

function DisplayView:RemoveListener()
    self.teamBtn.onClick:RemoveAllListeners()
end


function DisplayView:OnShow()
    if self.characterLoaded ~= nil then
        self.characterLoaded:SetActive(true)
    end
end

function DisplayView:OnHide()
    if self.characterLoaded ~= nil then
        self.characterLoaded:SetActive(false)
    end
end

--更新角色UI
function DisplayView:UpdateCharacter(character)
    --加载角色模型
    if self.characterLoaded == nil then
        self.characterLoaded = GameObject.Instantiate(Resources.Load("Character",typeof(GameObject)),
                                                        self.transform)   
    end
    Dependence.LuaUtil.SetPosition(self.characterLoaded,self.pos.x,self.pos.y)

    --更新文本信息
    self.nameText.text = character.name
    self.strBuilder:Clear()
    self.strBuilder:Append(DisplayView.LevelStr)
    self.strBuilder:Append(tostring(character.level))
    self.levelText.text = self.strBuilder:ToString()
    self.strBuilder:Clear()
    self.strBuilder:Append(DisplayView.TypeStr)
    self.strBuilder:Append(tostring(character.type))
    self.typeText.text = self.strBuilder:ToString()

    --更新品质和星级
    self:SetStar(character.quality)

    --更新队伍状态显示
    self.teamText.text = character.isOnTeam and DisplayView.OnTeamStr or DisplayView.TeamStr

end
--设置品质星级
function DisplayView:SetStar(quality)
    --设置品质
    self.qualityText.text = Dependence.CharacterQualityStr[quality];

    --设置星级
    for i = 1,5 do
        if i <= quality then 
            self.starGroup[i].canvasRenderer:SetAlpha(1)
        else 
            self.starGroup[i].canvasRenderer:SetAlpha(0)
        end
    end
end
--更新上阵按钮状态
function DisplayView:SetTeamButtonState(isOnTeam)
    if isOnTeam then
        self.teamText.text = DisplayView.OnTeamStr
    else
        self.teamText.text = DisplayView.TeamStr
    end
end

return DisplayView