----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：核弹特效
----------------------------------------------------------------------

local M = class("UIBomb", u3a.UIGameObject)

function M:onCreate(pos)
    self:setPosition(pos)
    self:coroutine(self, "loop")
end

function M:loop()
    u3a.WaitForFrames(1)
    self:playCsbAni(self:fullPath("ui/bomb/uimbomb1.csb"), 120)
    self:playCsbAni(self:fullPath("ui/bomb/uimbombcom.csb"), 165)
    self:playCsbAni(self:fullPath("ui/bomb/uisbomb2.csb"), 49)
    u3a.SafeRemoveNode(self)
end

function M:playCsbAni(filename, frames)
    local node = LoadCsb(filename)
    self:addChild(node)
    u3a.BindToUI(node, node)
    node:setPosition(0, 0)
    local action = cc.CSLoader:createTimeline(filename)
    node:runAction(action)
    action:gotoFrameAndPlay(0)
    u3a.WaitForSeconds(frames / 60.0)
    u3a.SafeRemoveNode(node)
end

return M