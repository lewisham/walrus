----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：手牌
----------------------------------------------------------------------

local UIHandCards = class("UIHandCards", UIBase)

function UIHandCards:getParentNode()
    return self:find("UIDesk").HandCardsNode
end

function UIHandCards:onCreate()
    self:loadCsb(MFullPath("csb/HandCards.csb"), false)
    SafeRemoveNode(self.FileNode_1)
    self:updateCards()
    BindToUI(self.down, self.down)
    self:updateDownFuzi()
end

function UIHandCards:updateCards(tb)
    do return end
    tb = {1, 1, 2, 3, 4}
    local x = 100
    local y = 67
    for _, val in ipairs(tb) do
        local node = self:createCard(val)
        node:setPosition(x, y)
        x = x + 80
    end
end

function UIHandCards:createCard(idx)
    local node = cc.Node:create()
    self:addChild(node)
    local bg = cc.Sprite:create(self:fullName("assets/handcards/down/img_normal_card.png"))
    node:addChild(bg)
    local filename = self:fullName("assets/handcards/down/hand_card_%02d.png", idx)
    local image = cc.Sprite:create(filename)
    node:addChild(image)
    return node
end

function UIHandCards:updateFuziCard(bg, number, cnt)
    if cnt == 0 then bg:setVisible(false) return end
    bg:setVisible(true)
    SafeRemoveNode(bg.card)
    local filename = self:fullName("assets/handcards/down/hand_card_%02d.png", number)

    local card = cc.Sprite:create(filename)
    bg:addChild(card)
    bg.card = card
    card:setSkewX(-bg:getSkewX())
    local size = bg:getContentSize()
    card:setScale(0.6)
    card:setPosition(size.width / 2, size.height / 2 + 10)
end

function UIHandCards:updateDownFuzi()
    local tb = 
    {
        {data = {1, 2, 3, 0, 0}, counts = {1, 1, 1, 0, 0}},
        {data = {49, 50, 51, 52, 0}, counts = {1, 1, 1, 1, 0}},
        {data = {53, 54, 55, 0, 0}, counts = {1, 1, 1, 0, 0}},
        {data = {21, 21, 21, 0, 21}, counts = {1, 1, 1, 0, 1}},
    }
    local node = self.down
    for i = 1, 4 do
        local unit = tb[i]
        if unit == nil then
            node["fuzi" .. i]:setVisible(false)
        else
            node["fuzi" .. i]:setVisible(true)
            for j = 1, 5 do
                local key = string.format("fuzi%d_%d", i, j)
                self:updateFuziCard(node[key], unit.data[j], unit.counts[j])
            end
        end
    end
end

return UIHandCards