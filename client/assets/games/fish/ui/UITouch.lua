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
            self:launcher()
            self:startTimer()
            return true
        elseif event.name == "moved" then
            self.touchPos = self:getTouchMovePosition()
        else
            self:stopTimer()
        end
    end
    self:onTouch(callback)
    self:setTouchEnabled(true)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
end

function M:launcher()
    self:post("onEventFire", 1, self.touchPos)
end

function M:startTimer()
    local function callback()
        self:launcher()
    end
    local tb = 
    {
        cc.DelayTime:create(0.25),
        cc.CallFunc:create(callback),
    }
    self:stopAllActions()
    self:runAction(cc.RepeatForever:create(cc.Sequence:create(tb)))
end

function M:stopTimer()
    self:stopAllActions()
end

return M