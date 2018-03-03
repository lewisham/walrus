----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台Panel
----------------------------------------------------------------------

local M = class("UIGunPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uigunchange.csb"))
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    self:setPosition(cannon:convertToWorldSpaceAR(cc.p(0, 62)))
    self:setVisible(false)

    self._posTb = {}
    for i,btn in ipairs(self.panel:getChildren()) do
        table.insert(self._posTb, {x = btn:getPositionX(), y = btn:getPositionY()})
    end
end

function M:switch()
    if self:isVisible() then
        self:close()
    else
        self:open()
    end
end

function M:onEventTouchBegan()
    if not self:isVisible() then return end
    self:close()
end

function M:open()
    self:setVisible(true)
    local bAutoFire = self:getScene():get("auto_fire")
    self.spr_autofire:setVisible(not bAutoFire)
    self.spr_cancelauto:setVisible(bAutoFire)

    for i,btn in ipairs(self.panel:getChildren()) do
        btn:stopAllActions()
        btn:setTouchEnabled(false)
        btn:setPosition(cc.p(0, 0))
        btn:setScale(0)
        btn:runAction(cc.ScaleTo:create(0.1, 1))
        btn:runAction(cc.Sequence:create(
            cc.MoveTo:create(0.1, self._posTb[i]),
            cc.CallFunc:create(function() btn:setTouchEnabled(true) end)
        ))
    end
end

function M:close()
    for i,btn in ipairs(self.panel:getChildren()) do
        btn:stopAllActions()
        btn:setTouchEnabled(false)
        btn:runAction(cc.ScaleTo:create(0.1, 0))
        btn:runAction(cc.Sequence:create(
            cc.MoveTo:create(0.1, cc.p(0, 0)),
            cc.CallFunc:create(function()
                btn:setScale(1)
                btn:setPosition(self._posTb[i])
            end)
        ))
    end
    self:callAfter(0.1, function() self:setVisible(false) end)
end

function M:click_btn_autofire()
    self:close()
    local bAutoFire = not self:getScene():get("auto_fire")
    self:getScene():set("auto_fire", bAutoFire)
    if not bAutoFire then
        self:find("UITouch"):stopTimer()
    end
end

function M:click_btn_face()
    self:close()
    self:find("UIEmoji"):setVisible(true)
end

function M:click_btn_changecannon()
    self:createGameObject("UIChangeGun")
end

return M