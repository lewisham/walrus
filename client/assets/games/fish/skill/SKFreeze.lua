----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：冰冻技能
----------------------------------------------------------------------

local M = class("SKFreeze", u3a.UIGameObject)

function M:onCreate()
    self:set("duration", 0)
end

function M:activeSkill()
    self:releaseSkill()
end

function M:releaseSkill()
    if self:get("duration") > 0 then
        self:set("duration", 10.0)
        return
    end
    self:set("duration", 10.0)
    self:coroutine(self, "releaseSkillImpl")
end

function M:releaseSkillImpl()
    self:find("SCGameLoop"):set("freeze", true)
    local go = self:find("SCPool")
    for _, fish in ipairs(go.mFishList) do
        if fish.alive then
            fish:updateState(u3a.FISH_STATE.start_freeze)
        end
    end
    local dt = 0.2
    while true do
        if self:modify("duration", -dt) < 0 then break end
        u3a.WaitForSeconds(dt)
    end
    self:find("SCGameLoop"):set("freeze", false)
    local go = self:find("SCPool")
    for _, fish in ipairs(go.mFishList) do
        if fish.alive then
            fish:updateState(u3a.FISH_STATE.normal)
        end
    end
end

return M