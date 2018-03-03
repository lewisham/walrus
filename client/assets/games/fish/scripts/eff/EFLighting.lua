----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：闪电效果
----------------------------------------------------------------------

local M = class("EFLighting", wls.UIGameObject)

function M:onCreate()
    self.mbLighting = false
    self.mLightingHeight = 0
    self.mStartPos = cc.p(0, 0)
    self.mPool = {}
    self:initPool()
    self:setVisible(false)
end

function M:initPool()
    for i = 1, 20 do
        self:createLight()
    end
    self.mLightingHeight = self.mPool[1].thunder:getContentSize().height
end

function M:createLight()
    local ball = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/effect/lightningball.png"))
    self:addChild(ball, 1)
    ball:setVisible(false)
    ball:setScale(0.7)
    
    local thunder = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/effect/lightning_00.png"))
    self:addChild(thunder)
    thunder:setVisible(false)
    thunder:setAnchorPoint(cc.p(0.5, 0))
    local strFormat = "games/fish/assets/ui/images/effect/lightning_%02d.png"
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 10.0)
    thunder:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    
    local unit = {}
    unit.ball = ball
    unit.thunder = thunder
    unit.use = false
    table.insert(self.mPool, unit)
    return unit
end

function M:getLight()
    for _, val in ipairs(self.mPool) do
        if not val.use then
            return val
        end
    end
    return self:createLight()
end

-- 闪点球
function M:startLighting(pos)
    self.mStartPos.x = pos.x
    self.mStartPos.y = pos.y
    self.mbLighting = true
    self:stopAllActions()
    for _, val in ipairs(self.mPool) do
        val.use = false
        val.ball:setVisible(false)
        val.thunder:setVisible(false)
    end
    local function callback()
        self:setVisible(false)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(callback)))
    self:setVisible(true)
end

-- 闪点链
function M:addLighting(pos)
    if not self.mbLighting then return end
    local unit = self:getLight()
    unit.use = true
    unit.ball:setPosition(pos)
    unit.ball:setVisible(true)
    unit.thunder:setPosition(pos)
    unit.thunder:setVisible(true)
    local offset = cc.pSub(pos, self.mStartPos)
    local scaleY = cc.pGetLength(offset) / self.mLightingHeight
    unit.thunder:setScaleY(scaleY)
    local rotation = math.atan2(offset.y, offset.x) * 180 / math.pi
    unit.thunder:setRotation(270 - rotation)
end

function M:endLighting()
    self.mbLighting = false
end

return M