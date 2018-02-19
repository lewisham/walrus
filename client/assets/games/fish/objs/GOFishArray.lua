----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼组
----------------------------------------------------------------------

local M = class("GOFishArray", u3a.FishObject)

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
    self.timeline_id = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = frame
    self.mFishData, self.mMaxFrame = self:find("SCConfig"):getFishArray(self.mStartID)
    self:doFrame()
end


function M:updateFrame()
    self.mCurFrame = self.mCurFrame + 1
    self:doFrame()
    self.alive = self.mCurFrame < self.mMaxFrame
end

function M:doFrame()
    local unit = self.mFishData[self.mCurFrame]
    if unit == nil then return end
    for _, val in ipairs(unit.fishes) do
        self:find("SCPool"):createFish(val[1], tostring(val[2] +300000000), 1, val[3])
    end
end

return M