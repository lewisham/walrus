----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：设置界面
----------------------------------------------------------------------

local M = class("UISetting", FCDefine.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("ui/fishform/uifishform.csb"), true)
end

function M:click_btn_close()
    SafeRemoveNode(self)
end

return M