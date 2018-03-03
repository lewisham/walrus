----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2018-2-23
-- 描述：微乐大厅启动场景
----------------------------------------------------------------------

local M = class("GSLauncherWL", wls.GameScene)

function M:createAutoPath()
    self:autoAddSound("games\\fish\\assets\\sound")
    self:autoRequire("games\\fish")
end

-- 解析协议
function M:parseMsg()
    wls.JMSG = self:require("LuaJmsg")
    wls.JMSG:init(self:require("MessageDefine"))
end

function M:run()
    self:parseMsg()
    self:set("assets_path", "games/fish/assets/")
    self:coroutine(self, "play")
end

function M:play()
    self:createScene()
    wls.WaitForFrames(1)
    self:createRoot()
    
    self:createGameObject("SCSelectRoom")
    self:createGameObject("SCJoinRoom")
    self:createGameObject("UIHallBackGround")
    self:createGameObject("UIHallPanel")
    self:createGameObject("SCConfig"):initHallData()
end

function M:createScene()
    local scene = cc.Scene:create()
    cc.Director:getInstance():pushScene(scene)
end

function M:exitToHall()
    self:destroy()
    cc.Director:getInstance():popToRootScene()
end

return M