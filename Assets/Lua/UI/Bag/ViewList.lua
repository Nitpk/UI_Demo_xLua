--[[
作者：阳贻凡
ps：因为ViewList需要每帧更新格子，在lua侧帧更新开销更高，
    所以我打算ViewList还是作为组件挂载在ScrollView上，给lua这边提供接口调用。
    （lua版的ViewList还没写完）
--]]

local BaseClass = require("BaseClass")
--循环列表
local ViewList = BaseClass("ViewList", Object)
--列表方向
ViewList.directionType =
{
    Vertical = 0,
    Horizontal = 1
}

function ViewList:__init(scrollRect, cellTemplate, direction, rowCellCount, cellSpace)
    --列表组件
    self.scrollRect = scrollRect
    --内容组件
    self.content = scrollRect.content
    --视野
    self.viewport = scrollRect.viewport
    --格子预制体
    self.cellTemplate = cellTemplate
    --列表方向
    self.direction = direction or ViewList.directionType.Vertical
    --每行或每列的格子数量
    self.rowCellCount = rowCellCount or 1
    --格子间隔
    self.cellSpace = cellSpace or {x=0, y=0}
    --单元格尺寸
    self.cellSize = cellTemplate.transform.sizeDelta
    self.totalSize = self.cellSize + cellSpace
    --对象池管理
    self.cellPool = {}
    self.activeCells = {}
    
    -- 数据相关
    self.datas = {}
    self.onCellUpdate = nil -- 外部传入的更新回调
    
    -- 初始化锚点
    self:_InitAnchors()
    
    -- 注册滚动事件
    CS.xLuaHelper.AddListener(self.scrollRect.onValueChanged, function()
        self:UpdateDisplay()
    end)
end

function ViewList:_InitAnchors()
    self.content.anchorMin = Vector2(0, 1)
    self.content.anchorMax = Vector2(1, 1)
    
    --模板单元格锚点配置
    local cellTrans = self.cellTemplate.transform
    cellTrans.pivot = Vector2(0, 1)
    cellTrans.anchorMin = Vector2(0, 1)
    cellTrans.anchorMax = Vector2(0, 1)
end

-- 设置数据源
function ViewList:SetData(datas)
    self.datas = datas or {}
    self:_RecalculateContentSize()
    self:UpdateDisplay(true)
end

-- 重新计算内容尺寸
function ViewList:_RecalculateContentSize()
    local rowCount = math.ceil(#self.datas / self.rowCellCount)
    local height = rowCount * self.totalSize.y - self.cellSpace.y
    self.content.sizeDelta = Vector2(self.content.sizeDelta.x, height)
end

-- 核心更新逻辑
function ViewList:UpdateDisplay(forceRefresh)
    if #self.datas == 0 then
        self:_RecycleAllCells()
        return
    end
    
    local viewMin, viewMax = self:_GetViewBounds()
    self:_RemoveInvisibleCells(viewMin, viewMax)
    self:_AddVisibleCells(viewMin, viewMax, forceRefresh)
end

-- 获取可视区域边界
function ViewList:_GetViewBounds()
    local viewportRect = self.viewport.rect
    local contentPos = self.content.anchoredPosition.y
    return {
        min = -contentPos - viewportRect.height,
        max = -contentPos
    }
end

-- 回收不可见单元格
function ViewList:_RemoveInvisibleCells(viewMin, viewMax)
    for i = #self.activeCells, 1, -1 do
        local cell = self.activeCells[i]
        local posY = cell.transform.anchoredPosition.y
        
        if posY > viewMax or (posY + self.cellSize.y) < viewMin then
            table.remove(self.activeCells, i)
            self:_RecycleCell(cell)
        end
    end
end

-- 添加可见单元格
function ViewList:_AddVisibleCells(viewMin, viewMax, forceRefresh)
    local startRow = math.floor(viewMin / self.totalSize.y)
    local endRow = math.ceil(viewMax / self.totalSize.y)
    
    startRow = math.max(0, startRow - 1)
    endRow = math.min(self:_TotalRows() - 1, endRow + 1)
    
    for row = startRow, endRow do
        for col = 0, self.rowCellCount - 1 do
            local dataIndex = row * self.rowCellCount + col
            if dataIndex >= #self.datas then break end
            
            if not self:_HasCellAt(row, col) or forceRefresh then
                local cell = self:_GetCell(dataIndex, row, col)
                self:_UpdateCell(cell, dataIndex)
            end
        end
    end
end

-- 获取/创建单元格
function ViewList:_GetCell(dataIndex, row, col)
    -- 从对象池获取
    if #self.cellPool > 0 then
        local cell = table.remove(self.cellPool)
        cell.gameObject:SetActive(true)
        return cell
    end
    
    -- 创建新单元格
    local newCell = CS.UnityEngine.Object.Instantiate(
        self.cellTemplate, 
        self.content
    )
    newCell.gameObject:SetActive(true)
    table.insert(self.activeCells, newCell)
    return newCell
end

-- 更新单元格数据和位置
function ViewList:_UpdateCell(cell, dataIndex)
    local row = math.floor(dataIndex / self.rowCellCount)
    local col = dataIndex % self.rowCellCount
    
    -- 计算位置
    local posX = col * (self.cellSize.x + self.cellSpace.x)
    local posY = -row * self.totalSize.y
    cell.transform.anchoredPosition = Vector2(posX, posY)
    
    -- 回调外部更新逻辑
    if self.onCellUpdate then
        self.onCellUpdate(cell, self.datas[dataIndex + 1], dataIndex + 1) -- Lua索引从1开始
    end
end

-- 回收单元格到对象池
function ViewList:_RecycleCell(cell)
    cell.gameObject:SetActive(false)
    table.insert(self.cellPool, cell)
end

-- 清空所有单元格
function ViewList:_RecycleAllCells()
    for _, cell in ipairs(self.activeCells) do
        self:_RecycleCell(cell)
    end
    self.activeCells = {}
end

-- 其他辅助方法
function ViewList:_TotalRows()
    return math.ceil(#self.datas / self.rowCellCount)
end

function ViewList:_HasCellAt(row, col)
    -- 实现单元格存在性检查
    return false
end

return ViewList