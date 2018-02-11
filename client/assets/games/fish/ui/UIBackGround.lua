----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：背景界面
----------------------------------------------------------------------

local M = class("UIBackGround", u3a.UIGameObject)

function M:onCreate()
    local sprite = cc.Sprite:create(self:fullPath(string.format("bg/bl_roombg_%s.jpg", u3a.RoomIdx)))
    self:addChild(sprite)
    sprite:setPosition(display.width / 2, display.height / 2)
    sprite:setScale(display.height / 720)
    self:initWave()
    self:initBubble()
    self:initLayer()
    self:initJoinTips()
end

-- 水波纹
function M:initWave()
    local wave1 = cc.Sprite:create(self:fullPath("bg/wave_1_00.png"))
    wave1:setPosition(cc.p(display.width / 2, display.height / 2))
    self:addChild(wave1)
    wave1:setScale(2)
    wave1:setOpacity(0)
    local time = 0.9
    local seq = cc.Sequence:create(cc.FadeTo:create(time,255),cc.FadeTo:create(time,0))
    wave1:runAction(cc.RepeatForever:create(seq))

    local wave2 = cc.Sprite:create(self:fullPath("bg/wave_1_01.png"))
    wave2:setPosition(cc.p(display.width / 2, display.height / 2))
    self:addChild(wave2)
    wave2:setScale(2)
    wave2:setOpacity(255)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(function ()
        local seq2 = cc.Sequence:create(cc.FadeTo:create(time,255),cc.FadeTo:create(time,0))
        wave2:runAction(cc.RepeatForever:create(seq2))
    end)))
end

function M:initBubble()
    local emitter1 = cc.ParticleSystemQuad:create(self:fullPath("bg/effect_paopao_01.plist"))  
    emitter1:setAutoRemoveOnFinish(false)
    emitter1:setPosition(195, 160)
    self:addChild(emitter1)  

    local emitter2 = cc.ParticleSystemQuad:create(self:fullPath("bg/effect_paopao_01.plist"))  
    emitter2:setAutoRemoveOnFinish(false)
    emitter2:setPosition(1147, 212)
    self:addChild(emitter2)  
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


function M:shake(interval, times)
    local pos = cc.p(display.width / 2, display.height / 2)
    local function move()
        local function getDirect()
            return math.random(1, 2) == 2 and -1 or 1
        end
        times = times - 1
        self:stopActionByTag(11200)
        self:setPosition(pos)
        local offset = 30/20*times
        local tarPos = cc.p(math.random(-offset*getDirect(),offset*getDirect()), math.random(-offset*getDirect(),offset*getDirect()))
        local moveBy = cc.MoveBy:create(interval/2, tarPos);
        local act = cc.RepeatForever:create(cc.Sequence:create(moveBy, moveBy:reverse()))
        act:setTag(11200)
        self:runAction(act)
        
    end
    local act = cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(move), cc.DelayTime:create(interval)), times)
    self:runAction(act)
end

function M:initJoinTips()
    self.waiting = {}
    for i = 1, 4 do
		self.waiting[i] = cc.Sprite:create(self:fullPath("bg/bl_pic_ddjr.png"))
    	self.waiting[i]:setPosition(u3a.AimPosTab[i])
    	self:addChild(self.waiting[i], 100)
    	self.waiting[i]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(0.8,0),cc.DelayTime:create(0.2),cc.FadeTo:create(0.8,255))))
	end
end

function M:showWaiting(viewID, bVisible)
    self.waiting[viewID]:setVisible(bVisible)
end

return M