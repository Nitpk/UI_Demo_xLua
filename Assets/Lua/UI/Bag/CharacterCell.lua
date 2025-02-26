--[[
作者：阳贻凡
--]]

local Dependence = require("Dependence")
--阵容角色格子
local CharacterCell = Dependence.BaseClass("CharacterCell",Dependence.Object)

--角色图片路径
CharacterCell.path = "ArtRes/"

--字符串常量
CharacterCell.LevelStr = "Lv."
CharacterCell.TypeStr = "类型"


function CharacterCell:__init(gameObject)
    self.transform = gameObject.transform
    self.gameObject = gameObject

    self:InitComponents(self.transform)
end

function CharacterCell:InitComponents(transform)
    --基础组件
    self.characterBtn = Dependence.LuaUtil.GetButton(transform)
    
    --文本组件
    self.qualityText = Dependence.LuaUtil.GetText(transform,"QualityText")
    self.typeText = Dependence.LuaUtil.GetText(transform,"TypeText")
    self.levelText = Dependence.LuaUtil.GetText(transform,"LevelText")

    --星级组处理
    self.starGroup = {}
    local groupTrans = transform:Find("StarGroup")
    local starPaths = {
        "StarImage",
        "StarImage (1)",
        "StarImage (2)",
        "StarImage (3)",
        "StarImage (4)"
    } 
    for i=1,5 do
        self.starGroup[i] = Dependence.LuaUtil.GetImage(groupTrans,starPaths[i])
    end

    
    self.characterImage = Dependence.LuaUtil.GetImage(transform,"CharacterImage")
    self.teamImage = Dependence.LuaUtil.GetImage(transform,"TeamImage")
    self.highlight = Dependence.LuaUtil.GetImage(transform)
    --当前角色id
    self.cId = -1

end


--更新格子UI
function CharacterCell:UpdateCell(cInfo,highlightId)
    if not cInfo then
        return
    end

    self.characterImage.sprite = Resources.Load(CharacterCell.path..cInfo.imagePath,typeof(Sprite))
    self:SetStar(cInfo.quality)
    --更新角色等级
    Dependence.ViewBase.strBuilder:Clear()
    Dependence.ViewBase.strBuilder:Append(CharacterCell.LevelStr)
    Dependence.ViewBase.strBuilder:Append(tostring(cInfo.level))
    self.levelText.text = Dependence.ViewBase.strBuilder:ToString()
    --更新角色类型
    Dependence.ViewBase.strBuilder:Clear()
    Dependence.ViewBase.strBuilder:Append(CharacterCell.TypeStr)
    Dependence.ViewBase.strBuilder:Append(tostring(cInfo.type))
    self.typeText.text = Dependence.ViewBase.strBuilder:ToString()
    --更新上阵状态
    self:SetTeam(cInfo.isOnTeam)
    --更新高亮
    self:Highlight(highlightId == cInfo.id)

    self.cId = cInfo.id
end
--设置品质星级
function CharacterCell:SetStar(quality)
    self.qualityText.text = Dependence.CharacterQualityStr[quality]

    --设置星级
    for i = 1,5 do
        if i <= quality then 
            self.starGroup[i].canvasRenderer:SetAlpha(1)
        else 
            self.starGroup[i].canvasRenderer:SetAlpha(0)
        end
    end
end
--设置高亮
function CharacterCell:Highlight(inHighlight)
    if inHighlight then
        self.highlight.color = Color.yellow
    else
        self.highlight.color = Color.white
    end
end
--设置上阵状态
function CharacterCell:SetTeam(isOnTeam)
    if isOnTeam then
        self.teamImage.canvasRenderer:SetAlpha(1)
    else
        self.teamImage.canvasRenderer:SetAlpha(0)
    end
end

return CharacterCell