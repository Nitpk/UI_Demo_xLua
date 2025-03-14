--[[
作者：阳贻凡
--]]


--阵容视图
local TeamView = BaseClass("TeamView", ViewBase)
TeamView.Name = "TeamView"


function TeamView:InitComponents()
    self.cells ={}
    
    self.cells[1] = TeamCharacterCell.New(self.transform:Find("TeamCell1"))
    self.cells[2] = TeamCharacterCell.New(self.transform:Find("TeamCell2"))
    self.cells[3] = TeamCharacterCell.New(self.transform:Find("TeamCell3"))
    self.cells[4] = TeamCharacterCell.New(self.transform:Find("TeamCell4"))
    self.cells[5] = TeamCharacterCell.New(self.transform:Find("TeamCell5"))

end

function TeamView:AddListener()
    --阵容角色格子
    for i = 1 ,#self.cells do
        self.cells[i].teamBtn.onClick:AddListener(
            function()
                EventSystem.GetInstance():Trigger(EventType.CHARACTER_BAG.CLICK_TEAM
                    ,self.cells[i].cId)
            end)
    end
end

function TeamView:RemoveListener()
    for i = 1 ,#self.cells do
        self.cells[i].teamBtn.onClick:RemoveAllListeners()
    end
end

--设置上阵
function TeamView:SetTeam(cInfo)
    self.cells[cInfo.type]:UpdateCell(cInfo)
end
--高亮
function TeamView:Highlight(type,isHighLight,cId)
    if self.cells[type].cId == cId then
        self.cells[type]:Highlight(isHighLight)
    end
end

return TeamView