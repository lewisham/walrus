----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：点击层
----------------------------------------------------------------------

local M = class("UITouch", wls.UIGameObject)

function M:onCreate()
    self:setContentSize(cc.size(display.width, display.height))
    self.touchPos = cc.p(0, 0)
    self.bTimer = false
    self.bStopTimer = false
    self:registerTouchEvent()
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
    self.mBlockList = {"SKBomb", "SKLockTarget", "SKViolent"}
end

function M:registerTouchEvent()
    local target = nil
    local function callback(event)
        if event.name == "began" then
            self.touchPos = self:getTouchBeganPosition()
            self:post("onEventTouchBegan", clone(self.touchPos))
            target = self:calcEventTarget()
            wls.Invoke(target, "onTouchBegan", self.touchPos)
            return true
        elseif event.name == "moved" then
            self.touchPos = self:getTouchMovePosition()
            wls.Invoke(target, "onTouchMoved", self.touchPos)
        else
            wls.Invoke(target, "onTouchEnded", self.touchPos)
        end
    end
    self:onTouch(callback)
    self:setTouchEnabled(false)
end

-- 处理事件的对象
function M:calcEventTarget()
    local go
    for _, name in ipairs(self.mBlockList) do
        go = self:find(name)
        if go:isListenTouchEvent() then 
            return go
        end
    end
    return self
end

function M:onTouchBegan()
    self:startTimer()
end

function M:onTouchMoved()
    self:updateAngle()
end

function M:onTouchEnded()
    if not self:getScene():get("auto_fire") then
        self.bStopTimer = true
    end
end

function M:updateAngle()
    local viewID = wls.SelfViewID
    local cannon = self:find("UICannon" .. viewID)
    local vec = cc.pSub(self.touchPos, cannon.cannonWorldPos)
    local angle = math.atan2(vec.y, vec.x) * 180 / math.pi
    cannon:updateAngle(angle)
end

function M:launcher()
    local viewID = wls.SelfViewID
    if self:find("DAFish"):getBulletCnt(viewID) >= wls.MAX_BULLET_CNT then
        wls.Toast(self:find("SCConfig"):getLanguageByID(800000090))
        return
    end
    local cannon = self:find("UICannon" .. viewID)
    local err = cannon:isCanFire()
    if err > 0 then
        self:handlError(err)
        return
    end
    local id = self:find("DAFish"):createBulletID()
    local vec = cc.pSub(self.touchPos, cannon.cannonWorldPos)
    local angle = math.atan2(vec.y, vec.x) * 180 / math.pi
    cannon:firePre(id, angle)
    wls.SendMsg("sendBullet", id, angle)
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
        cc.DelayTime:create(wls.BULLET_LANCHER_INTERVAL),
        cc.CallFunc:create(callback),
    }
    self:runAction(cc.RepeatForever:create(cc.Sequence:create(tb)))
end

function M:stopTimer()
    self.bStopTimer = false
    self.bTimer = false
    self:stopAllActions()
end

-- 处理
function M:handlError(err)
    if err == wls.FireErrorCode.Lock then
        wls.Dialog(3, "是否开户")
    end
end

return M