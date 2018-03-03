----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：自身玩家数据
----------------------------------------------------------------------

local M = class("DAPlayer", wls.GameObject)

function M:onCreate()
end

function M:updateData(data)
    for key, val in pairs(data) do
        self[key] = val
    end
    self.props = {}
    for _, val in ipairs(data.props) do
        self.props[val.propId] = val.propCount
    end
    Log(data)
end

-- 获得玩家数据
function M:getDataByKey(key)
    if self[key] == nil then
        Log("该数据不存在")
    end
    return self[key] or 0
end

-- 获得道具数量
function M:getPropCnt(id)
    return self.props[id] or 0
end

-- 获得下一级炮的倍率
function M:getNextRate(cur)
    if cur > self.maxGunRate then return wls.RoomMinGunRate end
    local tb = self:find("SCConfig"):get("cannon")
    local config = nil
    for key, val in ipairs(tb) do
        if val.times == cur then
            config = tb[key + 1]
            if config == nil then config = tb[1] end
            break
        end
    end
    return config.times
end

-- 获得上一级炮的倍率
function M:getLastRate(cur)
    if cur <= wls.RoomMinGunRate then return self:getNextRate(self.maxGunRate) end
    local tb = self:find("SCConfig"):get("cannon")
    local config = nil
    for key, val in ipairs(tb) do
        if val.times == cur then
            config = tb[key - 1]
            if config == nil then config = tb[#tb] end
            break
        end
    end
    return config.times
end

return M