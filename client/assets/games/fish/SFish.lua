----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：捕鱼
----------------------------------------------------------------------

local M = class("SFish", u3a.GameScene)

function M:createAutoPath()
    self:autoAddSound("games\\fish\\assets\\sound")
    self:autoRequire("games\\fish")
end

function M:initConfig()
    rawset(_G, "u3a", self:require("u3a"))
    self:require("FishDef")
    self:set("assets_path", "games/fish/assets/")
    -- 显示配置
    --rawset(_G, "TEST_COUNT", 0)
    --cc.Director:getInstance():setDisplayStats(true)
    --self:set("enble_collider", true) -- 显示碰撞区
    self:set("enable_fps", true) -- 显示帧速
    self:set("flip", false)
    -- 游戏数据
    self:set("room_idx", 2)
    self:set("view_id", 1)
    self:set("auto_fire", false)
end

-- 适配率
function M:initResolution()
    local resolution = 
    {
        width = 1280,
        height = 890,
        autoscale = "FIXED_WIDTH",
        callback = function(framesize)
            local ratio = framesize.width / framesize.height
            if ratio <= 1.5 then --4:3 屏幕 单独适配
                return {autoscale = "FIXED_WIDTH"} -- FIXED_HEIGHT
            end
        end
    }
    display.setAutoScale(resolution) 
    u3a.SCALE = 720 / display.width
    print(display.width, display.height)
end

function M:run()
    self:initResolution()
    self:coroutine(self, "play")
end

function M:doExitGameImpl()
    if not WaitForDialog("提示", "是否退出游戏？") then return end

end

function M:initData()
    self:createGameObject("DAFish")
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGrid")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCNetwork")
    self:createGameObject("SCAction")
end

function M:initSkill()
    self:createGameObject("SKFreeze")
    self:createGameObject("SKBomb")
    self:createGameObject("SKSummon")
end

function M:play()
    self:createGameObject("SCUpdate"):play("http://192.168.67.132/fish/")
    self:initConfig()
    self:initData()
    self:createGameObject("UILoading"):play()
    self:createGameObject("UIBackGround")
    self:createGameObject("UIEffect")
    self:createGameObject("UITouch")
    self:initSkill()
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UICoinMgr")
    self:createGameObject("UIGunChange")
    self:createGameObject("ISever")
    self:createGameObject("UISkillPanel")
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