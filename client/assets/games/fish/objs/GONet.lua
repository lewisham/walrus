----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼网
----------------------------------------------------------------------

local M = class("GONet", require("games.fish.objs.GOCollider"))

function M:onCreate()
    self:getScene():get("fish_layer"):addChild(self, 2)
    self.filename = "net_1"
    self.sp = cc.Sprite:createWithSpriteFrameName(self.filename .. "_00.png")
    self:addChild(self.sp)
    self:setVisible(false)
end

function M:reset()
end

function M:play(id, pos)
    self.filename = self:require("cannonoutlook")[tostring(id)].net_res
    self:setPosition(pos)
    self:setAlive(true)
    self:setVisible(true)
    local filename = self.filename
    local animation = cc.Animation:create()
    local idx = 0
    while true do
        local frameName = string.format("%s_%02d.png", filename, idx)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        if spriteFrame == nil then break end
        animation:addSpriteFrame(spriteFrame)
        idx = idx + 1
    end
    animation:setDelayPerUnit(1 / 20.0)
    local function callback()
        self:setVisible(false)
        self:setAlive(false)
    end
    local act = cc.Sequence:create(cc.Animate:create(animation), cc.CallFunc:create(callback))
    self.sp:runAction(act)
end

return M