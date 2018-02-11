rawset(_G, "u3a", require("games.fish.core.u3a"))
u3a.LuaObject = require("games.fish.core.LuaObject")
u3a.GameScene = require("games.fish.core.GameScene")
u3a.GameObject = require("games.fish.core.GameObject")
u3a.UIGameObject = require("games.fish.core.UIGameObject")
u3a.FishObject = require("games.fish.core.FishObject")

local launcherFile = "games.fish.scene.walrus.SWalrus"
if OLD_FISH_TEST then
    launcherFile = "games.fish.scene.weile.SWeile"
end

local scene = require(launcherFile).new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()


