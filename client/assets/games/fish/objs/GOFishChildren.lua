----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：多条鱼对象
----------------------------------------------------------------------

local M = class("GOFishChildren", require("games.fish.objs.GOFish"))

function M:onCreate(id)
    self:initData(id)
    self.mFishList = {}
    self:createFishes()
    self:initCollider()
    self:setVisible(false)
    self:reset()
    self:getScene():get("fish_layer"):addChild(self, tonumber(self.config.show_layer))
end

function M:createFishes()
    local config = self:find("SCConfig"):getFishchildren(tostring(self.id + 90000000))
    for i = 1, config.fishcount do
        local unit = {}
        table.insert(self.mFishList, unit)
        local node = cc.Node:create()
        self:addChild(node)
        unit.sp = self:createFishSprite(tostring(100000000 + config.fishid[i]))
        table.insert(self.mFishSpriteList, unit.sp)
        node:addChild(unit.sp)
        unit.sp:setScale(config.fishscale[i] / 100)
        unit.sp:setPosition(config.offset[i])
        unit.bg = cc.Sprite:create(self:fullPath(string.format("plist/fish/fish_com_%d.png", config.bgindex[i])))
        node:addChild(unit.bg, -1)
        unit.bg:setScale(config.bgscale[i] / 100)
        unit.bg:setPosition(config.offset[i])

        local act = cc.Speed:create(cc.RepeatForever:create(cc.RotateBy:create(3.0, 360)), 1.0)
        table.insert(self.mFreezeActionList, act)
        unit.bg:runAction(act)
    end
end

function M:createFishSprite(id)
    local config = self:find("SCConfig"):get("fish")[id]
    local sp = cc.Sprite:createWithSpriteFrameName(config.fish_res .. "_00.png")
    local strFormat = string.format("%s_%s.png", config.fish_res, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 3 / 20.2)
    local act = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    table.insert(self.mFreezeActionList, act)
    sp:runAction(act)
    return sp
end

return M