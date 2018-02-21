----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：核弹技能
----------------------------------------------------------------------

local M = class("SKBomb", wls.UIGameObject)

function M:onCreate()
    
end

function M:activeSkill()
end

function M:releaseSkill(pos)
    self:coroutine(self, "loop", pos)
end

function M:loop(pos)
    wls.WaitForFrames(1)
    local root = cc.Node:create()
    self:addChild(root)
    root:setPosition(pos)
    self:playCsbAni(root, self:fullPath("ui/bomb/uimbomb1.csb"), 120)
    self:playCsbAni(root, self:fullPath("ui/bomb/uimbombcom.csb"), 165)
    self:playCsbAni(root, self:fullPath("ui/bomb/uisbomb2.csb"), 49)
    wls.SafeRemoveNode(root)
end

function M:playCsbAni(root, filename, frames)
    local node = wls.LoadCsb(filename)
    root:addChild(node)
    wls.BindToUI(node, node)
    node:setPosition(0, 0)
    local action = cc.CSLoader:createTimeline(filename)
    node:runAction(action)
    action:gotoFrameAndPlay(0)
    wls.WaitForSeconds(frames / 60.0)
    wls.SafeRemoveNode(node)
end

return M