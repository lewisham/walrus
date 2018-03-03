----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：c++ GameClient
----------------------------------------------------------------------

local M = class("SCGameClient", wls.GameObject)

function M:onCreate()
    self.mPlayers = {}
    self.mSelfPlayer = nil
    self:registerProcessEvent()
end

function M:getPlayer(id)
    return self.mPlayers[id]
end

function M:getSelfPlayer()
    return self.mSelfPlayer
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
        ["CreateGameScene"] = "onCreateGameScene",
        ["OnGiftMoneyReplay"] = "onGiftMoneyReplay",
        [31] = "onRecvMsg",
    }
    if GameClient.event["Initialize"] then return end
    for key, name in pairs(tb) do
        GameClient.event[key] = function(obj, ...) return self:handleProcessEvent(name, ...) end
    end
end

function M:handleProcessEvent(name, ...)
    print("+++++++++++handleProcessEvent  " .. name)
    if self[name] then 
        return wls.Invoke(self, name, ...) 
    else
        Log("no hander for process", name)
    end
end

-- 收到网络消息
function M:onRecvMsg(buffer)
    local id, resp = wls.JMSG:decode(buffer)
    self:find("SCRecv"):doHandleMsg(id, resp)
end

-- 游戏初始化
function M:onInitialize()
	return true
end

-- 游戏关闭
function M:onShutdown()
    self:getScene():destroy()
    cc.Director:getInstance():popToRootScene()
end

-- 玩家进入
local FilpMap = {3, 4, 1, 2}
function M:onPlayerJoin(player, isSelf)
    local data = {}
    local wChairID = player.chairid + 1
    local viewID = wChairID
    if isSelf and viewID > 2 then
        wls.PlayerFlip = true
    end
    if wls.PlayerFlip then
        viewID = FilpMap[viewID]
    end
    data.is_self = isSelf
    data.id = player.id
    data.chairid = wChairID
    data.player = player
    data.view_id = viewID
    self.mPlayers[player.id] = data
    if not isSelf then return end
    self.mSelfPlayer = data
    wls.SelfViewID = viewID
end

-- 玩家离开桌子
function M:onPlayerLeave(player)
    local data = self.mPlayers[player.id]
    self.mPlayers[player.id] = nil
    if data == nil or data.view_id == nil then return end
    if self:find("UIBackGround") == nil then return end
    self:find("UIBackGround"):showWaiting(data.view_id, true)
    local cannon = self:find("UICannon" .. data.view_id)
    cannon:setVisible(false)
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

-- 创建游戏场景
function M:onCreateGameScene()
    local scene = cc.Scene:create()
    cc.Director:getInstance():pushScene(scene)
    scene.mSceneName = "fish"
    rawset(_G, "g_rootNode", scene)
    self:set("create_scene", true)
    return scene
end

function M:onPrintMessage(msgType, strMsg)
end

return M