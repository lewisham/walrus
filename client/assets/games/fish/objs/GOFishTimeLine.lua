----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼群时间线
----------------------------------------------------------------------

local M = class("GOFishTimeLine", u3a.FishObject)

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
    self.mMaxFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = 0
    self.mMaxFrame = 0
    self.mFishData, self.mMaxFrame = self:find("SCConfig"):getFishTimeline(self.mStartID)
    local args = {}
    local unit
    while self.mCurFrame < frame do
        self.mCurFrame = self.mCurFrame + 1
        unit = self.mFishData[self.mCurFrame]
        if unit then
            for _, val in ipairs(unit.fishes) do
                if val[1] == "100" then
                    --self:find("SCPool"):createFishArray(val[2], 1)
                else
                    args.id = val[1]
                    args.path_id = tostring(val[2] +300000000)
                    args.cur_frame = frame - self.mCurFrame
                    args.timeline_id = unit.id
                    self:find("SCPool"):createFish(args)
                end
            end
        end
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
        if val[1] == "100" then
            self:find("SCPool"):createFishArray(val[2], 1)
        else
            args.id = val[1]
            args.path_id = tostring(val[2] +300000000)
            args.cur_frame = 1
            local fish = self:find("SCPool"):createFish(args)
            self:doBossWarnning(fish)
        end
    end
end

function M:doBossWarnning(fish)
    if fish == nil then return end
    local config = fish.config
    local trace_type = tonumber(fish.config.trace_type)
    if trace_type ~= 5 and trace_type ~= 10 then return end
    self:createGameObject("UIBossComing"):play(fish.config.id, tonumber(fish.config.score))
end

return M