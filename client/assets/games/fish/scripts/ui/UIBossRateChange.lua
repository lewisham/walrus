----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：boss 
----------------------------------------------------------------------

local M = class("UIBossRateChange", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/bossratechange/uibossratechange.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uibosscome.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

return M