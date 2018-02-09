----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：技能操作层
----------------------------------------------------------------------

--底部的按键
local DOWN_LIST  = 
{
    { ["varname"] = "btn_skill_3",["propId"] = 3,["index"] = 1,["allCount"] = 3}, 
    { ["varname"] = "btn_skill_4",["propId"] = 4,["index"] = 2,["allCount"] = 3},
    { ["varname"] = "btn_skill_5",["propId"] = 5,["index"] = 1,["allCount"] = 1},
    --{ ["varname"] = "btn_skill_17",["propId"] = 17,["index"] = 3,["allCount"] = 3},
    --{ ["varname"] = "btn_skill_14",["propId"] = 14,["index"] = 1,["allCount"] = 1},
}

local M = class("UISkillPanel", u3a.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/skill/uiskilldesk.csb"))
    self.node_violentcd:setVisible(false)
    self.btn_skill_14:setVisible(false)
    self.btn_skill_5:setVisible(false)
    self.node_left:setVisible(false)
    for k, v in ipairs(DOWN_LIST) do
        local go = self:wrapGameObject(self[v.varname], "UISkillIcon")
        go:updateIcon(v.propId, v.index, v.allCount)
    end
end

return M