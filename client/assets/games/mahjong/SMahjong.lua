----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：麻将基类
----------------------------------------------------------------------

local SMahjong = class("SMahjong", GameBase)

function SMahjong:initLuaPath()
    self:autoRequire("games\\mahjong")
end

function SMahjong:run()
    self:initLuaPath()
    self:require("MJCommon")
    self:createGameObject("DAMahjong")
    self:createGameObject("UIDesk")
    self:createGameObject("UIPlayerHandCards")
    --self:createGameObject("UIReady")
end

return SMahjong