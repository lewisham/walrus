----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：自已座提示
----------------------------------------------------------------------

local M = class("UISelfChairTips", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uiselftips.csb"), true)
    self.Node_1:setVisible(false)
end

function M:play()
    self.Node_1:setVisible(true)
    self:find("UIGunPanel"):open()
    local pos = cc.p(self:find("UICannon" .. wls.SelfViewID):getPosition())
    self.Node_1:setPosition(pos.x, pos.y + 180)
    local tb =
    {
        cc.MoveBy:create(0.5, cc.p(0,-10)),
        cc.MoveBy:create(0.5, cc.p(0,10)),
        cc.MoveBy:create(0.5, cc.p(0,-10)),
        cc.MoveBy:create(0.5, cc.p(0,10)),
    }
    self.Node_1:runAction(cc.Sequence:create(tb))
    wls.WaitForSeconds(2.0)
    self:find("UIGunPanel"):close()
    wls.SafeRemoveNode(self)
end

return M