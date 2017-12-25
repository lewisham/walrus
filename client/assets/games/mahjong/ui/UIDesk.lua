----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：桌面
----------------------------------------------------------------------

local UIDesk = class("UIDesk", UIBase)

function UIDesk:onCreate()
    self:loadCsb(MFullPath("csb/Table.csb"), true)
    self:createGameObject("UICenter")
    self:createGameObject("UIWallCards")
end

function UIDesk:reset()
    self:reloadGameObject("UICenter")
    self:reloadGameObject("UIWallCards")
    self:reloadGameObject("UIOutCards")
    self:reloadGameObject("UIHandCards")
end

-- 游戏开始发牌
function UIDesk:sendCards(co)
    self:find("UIDesk"):reset()
    self:find("UICenter"):playDice(co)
    for i = 1, 12 do
        self:find("UIWallCards"):sendCard4(co)
    end
    for i = 1, 5 do
        self:find("UIWallCards"):sendCard1(co)
    end
end

return UIDesk
