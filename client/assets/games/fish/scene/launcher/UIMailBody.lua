local COL = 8
local ROW = 1
local M = class("UIMailBody", wls.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("hall/mail_body.csb"), true)
end

function M:initWithData(data)

    self.text_time:setString(data.sendTime)
    self.text_title:setString(data.title)
    self.text_sender:setString(data.sender)
    self.text_body:setString(data.content)

    self:set("data", data)
    if (data.props == nil or table.maxn(data.props) == 0) and (data.seniorProps == nil or table.maxn(data.seniorProps) == 0) then
        --没道具
        return
    end
    local props = self:merge(data.props, data.seniorProps)

    self:createProp(props)
end

function M:createProp(props)
    local items = {}
    local propNum = table.maxn(props)
    local centerX = self.scroll_props:getInnerContainerSize().width/2
    local scrollSize = self.scroll_props:getContentSize()
    local firstItem = self:createGameObject("UIPackbackItem")
    local itemSize = firstItem:getItemSize()
    local beginX = centerX-(propNum-1)*itemSize.width/2
    local firstPropConfig = self:find("SCConfig"):getItemData(props[1]["propId"])
    local firstPos = cc.p(beginX, itemSize.height/2)
    firstItem:setPosition(firstPos)
    firstItem:initWithData(firstPropConfig, props[1])
    wls.ChangeParentNode(firstItem, self.scroll_props)
    table.insert(items, firstItem)
    
    
    for key = 2, propNum do
        local row = 1
        local col = (key%COL == 0 and COL or key%COL)
        local pos = cc.p(beginX+(col-1)*itemSize.width, itemSize.height/2)
        local info = self:find("SCConfig"):getItemData(props[key]["propId"])
        local item = self:createGameObject("UIPackbackItem")
        item:setPosition(pos)
        item:initWithData(info, props[key])
        wls.ChangeParentNode(item, self.scroll_props)
        table.insert(items, item)
    end
end

function M:merge(tab1, tab2)
    for key, val in pairs(tab2) do
        table.insert(tab1, val)
    end

    return tab1
end

function M:click_btn_close()
    self:removeFromScene()
end

function M:click_btn_sure()
    --发送确认邮件收取的消息
    self:find("SCRoomMgr"):sendMakeMailAsRead(self:get("data")["id"])
    
    self:removeFromScene()
end

return M