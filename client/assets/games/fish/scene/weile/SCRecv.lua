----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：网络接收处理
----------------------------------------------------------------------

local M = class("SCRecv", u3a.GameObject)

function M:onCreate()
    self:set("start_process", false)
end 

function M:doHandleMsg(id, resp)
    resp = clone(resp)
    if id == "MSGS2CGameStatus" then
        u3a.Invoke(self, id, resp)
        return
    end
    if not self:get("start_process") then return end
    if self[id] == nil then
        print("++++++++++++++++++++++未处理的消息协议   " .. id)
        return
    end
    u3a.Invoke(self, id, resp)
end

function M:getPlayer(id)
    return self:find("SCGameClient"):getPlayer(id)
end

-------------------------------------
-- 协议处理
-------------------------------------

-- 进入游戏初始化
function M:MSGS2CGameStatus(resp)
    --Log(resp)
    for _, val in pairs(resp.playerInfos) do
        self:MSGS2CPlayerJion(val)
    end
    self:find("SCGameLoop"):setClientFrame(resp.frameId)
    self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, false)
    self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, true)
end

-- 玩家加入 
function M:MSGS2CPlayerJion(resp)
    --Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    resp.is_self = player.is_self
    resp.chairid = player.chairid
    resp.view_id = player.view_id
    self:find("UIBackGround"):showWaiting(resp.view_id, false)
    local cannon = self:find("UICannon" .. resp.view_id)
    cannon:join(resp.is_self)
    cannon:updateGun(resp.gunType)
    cannon:find("SCPool"):createBulletPool(cannon.config.id)
    cannon.fnt_multiple:setString(resp.currentGunRate)
    cannon.fnt_coins:setString(resp.fishIcon)
    cannon.fnt_diamonds:setString(resp.crystal)
    if resp.is_self then
        self:find("UITouch"):setTouchEnabled(true)
    end
end

-- 心跳包
function M:MSGS2CHeartBeat(resp)
    self:find("SCGameLoop"):setServerFrame(resp.frameCount)
    self:find("SCGameLoop"):syncFrame()
end

-- 玩家射击
function M:MSGS2CPlayerShoot(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:fire(resp.angle)
    local cost = (resp.isViolent and resp.gunRate*resp.nViolentRatio or resp.gunRate)
    cannon:modifyCoin(-cost)
end

-- 击中鱼
function M:MSGS2CPlayerHit(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    if #resp.killedFishes == 0 then return end
    --Log(resp)
    local go = self:find("SCPool")
    for _, val in ipairs(resp.killedFishes) do
        go:killFish(player.view_id, val.timelineId, val.fishArrayId)
    end
end

-- 请求冰冻技能结果
function M:MSGS2CFreezeResult(resp)
    if not resp.isSuccess then
        return
    end
    self:find("SKFreeze"):activeSkill()
end

-- 开始冰冻技能
function M:MSGS2CFreezeStart(resp)
    self:find("SKFreeze"):activeSkill()
end

-- 结束冰冻技能
function M:MSGS2CFreezeEnd(resp)
end

-- 改变炮的倍率
function M:MSGS2CGunRateChange(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:updateGunRate(resp.newGunRate)
end

-- 鱼潮来临提示
function M:MSGS2CFishGroupNotify(resp)
    local function callback()
        self:createGameObject("UIGroupComing"):play()
        local go = self:find("SCPool")
        go:removeTimeline()
        go:allFishFadeOut()
    end
    self:find("UIBackGround"):callAfter(11, callback)
end

-- 鱼潮来临
function M:MSGS2CStartFishGroup(resp)
    self:find("SCGameLoop"):setClientFrame(1)
    self:find("SCPool"):createFishGroup(resp.index, 1)
end

-- 鱼时间线
function M:MSGS2CStartTimeline(resp)
    self:find("SCGameLoop"):setClientFrame(1)
    self:find("SCPool"):createTimeLine(resp.index, 1, false)
    self:find("SCPool"):createTimeLine(resp.index, 1, true)
end

-- 召唤鱼
function M:MSGS2CCallFish(resp)
end

-- 全局消息广播
function M:MSGS2CGameAnnouncement(resp)
end

return M