----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼组
----------------------------------------------------------------------

local M = class("GOFishArray", wls.FishObject)

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self:set("timeline_id", 0)
    self.mStartID = id
    self.mCurFrame = 0
end

function M:gotoFrame(frame)
    assert(frame >= 0, "error frame " .. frame)
    self:setAlive(true)
    self.mCurFrame = 0
    self.mFishData, self.mMaxFrame = self:find("SCConfig"):getFishArray(self.mStartID)
    local args = {}
    while self.mCurFrame <= frame do
        local unit = self.mFishData[self.mCurFrame]
        if unit then
            for _, val in ipairs(unit.fishes) do
                args.id = val.fishid
                args.path_id = tostring(val.trace +300000000)
                args.cur_frame = frame - self.mCurFrame
                args.offset = val.offset
                args.timeline_id = self:get("timeline_id")
                args.array_id = val.arrayid
                self:find("SCPool"):createFish(args)
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
    local args = {}
    for _, val in ipairs(unit.fishes) do
        args.id = val.fishid
        args.path_id = tostring(val.trace +300000000)
        args.cur_frame = 1
        args.offset = val.offset
        args.timeline_id = self:get("timeline_id")
        args.array_id = val.arrayid
        self:find("SCPool"):createFish(args)
    end
end

return M