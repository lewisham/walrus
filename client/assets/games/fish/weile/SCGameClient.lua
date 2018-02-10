----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：c++ GameClient
----------------------------------------------------------------------

local M = class("SCGameClient", u3a.GameObject)

function M:onCreate()
    self:registerProcessEvent()
    --self:parseMsg()
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
        [31] = "onNetMessage",
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
function M:onNetMessage(buffer)
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
function M:onPlayerJoin(pPlayer, isSelf)
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

return M