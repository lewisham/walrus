----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：点击层
----------------------------------------------------------------------

local M = class("UITouch", UIBase)

function M:onCreate()
    self:setContentSize(cc.size(display.width, display.height))
    self.touchPos = cc.p(0, 0)
    local function callback(event)
        if event.name == "began" then
            self.touchPos = self:getTouchBeganPosition()
            self:startTimer()
            return true
        elseif event.name == "moved" then
            self.touchPos = self:getTouchMovePosition()
        elseif not self.bAutoFire then
            self:stopTimer()
        end
    end
    self.bAutoFire = true
    self.bTimer = false
    self:onTouch(callback)
    self:setTouchEnabled(false)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
end

function M:launcher()
    self:post("onEventFire", 1, self.touchPos)
end

function M:startTimer()
    if self.bTimer then return end
    self.bTimer = true
    self:launcher()
    local function callback()
        self:launcher()
    end
    local tb = 
    {
        cc.DelayTime:create(FCDefine.BULLET_LANCHER_INTERVAL),
        cc.CallFunc:create(callback),
    }
    self:runAction(cc.RepeatForever:create(cc.Sequence:create(tb)))
end

function M:stopTimer()
    self.bTimer = false
    self:stopAllActions()
end

return M