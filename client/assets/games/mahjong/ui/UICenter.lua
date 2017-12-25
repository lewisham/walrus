----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：桌面中心
----------------------------------------------------------------------

local UICenter = class("UICenter", UIBase)

function UICenter:getParentNode()
    return self:find("UIDesk").CenterNode
end

function UICenter:onCreate()
    self:loadCsb(MFullPath("csb/TableCenter.csb"), true)
    self.dice_action:setVisible(false)
end

-- 播放两个骰子动画
function UICenter:playDice(co)
    local s1 = math.random(1, 6)
    local s2 = math.random(1, 6)
    self.dice1:setVisible(false)
    self.dice2:setVisible(false)
    local delayPerUnit = 1 / 20.0
    self:diceAction(delayPerUnit)
    WaitForSeconds(co, 15 * delayPerUnit)
    self:setDice(1, s1)
    self:setDice(2, s2)
end

function UICenter:setDice(idx, to)
    local dice = self["dice" .. idx]
    local filename = MFullPath("images/dice/dice_%d.png", to)
    dice:setVisible(true)
    dice:loadTexture(filename)
end

function UICenter:diceAction(delayPerUnit)
    local sprite = self.dice_action
    local filename = MFullPath("images/dice/dice.plist")
    local instance = cc.SpriteFrameCache:getInstance()
    instance:addSpriteFrames(filename)
    sprite:setVisible(true)
    local animation = cc.Animation:create()
	local number, name
    for i = 0, 7 do
        name = "sezi_" .. i .. ".png"
        local frame = instance:getSpriteFrame(name) 
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(delayPerUnit)
    animation:setRestoreOriginalFrame(false)
    local act1 = cc.Animate:create(animation)
    local tb = 
    {
        cc.Animate:create(animation),
        cc.Animate:create(animation),
        cc.Hide:create(),
    }
    sprite:runAction(cc.Sequence:create(tb))
end


return UICenter
