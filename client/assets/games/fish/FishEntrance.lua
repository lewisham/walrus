-- 核心
rawset(_G, "wls", require("games.fish.core.wls"))
wls.LuaObject = require("games.fish.core.LuaObject")
wls.GameScene = require("games.fish.core.GameScene")
wls.GameObject = require("games.fish.core.GameObject")
wls.UIGameObject = require("games.fish.core.UIGameObject")
wls.FishObject = require("games.fish.core.FishObject")

-- 启动场景
local scene = require("games.fish.scene.launcher.GSLauncherWL").new()
scene:createAutoPath()
scene:onCreate()
scene:run()
rawset(_G, "GSLauncherWL", scene)

