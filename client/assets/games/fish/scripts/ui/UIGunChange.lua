----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台Panel
----------------------------------------------------------------------

local M = class("UIGunChange", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uigunchange.csb"))
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    self:setPosition(cannon:convertToWorldSpaceAR(cc.p(0, 62)))
    self:setVisible(false)
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
    self:setVisible(false)
end

function M:open()
    self:setVisible(true)
    local bAutoFire = self:getScene():get("auto_fire")
    self.spr_autofire:setVisible(not bAutoFire)
    self.spr_cancelauto:setVisible(bAutoFire)
end

function M:close()
    self:setVisible(false)
end

function M:click_btn_autofire()
    self:setVisible(false)
    local bAutoFire = not self:getScene():get("auto_fire")
    self:getScene():set("auto_fire", bAutoFire)
    if not bAutoFire then
        self:find("UITouch"):stopTimer()
    end
end

function M:click_btn_face()
    self:setVisible(false)
end

function M:click_btn_changecannon()
    self:setVisible(false)
end

return M