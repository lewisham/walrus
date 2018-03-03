----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：子弹
----------------------------------------------------------------------

local FOLLOW_INTERVAL = 5

local M = class("GOBullet", wls.FishObject)

function M:onCreate(id)
    self.mViewID = -1
    self.config = self:require("cannonoutlook")[id]
    self:getScene():get("bullet_layer"):addChild(self, tonumber(id))
    -- 子弹图
    local sprite = cc.Sprite:createWithSpriteFrameName(self.config.bullet_img)
    self:addChild(sprite)
    sprite:setAnchorPoint(cc.p(0.5, 0.75))
    self.vertices = {cc.p(-5, -10), cc.p(5, -10), cc.p(5, 15), cc.p(-5, 15)}
    self.raduis_2 = 20 * 20
    self:initCollider()
    self.bulletSpr = sprite
    self.vec = cc.p(0, 0)

    -- 狂暴图
    local bg = cc.Sprite:createWithSpriteFrameName("effect_bullet_superpos_01.png")
    self:addChild(bg)
    bg:setAnchorPoint(cc.p(0.5, 0.75))
    bg:setVisible(false)
    self.bgSpr = bg
    self:setVisible(false)
end

function M:resetBullet(viewID, bViolent)
    self.mbSelf = wls.SelfViewID == viewID  -- 是否是自己的子弹
    self.mViewID = viewID
    self.mbFollow = false
    self.mFollowFish = nil
    self:setAlive(true)
    self:setVisible(true)
    if bViolent == nil then bViolent = false end
    self.bgSpr:setVisible(bViolent)
    self:find("DAFish"):modifyBulletCnt(viewID, 1)
    self.mFollowIdx = FOLLOW_INTERVAL
end

function M:isNeedCollionCheck()
    if not self.alive then return false end
    return not self.mbFollow
end

function M:getViewID(viewID)
    return self.mViewID
end

-- 向某个角度发射
function M:launch(id, srcPos, angle, duration)
    self:setVisible(true)
    self.config = self:require("cannonoutlook")[id]
    self.bulletSpr:setSpriteFrame(self.config.bullet_img)
    angle = angle - 90
    self:setPosition(srcPos)
    local radian = angle / 180 * 3.1415926
    self.vec.x = -math.sin(radian)
    self.vec.y = math.cos(radian)
    self:moveToNextPoint()
end

-- 跟踪某个点
function M:follow(id, srcPos, angle, duration)
    self.mbFollow = true
    self:setVisible(true)
    self.config = self:require("cannonoutlook")[id]
    self.bulletSpr:setSpriteFrame(self.config.bullet_img)
    self:setPosition(srcPos)
    self.mFollowFish = self:find("SCPool"):getFollowFish(self.mViewID)
    if self.mFollowFish == nil then return end
    self:flightTo()
end

function M:updateFrame()
    if self.mbFollow then
        self:updateFollow()
    else
        self:updateNormal()
    end
end

function M:updateNormal()
    local pos = cc.p(self:getPosition())
    if pos.x < 0 then
        pos.y = pos.y - pos.x / self.vec.x * self.vec.y
        pos.x = 0
        self.vec.x = -self.vec.x
        self:setPosition(pos)
        self:moveToNextPoint()
    elseif pos.x > display.width then
        pos.y = pos.y - (pos.x - display.width) / self.vec.x * self.vec.y
        pos.x = display.width
        self.vec.x = -self.vec.x
        self:setPosition(pos)
        self:moveToNextPoint()
    elseif pos.y < 0 then
        pos.x = pos.x - pos.y / self.vec.y * self.vec.x
        pos.y = 0
        self.vec.y = -self.vec.y
        self:setPosition(pos)
        self:moveToNextPoint()
    elseif pos.y > display.height then
        pos.x = pos.x - (pos.y - display.height) / self.vec.y * self.vec.x
        pos.y = display.height
        self.vec.y = -self.vec.y
        self:setPosition(pos)
        self:moveToNextPoint()
    end
end

function M:moveToNextPoint()
    local raduis = display.width + display.height
    local dstPos = cc.p(raduis * self.vec.x, raduis * self.vec.y)
    local act = cc.MoveBy:create(raduis / 650.0, dstPos)
    act:setTag(101)
    self:stopActionByTag(101)
    self:runAction(act)
    local rotation = math.atan2(self.vec.y, self.vec.x) * 180 / math.pi
    self:setRotation(-rotation + 90)
end

function M:onCollsion()
    self:removeFromScreen()
end

function M:removeFromScreen()
    self.bullet_id = -1
    self:setVisible(false)
    self:setAlive(false)
    self:find("DAFish"):modifyBulletCnt(self.mViewID, -1)
end

-- 跟踪
function M:updateFollow()
    self.mFollowFish = self:find("SCPool"):getFollowFish(self.mViewID)
    if self.mFollowFish == nil then return end
    if not self.mFollowFish:isAlive() then
        return
    end
    if self.mFollowIdx > 0 then
        self.mFollowIdx = self.mFollowIdx - 1
        return
    end
    self.mFollowIdx = FOLLOW_INTERVAL
    self:flightTo()
end

-- 飞行到
function M:flightTo()
    local dst = cc.p(self.mFollowFish:getPosition())
    local pos = cc.p(self:getPosition())
    local offset = cc.pSub(dst, pos)
    local distance = cc.pGetLength(offset)
    local duration = distance / 650 * 0.6
    local rotation = math.atan2(offset.y, offset.x) * 180 / math.pi
    self:runAction(cc.RotateTo:create(0.03, -rotation + 90))
    self:stopActionByTag(101)
    local function moveTo()
        if self.mFollowFish == nil then 
            return 
        end
        self:find("SCPool"):createNet(self.config.id, dst)
        self:stopActionByTag(101)
        if self.mbSelf then
            self.mFollowFish:onRed()
            wls.SendMsg("sendHit", self.bullet_id, {self.mFollowFish})
        end
        self:removeFromScreen()
    end
    local function moveOut()
        wls.SendMsg("sendHit", self.bullet_id, {})
        self:removeFromScreen()
    end
    local rate = display.width / distance
    local act = cc.Sequence:create
    {
        cc.MoveBy:create(duration, offset), 
        cc.CallFunc:create(moveTo),
        cc.MoveBy:create(duration * rate, cc.p(offset.x * rate, offset.y * rate)),
        cc.CallFunc:create(moveOut),
    }
    act:setTag(101)
    self:runAction(act)

end

return M