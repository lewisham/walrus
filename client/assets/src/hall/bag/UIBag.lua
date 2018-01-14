----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：背包界面
----------------------------------------------------------------------

local M = class("UIBag", UIBase)

function M:onCreate()
    self:loadCenterNode("ui/bag/bag_node.csb", true, "scaleTo")
    local go = self:find("DAPlayer")
    self.txt_mn_xd:setString(go:get("money"))
    self.txt_mn_bg:setString(go:get("bank"))
end

function M:click_btn_close()
    SafeRemoveNode(self)
end

return M