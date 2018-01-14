----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅下边菜单栏
----------------------------------------------------------------------

local M = class("UIBroadInfo", UIBase)

function M:onCreate()
    local go = self:find("DAPlayer")
    self.txt_name:setString(go:get("nickname"))
    self.txt_id:setString("ID." .. go:get("id"))
end

function M:click_btn_mail()
    self:createGameObject("UINotice")
end

return M