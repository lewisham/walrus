----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：玩家的手牌
----------------------------------------------------------------------

local UIPlayerHandCards = class("UIPlayerHandCards", UIBase)

function UIPlayerHandCards:onCreate()
    self.mCardRoot = cc.Node:create()
    self.mSelectCard = nil
    self:addChild(self.mCardRoot)
    self:registerEvent()
    self:resetCards()
end

function UIPlayerHandCards:registerEvent()
    local size = cc.Director:getInstance():getWinSize()
    self:setContentSize(size)
 	self:setTouchEnabled(true)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
    local function touchEvent(_sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local pos = self:getTouchBeganPosition()
            self:selectCard(pos)
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then 
            local pos = self:getTouchEndPosition()
            if self.mSelectCard then
                self:onCancelSelect()
            end
            self.mSelectCard = nil
        elseif eventType == ccui.TouchEventType.moved then  
            local pos = self:getTouchMovePosition()
            if self.mSelectCard == nil then
                self:selectCard(pos)
            end
            if self.mSelectCard then
                self:onDragCard(pos)
            end
		end
	end
	self:addTouchEventListener(touchEvent)
end

-- 选择牌
function UIPlayerHandCards:selectCard(pos)
    local tb = self.mCardRoot:getChildren()
    for _, node in ipairs(tb) do
        local rect = node:getBoundingBox()
        if cc.rectContainsPoint(rect, pos) then
            self.mSelectCard = node
            break
        end
    end
    if self.mSelectCard then
        self:onSelectCard()
    end
end

function UIPlayerHandCards:onSelectCard()
    self.mSelectCard:setScale(1.2)
    self.mDragCard = self:createCard(self.mSelectCard.number)
    self.mDragCard:setPosition(self.mSelectCard:getPosition())
    self.mDragCard:setScale(self.mSelectCard:getScale())
end

function UIPlayerHandCards:onDragCard(pos)
    self.mDragCard:setPosition(pos)
end

function UIPlayerHandCards:onCancelSelect()
    SafeRemoveNode(self.mDragCard)
    local tb = self.mCardRoot:getChildren()
    for _, node in ipairs(tb) do
    end
end

function UIPlayerHandCards:resetCards()
    local tb = {1, 2, 3, 4}
    local x = self:calcStartPosX(#tb)
    local y = 2
    local offx = 80
    for key, number in ipairs(tb) do
        local node = self:createCard(number)
        node:setPosition(x, y)
        x = x + offx
    end
end

function UIPlayerHandCards:calcStartPosX(cnt)
    return 180
end

function UIPlayerHandCards:createCard(number)
    local card = ccui.ImageView:create(MFullPath("images/handcards/down/img_normal_card.png"))
    self.mCardRoot:addChild(card)
    card:setAnchorPoint(0, 0)
    local size = card:getContentSize()
    local sprite = ccui.ImageView:create(MFullPath("images/handcards/down/hand_card_%02d.png", number))
    card:addChild(sprite)
    sprite:setPosition(size.width / 2, size.height / 2)

    card.number = number
    return card
end

return UIPlayerHandCards