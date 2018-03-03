----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：锁定链
----------------------------------------------------------------------

local M = class("UILockChain", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uilockchain.csb"))
    self:setVisible(false)
    wls.BindToUI(self.Node_Normal, self.Node_Normal)
    wls.BindToUI(self.Node_Violent, self.Node_Violent)
    self.Node_Violent:setPosition(0, 0)
    self.Node_Normal:setPosition(0, 0)

    self.Node_Violent:setVisible(false)
    self.Node_Normal:setVisible(false)
    self.mLockNode = self.Node_Normal
end

function M:updateType(bViolent)
    self.Node_Violent:setVisible(false)
    self.Node_Normal:setVisible(false)
    self.mLockNode = bViolent and self.Node_Violent or self.Node_Normal
    self.mLockNode:setVisible(true)
end

function M:lockFish(fish)
    if fish == nil then
        self:setVisible(false)
    end
    if self.mLockFish == fish then return end
    self:setVisible(true)
    self.mLockFish = fish
    local node = self.mLockNode
    node.loop:stopAllActions()
    node.loop:runAction(cc.RepeatForever:create(cc.RotateBy:create(4, 360)))
    node.arrow:stopAllActions()
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.13,0.8),cc.ScaleTo:create(0.87,1))
    node.arrow:runAction(cc.RepeatForever:create(seq))
end

function M:onUpdate()
    if self.mLockFish == nil then return end
    if not self.mLockFish:isAlive() then
        self.mLockFish = nil
        self:setVisible(false)
        return
    end
    self:updateView(cc.p(self.mLockFish:getPosition()))
end

-- 更新点
function M:updateView(pos)
    local node = self.mLockNode
    node.loop:setPosition(pos)
    if self.mCannonPos == nil then
        local cannon = self:find("UICannon" .. wls.SelfViewID)
        self.mCannonPos = cc.p(cannon.cannonWorldPos.x, cannon.cannonWorldPos.y)
    end
    local offset = cc.pSub(pos, self.mCannonPos)
    local addx, addy = offset.x / 9, offset.y / 9
    local orgin = cc.p(self.mCannonPos.x, self.mCannonPos.y)
    for i = 1, 8 do
        orgin.x = orgin.x + addx
        orgin.y = orgin.y + addy
        node["dot" .. i]:setPosition(orgin)
    end
end

return M