--[[
作者：阳贻凡
--]]

--阵容角色格子
local TeamCharacterCell = BaseClass("TeamCharacterCell",Object)

--头像图片路径
TeamCharacterCell.path = "ArtRes/"

--字符串常量
TeamCharacterCell.LevelStr = "Lv."

function TeamCharacterCell:__init(transform)
    self.transform = transform
    self.gameObject = transform.gameObject
    
    self:InitComponents(transform)
end

function TeamCharacterCell:InitComponents(transform)
    --基础组件
    self.teamBtn = LuaUtil.GetButton(transform)
    
    --文本组件
    self.qualityText = LuaUtil.GetText(transform,"QualityText")
    self.levelText = LuaUtil.GetText(transform,"LevelText")

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
        self.starGroup[i] = LuaUtil.GetImage(groupTrans,starPaths[i])
    end

    --头像组件
    self.headImage = LuaUtil.GetImage(transform,"HeadImage")
    --高亮组件
    self.highlight = LuaUtil.GetImage(transform)
    --当前角色id
    self.cId = -1
end

--更新格子UI
function TeamCharacterCell:UpdateCell(cInfo)
    if not cInfo then
        return
    end

    self.cId = cInfo.id
    --加载图片
    StartCoroutine(LoadMgr.LoadAsync,TeamCharacterCell.path..cInfo.headPath,typeof(Sprite),
    function(asset)
        self.headImage.sprite = asset
    end
    )
    
    self:SetStar(cInfo.quality)

    ViewBase.strBuilder:Clear()
    ViewBase.strBuilder:Append(TeamCharacterCell.LevelStr)
    ViewBase.strBuilder:Append(tostring(cInfo.level))
    self.levelText.text = ViewBase.strBuilder:ToString()
    
end
--设置品质星级
function TeamCharacterCell:SetStar(quality)
    self.qualityText.text = CharacterQualityStr[quality]

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
function TeamCharacterCell:Highlight(inHighlight)
    if inHighlight then
        self.highlight.color = Color.yellow
    else
        self.highlight.color = Color.white
    end
end

return TeamCharacterCell