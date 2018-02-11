----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：c++ GameClient
----------------------------------------------------------------------

local M = class("SCGameClient", u3a.GameObject)

function M:onCreate()
    self.mPlayerList = {}
    --self:registerProcessEvent()
    self:parseMsg()
end

function M:parseMsg()
    self.jmsg = self:require("LuaJmsg")
    self.jmsg:init(self:require("MessageDefine"))
end

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
function M:onPlayerJoin(player, isSelf)
    local data = {}
    local wChairID = player.chairid + 1
    data.is_self = isSelf
    data.id = player.id
    data.chairid = wChairID
    data.player = player
    data.view_id = wChairID
    self.mPlayerList[wChairID] = data
    if not isSelf then return end
    self:getScene():set("view_id", data.view_id)
end

-- 玩家离开桌子
function M:onPlayerLeave(pPlayer)
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
--
-------------------------------------
function M:doHandleMsg(id, resp)
    resp = clone(resp)
    --Log(id)
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
    local player = nil
    for _, val in pairs(self.mPlayerList) do
        if val.id == resp.playerId then player = val break end
    end
    if player == nil then return end
    resp.is_self = player.is_self
    resp.chairid = player.chairid
    resp.view_id = player.view_id
    self:find("UIBackGround"):showWaiting(resp.view_id, false)
    local cannon = self:find("UICannon" .. resp.view_id)
    cannon:join(resp.is_self)
    cannon:updateGun(resp.gunType)
    cannon:find("SCPool"):createBulletPool(cannon.config.id)
    cannon.fnt_multiple:setString(resp.currentGunRate or 1)
    cannon.fnt_coins:setString(resp.coin or 0)
    cannon.fnt_diamonds:setString(resp.crystal or 0)
    if resp.is_self then
        self:getScene():set("view_id", resp.view_id)
        self:find("UITouch"):setTouchEnabled(true)
    end
end

-- 心跳包
function M:MSGS2CHeartBeat(resp)
    --Log(resp)
end

function M:MSGS2CPlayerShoot(resp)
    Log(resp)
    
end

return M