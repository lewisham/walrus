----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：子弹
----------------------------------------------------------------------

local M = class("GOBullet", wls.FishObject)

function M:onCreate(id)
    self.mViewID = -1
    self.config = self:require("cannonoutlook")[id]
    self:getScene():get("bullet_layer"):addChild(self, tonumber(id))
    local sprite = cc.Sprite:create(self:fullPath("plist/bullet/".. self.config.bullet_img))
    self:addChild(sprite)
    sprite:setAnchorPoint(cc.p(0.5, 0.75))
    self.vertices = {cc.p(-5, -10), cc.p(5, -10), cc.p(5, 15), cc.p(-5, 15)}
    self.raduis_2 = 20 * 20
    self:initCollider()
    self.bulletSpr = sprite
    self.vec = cc.p(0, 0)
    self:setVisible(false)
end

function M:resetBullet(viewID)
    self.mbSelf = wls.SelfViewID == viewID  -- 是否是自己的子弹
    self.mViewID = viewID
    self.mbFollow = false
    self.mFollowFish = nil
    self:setAlive(true)
    self:setVisible(true)
    self:find("DAFish"):modifyBulletCnt(viewID, 1)
end

function M:isNeedCollionCheck()
    if not self.alive then return false end
    return not self.mbFollow
end

function M:getViewID(viewID)
    return self.mViewID
end

-- 向某个角度发射
function M:launch(id, srcPos, angle)
    self:setVisible(true)
    self.config = self:require("cannonoutlook")[id]
    self.bulletSpr:setTexture(self:fullPath("plist/bullet/".. self.config.bullet_img))
    angle = angle - 90
    self:setPosition(srcPos)
    local radian = angle / 180 * 3.1415926
    self.vec.x = -math.sin(radian)
    self.vec.y = math.cos(radian)
    self:moveToNextPoint()
end

-- 跟踪某个点
function M:follow(id, srcPos, angle)
    self.mbFollow = true
    self:launch(id, srcPos, angle)
    self.mFollowFish = self:find("SCPool"):getFollowFish(self.mViewID)
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
    self:setVisible(false)
    self:setAlive(false)
    self:find("DAFish"):modifyBulletCnt(self.mViewID, -1)
end

-- 跟踪
function M:updateFollow()
    if self.mFollowFish == nil then return end
    if not self.mFollowFish:isAlive() then
        self.mFollowFish = self:find("SCPool"):getFollowFish(self.mViewID)
    end
    local p2 = cc.p(self:getPosition())
    self.vec = cc.pNormalize(cc.pSub(self.mFollowFish.position, p2))
    self:moveToNextPoint()
end

return M