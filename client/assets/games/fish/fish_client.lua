rawset(_G, "FCDefine", require("games.fish.FCDefine"))

local scene = require("games.fish.SFish").new()
scene:createRoot()
scene:createAutoPath()
scene:onCreate()
scene:run()
