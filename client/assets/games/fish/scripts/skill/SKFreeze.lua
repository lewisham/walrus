----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：冰冻技能
----------------------------------------------------------------------

local M = class("SKFreeze", wls.UIGameObject)

function M:onCreate()
    self:set("duration", 0)
    local bg = cc.Sprite:create(self:fullPath("bg/effect_fullfz.png"))
    self:addChild(bg)
    bg:setPosition(display.width / 2, display.height / 2)
    bg:setVisible(false)
    bg:setScale(2 * display.height / 720)
    self.bg = bg
end

function M:activeSkill()
    self:releaseSkill()
end

-- 释放技能
function M:releaseSkill()
    if self:get("duration") > 0 then
        self:set("duration", 10.0)
        return
    end
    self:set("duration", 10.0)
    self:coroutine(self, "releaseSkillImpl")
end

function M:releaseSkillImpl()
    self:find("SCSound"):playSound("fishfreeze_01")
    self.bg:setOpacity(0)
    self.bg:setVisible(true)
    self.bg:runAction(cc.FadeIn:create(0.8))
    self:find("SCGameLoop"):set("freeze", true)
    local go = self:find("SCPool")
    for _, fish in ipairs(go.mFishList) do
        if fish.alive then
            fish:updateState(wls.FISH_STATE.start_freeze)
        end
    end
    local dt = 0.2
    while true do
        if self:modify("duration", -dt) < 0 then break end
        wls.WaitForSeconds(dt)
    end
    self:find("SCGameLoop"):set("freeze", false)
    local go = self:find("SCPool")
    for _, fish in ipairs(go.mFishList) do
        if fish.alive then
            fish:updateState(wls.FISH_STATE.normal)
        end
    end
    self.bg:runAction(cc.FadeOut:create(0.2))
    wls.WaitForSeconds(0.2)
    self.bg:setVisible(false)
end

return M