----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：麻将测试
----------------------------------------------------------------------

local SCDeubg = class("SCDeubg", GameObject)

function SCDeubg:init()
end

function SCDeubg:debug()
    DebugGameObject(self)
    self:coroutine(self, "play")
end

function SCDeubg:play(co)
    self:testRemoveOneByOne(co)
end

-- 测试移除牌
function SCDeubg:testRemoveOneByOne(co)
    local idx = 65
    local go = self:find("UIWallCards")
    local total = self:find("DAMahjong"):getCardAmount()
    for i = 1, total do
        local unit = go:get("cards")[idx]
        idx = idx + 1 > total and 1 or idx + 1
        if unit.sprite then
            DebugGameObject(go)
            go:removeAction(unit.sprite)
            unit.sprite = nil
            WaitForSeconds(co, 1.5)
        end
    end
end

return SCDeubg