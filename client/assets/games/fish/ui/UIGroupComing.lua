----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：鱼潮来临
----------------------------------------------------------------------

local M = class("UIGroupComing", u3a.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uifishgroupcome.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uifishgroupcome.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

function M:play()
    self:setVisible(true)
    local function callback()
        u3a.SafeRemoveNode(self)
    end
    --self.mTimelineAction:setLastFrameCallFunc(function() self:setVisible(false) end)
    self.mTimelineAction:gotoFrameAndPlay(0)
    self:callAfter(160 / 60.0, callback)
end

return M