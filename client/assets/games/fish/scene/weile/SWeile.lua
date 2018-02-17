----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：微乐捕鱼
----------------------------------------------------------------------

local M = class("SWeile", u3a.GameScene)

function M:createAutoPath()
    self:autoAddSound("games\\fish\\assets\\sound")
    self:autoRequire("games\\fish")
end

function M:initConfig()
    rawset(_G, "u3a", self:require("u3a"))
    self:require("FishDef")
    -- 显示配置
    --rawset(_G, "TEST_COUNT", 0)
    --cc.Director:getInstance():setDisplayStats(true)
    --self:set("enble_collider", true) -- 显示碰撞区
    self:set("enable_fps", true) -- 显示帧速
    -- 游戏数据
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
    math.randomseed(os.clock())
    self:initResolution()
    self:set("assets_path", "games/fish/assets/")
    self:coroutine(self, "play")
end

-- 退出处理
function M:doExitGameImpl()
    if not u3a.WaitForDialog("提示", "是否退出游戏？") then return end

end

-- 解析协议
function M:parseMsg()
    u3a.JMSG = self:require("LuaJmsg")
    u3a.JMSG:init(self:require("MessageDefine"))
end

function M:initData()
    self:createGameObject("DAFish")
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGrid")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCAction")
    self:createGameObject("SCGameClient")
    self:createGameObject("SCRecv")
    self:createGameObject("SCSend")
end

function M:initSkill()
    self:createGameObject("SKFreeze")
    self:createGameObject("SKBomb")
    self:createGameObject("SKSummon")
end

function M:play()
    self:createGameObject("SCUpdate"):play("http://192.168.67.132/fish/")
    self:parseMsg()
    self:initConfig()
    self:initData()
    self:createGameObject("UILoading")
    self:createGameObject("UIBackGround")
    self:createGameObject("UIEffect")
    self:createGameObject("UITouch")
    self:initSkill()
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UICoinMgr")
    self:createGameObject("UISkillPanel")
    self:createGameObject("UIRightPanel")
    self:find("UILoading"):play()
    u3a.WaitForFrames(1)
    self:createGameObject("UISelfChairTips")
    self:find("SCPool"):createFishPool()
    u3a.WaitForFrames(2)
    self:find("SCRecv"):set("start_process", true)
    self:find("SCGameLoop"):startUpdate()
    u3a.WaitForFrames(1)
    self:createGameObject("UIGunChange")
    self:find("UILoading"):removeFromScene()
    self:find("UISelfChairTips"):play()
end

return M