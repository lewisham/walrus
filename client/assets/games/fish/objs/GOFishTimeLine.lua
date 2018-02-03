----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼群时间线
----------------------------------------------------------------------

local M = class("GOFishTimeLine", FCDefine.FishObject)

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
    self.mMaxFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = frame
    self.mMaxFrame = 0
    self.mFishData, self.mMaxFrame = self:find("SCConfig"):getFishTimeline(self.mStartID)
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
        if val[1] == "100" then
            self:find("SCPool"):createFishArray(val[2], 1)
        else
            local fish = self:find("SCPool"):createFish(val[1], tostring(val[2] +300000000), 1)
            self:doBossWarnning(fish)
        end
    end
end

function M:doBossWarnning(fish)
    if fish == nil then return end
    local config = fish.config
    local trace_type = tonumber(fish.config.trace_type)
    if trace_type ~= 5 and trace_type ~= 10 then return end
    self:createGameObject("UIBossComing"):play()
end

return M