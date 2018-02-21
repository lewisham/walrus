----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：图鉴
----------------------------------------------------------------------

local M = class("UIFishHandBook", wls.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("ui/fishform/uifishform.csb"), true)
end

function M:click_btn_close()
    wls.SafeRemoveNode(self)
end

return M