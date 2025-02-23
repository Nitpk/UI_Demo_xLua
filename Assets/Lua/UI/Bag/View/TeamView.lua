--[[
作者：阳贻凡
--]]
local BaseClass = require("BaseClass")
local ViewBase = require("ViewBase")
local LuaUtil = CS.Demo.LuaUtil
local EventSystem = require("EventSystem")
local EventType= require("EventType")
local TeamCharacterCell = require("TeamCharacterCell")
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