----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：微乐捕鱼
----------------------------------------------------------------------

local M = class("GSWalrus", wls.GameScene)

function M:createAutoPath()
    self:autoAddSound("games\\fish\\assets\\sound")
    self:autoRequire("games\\fish")
end

function M:initConfig()
    rawset(_G, "wls", self:require("wls"))
    self:require("FishDef")
    -- 显示配置
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
    wls.SCALE = 720 / display.width
    print(display.width, display.height)
end

function M:run()
    wls.RoomIdx = GFishRoomIdx or 1
    wls.RoomMinGunRate = tonumber(self:require("room")[tostring(910000000 + wls.RoomIdx)].cannon_min)
    math.randomseed(os.clock())
    self:initResolution()
    self:set("assets_path", "games/fish/assets/")
    self:coroutine(self, "play")
end

-- 解析协议
function M:parseMsg()
    wls.JMSG = self:require("LuaJmsg")
    wls.JMSG:init(self:require("MessageDefine"))
end

function M:initData()
    self:createGameObject("DAFish")
    self:createGameObject("DASkill")
    self:createGameObject("DAPlayer")
    self:createGameObject("SCConfig"):initGameData()
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGrid")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCAction")
end

function M:initSkill()
    self:createGameObject("SKFreeze")
    self:createGameObject("SKTimeRevert")
    self:createGameObject("SKBomb")
    self:createGameObject("SKSummon")
    self:createGameObject("SKViolent")
    self:createGameObject("SKLockTarget")
    self:createGameObject("UILockChain")
end

function M:initDialog()
    local go = self:createGameObject("UIDialog")
    go:rename("CommonDialog")
    wls.Dialog = function(style, str, callback)
        go:updateView(style, str)
        go:setCallback(callback)
        return go
    end
end

function M:play()
    self:createRoot()
    self:createGameObject("SCUpdate"):play("http://192.168.67.132/fish/")
    self:parseMsg()
    self:initConfig()
    self:initData()
    self:createGameObject("UIToast")
    self:initDialog()
    self:createGameObject("UILoading"):play()
    self:initUI()
    wls.WaitForFrames(1)
    self:find("SCPool"):createFishPool()
    wls.WaitForFrames(2)
    self:find("SCGameLoop"):startUpdate()
    wls.WaitForFrames(1)
    self:waitForReady()
    --self:find("UISkillPanel"):updateAllIcon()
    self:find("UILoading"):removeFromScene()
    self:createGameObject("UITestPanel")
    self:createGameObject("UISelfChairTips"):play()
end

-- 初始化界面
function M:initUI()
    self:createGameObject("UIBackGround")
    self:createGameObject("UIEffect")
    self:createGameObject("EFLighting")
    self:createGameObject("UITouch")
    self:initSkill()
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UICoinMgr")
    self:createGameObject("UIPropMgr")
    self:createGameObject("UISkillPanel")
    self:createGameObject("UIRightPanel")

    self:createGameObject("UINotice")
    self:createGameObject("UIGunPanel")
    self:createGameObject("UIEmoji")
	self:createGameObject("UIPlayerInfo")
	self:createGameObject("UIMagicPropAni")
	self:createGameObject("UINewBieTask")
    self:createGameObject("UISetting")
end

-- 等待准备
function M:waitForReady()
    self:createGameObject("IServer"):play()
end

function M:doExitGame()

end


return M