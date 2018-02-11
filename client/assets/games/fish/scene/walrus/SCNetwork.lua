----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：网络处理
----------------------------------------------------------------------

local M = class("SCNetwork", u3a.GameObject)

function M:onCreate()

end

function M:sendMsg(id, req)
    self:post("SendMsg", id, req)
end

-------------------------------------
-- 消息处理
-------------------------------------

-- 玩家加入
function M:onMsgPlayerJoin(player)
    self:find("UIBackGround"):showWaiting(player.view_id, false)
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:join(player.is_self)
    cannon:updateGun(player.gun_id)
    self:find("SCPool"):createBulletPool(cannon.config.id)
    cannon.fnt_multiple:setString(player.gun_rate)
    cannon.fnt_coins:setString(player.coin)
    cannon.fnt_diamonds:setString(player.diamonds)

    if player.is_self then
        self:find("UITouch"):setTouchEnabled(true)
    end
end

-- 时间线
function M:onMsgCreateTimeLine(resp)
    self:find("SCPool"):createTimeLine(resp.id, resp.frame, false)
    self:find("SCPool"):createTimeLine(resp.id, resp.frame, true)
end

-- 鱼潮
function M:onMsgCreateFishGroup(resp)
    self:createGameObject("UIGroupComing"):play()
    local go = self:find("SCPool")
    go:removeTimeline()
    go:createFishGroup(resp.group_id, 1)
    go:allFishFadeOut()
end

function M:onMsgShoot(resp)
    local cannon = self:find("UICannon" .. resp.view_id)
    cannon:fire(resp.angle)
    cannon:updateCoin(resp.coin)
end

return M