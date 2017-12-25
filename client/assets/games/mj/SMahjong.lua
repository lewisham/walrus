----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：麻将场景基类
----------------------------------------------------------------------

local SMahjong = class("SMahjong", GameBase)

function SMahjong:initLuaPath()
    self:autoRequire("games\\mj")
end

function SMahjong:run()
    self:initLuaPath()
end

return SMahjong