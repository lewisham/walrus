----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：墙牌
----------------------------------------------------------------------

local UIWallCards = class("UIWallCards", UIBase)

function UIWallCards:getParentNode()
    return self:find("UIDesk").WallCardsNode
end

function UIWallCards:onCreate()
    SafeRemoveNode(self.BackGround)
    self:loadCsb(MFullPath("csb/WallCards.csb"), false)
    self:set("cards", {})
    self:set("idx", 0)
    local tb = self:find("DAMahjong"):getWallCounts()
    self:initDown(tb[1])
    self:initLeft(tb[2])
    self:initUp(tb[3])
    self:initRight(tb[4])
end

-- 获得下一张牌
function UIWallCards:getNext()
    local idx = self:get("idx")
    local tb = self:get("cards")
    idx = idx + 1
    if idx > #tb then idx = 1 end
    self:set("idx", idx)
    return self:get("cards")[idx]
end

-- 获得最后一张牌
function UIWallCards:getLast()
end

function UIWallCards:addCard(sprite)
    local tb = self:get("cards")
    local idx = #tb + 1
    local unit = {}
    unit.idx = idx
    unit.sprite = sprite
    table.insert(tb, unit)
end

-- 初始化下面牌墙
function UIWallCards:initDown(cnt)
    if cnt == 0 then self.down:setVisible(false) return end
    local tb = {}
    local filename = MFullPath("csb/wallcards/WallCardDown%d.csb", cnt)
    local node = LoadCsb(filename, tb)
    self.down:addChild(node)
    for i = 1, 18 do
        local up = tb[string.format("card%02d", 2 * i - 1)]
        local down = tb[string.format("card%02d", 2 * i)]
        if up and down then
            self:addCard(up)
            self:addCard(down)
        end
    end
end

-- 初始化左面牌墙
function UIWallCards:initLeft(cnt)
    if cnt == 0 then self.left:setVisible(false) return end
    local tb = {}
    local filename = MFullPath("csb/wallcards/WallCardLeft%d.csb", cnt)
    local node = LoadCsb(filename, tb)
    self.left:addChild(node)
    for i = 1, 18 do
        local down = tb[string.format("card%02d", 2 * i - 1)]
        local up = tb[string.format("card%02d", 2 * i)]
        if up and down then
            self:addCard(up)
            self:addCard(down)
        end
    end
end

-- 初始化上面牌墙
function UIWallCards:initUp(cnt)
    if cnt == 0 then self.up:setVisible(false) return end
    local tb = {}
    local filename = MFullPath("csb/wallcards/WallCardUp%d.csb", cnt)
    local node = LoadCsb(filename, tb)
    self.up:addChild(node)
    for i = 1, 18 do
        local down = tb[string.format("card%02d", 2 * i - 1)]
        local up = tb[string.format("card%02d", 2 * i)]
        if up and down then
            self:addCard(up)
            self:addCard(down)
        end
    end
end

-- 初始化右面牌墙
function UIWallCards:initRight(cnt)
    if cnt == 0 then self.right:setVisible(false) return end
    local tb = {}
    local filename = MFullPath("csb/wallcards/WallCardLeft%d.csb", cnt)
    local node = LoadCsb(filename, tb)
    self.right:addChild(node)
    for i = 18, 1, -1 do
        local down = tb[string.format("card%02d", 2 * i - 1)]
        local up = tb[string.format("card%02d", 2 * i)]
        if up and down then
            up:setPositionX(1280 - up:getPositionX())
            up:setFlippedX(true)
            down:setPositionX(1280 - down:getPositionX())
            down:setFlippedX(true)
            self:addCard(up)
            self:addCard(down)
        end
    end
end

function UIWallCards:sendCard4(co)
    for i = 1, 4 do
        self:removeNext()
    end
    WaitForSeconds(co, 0.2)
end

function UIWallCards:sendCard1(co)
    self:removeNext()
    WaitForSeconds(co, 0.2)
end

function UIWallCards:removeNext()
    local unit = self:getNext()
    self:removeAction(unit.sprite)
end

function UIWallCards:removeAction(sprite)
    local tb = 
    {
        cc.MoveBy:create(0.15, cc.p(0, 20)),
        cc.Spawn:create(cc.FadeOut:create(0.05), cc.MoveBy:create(0.05, cc.p(0, 10))),
        cc.RemoveSelf:create(),
    }
    sprite:runAction(cc.Sequence:create(tb))
    --sprite:setLocalZOrder(1000)
end

return UIWallCards