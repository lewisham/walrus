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
    --cc.Director:getInstance():setDisplayStats(true)
    --self:set("enble_collider", true) -- 显示碰撞区
    self:set("enable_fps", true) -- 显示帧速
    self:set("flip", false)
    self:set("shader_list", {})
    -- 游戏数据
    self:set("room_idx", 1)
    self:set("view_id", 2)
    self:set("auto_fire", false)
    self:set("retain_action", {})
end

function M:run()
    self:initConfig()
    --self:initShader()
    self:createGameObject("DAFish")
    self:createGameObject("SCConfig")
    self:createGameObject("SCSound")
    self:createGameObject("SCPool")
    self:createGameObject("SCGameLoop")
    self:createGameObject("SCNetwork")
    self:createGameObject("SCAction")
    self:coroutine(self, "play")
end

function M:doExitGameImpl()
    if not WaitForDialog("提示", "是否退出游戏？") then return end

end

function M:play()
    self:createGameObject("UILoading"):play()
    self:createGameObject("UIBackGround")
    self:createGameObject("UIEffect")
    self:createGameObject("UICoinMgr")
    self:createGameObject("UITouch")
    for i = 1, 4 do
        self:createGameObject("UICannon", i):rename("UICannon" .. i)
    end
    self:createGameObject("UIGunChange")
    self:createGameObject("ISever")
    self:createGameObject("UISkill")
    self:createGameObject("UIRightPanel")
    WaitForFrames(1)
    self:createGameObject("UISelfChairTips")
    self:find("UILoading"):removeFromScene()
    WaitForFrames(2)
    self:find("SCGameLoop"):startUpdate()
    self:find("UISelfChairTips"):play()
end

function M:initShader()
    local list = {}
    local function addShader(name, fsh)
        local glprogram = cc.GLProgram:createWithFilenames("games/fish/shader/common.vsh", "games/fish/shader/" .. fsh)
        local state = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
        state:retain()
        list[name] = state
    end
    list["normal"] = cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP")
    addShader("red", "red.fsh")
    self:set("shader_list", list)
end

return M