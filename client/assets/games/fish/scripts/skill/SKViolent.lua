----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：狂暴技能
----------------------------------------------------------------------

local M = class("SKViolent", wls.UIGameObject)

function M:onCreate()
    self.config = self:require("skill")["960000006"]
    self.mbActive = false
    self:set("duration", 0.0)
    self.mRate = 1
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
    --wls.SendMsg("sendBulletTargetChange", fish)
end

-- 激活技能
function M:activeSkill(costType)
    wls.SendMsg("sendUseViolent", costType)
end

-- 释放技能
function M:releaseSkill(skillPlus)
    self:find("UITouch"):stopTimer()
    self:find("UISkillPanel"):onRunTimer(17)
    self:find("UISkillPanel"):setIsViolent(true,tonumber(self.config.duration))

    self:find("UILockChain"):updateType(true)
    self.mLockFish = nil
    self:find("SCPool"):setFollowFish(wls.SelfViewID, self.mLockFish)
    self.mbActive = true
    self:find("UILockChain"):lockFish(self.mLockFish)
    self:set("duration", tonumber(self.config.duration) * skillPlus / 100)
    self:coroutine(self, "releaseSkillImpl")
    
end

-- 设置倍率
function M:setRate(rate)
    self.mRate = rate
end

-- 得到倍率
function M:getRate(rate)
    return self.mRate
end

function M:releaseSkillImpl()
    local dt = 0.2
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    local id, vec, angle
    local bRetarget = false
    while true do
        if self:modify("duration", 0) <= 0 then break end
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
            cannon:shootPre(id, angle, true)
            --wls.SendMsg("sendBullet", id, angle, self.mLockFish:get("timeline_id"), self.mLockFish:get("array_id"))
        end
        wls.WaitForSeconds(dt)
    end
    self:stopSkill()
end

-- 技能停止
function M:stopSkill()
    self.mbActive = false
    self:set("duration", 0)
    print("stopSkill")
    self:find("UILockChain"):setVisible(false)
    self:setRate(1)
end

-- 停止玩家技能
function M:stopPlayerSkill(viewId)
    if viewId == wls.SelfViewID  then 
        self:set("duration", 0)
        self:setRate(1)
        self:find("UISkillPanel"):setIsViolent(false)
    end
    local cannon = self:find("UICannon" .. viewId)
    cannon:stopViolentAct()
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