----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：登录场景
----------------------------------------------------------------------

local M = class("SLogin", GameScene)

function M:run()
    self:autoRequire("src\\scene\\hall")
	self:awaken()
    self:coroutine(self, "play")
end

function M:play()
end

return M