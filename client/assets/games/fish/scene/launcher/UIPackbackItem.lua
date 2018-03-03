local M = class("UIPackbackItem", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("hall/packback_item.csb"))
    self.spr_chooseframe:setVisible(false)
    self.spr_item:setVisible(false)
    self.fnt_item_count:setVisible(false)
end

function M:initWithData(config, data)
    self.spr_item:setVisible(true)
    self.fnt_item_count:setVisible(true)
    self.spr_item:setTexture(self:fullPath("ui/images/common/prop/"..config["res"]))
    self.fnt_item_count:setString(data["propCount"])
    self:set("config", config)
    self:set("data", data)
end

function M:setSelected()
    self.spr_chooseframe:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1.1, 1.1), cc.ScaleTo:create(0.05, 1, 1)))
    self.spr_chooseframe:setVisible(true)
end

function M:cancelSelected()
    self.spr_chooseframe:setVisible(false)
end

function M:isSelected()
    return self.spr_chooseframe:isVisible()
end

function M:isNull()
    return self.spr_item:isVisible()
end

function M:isClicked(pos)
    local itemWorldPos = self:convertToWorldSpace(cc.p(self.panel:getPositionX(), self.panel:getPositionY()))
    local size = self.panel:getContentSize()
    local rect = cc.rect(itemWorldPos.x-size.width/2, itemWorldPos.y-size.height/2, size.width, size.height)
    return cc.rectContainsPoint(rect, pos)
end

function M:getItemSize()
    return cc.size(self.panel:getContentSize().width, self.panel:getContentSize().height)
end

function M:getConfigData()
    return self:get("config"), self:get("data")
end

return M