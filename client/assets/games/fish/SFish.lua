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
    self:set("assets_path", "games/fish/assets/")
    --rawset(_G, "TEST_COUNT", 0)
    -- 显示配置
    cc.Director:getInstance():setDisplayStats(false)
    self:set("enble_collider", false) -- 显示碰撞区
    self:set("flip", false)
    -- 游戏数据
    self:set("room_idx", 5)
end

function M:run()
    self:initConfig()
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGameLoop")
    self:coroutine(self, "play")
end

function M:play()
    self:createGameObject("UILoading"):play()
    self:createGameObject("UITouch")
    self:createGameObject("UIBackGround")
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:find("UICannon1"):join(2)
    --self:find("SCPool"):testFish("100000011")
    --self:find("SCPool"):randomTimeLine()
    --self:find("SCPool"):createNet(1, cc.p(512, 360))
    --self:find("SCPool"):createFishArray("312124001", 1)
    --self:find("SCPool"):createFishGroup(7, 1)
    self:createGameObject("ISever")
    self:find("SCGameLoop"):startUpdate()
end

return M