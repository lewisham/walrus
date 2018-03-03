----------------------------------------------------------------------
-- 作者：lps
-- 日期：2018-2-27
-- 描述：时光沙漏回朔动画
----------------------------------------------------------------------

local M = class("UITimehourRevert", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/hourglass/uihourglasssecond.csb"))
    self:setPosition(display.width / 2, display.height / 2)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/hourglass/uihourglasssecond.csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.mTimelineAction = action
    self:setVisible(false)
end

function M:play(aimCount,curCount)
    
    self:find("SCSound"):playSound("congrat_01")
    self:setVisible(true)
    self:stopTimer(1)
    self.BitmapFontLabel_1:setString(math.floor(curCount))
    local allTime = 1.5
    local disTime = 0.05
    local curTime = 0
    local func = function ( )
        curTime = curTime +disTime
        local curNumCount = curCount + (curTime/allTime)*(aimCount - curCount)
        self.BitmapFontLabel_1:setString(math.floor(curNumCount))
        if aimCount >= curCount then
            if curNumCount >= aimCount then
                self.BitmapFontLabel_1:setString(math.floor(aimCount))
                self:stopTimer(1)
            end
        else
            if curNumCount <= aimCount then
                self.BitmapFontLabel_1:setString(math.floor(aimCount))
                self:stopTimer(1)
            end
        end

    end
    self:startTimer(disTime,func,1,-1)

    local function callback()
        Log("-----Timeback----SafeRemoveNode-----------")
        wls.SafeRemoveNode(self)
        --收取鱼币动画
    end

    self.mTimelineAction:play("revert",false)
    self:callAfter(180 / 60.0, callback)
    return 2.5
end

return M