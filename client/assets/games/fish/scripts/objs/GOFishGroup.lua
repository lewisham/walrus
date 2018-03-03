----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼潮
----------------------------------------------------------------------

local M = class("GOFishGroup", wls.FishObject)

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = 0
    self.mFishData, self.mMaxFrame = self:find("SCConfig"):getFishGroup(self.mStartID)
    local unit = nil
    local arrayArgs = {}
    while self.mCurFrame <= frame do
        unit = self.mFishData[self.mCurFrame]
        if unit then
            for _, val in ipairs(unit.fishes) do
                arrayArgs.timeline_id = val.id
                arrayArgs.id = val.fisharrid
                arrayArgs.frame = frame - self.mCurFrame
                self:find("SCPool"):createFishArray(arrayArgs)
            end
        end
        self.mCurFrame = self.mCurFrame + 1
    end
end

function M:updateFrame()
    self.mCurFrame = self.mCurFrame + 1
    self:doFrame()
    self.alive = self.mCurFrame < self.mMaxFrame
end

function M:doFrame()
    local unit = self.mFishData[self.mCurFrame]
    if unit == nil then return end
    local arrayArgs = {}
    for _, val in ipairs(unit.fishes) do
        arrayArgs.timeline_id = val.id
        arrayArgs.id = val.fisharrid
        arrayArgs.frame = 1
        self:find("SCPool"):createFishArray(arrayArgs)
    end
end

return M