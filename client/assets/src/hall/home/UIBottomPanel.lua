----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅下边菜单栏
----------------------------------------------------------------------

local M = class("UIBottomPanel", UIBase)

function M:onCreate()
end

function M:onUpdate()
    local go = self:find("DAPlayer")
    self.txt_beans:setString(go:get("money"))
end

function M:click_btn_bag()
    self:createGameObject("UIBag")
end

return M