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
    local args = {}
    for _, val in ipairs(unit.fishes) do
        args.id = val[1]
        args.path_id = tostring(val[2] +300000000)
        args.cur_frame = 1
        args.offset = val[3]
        self:find("SCPool"):createFish(args)
    end
end

return M