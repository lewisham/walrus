local MSG_ID_GET_DESK = 6
local MSG_ID_NORMAL = 8
local M = ClassEx("SCRoomMgr", function() 
    local obj =  CAllocSitRoomManager.New()
    return obj
end)

function M:onCreate()
    local roomId = self:find("SCJoinRoom"):getRoomId()
    self:registerEvent()
    self:SetRoomInfo(hallmanager, roomId)
    if self:Initialize() then
        
    end
end

function M:sendJMsg(name, data)
    print("sendJMsg "..name.." data:"..json.encode(data))
    local msg = CLuaMsgHeader.New()
    msg.id = 8
    wls.JMSG:encode(name, msg, data)
    self:SendData(msg)
end

function M:onJMsg(obj, msg)
    local type, data = wls.JMSG:decode(msg)
    local func = self[type]
    print("onJMsg "..type.." data:"..json.encode(data))
    if func ~= nil then
        func(self, data)
    end
end

function M:registerEvent()
    local evt = {}
    self.event = evt
    self:set("event", evt)

    self:RegisterMsgProcess("Initialize", self.OnInitialize)
    self:RegisterMsgProcess("OnMsgJoinRoom", self.OnMsgJoinRoom)
    self:RegisterMsgProcess("OnMsgSitDown", self.OnMsgSitDown)
    self:RegisterMsgProcess("Shutdown", self.Shutdown)
    self:RegisterMsgProcess("OnStopGame", self.OnStopGame)
    self:RegisterMsgProcess(4296, self.onJMsg)
end

function M:JoinRoomSuccess()
    self:sendGetHallInfo()
end

function M:RegisterMsgProcess(msg, func, name)
    self:get("event")[msg] = function(...)
        local ret = func(self, ...)
        return ret;
    end
end

function M:OnInitialize()
    print("OnInitialize")
    
    return true
end

function M:OnMsgJoinRoom(room)
    print("OnMsgJoinRoom")
    if not room:StartGame() then
        print("启动房间失败")
        room:ExitRoom()
    end
end

function M:OnMsgSitDown()
end

function M:Shutdown()
end

function M:OnStopGame()
end

function M:sendGetHallInfo()
    local data = {
        channelId = 1,
        version = "1.1.1"
    }
    self:sendJMsg("MSGC2SGetHallInfo", data)
end

function M:sendGetMailDetail(mailId)
    local data = {
        id = mailId
    }
    self:sendJMsg("MSGC2SGetMailDetail", data)
end

function M:sendMakeMailAsRead(mailId)
    local data = {
        id = mailId
    }
    self:sendJMsg("MSGC2SMarkMailAsRead", data)
end

function M:sendForge()
    local data = {

    }
    self:sendJMsg("MSGS2CForge", data)
end

function M:sendGetDesk(lv)
    print("lv"..lv)
    local data = {
        level = lv
    }
    self:sendJMsg("MSGC2SGetDesk", data)
end


function M:MSGS2CGetHallInfo(data)
    data["playerInfo"]["fishIcon"] = 10010
    data["playerInfo"]["crystal"] = 10086
    self:find("UIHallBackGround"):refreshWithData(data["playerInfo"])
    self:find("UIHallPanel"):refreshWithData(data["playerInfo"])
    self:set("HallInfo", data)
end

function M:MSGPlayerInfo(data)

end

function M:MSGS2CLoginDraw(data)
end

function M:MSGS2CVipLoginDraw(data)
end

function M:MSGS2CGetMonthCardReward(data)
end

function M:MSGS2CApplyAlmResult(data)
end

function M:MSGS2CAlmInfo(data)
end

function M:MSGS2CSignIn(data)
end

function M:MSGS2CBuy(data)
end

function M:MSGS2CAnnounce(data)
end

function M:MSGS2CShareLink(data)
end

function M:MSGS2CInviteCode(data)
end

function M:MSGS2CChangeNickName(data)
end

function M:MSGS2CGetMailDetail(data)
    self:find("UIMailPanel"):onGetMailDetail(data)
end

function M:MSGS2CMarkMailAsRead(data)
    self:find("UIMailPanel"):onMakeMailAsRead(data)
end

function M:MSGS2CForge(data)
    self:find("UIForgedPanel"):onForgedResult(data)
end

function M:MSGS2CDecompose(data)
end

function M:MSGS2CReceivePhoneFare(data)
end

function M:MSGS2CGetVipDailyReward(data)
end

function M:MSGS2CGetAllTaskInfo(data)
end

function M:MSGS2CGetTaskReward(data)
end

function M:MSGS2CGetActiveReward(data)
end

function M:MSGS2CHaveFinishTask(data)
end

function M:MSGS2CIsOnTimehourGlass(data)
end

function M:MSGS2CGetTimeHourglass(data)
end

function M:MSGS2CForbidAccount(data)
end

function M:MSGS2CUsePropCannon(data)
end

function M:MSGS2CSellItem(data)
end

function M:MSGS2CGetNewerReward(data)
end
    
return M