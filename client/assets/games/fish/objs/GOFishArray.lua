----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼组
----------------------------------------------------------------------

local M = class("GOFishArray", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.mStartID = id
    self.mCurFrame = 0
end

function M:gotoFrame(frame)
    self:setAlive(true)
    self.mCurFrame = frame
    local id = 310000000 + self.mStartID * 1000
    local fisharray = self:require("fisharray")
    local tb = {}
    while true do
        local config = fisharray[tostring(id)]
        if config == nil then break end
        if config.fishid == "" then break end
        id = id + 1
        local unit = {}
        unit.fishid = config.fishid
        unit.frame = tonumber(config.frame)
        unit.pathid = config.trace
        unit.offset = cc.p(tonumber(config.offsetx), tonumber(config.offsety))
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
            self:find("SCPool"):createFish(unit.fishid, tostring(unit.pathid +300000000), 1, unit.offset)
        end
        if bAllUse and not unit.use then
            bAllUse = false
        end
    end
    self.alive = not bAllUse
end

return M