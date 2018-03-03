----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅背景界面
----------------------------------------------------------------------
local OFFSET_X = 6
local M = class("UIHallPanel", wls.UIGameObject)


function M:onCreate()
    self:loadCsb(self:fullPath("hall/fish_hall_panel.csb"))
    self.panel:addTouchEventListener(handler(self, self.click_btn_panel))

    self:wrapGameObject(self["node_peas"], "UIShowMoney")
    self:wrapGameObject(self["node_info"], "UIInfoItem")
end

function M:refreshWithData(data)
    local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    local roleInfo = gg.Cookies:GetDefRole(from)
    self.node_peas:setMoneyNum(data["crystal"])
    self.node_info:setPlayerName(roleInfo["nick"])
end

function M:click_btn_ret(sender)
    self:getScene():exitToHall()
end

function M:click_btn_panel(sender, eventName)
    if eventName == ccui.TouchEventType.began then
        self.touchBegPos = sender:getTouchBeganPosition()
    elseif eventName == ccui.TouchEventType.ended then
        self.touchEndPos = sender:getTouchEndPosition()
        if (self.touchEndPos.x-self.touchBegPos.x > OFFSET_X) or (self.touchEndPos.x-self.touchBegPos.x < -OFFSET_X) then
            self:find("UIHallBackGround"):scroll(self.touchBegPos, self.touchEndPos)
        else
            self:find("UIHallBackGround"):click(self.touchEndPos)
        end
    end
end

function M:click_btn_packback()
    --打开背包
    self:createGameObject("UIPackbackPanel")
end

function M:click_btn_forged()
    --打开锻造
    self:createGameObject("UIForgedPanel")
end


return M