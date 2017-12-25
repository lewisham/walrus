----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：大厅场景
----------------------------------------------------------------------

local M = class("SHall", GameScene)

function M:run()
    self:autoRequire("src\\scene\\hall")
    self:createGameObject("DAPlayer")
    self:createGameObject("SCNetWork")
	self:awaken()
    self:coroutine(self, "play")
end

function M:play()
    if not self:find("SCNetWork"):connect() then
        return
    end
    self:balckOut(nil, 0.5)
    cc.SimpleAudioEngine:getInstance():playMusic("sound/bgm_battle1.mp3", true)
    self:createGameObject("UIHallBackGround")
    self:find("SCNetWork"):test()
end

return M