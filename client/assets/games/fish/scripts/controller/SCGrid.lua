----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：格子类
----------------------------------------------------------------------

local GRID_CNT = 4
local GRID_WIDTH = display.width / GRID_CNT
local GRID_HEIGHT = display.height / GRID_CNT

local function convertIdx(pos)
    return math.floor(pos.y / GRID_HEIGHT) * GRID_CNT + math.ceil(pos.x / GRID_WIDTH)
end

local M = class("SCGrid", wls.GameObject)

function M:onCreate()
    self.mGridList = {}
    local idx = 1
    for y = 1, GRID_CNT do
        for x = 1, GRID_CNT do
            local unit = {}
            unit.idx = idx
            unit.fishes = {}
            table.insert(self.mGridList, unit)
            idx = idx + 1
        end
    end
end

function M:reset()
    for _, unit in ipairs(self.mGridList) do
        unit.fishes = {}
    end
end

function M:addFish(fishIdx, pos)
    local idx = convertIdx(pos)
    if self.mGridList[idx] then
        self.mGridList[idx].fishes[fishIdx] = 1
    end
end

function M:addFishRef(fishIdx, points, pos)
    self:addFish(fishIdx, pos)
    for _, point in ipairs(points) do
        self:addFish(fishIdx, point)
    end
end

function M:getFishesByPos(pos)
    local idx = convertIdx(pos)
    if self.mGridList[idx] then
        return self.mGridList[idx].fishes
    end
end

function M:getFishesByPoints(points)
    local list = {}
    for _, pos in ipairs(points) do
        local tb = self:getFishesByPos(pos)
        if tb then
            for idx, _ in pairs(tb) do
                list[idx] = 0
            end
        end
    end
    return list
end

return M