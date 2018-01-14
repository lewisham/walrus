----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼群时间线
----------------------------------------------------------------------

local M = class("GOFishTimeLine", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = frame
    local id = self.mStartID or 320101001
    local timeline = self:require("timeline")
    local tb = {}
    while true do
        local config = timeline[tostring(id)]
        if config == nil then break end
        if config.fishid == "" then break end
        id = id + 1
        local unit = {}
        unit.fishid = config.fishid
        unit.frame = tonumber(config.frame)
        unit.pathid = config.pathid
        unit.use = false
        table.insert(tb, unit)
    end
    self.mFishData = tb
end

function M:updateFrame()
    self.mCurFrame = self.mCurFrame + 1
    local bAllUse = true
    for _, unit in ipairs(self.mFishData) do
        if unit.frame == self.mCurFrame then
            unit.use = true
            if unit.fishid == "100" then
                self:find("SCPool"):createFishArray(unit.pathid, 1)
            else
                self:find("SCPool"):createFish(unit.fishid, tostring(unit.pathid +300000000), 1)
            end
        end
        if bAllUse and not unit.use then
            bAllUse = false
        end
    end
    self.alive = not bAllUse
end

return M