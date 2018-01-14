----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼对象
----------------------------------------------------------------------

local M = class("GOBullet", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self.config = self:require("cannonoutlook")[id]
    self:getScene():get("fish_layer"):addChild(self, 1)
    local sprite = cc.Sprite:create(self:fullPath("plist/bullet/".. self.config.bullet_img))
    self:addChild(sprite)
    sprite:setAnchorPoint(cc.p(0.5, 0.75))
    self.vertices = {cc.p(-5, -10), cc.p(5, -10), cc.p(5, 15), cc.p(-5, 15)}
    self.raduis_2 = 20 * 20
    self:initCollider()
    self.bulletSpr = sprite
    self.vec = cc.p(0, 0)
end

function M:reset()
    self:setAlive(true)
    self:setVisible(true)
end

-- 发射
function M:launch(id, srcPos, angle)
    self.config = self:require("cannonoutlook")[id]
    self.bulletSpr:setTexture(self:fullPath("plist/bullet/".. self.config.bullet_img))
    angle = angle - 90
    self:setPosition(srcPos)
    local radian = angle / 180 * 3.1415926
    self.vec.x = -math.sin(radian)
    self.vec.y = math.cos(radian)
    self:moveToNextPoint()
end

-- 发射到某个点
function M:laucherToPos(id, srcPos, dstPos)
    self.config = self:require("cannonoutlook")[id]
    self.bulletSpr:setTexture(self:fullPath("plist/bullet/".. self.config.bullet_img))
    self:setPosition(srcPos)
    self.vec = cc.pSub(dstPos, srcPos)
    local act = cc.MoveTo:create(1.5, dstPos)
    act:setTag(101)
    self:stopActionByTag(101)
    self:runAction(act)
    local rotation = math.atan2(self.vec.y, self.vec.x) * 180 / PI
    self:setRotation(-rotation + 90)
end

function M:updateFrame()
    self:updateNormal()
    self:updatePoints()
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
    local rotation = math.atan2(self.vec.y, self.vec.x) * 180 / PI
    self:setRotation(-rotation + 90)
end

function M:onCollsion()
    self:setVisible(false)
    self:setAlive(false)
end

return M