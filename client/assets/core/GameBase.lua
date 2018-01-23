----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏基类
----------------------------------------------------------------------

GameBase = class("GameBase", GameScene)

-- 构造函数
function GameBase:ctor()
    GameBase.super.ctor(self)
end

function GameBase:doExitGame()
    self:coroutine(self, "doExitGameImpl")
end

function GameBase:doExitGameImpl()
end