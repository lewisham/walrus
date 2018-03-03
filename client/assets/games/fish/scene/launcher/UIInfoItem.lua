local M = class("UIInfoItem", wls.UIGameObject)

function M:onCreate()
    self:clipHead()
end

function M:setPlayerName(name)
    self.text_name:setString(name)
end

function M:clipHead()
    -- 头像裁剪
    local size = self.btn_player_head_bg:getContentSize()
    local node = self:getClippingNode(cc.rect(0, 0, size.width, size.width), size.width / 2)
    self.spr_player_bg:addChild(node)
    self.spr_player_photo:setVisible(false)
    node:setPosition(cc.p(self.btn_player_head_bg:getPositionX(),self.btn_player_head_bg:getPositionY()))
    
    local photo = cc.Sprite:createWithSpriteFrameName("games/fish/assets/hall/images/playerinfo/com_pic_photo_1.png");
    photo:setContentSize(cc.size(size.width, size.width))
    photo:setAnchorPoint(cc.p(0, 0))
    photo:setPosition(cc.p(0, 0))
    photo:setVisible(true)

    node:addChild(photo)
    node:setVisible(true)
    self.spr_head_edge:setLocalZOrder(node:getLocalZOrder() + 1)
end

function M:getClippingNode(rect, radius)
    local clippNode = cc.ClippingNode:create();
    local drawNode = cc.DrawNode:create();
    local segments = 100
    local origin = cc.p(rect.x, rect.y)
    local destination = cc.p(rect.x + rect.width, rect.y + rect.height)
    local points = { }

    local coef = math.pi / 2 / segments
    local vertices = { }
    for i = 0, segments do
        local rads =(segments - i) * coef
        local x = radius * math.sin(rads)
        local y = radius * math.cos(rads)

        table.insert(vertices, cc.p(x, y))
    end
    local tagCenter = cc.p(0, 0)
    local minX = math.min(origin.x, destination.x)
    local maxX = math.max(origin.x, destination.x)
    local minY = math.min(origin.y, destination.y)
    local maxY = math.max(origin.y, destination.y)
    local dwPolygonPtMax =(segments + 1) * 4
    local pPolygonPtArr = { }
    tagCenter.x = minX + radius;
    tagCenter.y = maxY - radius;
    for i = 0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y
        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    tagCenter.x = maxX - radius;
    tagCenter.y = maxY - radius;
    for i = 0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y
        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    tagCenter.x = maxX - radius;
    tagCenter.y = minY + radius;
    for i = 0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y
        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    tagCenter.x = minX + radius;
    tagCenter.y = minY + radius;
    for i = 0, segments do
        local x = tagCenter.x - vertices[#vertices - i].x
        local y = tagCenter.y - vertices[#vertices - i].y
        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    drawNode:drawPolygon(pPolygonPtArr, #pPolygonPtArr, cc.c4f(0, 0, 0, 0), 1, cc.c4f(0, 1, 0, 1))
    clippNode:setStencil(drawNode);
    return clippNode;
end

function M:click_btn_player_head_bg()
    --打开玩家详情面板
    self:createGameObject("UIPlayerInfoPanel")
end

return M