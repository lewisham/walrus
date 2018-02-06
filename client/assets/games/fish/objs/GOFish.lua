----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼对象
----------------------------------------------------------------------

local MOVE_TAG = 101

local M = class("GOFish", u3a.FishObject)

function M:onCreate(id)
    self:initData(id)
    self:createActionSprite()
    self:initCollider()
    self:setVisible(false)
    self:reset()
    self:getScene():get("fish_layer"):addChild(self, tonumber(self.config.show_layer))
end

function M:removeFromScreen()
    self:setVisible(false)
    self:setAlive(false)
end

function M:initData(id)
    self.id = id
    self.config = self:find("SCConfig"):get("fish")[id]
    self.vertices = self.config.vertices
    self.raduis_2 = self.config.raduis * self.config.raduis
    self.mFishSpriteList = {}
    self.mFreezeActionList = {}
end

function M:setOffsetPos(pos)
    self.mPathOffset = pos
end

function M:reset()
    self:setRed(false)
    self.hp = math.random(1, 30)
    self.mPathOffset = cc.p(0, 0)
    self.frameIdx = 1
    self.mCurIdx = 3
    self.mState = u3a.FISH_STATE.normal
    self.mRedIdx = 0
    self.mStopRedCnt = 0
end

function M:setPath(path)
    self.path = path
    self.frameIdx = 1
    self.mCurIdx = 3
end

function M:updateFrame()
    self.mCurIdx = self.mCurIdx - 1
    if self.mCurIdx <= 0 then
        self.mCurIdx = 3
        self:nextFrame()
    end
    self:updateShadowPos()
    self:updateRed()
end

function M:updateRed()
    if self.mStopRedCnt > 0 then
        self.mStopRedCnt = self.mStopRedCnt - 1
    end
    if self.mRedIdx > 0 then
        self.mRedIdx = self.mRedIdx - 1
        self.mStopRedCnt = 12
        self:setRed(true)
    else
        self:setRed(false)
    end
end

function M:setRed(bo)
    for _, sprite in ipairs(self.mFishSpriteList) do
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
    self.frameIdx = frame or 1
    if self.path[frame] == nil then 
        self:outOfFrame()
        return 
    end
    local pos, angle = self:getPathInfo()
    self:setAlive(true)
    self:setVisible(true)
    self:setPosition(pos)
    self:updateAngle(angle)
    self:updateFrame()
end

-- 下一帧
function M:nextFrame()
    self.frameIdx = self.frameIdx + 1
    if self.path[self.frameIdx] == nil then 
        self:outOfFrame()
        return 
    end
    local pos, angle = self:getPathInfo()
    local mov = cc.MoveTo:create(0.15, pos)
    mov:setTag(MOVE_TAG)
    self:updateAngle(angle)
    self:runAction(mov)
end

function M:getPathInfo()
    local unit = self.path[self.frameIdx]
    local pos = cc.pAdd(self.mPathOffset, unit.pos)
    if not self:getScene():get("flip") then 
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

function M:fadeOut()
    local function callback()
        for _, sprite in ipairs(self.mFishSpriteList) do
            sprite:setOpacity(255)
        end
        self:removeFromScreen()
    end
    for _, sprite in ipairs(self.mFishSpriteList) do
        sprite:runAction(cc.Sequence:create(cc.FadeOut:create(0.3), cc.CallFunc:create(callback)))
    end
end

function M:flipFishSprite(bY, bFilp)
    for _, sprite in ipairs(self.mFishSpriteList) do
        if bY then
            sprite:setFlippedY(bFilp)
        else
            sprite:setFlippedX(bFilp)
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
    local sp = cc.Sprite:createWithSpriteFrameName(self.config.fish_res .. "_00.png")
    self:addChild(sp)
    local strFormat = string.format("%s_%s.png", self.config.fish_res, "%02d")
    local animation = self:find("SCAction"):createAnimation(strFormat, 3 / 20.2)
    local act1 = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    table.insert(self.mFreezeActionList, act1)
    sp:runAction(act1)
    table.insert(self.mFishSpriteList, sp)

    -- 阴影
    local shadow = cc.Sprite:create()
    shadow:setColor(cc.c3b(0, 0, 0))
    shadow:setOpacity(128)
    shadow:setScale(0.8)
    local act2 = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    table.insert(self.mFreezeActionList, act2)
    shadow:runAction(act2)
    self:addChild(shadow, -2)
    self.shadow = shadow
end

function M:onHit()
    if self.mStopRedCnt == 0 then
        self.mStopRedCnt = 12
        self.mRedIdx = 8
    end
    self.hp = self.hp - 1
    if self.hp < 1 then
        self:outOfFrame()
        self:find("UICoinMgr"):play(cc.p(self:getPosition()), tonumber(self.config.coin_num), self:getScene():get("view_id"), math.random(10, 100))
    end
end

function M:updateState(state)
    if self.mState == state then return end
    self.mState = state
    if state == u3a.FISH_STATE.normal then
        self:onNormal()
    elseif state == u3a.FISH_STATE.start_freeze then
        self:onStartFreeze()
    elseif state == u3a.FISH_STATE.freeze then
    elseif state == u3a.FISH_STATE.end_freeze then
    end
end

function M:onNormal()
    self.mCurIdx = 0
    for _, action in ipairs(self.mFreezeActionList) do
        action:setSpeed(1.0)
    end
end

function M:onStartFreeze()
    self:stopActionByTag(MOVE_TAG)
    for _, action in ipairs(self.mFreezeActionList) do
        action:setSpeed(0)
    end
end

return M