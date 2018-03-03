
local M = class("UIMailPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("hall/mail_panel.csb"), true)
    local unreadMails = self:find("SCRoomMgr"):get("HallInfo")["unreadMails"]
    local scrollSize = self.scroll_list:getInnerContainerSize()
    local mailNum = table.maxn(unreadMails)
    local height = self.mail_item:getContentSize().height
    local newScrollSize = cc.size(scrollSize.width, (height*mailNum < scrollSize.height and scrollSize.height or height*mailNum))
    self.scroll_list:setInnerContainerSize(newScrollSize)

    for key, val in ipairs(unreadMails) do
        val.sender = key
    end

    if mailNum == 0 then
        self.mail_item:setVisible(false)
        return;
    end

    self.spr_words_nomail:setVisible(false)
    self:createMailItems(unreadMails)
end

function M:createMailItems(unreadMails)
    local mailNum = table.maxn(unreadMails)
    local scrollSize = self.scroll_list:getInnerContainerSize()
    local itemSize = self.mail_item:getContentSize()
    local height = (itemSize.height*mailNum < scrollSize.height and self.mail_item:getPositionY() or mailNum*itemSize.height-itemSize.height/2)
    local items = {}
    table.insert(items, self.mail_item)
    self.mail_item:setPositionY(height)
    self:setMailInfo(self.mail_item, unreadMails[1])

    for key = 2, mailNum do
        local item = self.mail_item:clone()
        self:setMailInfo(item, unreadMails[key])
        item:setPositionY(items[key-1]:getPositionY()-itemSize.height)
        self.scroll_list:addChild(item)
        table.insert(items, item)
    end
end

function M:setMailInfo(item, info)
    item:setTag(info["id"])
    item:getChildByName("btn_look"):onClicked(handler(self, self.click_btn_look))
    item:getChildByName("text_title"):setString(info["title"])
    item:getChildByName("text_sender"):setString(info["sender"])
    item:getChildByName("text_time"):setString(info["sendTime"])
end

function M:removeMailItem(mailId)
    local items = self.scroll_list:getChildren()
    for key = table.maxn(items), 1, -1 do
        if items[key]:getTag() == mailId then
            print("pos x:"..items[key]:getPositionX().." y:"..items[key]:getPositionY())
            items[key]:removeFromParent()
            table.remove(items, key)
        end
    end
    if table.maxn(items) == 0 then
        self.spr_words_nomail:setVisible(true)
        return
    end


    local scrollSize = self.scroll_list:getInnerContainerSize()
    local mailNum = table.maxn(items)
    local itemSize = items[1]:getContentSize()
    local height = (itemSize.height*mailNum < self.scroll_list:getContentSize().height and self.scroll_list:getContentSize().height-itemSize.height/2 or mailNum*itemSize.height-itemSize.height/2)
    local newSizeHeight = (itemSize.height*mailNum < self.scroll_list:getContentSize().height and self.scroll_list:getContentSize().height or itemSize.height*mailNum)
    local newScrollSize = cc.size(scrollSize.width, newSizeHeight)
    self.scroll_list:setInnerContainerSize(newScrollSize)

    items[1]:setPositionY(height)
    for key = 2, table.maxn(items) do
        items[key]:setPositionY(items[key-1]:getPositionY()-itemSize.height)
    end
    
end

function M:click_btn_close()
    self:removeFromScene()
end

function M:click_btn_look(sender)
    local mailId = sender:getParent():getTag()
    self:find("SCRoomMgr"):sendGetMailDetail(mailId)
end

function M:onGetMailDetail(data)
    if data.success then
        local mailBody = self:createGameObject("UIMailBody")
        mailBody:initWithData(data)
    end
end

function M:onMakeMailAsRead(data)
    if data.success then
        self:find("SCRoomMgr"):sendGetHallInfo()
        self:removeMailItem(data.id)
    end
end

return M