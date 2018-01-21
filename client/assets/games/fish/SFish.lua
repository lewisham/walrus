----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：捕鱼
----------------------------------------------------------------------

local M = class("SFish", GameBase)

function M:createAutoPath()
    self:autoRequire("games\\fish")
end

function M:initConfig()
    rawset(_G, "FCDefine", self:require("FCDefine"))
    self:set("assets_path", "games/fish/assets/")
    -- 显示配置
    --rawset(_G, "TEST_COUNT", 0)
    cc.Director:getInstance():setDisplayStats(true)
    self:set("enble_collider", false) -- 显示碰撞区
    self:set("flip", false)
    -- 游戏数据
    self:set("room_idx", 1)
    self:set("view_id", 1)
end

function M:run()
    self:initConfig()
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCNetwork")
    self:coroutine(self, "play")
end

function M:doExitGameImpl()
    if not WaitForDialog("提示", "是否退出游戏？") then return end

end

function M:play()
    self:createGameObject("UILoading"):play()
    self:createGameObject("UITouch")
    self:createGameObject("UIBackGround")
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UIRightPanel")
    self:find("SCGameLoop"):startUpdate()
    self:createGameObject("ISever")
end

return M