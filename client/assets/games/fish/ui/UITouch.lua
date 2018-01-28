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
            self:createUnnameObject("UIBomb", self.touchPos)
            self:startTimer()
            return true
        elseif event.name == "moved" then
            self.touchPos = self:getTouchMovePosition()
            self:updateAngle()
        elseif not self:getScene():get("auto_fire") then
            self.bStopTimer = true
        end
    end
    self.bTimer = false
    self.bStopTimer = false
    self:onTouch(callback)
    self:setTouchEnabled(false)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
end

function M:updateAngle()
    local viewID = self:getScene():get("view_id")
    local cannon = self:find("UICannon" .. viewID)
    local vec = cc.pSub(self.touchPos, cannon.cannonWorldPos)
    local angle = math.atan2(vec.y, vec.x) * 180 / PI
    cannon:updateAngle(angle)
end

function M:launcher()
    local viewID = self:getScene():get("view_id")
    if self:find("DAFish"):getBulletCnt(viewID) >= FCDefine.MAX_BULLET_CNT then
        Toast("屏幕上子弹太多")
        return
    end
    local cannon = self:find("UICannon" .. viewID)
    local vec = cc.pSub(self.touchPos, cannon.cannonWorldPos)
    local rotation = math.atan2(vec.y, vec.x) * 180 / PI
    cannon:firePre(rotation)
end

function M:startTimer()
    self.bStopTimer = false
    if self.bTimer then return end
    self.bTimer = true
    self:launcher()
    local function callback()
        if self.bStopTimer then
            self:stopTimer()
            return
        end
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
    self.bStopTimer = false
    self.bTimer = false
    self:stopAllActions()
end

return M