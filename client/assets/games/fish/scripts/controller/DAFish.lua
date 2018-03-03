----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("DAFish", wls.GameObject)

function M:onCreate()
    self:set("bullet_cnts", {0, 0, 0, 0})
    self:set("props", {})
    self.mBulletIdx = 0
end

function M:getBulletCnt(viewID)
    return self:get("bullet_cnts")[viewID]
end

function M:modifyBulletCnt(viewID, cnt)
    local cur = self:get("bullet_cnts")[viewID]
    cur = cur + cnt
    self:get("bullet_cnts")[viewID] = cur
end

-- 创建子弹id
function M:createBulletID()
    self.mBulletIdx = self.mBulletIdx + 1
    if self.mBulletIdx > 100 then self.mBulletIdx = 0 end
    local id
    if wls.CreateBulletID then
        id = wls.CreateBulletID(self.mBulletIdx)
    else
        id = wls.SelfViewID .. self.mBulletIdx
    end
    return id
end

return M