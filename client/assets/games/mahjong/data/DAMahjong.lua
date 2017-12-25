----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：麻将数据
----------------------------------------------------------------------

local DAMahjong = class("DAMahjong", GameObject)

function DAMahjong:init()
    self.mWallAmount = 0
    self:calcMahjongCnt()
end

-- 获得每个方位的牌墙数
function DAMahjong:getWallCounts()
    return {17, 17, 17, 17}
end

-- 获得牌墙总数
function DAMahjong:getCardAmount()
    return self.mWallAmount
end

function DAMahjong:calcMahjongCnt()
    local cnt = 0
    for _, val in ipairs(self:getWallCounts()) do
        cnt = cnt + val * 2
    end
    self.mWallAmount = cnt
end

return DAMahjong