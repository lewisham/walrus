----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：捕鱼全局定义
----------------------------------------------------------------------

local _M = {}
setmetatable(_M, {__index = _G})
setfenv(1, _M)

MAX_BULLET_CNT = 25
BULLET_LANCHER_INTERVAL = 0.2

function CreateSpriteFrameAnimation(strFormat, inteval)
    local animation = cc.Animation:create()
    local idx = 0
    while true do
        local frameName = string.format(strFormat, idx)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        if spriteFrame == nil then break end
        animation:addSpriteFrame(spriteFrame)
        idx = idx + 1
    end
    animation:setDelayPerUnit(3 / 20.0)
    return animation
end

return _M