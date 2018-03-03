local M = class("UIPlayerInfoPanel", wls.UIGameObject)

function M:onCreate()
    local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    local roleInfo = gg.Cookies:GetDefRole(from)

    self:loadCenterNode(self:fullPath("hall/player_info_panel.csb"), true)
    local playerInfo = self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]
    self.text_account:setString(roleInfo["username"])
    self.text_grade:setString(playerInfo["gradeExp"])
    self.text_id:setString(playerInfo["playerId"])
    self.text_name:setString(roleInfo["nick"])
    self.text_coin:setString(playerInfo["fishIcon"])
    self.text_crystal:setString(playerInfo["crystal"])
end

function M:setPlayerInfo(info)
    
end

function M:click_btn_close()
    self:removeFromScene()
end

function M:click_btn_rank()
end

return M