----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：技能操作层
----------------------------------------------------------------------

local M = class("UISkill", UIBase)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/skill/uiskilldesk.csb"))
    self.node_violentcd:setVisible(false)
    self.btn_skill_14:setVisible(false)
    self.btn_skill_5:setVisible(false)
    self.node_left:setVisible(false)
end

return M