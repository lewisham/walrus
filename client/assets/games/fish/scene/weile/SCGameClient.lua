----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：c++ GameClient
----------------------------------------------------------------------

local M = class("SCGameClient", u3a.GameObject)

function M:onCreate()
    self:set("start_process", false)
    self.mPlayerList = {}
    --self:registerProcessEvent()
    self:parseMsg()
end

function M:parseMsg()
    self.jmsg = self:require("LuaJmsg")
    self.jmsg:init(self:require("MessageDefine"))
end

-------------------------------------
-- GameClient 处理
-------------------------------------
function M:registerProcessEvent()
    if GameClient == nil then return end
    local tb = 
    {
        ["Initialize"] = "onInitialize",
        ["Shutdown"] = "onShutdown",
        ["OnPlayerJoin"] = "onPlayerJoin",
        ["OnPlayerLeave"] = "onPlayerLeave",
        ["OnGameReset"] = "onGameReset",
        ["PrintMessage"] = "onPrintMessage",
        ["OnUserProp"] = "onUserProp",
        ["OnUsePropFailed"] = "onUsePropFailed",
        ["CreateM"] = "onCreateM",
        ["OnGiftMoneyReplay"] = "onGiftMoneyReplay",
        [31] = "onRecvMsg",
    }
    for key, name in pairs(tb) do
        GameClient.event[key] = function(obj, ...) return self:handleProcessEvent(name, ...) end
    end
end

function M:handleProcessEvent(name, ...)
    Log("+++++++++++handleProcessEvent", name)
    if self[name] then 
        return u3a.Invoke(self, name, ...) 
    else
        Log("no hander for process", name)
    end
end

-- 收到网络消息
function M:onRecvMsg(buffer)
end

-- 游戏初始化
function M:onInitialize()
	return true
end

-- 游戏关闭
function M:onShutdown()
    self:getScene():destroy()
end

-- 玩家进入
local FilpMap = {3, 4, 1, 2}
function M:onPlayerJoin(player, isSelf)
    local data = {}
    local wChairID = player.chairid + 1
    local viewID = wChairID
    if isSelf and viewID >= 2 then
        u3a.PlayerFlip = true
    end
    if u3a.PlayerFlip then
        viewID = FilpMap[viewID]
    end
    data.is_self = isSelf
    data.id = player.id
    data.chairid = wChairID
    data.player = player
    data.view_id = viewID
    data.coin = player.money
    self.mPlayerList[player.id] = data
    if not isSelf then return end
    u3a.SelfViewID = viewID
end

-- 玩家离开桌子
function M:onPlayerLeave(player)
    self.mPlayerList[player.id] = nil
end

-- 使用道具成功
function M:onUserProp(playerfrom, playerto, propid)
end

-- 使用道具失败
function M:onUsePropFailed(err)
end

function M:onGiftMoneyReplay(newmoney, giftvalue, giftcount, leftcount)
end

function M:onSocketError(state)
end

function M:onGameReset()
end

function M:onPrintMessage(msgType, strMsg)
end

-------------------------------------
-- 网络消息处理
-------------------------------------

-------------------------------------
-- 网络消息处理
-------------------------------------
function M:doHandleMsg(id, resp)
    resp = clone(resp)
    if id == "MSGS2CGameStatus" then
        u3a.Invoke(self, id, resp)
        return
    end
    if not self:get("start_process") then return end
    print(id)
    u3a.Invoke(self, id, resp)
end

-- 进入游戏初始化
function M:MSGS2CGameStatus(resp)
    --Log(resp)
    for _, val in pairs(resp.playerInfos) do
        self:MSGS2CPlayerJion(val)
    end
    self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, false)
    self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, true)
end

-- 玩家加入
function M:MSGS2CPlayerJion(resp)
    local player = self.mPlayerList[resp.playerId]
    if player == nil then return end
    resp.is_self = player.is_self
    resp.chairid = player.chairid
    resp.view_id = player.view_id
    resp.coin = player.coin
    self:find("UIBackGround"):showWaiting(resp.view_id, false)
    local cannon = self:find("UICannon" .. resp.view_id)
    cannon:join(resp.is_self)
    cannon:updateGun(resp.gunType)
    cannon:find("SCPool"):createBulletPool(cannon.config.id)
    cannon.fnt_multiple:setString(resp.currentGunRate)
    cannon.fnt_coins:setString(resp.coin)
    cannon.fnt_diamonds:setString(resp.crystal)
    if resp.is_self then
        self:find("UITouch"):setTouchEnabled(true)
    end
end

-- 心跳包
function M:MSGS2CHeartBeat(resp)
    --Log(resp)
end

-- 玩家射击
function M:MSGS2CPlayerShoot(resp)
    --Log(resp)
    local player = self.mPlayerList[resp.playerId]
    if player == nil then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:fire(resp.angle)
    local cost = (resp.isViolent and resp.gunRate*resp.nViolentRatio or resp.gunRate)
    cannon:modifyCoin(-cost)
end

-- 击中鱼
function M:MSGS2CPlayerHit(resp)
    --Log(resp)
end

return M