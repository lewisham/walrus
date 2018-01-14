----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：通知界面
----------------------------------------------------------------------

local M = class("UINotice", UIBase)

function M:onCreate()
    self:loadCsb("ui/common/full_bg.csb", true)
    self.btn_close:onClicked(function() self:click_btn_close() end)
end

function M:click_btn_close()
    SafeRemoveNode(self)
end

return M