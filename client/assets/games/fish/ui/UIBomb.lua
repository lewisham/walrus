----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：核弹特效
----------------------------------------------------------------------

local M = class("UIBomb", FCDefine.UIGameObject)

function M:onCreate(pos)
    self:setPosition(pos)
    self:coroutine(self, "loop")
end

function M:loop()
    WaitForFrames(1)
    self:playCsbAni(self:fullPath("ui/bomb/uimbomb1.csb"), 120)
    self:playCsbAni(self:fullPath("ui/bomb/uimbombcom.csb"), 165)
    self:playCsbAni(self:fullPath("ui/bomb/uisbomb2.csb"), 49)
    FCDefine.SafeRemoveNode(self)
end

function M:playCsbAni(filename, frames)
    local node = LoadCsb(filename)
    self:addChild(node)
    FCDefine.BindToUI(node, node)
    node:setPosition(0, 0)
    local action = cc.CSLoader:createTimeline(filename)
    node:runAction(action)
    action:gotoFrameAndPlay(0)
    WaitForSeconds(frames / 60.0)
    FCDefine.SafeRemoveNode(node)
end

return M