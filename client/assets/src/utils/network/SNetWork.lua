----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：网络场景
----------------------------------------------------------------------

require("socket")

local M = class("SNetWork", GameScene)

-- 构造函数
function M:ctor()
    M.super.ctor(self)
    self.mRootZorder = 1
end

function M:init()
    self:getRoot():setTouchEnabled(false)
    self:require("NetGobalFunc")
    self:require("ByteArray")
    self:createGameObject("UINetWaitting")
end

function M:createAutoPath()
    self:autoRequire("src\\utils\\network")
end

function M:createTCP(name, host, port, timeout)
    local go = self:createGameObject("DAClientTCP")
    go:rename(name)
    local error = go:connect(host, port, timeout)
    if error ~= "" then
        go:removeFromScene()
    end
    return error
end

return M