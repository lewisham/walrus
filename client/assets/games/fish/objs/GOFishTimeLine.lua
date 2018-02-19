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
    local arrayArgs = {}
    local unit
    self.pool = self:find("SCPool")
    while self.mCurFrame < frame do
        self.mCurFrame = self.mCurFrame + 1
        unit = self.mFishData[self.mCurFrame]
        if unit then
            for _, val in ipairs(unit.fishes) do
                if val[1] == "100" then
                    arrayArgs.timeline_id = unit.id
                    arrayArgs.id = val[2]
                    arrayArgs.frame = frame - self.mCurFrame
                    self.pool:createFishArray(arrayArgs)
                else
                    args.id = val[1]
                    args.path_id = tostring(val[2] +300000000)
                    args.cur_frame = frame - self.mCurFrame
                    args.timeline_id = unit.id
                    self.pool:createFish(args)
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
    local arrayArgs = {}
    local fish = nil
    for _, val in ipairs(unit.fishes) do
        if val[1] == "100" then
            arrayArgs.timeline_id = unit.id
            arrayArgs.id = val[2]
            arrayArgs.frame = 1
            self.pool:createFishArray(arrayArgs)
        else
            args.id = val[1]
            args.path_id = tostring(val[2] +300000000)
            args.cur_frame = 1
            args.timeline_id = unit.id
            fish = self.pool:createFish(args)
            self:doBossWarnning(fish)
        end
    end
end

-- boss 警告
function M:doBossWarnning(fish)
    if fish == nil then return end
    local config = fish.config
    local trace_type = tonumber(fish.config.trace_type)
    if trace_type ~= 5 and trace_type ~= 10 then return end
    self:createGameObject("UIBossComing"):play(fish.config.id, tonumber(fish.config.score))
end

return M