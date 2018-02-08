----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：Animation管理器
----------------------------------------------------------------------

local M = class("SCAction", u3a.GameObject)

function M:onCreate()
    self.mAnimationList = {}
    self.mRetainActions = {}
    self:set("shader_list", {})
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
    local frameName, spriteFrame
    while true do
        frameName = string.format(strFormat, idx)
        spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
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

-- 变红
function M:setRed(sprite, bo)
    if sprite.mbRed == bo then return end
    sprite.mbRed = bo
    if bo then
        local shader = self:get("shader_list")["red"]
        if shader then
            sprite:setGLProgramState(shader)
        else
            sprite:setColor(cc.c3b(255, 0, 0))
        end
    else
        local shader = self:get("shader_list")["normal"]
        if shader then
            sprite:setGLProgramState(shader)
        else
            sprite:setColor(cc.c3b(255, 255, 255))
        end
    end
end

function M:initShader()
    local list = {}
    local function addShader(name, fsh)
        local glprogram = cc.GLProgram:createWithFilenames("games/fish/shader/common.vsh", "games/fish/shader/" .. fsh)
        local state = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
        state:retain()
        list[name] = state
    end
    list["normal"] = cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP")
    addShader("red", "red.fsh")
    self:set("shader_list", list)
end

return M