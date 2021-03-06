----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：模拟服务器
----------------------------------------------------------------------

local M = class("IServer", wls.GameObject)

function M:onCreate()
    self.mFrameIdx = 0
    self.mTimeLineIdx = 0
    self.mGroupIdx = 600
    self.mPlayerList = {}
end

function M:play()
    --self:testFish("100000401")
    --self:find("SCPool"):randomTimeLine()
    --self:find("SCPool"):createNet(1, cc.p(512, 360))
    --self:find("SCPool"):createFishGroup(1, 1)
    local rates = {1, 2, 5, 10, 20, 30, 50}
    local tb = {}
    local viewID = wls.SelfViewID
    table.insert(tb, viewID)
    for i = 1, 4 do
        if viewID ~= i then
            table.insert(tb, i)
        end
    end
    for _, i in ipairs(tb) do
        local info =
        {
            view_id = i,
            gun_id = i == viewID and 1 or math.random(1, 7),
            gun_rate = rates[math.random(1, #rates)],
            is_self = i == viewID,
            coin = math.random(100000, 9999999),
            diamonds = math.random(0, 9999),
            shoot_cnt = 0,
        }
        table.insert(self.mPlayerList, info)
        self:onMsgPlayerJoin(info)
    end
    self:createTimeline()
    --self:createGroup()
    self:coroutine(self, "loop")
    self:coroutine(self, "updatePlayer")
end

function M:updatePlayer()
    while true do
        for _, player in ipairs(self.mPlayerList) do
            if not player.is_self then
                self:playerShoot(player)
            end
        end
        wls.WaitForSeconds(0.2)
    end
end

function M:playerShoot(player)
    if player.coin < player.gun_rate then
        if math.random(1, 10) == 1 then
            player.coin = math.random(1000, 9999)
        end
        return
    end
    if player.shoot_cnt < 1 then
        if math.random(1, 15) ~= 1 then return end
        player.shoot_cnt = math.random(1, 7)
    else
        player.shoot_cnt = player.shoot_cnt - 1
    end
    if self:find("DAFish"):getBulletCnt(player.view_id) >= wls.MAX_BULLET_CNT then
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
    local cannon = self:find("UICannon" .. req.view_id)
    cannon:fire(1, req.angle)
    cannon:setCoin(req.coin)
end

function M:loop()
    while true do
        self.mFrameIdx = self.mFrameIdx + 1
        self:updateFrame()
        wls.WaitForSeconds(0.05)
    end
end

function M:updateFrame()
    self.mTimeLineIdx = self.mTimeLineIdx - 1
    self.mGroupIdx = self.mGroupIdx - 1
    if self.mGroupIdx < 1 then
        local req = {}
        req.group_id = math.random(1, 7)
        local config = self:find("SCConfig"):getFishGroup(req.group_id)
        self.mGroupIdx = tonumber(config[#config].endframe)
        self.mTimeLineIdx = tonumber(self.mGroupIdx + 10)
        self.mGroupIdx = self.mGroupIdx + 1000
        self:post("onMsgCreateFishGroup", req)
        return
    end
    if self.mTimeLineIdx < 1 then
        self:createTimeline()
    end
end

function M:createTimeline()
    local idx = math.random(1, 6)
    local id = idx
    local req = {}
    req.id = id
    req.frame = 0
    self:find("SCPool"):createTimeLine(req.id, req.frame, false)
    self:find("SCPool"):createTimeLine(req.id, req.frame, true)
    self.mTimeLineIdx = 6000
    self.mGroupIdx = self.mTimeLineIdx
    self.mTimeLineIdx = self.mTimeLineIdx + 200
end

-- 玩家加入
function M:onMsgPlayerJoin(player)
    self:find("UIBackGround"):showWaiting(player.view_id, false)
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:join(player.is_self)
    cannon:updateGun(player.gun_id)
    self:find("SCPool"):createBulletPool(cannon.config.id)
    cannon:setCoin(player.coin)
    cannon:setGem(player.diamonds)
    cannon:setGunRate(player.gun_rate)
    if player.is_self then
        self:find("UITouch"):setTouchEnabled(true)
    end
end


----------------------------------
-- 测试
----------------------------------

function M:randomTimeLine()
    local roomID = math.random(1, 4)
    local idx = math.random(1, 6)
    local id = 320000000 + roomID * 100000 + idx * 1000 + 1
    self:find("SCGameLoop"):createTimeLine(id, 0)
end

function M:createGroup()
    local req = {}
    req.group_id = math.random(1, 7)
    self:post("onMsgCreateFishGroup", req)
end

return M