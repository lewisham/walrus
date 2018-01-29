----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：金币效果
----------------------------------------------------------------------

local M = class("UICoinMgr", UIBase)

function M:onCreate()
    self.mCoinPool = {}
    self.mLabelPool = {}
    self.mAmiPosList = {cc.p(332.43, 40), cc.p(945.05, 40), cc.p(945.05, 680), cc.p(332.43, 680)}
end

-- 创建数字
function M:createLabel(viewID)
    local idx = self:getScene():get("view_id") == viewID and 1 or 2
    for _, label in ipairs(self.mLabelPool) do
        if not label:isVisible() and label._idx == idx then
            return label
        end
    end
    local label = cc.LabelBMFont:create()
    label:setFntFile(self:fullPath(string.format("ui/fnt/bonus_num_%d.fnt", idx)))
    label:setVisible(false)
    self:addChild(label, 1)
    table.insert(self.mLabelPool, label)
    return label
end

-- 创建金币
function M:createCoin(viewID)
    local idx = self:getScene():get("view_id") == viewID and 1 or 2
    for _, coin in ipairs(self.mCoinPool) do
        if not coin:isVisible() and coin._idx == idx then
            return coin
        end
    end
    local coin = cc.Sprite:create()
    self:addChild(coin)
    coin._idx = idx
    local strFormat = string.format("game_coin%s_%s.png", idx, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 12.0)
    coin:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    table.insert(self.mCoinPool, coin)
    return coin
end

function M:play(pos, cnt, viewID, score)
    self:coroutine(self, "playImpl", pos, cnt, viewID, score)
end

function M:playImpl(pos, cnt, viewID, score)
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
            WaitForSeconds(0.12)
            x = x + gapWidth
        end
        y = y - gapHeight
    end
    self:showLabel(viewID, pos, score)
end

-- 显示金币
function M:showCoin(viewID, pos, add)
    local coin = self:createCoin(viewID)
    coin:setPosition(pos)
    coin:setScale(0.5)
    coin:setVisible(true)
    local timeMove = 0.75
    local aimPos = self.mAmiPosList[viewID] or cc.p(0, 0)
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
    local label = self:createLabel(viewID)
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
    if cnt == 2 then
        return {row = 2, col = 1}
    elseif cnt == 5 then
        return {row = 5, col = 1}
    elseif cnt == 8 then
        return {row = 4, col = 2}
    elseif cnt == 12 then
        return {row = 4, col = 3}
    elseif cnt == 18 then
        return {row = 6, col = 3}
    else
        return {row = 1, col = 1}
    end
end

function M:updateCoin(viewID, add)
    self:find("UICannon" .. viewID):modify(add)
end

return M