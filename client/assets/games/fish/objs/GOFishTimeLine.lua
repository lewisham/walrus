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
    self.mFishData = self:find("SCConfig"):getFishTimeline(self.mStartID)
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
                local fish = self:find("SCPool"):createFish(unit.fishid, tostring(unit.pathid +300000000), 1)
                self:doBossWarnning(fish)
            end
        end
        if bAllUse and not unit.use then
            bAllUse = false
        end
    end
    self.alive = not bAllUse
end

function M:doBossWarnning(fish)
    if fish == nil then return end
    local config = fish.config
    local trace_type = tonumber(fish.config.trace_type)
    if trace_type ~= 5 and trace_type ~= 10 then return end
    self:createGameObject("UIBossComing"):play()
end

return M