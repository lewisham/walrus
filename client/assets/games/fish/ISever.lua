----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：模拟服务器
----------------------------------------------------------------------

local M = class("ISever", GameObject)

function M:onCreate()
    self.mFrameIdx = 0
    self.mTimeLineIdx = 0
    self.mPlayerList = {}
    self:coroutine(self, "play")
    self:coroutine(self, "updatePlayer")
    self:test()
end

function M:test()
    --self:find("SCPool"):testFish("100000011")
    --self:find("SCPool"):randomTimeLine()
    --self:find("SCPool"):createNet(1, cc.p(512, 360))
    --self:find("SCPool"):createFishArray("312124001", 1)
    self:find("SCPool"):createFishGroup(1, 1)
    for i = 1, 4 do
        local info =
        {
            view_id = i,
            gun_id = math.random(1, 7),
            gun_rate = math.random(1, 3),
            is_self = i == 1,
            coin = math.random(1000, 9999),
            diamonds = math.random(0, 9999),
        }
        table.insert(self.mPlayerList, info)
        self:post("onMsgPlayerJoin", info)
    end
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

function M:updatePlayer()
    while true do
        for _, player in ipairs(self.mPlayerList) do
            if not player.is_self then
                self:playerShoot(player)
            end
        end
        WaitForSeconds(0.2)
    end
end

function M:playerShoot(player)
    --if math.random(1, 2) ~= 1 then return end
    if self:find("SCPool"):calcBulletCnt(player.view_id) >= FCDefine.MAX_BULLET_CNT then
        return
    end
    if player.shoot_angle == nil then
        player.shoot_angle = math.random(20, 160)
    elseif math.random(1, 8) == 1 then
        player.shoot_angle = math.random(20, 160)
    end
    local req = {}
    player.coin = player.coin - player.gun_rate
    req.view_id = player.view_id
    req.angle = player.shoot_angle
    req.coin = player.coin
    self:post("onMsgShoot", req)
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