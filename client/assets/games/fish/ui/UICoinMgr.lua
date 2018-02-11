----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：金币效果
----------------------------------------------------------------------

local M = class("UICoinMgr", u3a.UIGameObject)

function M:onCreate()
    self.mCoinPool = {}
    self.mLabelPool = {}
    self:initCoinRowAndCol()
    for i = 1, 20 do
        self:createLabel(1)
        self:createLabel(2)
        self:createCoin(1)
        self:createCoin(2)
    end
end

function M:initCoinRowAndCol()
    self.mCoinRowAndCol = {}
    self.mCoinRowAndCol[1] = {row = 1, col = 1}
    self.mCoinRowAndCol[2] = {row = 2, col = 1}
    self.mCoinRowAndCol[5] = {row = 5, col = 1}
    self.mCoinRowAndCol[8] = {row = 4, col = 2}
    self.mCoinRowAndCol[12] = {row = 4, col = 3}
    self.mCoinRowAndCol[18] = {row = 6, col = 3}
end

function M:createLabel(idx)
    local label = cc.LabelBMFont:create()
    label:setFntFile(self:fullPath(string.format("ui/fnt/bonus_num_%d.fnt", idx)))
    label:setVisible(false)
    self:addChild(label, 1)
    table.insert(self.mLabelPool, label)
    return label
end

function M:createCoin(idx)
    local coin = cc.Sprite:create()
    self:addChild(coin)
    coin:setVisible(false)
    coin._idx = idx
    local strFormat = string.format("game_coin%s_%s.png", idx, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 12.0)
    coin:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    table.insert(self.mCoinPool, coin)
    return coin
end

-- 创建数字
function M:getLabel(idx)
    for _, label in ipairs(self.mLabelPool) do
        if not label:isVisible() and label._idx == idx then
            return label
        end
    end
    return self:createLabel(idx)
end

-- 创建金币
function M:getCoin(idx)
    for _, coin in ipairs(self.mCoinPool) do
        if not coin:isVisible() and coin._idx == idx then
            return coin
        end
    end
    return self:createCoin(idx)
end

function M:play(pos, cnt, viewID, score)
    self:coroutine(self, "playImpl", pos, cnt, viewID, score)
end

function M:playImpl(pos, cnt, viewID, score)
    u3a.WaitForSeconds(1.0)
    local coord = self:getRowAndColByCount(cnt)
    local gapWidth = 50
    local gapHeight = 60
    local sx = pos.x - (coord.row - 1) * gapWidth / 2.0
    local sy = pos.y + (coord.col - 1) * gapHeight / 2.0
    local x = sx
    local y = sy
    local cur = 0
    for i = 1, coord.col do
        x = sx
        for j = 1, coord.row do
            cur = cur + 1
            local add = cur == cnt and score or 0
            self:showCoin(viewID, cc.p(x, y), add)
            u3a.WaitForSeconds(0.12)
            x = x + gapWidth
        end
        y = y - gapHeight
    end
    self:showLabel(viewID, pos, score)
end

-- 显示金币
function M:showCoin(viewID, pos, add)
    local idx = u3a.SelfViewID == viewID and 1 or 2
    local coin = self:getCoin(idx)
    coin:setPosition(pos)
    coin:setScale(0.5)
    coin:setVisible(true)
    local timeMove = 0.75
    local aimPos = u3a.AimPosTab[viewID] or cc.p(0, 0)
    local seq1 = cc.Sequence:create
    {
        cc.MoveBy:create(0.21, cc.p(0, 88)),
        cc.MoveBy:create(0.20, cc.p(0, -103)),
        cc.MoveBy:create(0.13, cc.p(0, 27)),
    }
    local tb =
    {
        cc.Spawn:create(cc.ScaleTo:create(0.54, 1), seq1),
        cc.DelayTime:create(0.83),
        cc.Spawn:create(cc.ScaleTo:create(timeMove, 0.7), cc.EaseExponentialIn:create(cc.MoveTo:create(timeMove, aimPos))),
        cc.Hide:create(),
    }
    if add > 0 then
        table.insert(tb, cc.CallFunc:create(function() self:updateCoin(viewID, add) end))
    end
    coin:runAction(cc.Sequence:create(tb))
end

-- 显示字体
function M:showLabel(viewID, pos, score)
    local idx = u3a.SelfViewID == viewID and 1 or 2
    local label = self:getLabel(idx)
    label:setPosition(pos)
    label:setVisible(false)
    label:setOpacity(255)
    label:setString("+" .. score)
    local tb =
    {
        cc.DelayTime:create(0.4),
        cc.Show:create(),
        cc.DelayTime:create(1.0),
        cc.FadeOut:create(0.3),
        cc.Hide:create(),
    }
    label:runAction(cc.Sequence:create(tb))
end

function M:getRowAndColByCount(cnt)
    local ret = self.mCoinRowAndCol[cnt]
    if ret == nil then ret = self.mCoinRowAndCol[1] end
    return ret
end

function M:updateCoin(viewID, add)
    self:find("UICannon" .. viewID):modifyCoin(add)
end

return M