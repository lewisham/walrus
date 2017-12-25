----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：网络等待
----------------------------------------------------------------------

local UINetWaitting = class("UINetWaitting", UIBase)

function UINetWaitting:onCreate()
    self:loadCsb("system/network/NetWaitting.csb", true)
    local rotate = cc.RotateBy:create(1, 360)
	self.circle:runAction(cc.RepeatForever:create(rotate))
    self:setVisible(false)
end

return UINetWaitting