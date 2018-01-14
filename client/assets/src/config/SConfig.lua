----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：配置数据场景
----------------------------------------------------------------------

local M = class("SConfig", GameScene)

function M:createAutoPath()
    self:autoRequire("src\\config")
end

function M:onCreate()
    self:getRoot():setTouchEnabled(false)
    self:loadConfig()
end

-- 自动加载本目录下的所有配置文件
function M:loadConfig()
    for name, _ in pairs(self:get("lua_path")) do
        if string.endWith(name, "tplt") then
            rawset(_G, name, self:require(name))
        end
    end
end

return M