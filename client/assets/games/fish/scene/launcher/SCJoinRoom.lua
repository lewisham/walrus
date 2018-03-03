local M = class("SCJoinRoom", wls.GameObject)

function M:onCreate()
    self.roomId = self:find("SCSelectRoom"):getRoomId()
    if self.roomId then
        self:createGameObject("SCRoomMgr")
        hallmanager:JoinRoom(self.roomId, false, nil, self:find("SCRoomMgr"))
    end
end

function M:getRoomId()
    return self.roomId
end

return M