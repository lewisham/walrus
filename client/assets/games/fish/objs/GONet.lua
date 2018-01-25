----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼网
----------------------------------------------------------------------

local M = class("GONet", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self.id = id
    self:getScene():get("net_layer"):addChild(self)
    self.filename = self:require("cannonoutlook")[tostring(id)].net_res
    self.sp = cc.Sprite:createWithSpriteFrameName(self.filename .. "_00.png")
    self:addChild(self.sp)
    self:setVisible(false)
    self:initAction()
    local width = 65
    self.vertices = {cc.p(-width, -width), cc.p(width, -width), cc.p(width, width), cc.p(-width, width)}
    width = width * 1.4
    self.raduis_2 = width * width
    self:initCollider()
end

function M:initAction()
    local strFormat = string.format("%s_%s.png", self.filename, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 20.0)
    local function callback()
        self:setVisible(false)
        self:setAlive(false)
    end
    self.action = cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(callback))
    self:find("SCAction"):retainAction(self.action)
end

function M:reset()
end

function M:play(pos)
    self:setPosition(pos)
    self:setAlive(true)
    self:setVisible(true)
    self.sp:runAction(self.action)
    self:updatePoints()
end

return M