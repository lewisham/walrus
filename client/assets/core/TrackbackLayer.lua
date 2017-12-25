----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：打印错误消息
----------------------------------------------------------------------

local M = class("TrackbackLayer", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 150)) end)

function M:show(msg, traceback)
    local layer = M:create()
    layer:init(msg, traceback)
    g_RootNode:addChild(layer, 1000000)
    return layer
end

function M:init(msg, traceback)
    local text = msg .. "\n" .. traceback
    local messageLabel = cc.Label:createWithSystemFont(text, "STHeitiSC-Medium", 20)
    self:addChild(messageLabel)
    messageLabel:setAlignment(1)
    messageLabel:setHorizontalAlignment(0)
    messageLabel:setPosition(display.center)
end

return M


