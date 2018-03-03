----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：房间图标
----------------------------------------------------------------------
local INTERVAL = 370
local ICON_NUM = 3
local MAX_ROOM_LV = 4
local M = class("UIRoom", wls.UIGameObject)

function M:getZorder()
    return 1
end

function M:onCreate()
end

function M:setRoomLV(lv)
    self:set("level", lv)
    self:setRoomIcon(lv)
    self:createRoomAct(lv)

    self.animation:play("roomact", true)
end

function M:setPosIndex(index, appearIndex)
    local oldPosIndex = self:get("posIndex")
    local distance = (index-self:get("posIndex"))*INTERVAL
    local newPos = cc.p(cc.p(self:getPositionX()+distance, self:getPositionY()))
    self:set("posIndex", index)
    self:set("newPos", cc.p(newPos))
    if index == MAX_ROOM_LV then
        self:coroutine(self, "disappearAct")
    elseif index == appearIndex then
        self:coroutine(self, "appearAct")
    else
        self:coroutine(self, "normalAct")
    end
end

function M:setRoomIcon(lv)
    local uiroom = cc.CSLoader:createNode(self:fullPath("hall/uiroom0"..lv..".csb"))
    self.node_fish:removeAllChildren()
    for _, child in ipairs(uiroom:getChildren()) do
        wls.ChangeParentNode(child, self.node_fish)
    end
    wls.BindToUI(self, self)

    --第四个隐藏
    if lv == MAX_ROOM_LV then
        self:setVisible(false);
    end
end

function M:createRoomAct(lv)
    local action = cc.CSLoader:createTimeline(self:fullPath("hall/uiroom0"..lv..".csb"))
    action:gotoFrameAndPause(0)
    self:runAction(action)
    self.animation = action
end

function M:isClicked(touchBegPos)
    local pos = cc.p(self.panel:getWorldPosition())
    local size = self.panel:getContentSize()
    local rect = cc.rect(pos.x-size.width/2, pos.y-size.height/2, size.width, size.height)
    return cc.rectContainsPoint(rect, touchBegPos)
end

function M:scrollToRight()
    if self:get("posIndex") == MAX_ROOM_LV then
        self:setPosIndex(1, 1)
    else
        self:setPosIndex(self:get("posIndex")+1, 1)
    end
end

function M:scrollToLeft()
    if self:get("posIndex") == 1 then
        self:setPosIndex(MAX_ROOM_LV, 3)
    else
        self:setPosIndex(self:get("posIndex")-1, 3)
    end
end

--边缘图标消失移动
function M:disappearAct()
    self:runAction(cc.ScaleTo:create(0.08, 0, 0))
    wls.WaitForSeconds(0.08)
    self:setVisible(false)
    self:runAction(cc.MoveTo:create(0, cc.p(self:get("newPos"))))
    
end

--边缘图标出现移动
function M:appearAct()
    self:runAction(cc.MoveTo:create(0, cc.p(self:get("newPos"))))
    wls.WaitForSeconds(0.02)
    self:setVisible(true)
    self:runAction(cc.ScaleTo:create(0.08, 1, 1))
end

--中间图标移动
function M:normalAct()
    self:runAction(cc.MoveTo:create(0.2, cc.p(self:get("newPos"))))
end

function M:clicked(pos)
    self:find("SCRoomMgr"):sendGetDesk(self:get("level"))
end

return M