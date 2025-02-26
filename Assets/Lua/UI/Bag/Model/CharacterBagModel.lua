--[[
作者：阳贻凡
--]]
local Dependence = require("Dependence")

--角色背包数据模型
local CharacterBagModel = Dependence.BaseClass("CharacterModel", Dependence.ModelBase)
CharacterBagModel.Name = "CharacterBagModel"

function CharacterBagModel:__init()
    --背包容量
    self.maxNum = 100
    --当前数量
    self.currentNum = 0
    --角色背包列表(有序)
    self.characterList = {}
    --角色字典
    self.characterDic = {}
    --当前背包的角色类型
    self.characterType = Dependence.CharacterType.All
    --角色阵容，5位角色
    self.teamList = {}

    --获得数据更新背包
    local dataDic = CS.Demo.LuaUtil.GetModelData()

    for id,character in pairs(dataDic) do
        --print(id, character.type)
        self:AddCharacter(character)
        self.characterDic[id] = character

        if character.isOnTeam then
            self.teamList[character.type] = character
        end
    end

    --当前高亮的角色id
    self.currentHighLightId = self.characterList[1].id
    --上一个高亮的角色id
    self.pastHighLightId = self.currentHighLightId
    
end

--根据类型筛选背包数据
function CharacterBagModel:GetList(characterType)
    local list = {}

    for i = 1,#self.characterList do
        local character = self.characterList[i]
        if characterType == Dependence.CharacterType.All
            or character.type == characterType then
            table.insert(list, character)
        end
    end

    return list
end

--添加角色
function CharacterBagModel:AddCharacter(character)
    --如果背包已满，无法添加
    if self.currentNum == self.maxNum then return end
    
    local flag = false
    for i = self.currentNum+1,2,-1 do
        --根据品质和等级排序
        if self.characterList[i-1].quality > character.quality
            or( self.characterList[i-1].quality == character.quality 
            and self.characterList[i-1].level > character.level) then
            
            --放在当前位置
            self.characterList[i] = character

            flag = true
            break
        end

        --交换并考虑下一个位置
        self.characterList[i] = self.characterList[i-1]

    end

    --如果还没有放入，放在最开头
    if not flag then
        self.characterList[1] = character
    end

    self.currentNum = self.currentNum + 1
end

return CharacterBagModel