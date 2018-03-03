----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-02-26
-- 描述：公告
----------------------------------------------------------------------

local M = class("UINotice", wls.UIGameObject)

local ROLL_SPEED = 60

function M:onCreate()
    self:loadCenterNode(self:fullPath("ui/common/uiannouncement.csb"), false)
    self:setPositionY(150)
    self:setVisible(false)
    self._msgList = {}
    self._isShowing = false
end

function M:pushNotice(msg)
    table.insert(self._msgList, msg)
    self:updateNoticeList()
end

function M:updateNoticeList()
    if table.maxn(self._msgList) <= 0 then
        self:setVisible(false)
        return
    else
        self:setVisible(true)
    end

    if self._isShowing then return end
    self._isShowing = true
    self:showNotice(self._msgList[1])
end

function M:showNotice(msg)
    if not msg or msg == {} then return end
    self.node_word:setPositionX(self.bg:getContentSize().width)
    for i=1,5 do
        self.node_word:getChildByName("txt_" .. i):setString(tostring(msg.params[i]))
    end

    local pos = 0
    for i,v in ipairs(self.node_word:getChildren()) do
        v:setPositionX(pos)
        pos = pos + v:getContentSize().width + 2
    end
    local width = pos + 50

    local rollAni = cc.Sequence:create(
        cc.MoveTo:create(width / ROLL_SPEED, cc.p(-width, 25)),
        cc.CallFunc:create(function()
            table.remove(self._msgList, 1)
            self._isShowing = false
            self:updateNoticeList()
        end)
    )
    self.node_word:runAction(rollAni)
end

return M