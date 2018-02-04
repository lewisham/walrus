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

local resolution = {
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

print(display.width, display.height)
local scene = require("games.fish.SFish").new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()


