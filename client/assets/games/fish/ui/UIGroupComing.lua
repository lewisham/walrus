----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：鱼潮来临
----------------------------------------------------------------------

local M = class("UIGroupComing", UIBase)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uifishgroupcome.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uifishgroupcome.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
end

function M:play()
    self.mTimelineAction:setLastFrameCallFunc(function() SafeRemoveNode(self) end)
    self.mTimelineAction:gotoFrameAndPlay(0)
end

return M