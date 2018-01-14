----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：大厅场景
----------------------------------------------------------------------

local M = class("SHall", GameScene)

function M:run()
    self:createGameObject("DAPlayer")
    self:createGameObject("DAGameList")
    self:createGameObject("DANotice")
    self:createGameObject("SCNetWork")
    self:coroutine(self, "play")
end

function M:createAutoPath()
    self:autoRequire("src\\hall")
end


function M:play()
    self:createGameObject("UIHallBackGround")
    if not self:find("SCNetWork"):connect() then
        print("连接失败")
    end
    PlayMusic("sound/bgm_battle1.mp3")
    self:createGameObject("UIMainHome")
    self:find("SCNetWork"):test()
end

-- 启动游戏
function M:startGame(id)
    print("startGame", id)
    local config = game_tplt[id]
    if config == nil then return end
    self:getGameApp():pushScene(config.launch_file)
end

-- 更新游戏
function M:updateGame(id)
end

return M