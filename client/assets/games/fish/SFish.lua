----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：捕鱼
----------------------------------------------------------------------

local M = class("SFish", u3a.GameScene)

function M:createAutoPath()
    self:autoRequire("games\\fish")
end

function M:initConfig()
    rawset(_G, "u3a", self:require("u3a"))
    self:set("assets_path", "games/fish/assets/")
    -- 显示配置
    --rawset(_G, "TEST_COUNT", 0)
    --cc.Director:getInstance():setDisplayStats(true)
    --self:set("enble_collider", true) -- 显示碰撞区
    self:set("enable_fps", true) -- 显示帧速
    self:set("flip", false)
    -- 游戏数据
    self:set("room_idx", 1)
    self:set("view_id", 2)
    self:set("auto_fire", false)
end

function M:run()
    self:initConfig()
    self:createGameObject("DAFish")
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGrid")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCNetwork")
    self:createGameObject("SCAction")
    self:coroutine(self, "play")
end

function M:doExitGameImpl()
    if not WaitForDialog("提示", "是否退出游戏？") then return end

end

function M:initSkill()
    self:createGameObject("SKFreeze")
    self:createGameObject("SKBomb")
    self:createGameObject("SKSummon")
end

function M:play()
    self:createGameObject("UILoading"):play()
    self:createGameObject("UIBackGround")
    self:createGameObject("UIEffect")
    self:createGameObject("UICoinMgr")
    self:createGameObject("UITouch")
    self:initSkill()
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UIGunChange")
    self:createGameObject("ISever")
    self:createGameObject("UISkill")
    self:createGameObject("UIRightPanel")
    u3a.WaitForFrames(1)
    self:createGameObject("UISelfChairTips")
    self:find("UILoading"):removeFromScene()
    self:find("SCPool"):createFishPool()
    u3a.WaitForFrames(2)
    self:find("SCGameLoop"):startUpdate()
    self:find("UISelfChairTips"):play()
end

return M