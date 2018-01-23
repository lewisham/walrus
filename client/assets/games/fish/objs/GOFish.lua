----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：鱼对象
----------------------------------------------------------------------

local MOVE_TAG = 101

local M = class("GOFish", require("games.fish.objs.GOCollider"))

function M:onCreate(id)
    self.id = id
    self.config = self:find("SCConfig"):get("fish")[id]
    self.vertices = self.config.vertices
    self.raduis_2 = self.config.raduis * self.config.raduis
    self:createActionSprite()
    self:initCollider()
    self:setVisible(false)
    self:reset()
    self:getScene():get("fish_layer"):addChild(self, tonumber(self.config.show_layer))
end

function M:setOffsetPos(pos)
    self.mPathOffset = pos
end
function M:reset()
    self.fishSprite:setOpacity(255)
    self.hp = math.random(1, 30)
    self.mPathOffset = cc.p(0, 0)
    self.frameIdx = 1
    self.mCurIdx = 0
    self.mState = 0
    self.mRedIdx = 0
    self.mbRed = false
end

function M:setPath(path)
    self.path = path
    self.frameIdx = 1
    self.mCurIdx = 0
end

function M:setState(state)
    self.mState = state
end

function M:updateFrame()
    if self.mState == 0 then
        self.mCurIdx = self.mCurIdx + 1
        if self.mCurIdx == 3 then
            self.mCurIdx = 0
            self:nextFrame()
        end
    end
    self:updateShadowPos()
    self:updatePoints()
    self:updateRed()
end

function M:updateRed()
    if self.mRedIdx > 0 then
        self.mRedIdx = self.mRedIdx - 1
        self.fishSprite:setColor(cc.c3b(255, 0, 0))
    else
        self.fishSprite:setColor(cc.c3b(255, 255, 255))
    end
end


function M:updateShadowPos()
    if self.shadow == nil then return end
    local pos = cc.pAdd(cc.p(self:getPosition()), cc.p(30, -30))
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
    self:setAlive(true)
    self:stopActionByTag(MOVE_TAG)
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
    self:setVisible(false)
    self:setAlive(false)
end

function M:fadeOut()
    local function callback()
        self:setVisible(false)
        self:setAlive(false)
    end
    self.fishSprite:runAction(cc.Sequence:create(cc.FadeOut:create(0.3), cc.CallFunc:create(callback)))
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
            self.fishSprite:setFlippedY(true)
        else
            self.fishSprite:setFlippedY(false)
        end
    elseif rt == 3 then
        angle = angle + 90
        self:setRotation(an0gle)
        if angle > 90 and angle < 270 then
            self.fishSprite:setFlippedX(true)
        else
            self.fishSprite:setFlippedX(false)
        end
    end
end

-- 动作精灵
function M:createActionSprite()
    local filename = self.config.fish_res
    local sp = cc.Sprite:createWithSpriteFrameName(filename .. "_00.png")
    self:addChild(sp)
    local animation = cc.Animation:create()
    local idx = 0
    while true do
        local frameName = string.format("%s_%02d.png", filename, idx)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        if spriteFrame == nil then break end
        animation:addSpriteFrame(spriteFrame)
        idx = idx + 1
    end
    animation:setDelayPerUnit(3 / 20.0)
    local act = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    sp:runAction(act)
    self.fishSprite = sp

    -- 阴影
    local shadow = cc.Sprite:create()
    shadow:setColor(cc.c3b(0, 0, 0))
    shadow:setOpacity(128)
    shadow:setScale(0.8)
    local act = cc.Speed:create(cc.RepeatForever:create(cc.Animate:create(animation)), 1.0)
    shadow:runAction(act)
    self:addChild(shadow, -2)
    self.shadow = shadow
end

function M:onHit()
    self.mRedIdx = 5
    self.hp = self.hp - 1
    if self.hp < 1 then
        self:outOfFrame()
    end
end

return M