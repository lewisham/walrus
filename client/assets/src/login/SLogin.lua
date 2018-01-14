----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：登录场景
----------------------------------------------------------------------

local M = class("SLogin", GameScene)

function M:run()
    self:coroutine(self, "play")
end

function M:createAutoPath()
    self:autoRequire("src\\login")
end

function M:play()
    self:createGameObject("src.hall.home.UIHallBackGround")
    self:createGameObject("UILogin")
end

function M:onMsgLoginSuccess(resp)
    self:getGameApp():replaceScene("src.hall.SHall")
end

return M