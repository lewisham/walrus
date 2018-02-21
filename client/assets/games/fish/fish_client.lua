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
wls.SendMsg = function() end -- 网络消息请求

-- 启动场景
local launcherFile = "games.fish.scene.walrus.GSWalrus"
if OLD_FISH_TEST then
    launcherFile = "games.fish.scene.weile.GSWeile"
end

local scene = require(launcherFile).new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()
rawset(_G, "GFishScene", scene)


