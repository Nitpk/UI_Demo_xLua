--[[
作者：阳贻凡
--]]


--角色背包数据模型
local CharacterBagModel = BaseClass("CharacterModel",  ModelBase)
CharacterBagModel.Name = "CharacterBagModel"

function CharacterBagModel:__init()
    --背包容量
    self.maxNum = 100
    --当前数量
    self.currentNum = 0
    --每次增加的容量数
    self.deltaNum = 1
    --角色背包列表(有序)
    self.characterList = {}
    --角色字典
    self.characterDic = {}
    --当前背包的角色类型
    self.characterType =  CharacterType.All
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
        if characterType ==  CharacterType.All
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
--更新高亮角色ID
function CharacterBagModel:UpdateHighlightID(characterID)
    if characterID == self.currentHighLightId then return end
    
    self.pastHighLightId = self.currentHighLightId
    self.currentHighLightId = characterID
end
--得到当前高亮角色ID
function CharacterBagModel:GetHighlightID()
    return self.currentHighLightId
end
--得到上一个高亮角色ID
function CharacterBagModel:GetHighlightID_Past()
    return self.pastHighLightId
end

--得到当前背包的角色类型
function CharacterBagModel:GetBagCharacterType()
    return self.characterType
end
--设置背包角色类型
function CharacterBagModel:SetBagCharacterType(characterType)
    self.characterType = characterType
end
--得到当前角色数量
function CharacterBagModel:GetCurrentCharacterNum()
    return self.currentNum
end
--得到背包容量
function CharacterBagModel:GetBagCapacity()
    return self.maxNum
end
--增加背包容量
function CharacterBagModel:AddBagCapacity()
    self.maxNum = self.maxNum + self.deltaNum
end
--根据ID得到角色信息（在所有角色中找）
function CharacterBagModel:GetCharacterInfo(characterID)
    return self.characterDic[characterID]
end
--根据角色类型得到角色信息（在已上阵的角色中找）
function CharacterBagModel:GetCharacterInfoOnTeam(characterType)
    return self.teamList[characterType]
end
--得到阵容角色列表
function CharacterBagModel:GetTeamList()
    return self.teamList
end
--设置上阵角色数据
function CharacterBagModel:SetCharacterOnTeam(characterID)
    local characterInfo = self.characterDic[characterID]
    self.teamList[characterInfo.type] = characterInfo
end

return CharacterBagModel