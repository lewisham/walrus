----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：锁定技能
----------------------------------------------------------------------

local M = class("SKLockTarget", wls.UIGameObject)

function M:onCreate()
    self.config = self:require("skill")["960000002"]
    self.mbActive = false
    self:set("duration", 0.0)
end

function M:setLockFish(fish)
    self.mLockFish = fish
    self:find("UILockChain"):lockFish(fish)
end

-- 改变目标
function M:changeLockFish(fish)
    self.mLockFish = fish
    self:find("SCPool"):setFollowFish(wls.SelfViewID, fish)
    self:find("UILockChain"):lockFish(fish)
    if fish == nil then return end
    wls.SendMsg("sendBulletTargetChange", fish)
end

-- 激活技能
function M:activeSkill(costType)
    Log("-------activeSkill--------")
    local fish = self:find("SCPool"):findFishByMoney()
    if fish == nil then return end
    self.mLockFish = fish
    wls.SendMsg("sendlockFish", fish:get("timeline_id"), fish:get("array_id"), costType)
end

-- 释放技能
function M:releaseSkill(skillPlus)
    self:find("UITouch"):stopTimer()
    self:find("UILockChain"):updateType(false)
    self:find("SCPool"):setFollowFish(wls.SelfViewID, self.mLockFish)
    self.mbActive = true
    self:find("UILockChain"):lockFish(self.mLockFish)
    self:set("duration", tonumber(self.config.duration) * skillPlus / 100)
    self:coroutine(self, "releaseSkillImpl")
end

function M:releaseSkillImpl()
    local dt = 0.2
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    local id, vec, angle
    local bRetarget = false
    while true do
        if self:modify("duration", -dt) < 0 then break end
        if not self:find("SKViolent"):isListenTouchEvent() then
            if self.mLockFish == nil then
                bRetarget = true
            elseif not self.mLockFish:isAlive() or not self.mLockFish:isInScreen() then
                bRetarget = true
            end
            -- 目标跑出屏幕，切换目标
            if bRetarget then
                self.mLockFish = self:find("SCPool"):findFishByMoney()
                self:changeLockFish(self.mLockFish)
                bRetarget = false
            end
            if self.mLockFish then
                id = self:find("DAFish"):createBulletID()
                vec = cc.pSub(cc.p(self.mLockFish:getPosition()), cannon.cannonWorldPos)
                angle = math.atan2(vec.y, vec.x) * 180 / math.pi
                cannon:shootPre(id, angle)
                wls.SendMsg("sendBullet", id, angle, self.mLockFish:get("timeline_id"), self.mLockFish:get("array_id"))
            end
        end
        wls.WaitForSeconds(dt)
    end
    self:stopSkill()
end

-- 技能停止
function M:stopSkill()
    self.mbActive = false
    self:set("duration", 0)
    if self:find("SKViolent"):isListenTouchEvent() then return end
    self:find("UILockChain"):setVisible(false)
end

function M:isListenTouchEvent()
    return self.mbActive
end

-- 点击
function M:onTouchBegan(pos)
    local fish = self:find("SCPool"):findLockFish(pos)
    if fish then
        self:changeLockFish(fish)
    end
end

return M