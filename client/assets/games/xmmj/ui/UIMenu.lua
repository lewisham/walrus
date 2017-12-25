----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗层ui
----------------------------------------------------------------------

local UIMenu = class("UIMenu", UIBase)

function UIMenu:onCreate()
    self:loadCsb("ui/battle/BattlePanel.csb", false)
end

function UIMenu:click_btn_restart()
    --ReloadLuaModule("Ting")
    --require("Ting"):test()
    --do return end
    self:getScene():createGameObject("UISetting") 
end

return UIMenu