----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：准备
----------------------------------------------------------------------

local UIReady = class("UIReady", UIBase)

function UIReady:onCreate()
    self:loadCsb(MFullPath("csb/Ready.csb"), true)
    self.Node_1:setVisible(false)
end

function UIReady:click_btn_start()
    self.btn_start:setVisible(false)
end

function UIReady:play(co)
    self:playAction()
    WaitForSeconds(co, 2.5)
    self:removeFromScene()
end

function UIReady:playAction()
    self.Node_1:setVisible(true)
    local total = 4.5
    for i = 1, 9 do
        local node = self["word" .. i]
        node:stopAllActions()
        local front = (i - 1) * total / 9
        local back = total - front
        local tb = 
        {
            cc.DelayTime:create(front),
            cc.JumpBy:create(0.3, cc.p(0, 0), 25, 1),
            cc.DelayTime:create(back),
        }
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(tb)))
    end
end

return UIReady
