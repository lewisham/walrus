----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：核弹技能
----------------------------------------------------------------------

local M = class("SKBomb", u3a.UIGameObject)

function M:onCreate()
    
end

function M:activeSkill()
end

function M:releaseSkill(pos)
    self:coroutine(self, "loop", pos)
end

function M:loop(pos)
    u3a.WaitForFrames(1)
    local root = cc.Node:create()
    self:addChild(root)
    root:setPosition(pos)
    self:playCsbAni(root, self:fullPath("ui/bomb/uimbomb1.csb"), 120)
    self:playCsbAni(root, self:fullPath("ui/bomb/uimbombcom.csb"), 165)
    self:playCsbAni(root, self:fullPath("ui/bomb/uisbomb2.csb"), 49)
    u3a.SafeRemoveNode(root)
end

function M:playCsbAni(root, filename, frames)
    local node = u3a.LoadCsb(filename)
    root:addChild(node)
    u3a.BindToUI(node, node)
    node:setPosition(0, 0)
    local action = cc.CSLoader:createTimeline(filename)
    node:runAction(action)
    action:gotoFrameAndPlay(0)
    u3a.WaitForSeconds(frames / 60.0)
    u3a.SafeRemoveNode(node)
end

return M