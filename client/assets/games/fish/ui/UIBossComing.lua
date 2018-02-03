----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：boss 来临警告
----------------------------------------------------------------------

local M = class("UIBossComing", FCDefine.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uibosscome.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uibosscome.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

function M:play(name, rate)
    self:setVisible(true)
    local function callback()
        FCDefine.SafeRemoveNode(self)
    end
    --self.mTimelineAction:setLastFrameCallFunc(function() self:setVisible(false) end)
    self.mTimelineAction:gotoFrameAndPlay(0)
    self:callAfter(150 / 60.0, callback)
end

return M