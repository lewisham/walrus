----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼潮
----------------------------------------------------------------------

local M = class("GOFishGroup", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = frame
    local id = 330000000 + self.mStartID * 100000
    local fishgroup = self:require("fishgroup")
    local tb = {}
    while true do
        local config = fishgroup[tostring(id)]
        if config == nil then break end
        if config.arrId == "" then break end
        id = id + 1
        local unit = {}
        unit.fisharrid = config.arrId
        unit.frame = tonumber(config.frame)
        unit.endframe = config.endframe
        unit.use = false
        table.insert(tb, unit)
    end
    self.mFishData = tb
end

function M:updateFrame()
    local bAllUse = true
    for _, unit in ipairs(self.mFishData) do
        if unit.frame == self.mCurFrame then
            unit.use = true
            self:find("SCPool"):createFishArray(unit.fisharrid, 1)
        end
        if bAllUse and not unit.use then
            bAllUse = false
        end
    end
    self.alive = not bAllUse
    self.mCurFrame = self.mCurFrame + 1
end

return M