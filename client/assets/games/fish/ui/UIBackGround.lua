----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：背景界面
----------------------------------------------------------------------

local M = class("UIBackGround", u3a.UIGameObject)

function M:onCreate()
    local idx = self:getScene():get("room_idx")
    local sprite = cc.Sprite:create(self:fullPath(string.format("bg/bl_roombg_%s.jpg", idx)))
    self:addChild(sprite)
    sprite:setPosition(display.width / 2, display.height / 2)
    sprite:setScaleY(display.height / 720)
    self:initWave()
    self:initLayer()
end

-- 水波纹
function M:initWave()
    local wave1 = cc.Sprite:create(self:fullPath("bg/wave_1_00.png"))
    wave1:setPosition(cc.p(display.width / 2, display.height / 2))
    self:addChild(wave1,1)
    wave1:setScale(2)
    wave1:setOpacity(0)
    local time = 0.9
    local seq = cc.Sequence:create(cc.FadeTo:create(time,255),cc.FadeTo:create(time,0))
    wave1:runAction(cc.RepeatForever:create(seq))

    local wave2 = cc.Sprite:create(self:fullPath("bg/wave_1_01.png"))
    wave2:setPosition(cc.p(display.width / 2, display.height / 2))
    self:addChild(wave2, 1)
    wave2:setScale(2)
    wave2:setOpacity(255)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(function ()
        local seq2 = cc.Sequence:create(cc.FadeTo:create(time,255),cc.FadeTo:create(time,0))
        wave2:runAction(cc.RepeatForever:create(seq2))
    end)))
end

function M:initLayer()
    local layer = cc.Layer:create()
    self:addChild(layer, 2)
    self:getScene():set("fish_layer", layer)

    layer = cc.Layer:create()
    self:addChild(layer, 3)
    self:getScene():set("bullet_layer", layer)

    layer = cc.Layer:create()
    self:addChild(layer, 3)
    self:getScene():set("net_layer", layer)
end

return M