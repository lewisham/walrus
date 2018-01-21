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
    cc.Director:getInstance():setDisplayStats(false)
    self:set("enble_collider", false) -- 显示碰撞区
    self:set("flip", true)
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
    self:test()
end

function M:test()
    --self:find("SCPool"):testFish("100000011")
    --self:find("SCPool"):randomTimeLine()
    --self:find("SCPool"):createNet(1, cc.p(512, 360))
    --self:find("SCPool"):createFishArray("312124001", 1)
    --self:find("SCPool"):createFishGroup(7, 1)
    self:find("UICannon1"):join(1)
    self:find("UICannon2"):join(2)
    self:find("UICannon3"):join(3)
    self:find("UICannon4"):join(4)
    self:createGameObject("ISever")
    self:find("UITouch"):setTouchEnabled(true)
    --self:createGameObject("UIBossComing"):play()
end

-- 时间线
function M:onMsgCreateTimeLine(resp)
    self:find("SCPool"):createTimeLine(resp.id, resp.frame)
end

function M:onMsgShoot(resp)

end

return M