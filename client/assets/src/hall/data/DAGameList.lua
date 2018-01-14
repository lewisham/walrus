----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：玩家游戏列表数据
----------------------------------------------------------------------

local M = class("DAGameList", GameObject)

function M:onCreate()
end

-- 显示的游戏列表
function M:getDispalyList()
    local tb = {}
    local unit = {}
    unit.id = 1001
    unit.idx = 1
    table.insert(tb, unit)
    local unit = {}
    unit.id = 2001
    unit.idx = 2
    table.insert(tb, unit)
    return tb
end

return M