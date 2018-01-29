----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("DAFish", GameObject)

function M:onCreate()
    self:set("bullet_cnts", {0, 0, 0, 0})
    self:set("cannon_rates", {1, 2, 5, 10, 20, 30, 50, 100, 200, 500, 1000})
end

function M:getBulletCnt(viewID)
    return self:get("bullet_cnts")[viewID]
end

function M:modifyBulletCnt(viewID, cnt)
    local cur = self:get("bullet_cnts")[viewID]
    cur = cur + cnt
    self:get("bullet_cnts")[viewID] = cur
end

function M:getNextRate(cur)
    local tb = self:get("cannon_rates")
    for key, val in ipairs(tb) do
        if val == cur then
            return tb[key + 1]
        end
    end
end

function M:getLastRate(cur)
    local tb = self:get("cannon_rates")
    for key, val in ipairs(tb) do
        if val == cur then
            return tb[key - 1]
        end
    end
end

return M