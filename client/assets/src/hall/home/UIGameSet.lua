----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：游戏集合
----------------------------------------------------------------------

local vNum = 3
local hNum = 4
local ICON_WIDTH = 132
local ICON_HEIGHT = 175
local ICON_GAP_X = 20
local ICON_GAP_Y = 20

local M = class("UIGameSet", UIBase)

function M:onCreate()
    self:updateGames()
end

function M:createPages()
    local size = self:getContentSize()
    size.width = ICON_WIDTH * hNum + (hNum + 2) * ICON_GAP_X
    size.height = ICON_HEIGHT * vNum + (vNum + 2) * ICON_GAP_Y
    self:setContentSize(size)
    self:setPositionX(display.width - size.width - 40)
    local games = self:find("DAGameList"):getDispalyList()
    local pageCnt = math.ceil(#games / (vNum * hNum))
    local pages = {}
    for i = 1, pageCnt do
        local layout = ccui.Layout:create()
        layout:setContentSize(size)
        self:addPage(layout)
        table.insert(pages, layout)
    end
end

-- 更新游戏列表
function M:updateGames()
    self:createPages()
    local games = self:find("DAGameList"):getDispalyList()
    local sx = ICON_GAP_X + ICON_WIDTH / 2
    local sy = ICON_HEIGHT * (vNum - 1) + ICON_HEIGHT / 2 + ICON_GAP_Y * vNum
    local curPage = 1
    local x = sx
    local y = sy
    local cnt = 0
    local pages = self:getItems()
    for key, info in ipairs(games) do    
        cnt = cnt + 1 
        local item = self:createUnnameChild(pages[curPage], "NDGameItem", info)
        item:setPosition(x, y)
        x = x + ICON_GAP_X + ICON_WIDTH
        if cnt == 12 then
            x = sx
            y = sy
            cnt = 0
            curPage = curPage + 1
        elseif cnt % 4 == 0 then
            x = sx
            y = y - ICON_GAP_Y - ICON_HEIGHT
        end
    end
end

return M