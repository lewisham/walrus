----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗设置
----------------------------------------------------------------------

local UISetting = class("UISetting", UIBase)

function UISetting:onCreate()
    self:loadCsb("ui/battle/BattleSetting.csb", true)
    self.Panel_1:onClicked(function() SafeRemoveNode(self) end)
    local auto = self:find("DAPlayers"):getPlayer():get("robot")
    self.btn_auto:setSelected(auto)

    local function callback()
        print("time line end")
    end
    local tl = cc.CSLoader:createTimeline("ui/battle/BattleSetting.csb")
    self:runAction(tl)
    tl:setLastFrameCallFunc(callback)
    tl:play("test2", false)
end

function UISetting:getZorder()
    return 100
end

function UISetting:click_btn_auto()
    local cur = self:find("DAPlayers"):getPlayer():get("robot")
    cur = not cur
    self:find("DAPlayers"):getPlayer():set("robot", cur)
end

function UISetting:click_btn_sound()
end

return UISetting