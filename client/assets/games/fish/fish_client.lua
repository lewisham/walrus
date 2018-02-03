rawset(_G, "FCDefine", require("games.fish.core.FCDefine"))
FCDefine.LuaObject = require("games.fish.core.LuaObject")
FCDefine.GameScene = require("games.fish.core.GameScene")
FCDefine.GameObject = require("games.fish.core.GameObject")
FCDefine.UIGameObject = require("games.fish.core.UIGameObject")
FCDefine.FishObject = require("games.fish.core.FishObject")

require("core.Coroutine")

local scene = require("games.fish.SFish").new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()


