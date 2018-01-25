----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：Animation管理器
----------------------------------------------------------------------

local M = class("SCAction", GameObject)

function M:onCreate()
    self.mAnimationList = {}
    self.mRetainActions = {}
end

function M:createAnimation(strFormat, inteval)
    local animation = self.mAnimationList[strFormat]
    if animation then 
        --print("++++++use cache", strFormat)
        return animation 
    end
    animation = cc.Animation:create()
    self.mAnimationList[strFormat] = animation
    local idx = 0
    while true do
        local frameName = string.format(strFormat, idx)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        if spriteFrame == nil then break end
        animation:addSpriteFrame(spriteFrame)
        idx = idx + 1
    end
    animation:setDelayPerUnit(inteval)
    animation:retain()
    return animation
end

function M:retainAction(action)
    action:retain()
    table.insert(self.mRetainActions, action)
end

return M