----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：自已座提示
----------------------------------------------------------------------

local M = class("UISelfChairTips", UIBase)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uiselftips.csb"), true)
    self.Node_1:setVisible(false)
end

function M:play()
    self.Node_1:setVisible(true)
    self:find("UIGunChange"):open()
    local pos = cc.p(self:find("UICannon" .. self:getScene():get("view_id")):getPosition())
    self.Node_1:setPosition(pos.x, pos.y + 180)
    local tb =
    {
        cc.MoveBy:create(0.5, cc.p(0,-10)),
        cc.MoveBy:create(0.5, cc.p(0,10)),
        cc.MoveBy:create(0.5, cc.p(0,-10)),
        cc.MoveBy:create(0.5, cc.p(0,10)),
    }
    self.Node_1:runAction(cc.Sequence:create(tb))
    WaitForSeconds(2.0)
    self:find("UIGunChange"):close()
    SafeRemoveNode(self)
end

return M