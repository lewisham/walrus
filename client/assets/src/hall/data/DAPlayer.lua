----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：玩家数据
----------------------------------------------------------------------

local M = class("DAPlayer", GameObject)

function M:onCreate()
    self:set("money", 0)
    self:set("bank", 0)
    self:set("nickname", "")
    self:set("id", 0)
    self:test()
end

function M:test()
    self:set("money", 1000)
    self:set("bank", 2000)
    self:set("nickname", "张三")
    self:set("id", 295417)
end

return M