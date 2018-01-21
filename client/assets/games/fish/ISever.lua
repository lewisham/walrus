----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：模拟服务器
----------------------------------------------------------------------

local M = class("ISever", GameObject)

function M:onCreate()
    self.mFrameIdx = 0
    self.mTimeLineIdx = 0
    self:coroutine(self, "play")
end

function M:play()
    while true do
        self:updateFrame()
        WaitForSeconds(0.05)
    end
end

function M:updateFrame()
    self.mFrameIdx = self.mFrameIdx + 1
    self:updateTimeLine()
end

function M:updateTimeLine()
    if self.mTimeLineIdx > 0 then
        self.mTimeLineIdx = self.mTimeLineIdx - 1
        return
    end
    self.mTimeLineIdx = 10000
    local room_idx = self:getScene():get("room_idx")
    local idx = math.random(1, 6)
    local id = 320000000 + room_idx * 100000 + idx * 1000 + 1
    local req = {}
    req.id = id
    req.frame = math.random(1, 50)
    self:post("onMsgCreateTimeLine", req)
end

return M