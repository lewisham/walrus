----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅主界面
----------------------------------------------------------------------

local M = class("UIMainHome", UIBase)

function M:onCreate()
    self:loadCsb("ui/hall/hall_layer.csb", true)
    self:wrapGameObject(self.Panel_Menu, "UIBottomPanel")
    self:wrapGameObject(self.Node_BroadInfo, "UIBroadInfo")
    self:wrapGameObject(self.pv, "UIGameSet")
end

return M