----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("DAFish", GameObject)

function M:onCreate()
    self:set("bullet_cnts", {0, 0, 0, 0})
end

function M:getBulletCnt(viewID)
    return self:get("bullet_cnts")[viewID]
end

function M:modifyBulletCnt(viewID, cnt)
    local cur = self:get("bullet_cnts")[viewID]
    cur = cur + cnt
    self:get("bullet_cnts")[viewID] = cur
end

return M