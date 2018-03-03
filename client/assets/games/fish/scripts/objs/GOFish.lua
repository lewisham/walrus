----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼对象
----------------------------------------------------------------------

local M = class("GOFish", wls.FishObject)

function M:onCreate(id)
    self:initData(id)
    self:createActionSprite()
    self:createHalo()
    self:initCollider()
    self:setVisible(false)
    self:reset()
    self:getScene():get("fish_layer"):addChild(self, tonumber(self.config.show_layer))
end

function M:removeFromScreen()
    self:setOutOfScreen(true)
    self:setVisible(false)
    self:setAlive(false)
    if self.fishType == 5 or self.fishType == 10 then
        self:find("SCSound"):playMusic("music_00" .. wls.RoomIdx)
    end
end

function M:initData(id)
    self.id = tonumber(id)
    self.config = self:find("SCConfig"):get("fish")[id]
    self.vertices = self.config.vertices
    self.raduis_2 = self.config.raduis * self.config.raduis
    self.mFishSpriteList = {}
    self.mRedSpriteList = {}
    self.mFreezeActionList = {}
    self.mHaloSpriteList = {}
    self.fishType = tonumber(self.config.trace_type)
    self.mbSpecailFish = (self.fishType == 6 or self.fishType == 7 or self.fishType == 8)
end

-- 创建光环
function M:createHalo()
    if self.config.halo_res == "0" then return end
    local bossHaloActType = tonumber(self.config.halo_type)
    local bgNameVec = string.split(self.config.halo_res, ";")
    local haloOffsetVec = {}
    local posList = string.split(self.config.halo_pos, ";")
    for _, val in ipairs(posList) do
        local tb = string.split(val, ",")
        table.insert(haloOffsetVec, cc.p(tonumber(tb[1]), tonumber(tb[2])))
    end
    if bossHaloActType == 1 then
        local lastSprite = nil
        for _, name in ipairs(bgNameVec) do
            local sprite = cc.Sprite:create(self:fullPath("plist/fish/" .. name))
            self:addChild(sprite, -1)
            sprite:setPosition(haloOffsetVec[1])
            sprite.x = sprite:getPositionX()
            sprite.y = sprite:getPositionY()
            lastSprite = sprite
            table.insert(self.mRedSpriteList, sprite)
            table.insert(self.mHaloSpriteList, sprite)
        end
        if lastSprite then
            local act1 = cc.Sequence:create(cc.ScaleTo:create(1.0, 1), cc.ScaleTo:create(0, 0))
            local act2 = cc.Sequence:create(cc.FadeTo:create(0.8, 204), cc.FadeTo:create(0.2, 0), cc.FadeTo:create(0.2, 255))
            lastSprite:runAction(cc.RepeatForever:create(cc.Spawn:create(act1, act2)))
        end
    elseif bossHaloActType == 2 then
        for _, name in ipairs(bgNameVec) do
            local sprite = cc.Sprite:create(self:fullPath("plist/fish/" .. name))
            self:addChild(sprite, -1)
            sprite:setPosition(haloOffsetVec[1])
            sprite.x = sprite:getPositionX()
            sprite.y = sprite:getPositionY()
            sprite:setScale(0.9)
            sprite:runAction(cc.RepeatForever:create(cc.RotateBy:create(12, 360)))
            table.insert(self.mHaloSpriteList, sprite)
        end
    else
        for _, name in ipairs(bgNameVec) do
            local sprite = cc.Sprite:create(self:fullPath("plist/fish/" .. name))
            self:addChild(sprite, -1)
            sprite:setPosition(haloOffsetVec[1])
            sprite.x = sprite:getPositionX()
            sprite.y = sprite:getPositionY()
            table.insert(self.mRedSpriteList, sprite)
            table.insert(self.mHaloSpriteList, sprite)
        end
    end
end

function M:setOffsetPos(pos)
    if pos == nil then return end
    self.mPathOffset.x = pos.x
    self.mPathOffset.y = pos.y
end

function M:reset()
    self:setRed(false)
    self.mPathOffset = cc.p(0, 0)
    self.frameIdx = 1
    self.totalFrame = 0
    self.mCurIdx = 3
    self.mState = wls.FISH_STATE.normal
    self.bRed = false
    self:setScale(1.0)
end

function M:setPath(path)
    self.path = path
    self.frameIdx = 1
    self.totalFrame = #path
    self.mCurIdx = 3
end

function M:updateFrame()
    self.mCurIdx = self.mCurIdx - 1
    if self.mState == wls.FISH_STATE.acce then
        self.frameIdx = self.frameIdx + 2
        self:nextFrame()
    elseif self.mCurIdx <= 0 then
        self.mCurIdx = 3
        self:nextFrame()
    end
    self:updateShadowPos()
end

function M:setRed(bo)
    for _, sprite in ipairs(self.mRedSpriteList) do
        self:find("SCAction"):setRed(sprite, bo)
    end
end

function M:updateShadowPos()
    if self.shadow == nil then return end
    local pos = cc.pAdd(cc.p(self:getPosition()), cc.p(20, -20))
    pos = self:convertToNodeSpaceAR(pos)
    self.shadow:setPosition(pos)
end

-- 跳转到帧
function M:gotoFrame(frame)
    assert(frame >= 0, "error frame " .. frame)
    self.frameIdx = math.floor(frame / 3) + 1
    self.mCurIdx = 3 - frame % 3
    if self.path[self.frameIdx] == nil then 
        self:outOfFrame()
        return 
    end
    local pos, angle = self:getPathInfo()
    self:setActionSpeed(1)
    self:setOutOfScreen(false)
    self:setAlive(true)
    self:setVisible(true)
    self:setPosition(pos)
    self:updateAngle(angle)
    self:updateFrame()
end

-- 下一帧
function M:nextFrame()
    self.frameIdx = self.frameIdx + 1
    if self.frameIdx > self.totalFrame then 
        self:outOfFrame()
        return 
    end
    local pos, angle = self:getPathInfo()
    self:updateAngle(angle)
    if wls.Skip_Frame then
        self:setPosition(pos)
        return
    end
    self:moveTo(pos, 0.15)
end

function M:getPathInfo()
    local unit = self.path[self.frameIdx]
    local pos = cc.pAdd(self.mPathOffset, unit.pos)
    if not wls.PlayerFlip then 
        return pos, unit.angle
    end
    pos.x = display.width - pos.x
    pos.y = display.height - pos.y
    return pos, unit.angle - 180
end

-- 帧数都走完
function M:outOfFrame()
    self:removeFromScreen()
end

-- 淡出
function M:fadeOut()
    if self:get("timeline_id") < 0 then return end
    self.mState = wls.FISH_STATE.acce
    self:setRed(false)
    local function callback()
        for _, sprite in ipairs(self.mRedSpriteList) do
            sprite:setOpacity(255)
        end
        if self.shadow then
            self.shadow:setOpacity(96)
        end
        self:removeFromScreen()
    end
    local total = #self.mRedSpriteList
    for key, sprite in ipairs(self.mRedSpriteList) do
        if key == total then
            sprite:runAction(cc.Sequence:create(cc.FadeOut:create(0.9), cc.CallFunc:create(callback)))
        else
            sprite:runAction(cc.FadeOut:create(0.8))
        end
    end
    if self.shadow then
        self.shadow:runAction(cc.FadeOut:create(0.8))
    end
end

-- 翻转
function M:flipFishSprite(bY, bFilp)
    for _, sprite in ipairs(self.mFishSpriteList) do
        if bY then
            sprite:setFlippedY(bFilp)
        else
            sprite:setFlippedX(bFilp)
        end
    end
    for _, sprite in ipairs(self.mHaloSpriteList) do
        if bY then
            sprite:setPositionY(bFilp and  -sprite.y or sprite.y)
        else
            sprite:setPositionX(bFilp and  -sprite.x or sprite.x)
        end
    end
end

function M:updateAngle(angle)
    local rt = tonumber(self.config.rotate_type)
    if rt == 0 then
        self:setRotation(angle + 90)
    elseif rt == 1 then
        self:setRotation(0)
    elseif rt == 2 then
        angle = angle + 90
        self:setRotation(angle)
        if angle > 90 and angle < 270 then
            self:flipFishSprite(true, true)
        else
            self:flipFishSprite(true, false)
        end
    elseif rt == 3 then
        angle = angle + 90
        self:setRotation(angle)
        if angle > 90 and angle < 270 then
            self:flipFishSprite(false, true)
        else
            self:flipFishSprite(false, false)
        end
    end
end

-- 动作精灵
function M:createActionSprite()
    local sp = cc.Sprite:create()
    self:addChild(sp)
    local strFormat = string.format("%s_%s.png", self.config.fish_res, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 3 / 20.2)
    local act1 = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    table.insert(self.mFreezeActionList, act1)
    sp:runAction(act1)
    table.insert(self.mFishSpriteList, sp)
    table.insert(self.mRedSpriteList, sp)

    -- 阴影
    local shadow = cc.Sprite:create()
    shadow:setColor(cc.c3b(0, 0, 0))
    shadow:setOpacity(96)
    shadow:setScale(0.8)
    local act2 = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    table.insert(self.mFreezeActionList, act2)
    shadow:runAction(act2)
    self:addChild(shadow, -2)
    self.shadow = shadow
end

-- 被捕获
function M:onHit()
    self:setAlive(false)
    self:setRed(false)
    if self.fishType == 7 then
        self:find("EFLighting"):startLighting(cc.p(self:getPosition()))
    else
        self:find("EFLighting"):addLighting(cc.p(self:getPosition()))
    end
end

-- 变红
function M:onRed()
    if self.bRed then return end
    self:setRed(true)
    self.bRed = true
    local tb =
    {
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function() self:setRed(false) end),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function() self.bRed = false end),
    }
    local act = cc.Sequence:create(tb)
    self:runAction(act)
end

-- 更新状态
function M:updateState(state)
    if self.mState == state then return end
    self.mState = state
    if state == wls.FISH_STATE.normal then
        self:onNormal()
    elseif state == wls.FISH_STATE.start_freeze then
        self:onStartFreeze()
    elseif state == wls.FISH_STATE.freeze then
    elseif state == wls.FISH_STATE.end_freeze then
    end
end

function M:onNormal()
    self.mCurIdx = 0
    self:setActionSpeed(1)
end

function M:onStartFreeze()
    self:stopMove()
    self:setActionSpeed(0)
end

-- 设置动作速度
function M:setActionSpeed(speed)
    for _, action in ipairs(self.mFreezeActionList) do
        action:setSpeed(speed)
    end
end

function M:isSpecailFish()
    return self.mbSpecailFish
end

return M