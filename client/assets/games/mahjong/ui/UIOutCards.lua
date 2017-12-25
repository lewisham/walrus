----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：打出去的牌
----------------------------------------------------------------------

local UIOutCards = class("UIOutCards", UIBase)

function UIOutCards:getParentNode()
    return self:find("UIDesk").OutCardsNode
end

function UIOutCards:onCreate()
    self:loadCsb(MFullPath("csb/OutCard.csb"), false)
    SafeRemoveNode(self.BgNode) 
    SafeRemoveNode(self.CenterNode)
    self:set("map", {{}, {}, {}, {}})
    self:initDown()
    self:initUp()
    self:initLeft()
    self:initRight()
    self:updateDown(GetRandomCards(12))
    self:updateLeft(GetRandomCards(3))
    self:updateUp(GetRandomCards(6))
    self:updateRight(GetRandomCards(16))
end

function UIOutCards:initDown()
    local tb = {}
    BindToUI(self.down, tb)
    local list = self:get("map")[1]
    for i = 1, 21 do
        local bg = tb[string.format("card%02d", i)]
        bg:setVisible(false)
        local unit = {}
        unit.bg = bg
        unit.idx = i
        table.insert(list, unit)
    end
end

function UIOutCards:initLeft()
    local tb = {}
    BindToUI(self.left, tb)
    local list = self:get("map")[2]
    for i = 1, 21 do
        local bg = tb[string.format("card%02d", i)]
        bg:setVisible(false)
        local unit = {}
        unit.bg = bg
        unit.idx = i
        table.insert(list, unit)
    end
end

function UIOutCards:initUp()
    local tb = {}
    BindToUI(self.up, tb)
    local list = self:get("map")[3]
    for i = 21, 1, -1 do
        local bg = tb[string.format("card%02d", i)]
        bg:setVisible(false)
        local unit = {}
        unit.bg = bg
        unit.idx = i
        table.insert(list, unit)
    end
end

function UIOutCards:initRight()
    local tb = {}
    BindToUI(self.right, tb)
    local list = self:get("map")[4]
    for j = 1, 3 do
        for i = 7, 1, - 1 do
            local idx = 7 * (j - 1) + i
            local bg = tb[string.format("card%02d", idx)]
            bg:setVisible(false)
            local unit = {}
            unit.bg = bg
            unit.idx = idx
            table.insert(list, unit)
        end
    end
end

function UIOutCards:updateDown(cards)
    local tb = self:get("map")[1]
    for key, val in ipairs(tb) do
        local idx = cards[key]
        if idx then
            local filename = self:fullName("assets/handcards/down/hand_card_%02d.png", idx)
            local bg = val.bg
            bg:setVisible(true)
            local card = cc.Sprite:create(filename)
            card:setSkewX(bg:getSkewX())
            local size = bg:getContentSize()
            card:setScale(0.45)
            card:setPosition(size.width / 2, size.height / 2 + 10)
            bg:addChild(card)
        end
    end
end

function UIOutCards:updateUp(cards)
    local tb = self:get("map")[3]
    for key, val in ipairs(tb) do
        local idx = cards[key]
        if idx then
            local filename = self:fullName("assets/handcards/down/hand_card_%02d.png", idx)
            local bg = val.bg
            bg:setVisible(true)
            local card = cc.Sprite:create(filename)
            card:setSkewX(bg:getSkewX())
            local size = bg:getContentSize()
            card:setScale(-0.45)
            card:setPosition(size.width / 2, size.height / 2 + 10)
            bg:addChild(card)
        end
    end
end

function UIOutCards:updateLeft(cards)
    local tb = self:get("map")[2]
    for key, val in ipairs(tb) do
        local idx = cards[key]
        if idx then
            local filename = self:fullName("assets/outcards/left/hand_card_1_%02d.png", idx)
            local bg = val.bg
            bg:setVisible(true)
            print(filename)
            local card = cc.Sprite:create(filename)
            card:setSkewX(bg:getSkewX())
            local size = bg:getContentSize()
            card:setScale(0.8)
            card:setPosition(size.width / 2, size.height / 2 + 10)
            bg:addChild(card)
        end
    end
end

function UIOutCards:updateRight(cards)
    local tb = self:get("map")[4]
    for key, val in ipairs(tb) do
        local idx = cards[key]
        if idx then
            local filename = self:fullName("assets/outcards/right/hand_card_1_%02d.png", idx)
            local bg = val.bg
            bg:setVisible(true)
            print(filename)
            local card = cc.Sprite:create(filename)
            card:setSkewX(bg:getSkewX())
            local size = bg:getContentSize()
            card:setScale(0.8)
            card:setPosition(size.width / 2, size.height / 2 + 10)
            bg:addChild(card)
        end
    end
end

return UIOutCards