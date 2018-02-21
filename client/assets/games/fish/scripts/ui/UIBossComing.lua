----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：boss 来临警告
----------------------------------------------------------------------

local M = class("UIBossComing", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uibosscome.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uibosscome.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

function M:play(id, rate)
    id = id - 100000000
    local filename = string.format("ui/images/bosscome/title_pic_%d.png", id)
    self.spr_bosscome:setSpriteFrame(self:fullPath(filename))
    self:find("SCSound"):playSound("bossalert_01")
    self:find("SCSound"):playMusic("music_bosscome")
    self:setVisible(true)
    local function callback()
        wls.SafeRemoveNode(self)
    end
    self.fnt_Rate:setString(rate)
    self.mTimelineAction:gotoFrameAndPlay(0)
    self:callAfter(150 / 60.0, callback)
end

return M