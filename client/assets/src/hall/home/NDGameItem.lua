----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：游戏item
----------------------------------------------------------------------

local M = class("NDGameItem", UIBase)

function M:onCreate(info)
    self.mGameInfo = info
    self:loadCsb("ui/hall/game_list_item_node.csb", false)
    self:initView()
end

function M:initView()
    local config = game_tplt[self.mGameInfo.id]
    self.panel:setVisible(false)
    self.action_node:setVisible(false)
    self.txt_name:setString(config.display_name)
    self.panel_bg:onClicked(function() self:click_game() end)
end

function M:click_game()
    self:getScene():startGame(self.mGameInfo.id)
end

return M