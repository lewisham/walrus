-- 代码重新加载
for _, path in pairs(require("games.fish.AutoPath")) do
    package.loaded[path] = nil
end

-- 核心
rawset(_G, "wls", require("games.fish.core.wls"))
wls.LuaObject = require("games.fish.core.LuaObject")
wls.GameScene = require("games.fish.core.GameScene")
wls.GameObject = require("games.fish.core.GameObject")
wls.UIGameObject = require("games.fish.core.UIGameObject")
wls.FishObject = require("games.fish.core.FishObject")

wls.RoomIdx = 1 -- 房间id
wls.SelfViewID = 1 -- 自己视图id
wls.RoomMinGunRate = 1 -- 当前房间最小炮率
wls.SendMsg = function() end -- 网络消息请求
wls.Toast = function() end
wls.Dialog = function() end

-- 启动场景
local launcherFile = "games.fish.scene.weile.GSWeile"
if FISH_SINGLE_GAME then
    launcherFile = "games.fish.scene.weile.GSWalrus"
end

local scene = require(launcherFile).new()
scene:createAutoPath()
scene:onCreate()
scene:run()
rawset(_G, "GFishScene", scene)


