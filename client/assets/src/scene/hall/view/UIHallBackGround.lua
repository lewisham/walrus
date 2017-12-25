----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅背景界面
----------------------------------------------------------------------

local M = class("UIHallBackGround", UIBase)

function M:onCreate()
    self:loadCsb("hall/main/HallBackGround.csb", true)
end

return M