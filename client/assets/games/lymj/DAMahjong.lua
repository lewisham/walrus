----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：麻将数据
----------------------------------------------------------------------

local DAMahjong = class("DAMahjong", require("games.mahjong.data.DAMahjong"))

-- 获得每个方位的牌墙数
function DAMahjong:getWallCounts()
    return {0, 17, 17, 17}
end

return DAMahjong