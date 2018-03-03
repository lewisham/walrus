----------------------------------------------------------------------
-- 作者：lps
-- 日期：2018-2-27
-- 描述：时光沙漏启动动画
----------------------------------------------------------------------

local M = class("UITimehourBanner", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/hourglass/uihourglassfirst.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/hourglass/uihourglassfirst.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

function M:play(tiemCount)
    
    self:find("SCSound"):playSound("hourglass_01")
    self:setVisible(true)
    local function callback()
        wls.SafeRemoveNode(self)
    end

    self.mTimelineAction:gotoFrameAndPlay(0)
    self:callAfter(180 / 60.0, callback)

    self.tiemCount = tiemCount
    self.fnt:setString(tiemCount)
    local func = function ( ... )
        self.tiemCount = self.tiemCount -1
        self.fnt:setString(self.tiemCount)
    end
    self:startTimer(1,func,1,-1)
end

return M