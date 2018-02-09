----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：特效层
----------------------------------------------------------------------

local M = class("UIEffect", u3a.UIGameObject)

function M:onCreate()
end

function M:playDeadthSound(soundType)
    if soundType == 7 then
        self:find("SCSound"):playSound("lightning_01")
    elseif soundType == 8 then
        self:find("SCSound"):playSound("capture_01")
    elseif soundType == 6 then
        self:find("SCSound"):playSound("bomb_01")
    elseif soundType >= 3 then
        self:find("SCSound"):playSound("capture_01")
    end
end

function M:playFishDeadEff(fish)
    -- 鱼死亡音效
    if fish.config.music_res ~= "0" and  math.random(0, 100) < tonumber(fish.config.music_rate) then
        self:find("SCSound"):playFishDead(fish.config.music_res)
    end
    self:find("UICoinMgr"):play(fish.position, tonumber(fish.config.coin_num), self:getScene():get("view_id"), math.random(10, 100))
    -- 特效音效
    local soundType = tonumber(fish.config.trace_type)
    if soundType == 7 then
        self:find("SCSound"):playSound("lightning_01")
    elseif soundType == 8 then
        self:find("SCSound"):playSound("capture_01")
    elseif soundType == 6 then
        self:find("SCSound"):playSound("bomb_01")
    elseif soundType >= 3 then
        self:find("SCSound"):playSound("capture_01")
    end
    -- 特效表现
    local deathType = tonumber(fish.config.death_effect)
    --deathType = 3
    local funname = "deathType" .. deathType
    if self[funname] then
        self[funname](self, fish)
    else
        fish:removeFromScreen()
    end
end

-- 效果1
function M:deathType1(fish)
    fish:stopAllActions()
    local function callback()
        fish:setActionSpeed(1.0)
        fish:removeFromScreen()
    end
    local tb =
    {
        cc.DelayTime:create(0.7),
        cc.CallFunc:create(callback),
    }
    fish:setActionSpeed(2.0)
    fish:runAction(cc.Sequence:create(tb))
end

-- 效果2
function M:deathType2(fish)
    fish:stopAllActions()
    fish:setActionSpeed(0)
    self:playBlastEff(0, fish.position)
    local function callback()
        fish:setScale(1)
        fish:removeFromScreen()
    end
    local tb =
    {
        cc.ScaleTo:create(0.1, 1.5),
        cc.RotateBy:create(2.0, 360 * 4),
        cc.CallFunc:create(callback),
    }
    fish:runAction(cc.Sequence:create(tb))
end

-- 效果3
function M:deathType3(fish)
    fish:stopAllActions()
    fish:setActionSpeed(0)
    self:playBlastEff(0, fish.position)
    self:playBlastCoinEff(0.2, fish.position)
    local function callback()
        fish:setScale(1)
        fish:removeFromScreen()
    end
    local tb =
    {
        cc.ScaleTo:create(0.1, 1.5),
        cc.RotateBy:create(2.0, 360 * 4),
        cc.CallFunc:create(callback),
    }
    fish:runAction(cc.Sequence:create(tb))
end

-- 效果4
function M:deathType4(fish)
    local delay = 1.2
    fish:stopAllActions()
    fish:setActionSpeed(0)
    self:playBlastEff(0, fish.position)
    self:playBlastCoinEff(0.2, fish.position)
    self:playBlastCoinEff(0, fish.position)
    local function callback()
        fish:setScale(1)
        fish:removeFromScreen()
    end
    local tb =
    {
        cc.ScaleTo:create(0.1, 1.5),
        cc.RotateBy:create(2.0, 360 * 4),
        cc.CallFunc:create(callback),
    }
    fish:runAction(cc.Sequence:create(tb))
end


function M:playBlastEff(delay, pos)
    local eff = cc.Sprite:create()
    self:addChild(eff)
    self:setPosition(pos)
    local strFormat = "games/fish/assets/ui/images/effect/blast1_%02d.png"
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 15.0)
    local tb = 
    {
        cc.DelayTime:create(delay),
        cc.Animate:create(animation),
        cc.RemoveSelf:create(),
    }
    eff:runAction(cc.Sequence:create(tb))
end

function M:playBlastCoinEff(delay, pos)
    local eff = cc.Sprite:create()
    self:addChild(eff)
    self:setPosition(pos)
    local strFormat = "games/fish/assets/ui/images/effect/blast2_%02d.png"
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 15.0)
    local tb = 
    {
        cc.DelayTime:create(delay),
        cc.Animate:create(animation),
        cc.RemoveSelf:create(),
    }
    eff:runAction(cc.Sequence:create(tb))
end

return M