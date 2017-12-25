----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：龙岩麻将
----------------------------------------------------------------------

local SLongYan = class("SLongYan", require("games.mahjong.SMahjong"))

function SLongYan:initLuaPath()
    SLongYan.super.initLuaPath(self)
    self:autoRequire("games\\lymj")
end

return SLongYan