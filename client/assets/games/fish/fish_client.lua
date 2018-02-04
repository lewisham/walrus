rawset(_G, "u3a", require("games.fish.core.u3a"))
u3a.LuaObject = require("games.fish.core.LuaObject")
u3a.GameScene = require("games.fish.core.GameScene")
u3a.GameObject = require("games.fish.core.GameObject")
u3a.UIGameObject = require("games.fish.core.UIGameObject")
u3a.FishObject = require("games.fish.core.FishObject")

--require("core.Coroutine")

u3a.MAX_BULLET_CNT = 25
u3a.BULLET_LANCHER_INTERVAL = 0.2
u3a.FISH_STATE =
{
    normal = 1,
    start_freeze = 2,
    freeze = 3,
    end_freeze = 4, 
}

local scene = require("games.fish.SFish").new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()


