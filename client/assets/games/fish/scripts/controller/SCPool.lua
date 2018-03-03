----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：对象池管理器
----------------------------------------------------------------------

local M = class("SCPool", wls.GameObject)

function M:onCreate()
    self.mNetPool = {}

    self.mFishPool = {} -- 鱼对象池
    self.mFishList = {} -- 鱼列表

    self.mBulletPool = {}
    self.mBulletList = {}
    self.mTimeLineList = {}
    self.mFishArrayList = {}
    self.mFishGroupList = {}

    self.mKilledFishes = {} -- 已经被捕获的鱼
    self.mFollowFish = {}
end

-- 预先创建鱼
function M:createFishPool()
    local tb = self:find("SCConfig"):get("fish")
    local go = nil
    for _, config in pairs(tb) do
        self.mFishPool[config.id] = {}
        if tonumber(config.id) < 100000201 then
            for i = 1, 4 do
                if tonumber(config.trace_type) == 4 or tonumber(config.trace_type) == 8 then
                    go = self:createUnnameObject("GOFishChildren", config.id)
                else
                    go = self:createUnnameObject("GOFish", config.id)
                end
                table.insert(self.mFishPool[config.id], go)
            end
        end
    end
end

-- 预先创建子弹与鱼网
function M:createBulletPool(id)
    for i = 1, wls.MAX_BULLET_CNT do
        local bullet = self:createUnnameObject("GOBullet", id)
        table.insert(self.mBulletPool, bullet)
        local net = self:createUnnameObject("GONet", id)
        table.insert(self.mNetPool, net)
    end
end

function M:removeTimeline()
    for _, timeline in ipairs(self.mTimeLineList) do
        wls.SafeRemoveNode(timeline)
    end
    self.mTimeLineList = {}
    for _, array in ipairs(self.mFishArrayList) do
        wls.SafeRemoveNode(array)
    end
    self.mFishArrayList = {}
end

-- 所有鱼淡出
function M:allFishFadeOut()
    for _, fish in ipairs(self.mFishList) do
        if fish:isAlive() then
            fish:fadeOut()
        end
    end
end

function M:getFish(id)
    -- 当前列表中创建
    for _, fish in ipairs(self.mFishList) do
        if fish:isOutOfScreen() and fish.id == id then
            return fish
        end
    end
    -- 对象池中创建
    for _, fish in ipairs(self.mFishPool[id]) do
        if fish:isOutOfScreen() then
            table.insert(self.mFishList, fish)
            return fish
        end
    end
    -- 重新创建
    local config = self:find("SCConfig"):get("fish")[id]
    if config == nil then
        printError(id)
        return
    end
    local go
    if tonumber(config.trace_type) == 4 or tonumber(config.trace_type) == 8 then
        go = self:createUnnameObject("GOFishChildren", id)
    else
        go = self:createUnnameObject("GOFish", id)
    end
    table.insert(self.mFishList, go)
    table.insert(self.mFishPool[id], go)
    return go
end

-- 创建鱼
function M:createFish(args)
    if self:isKilledFish(args.timeline_id, args.array_id) then
        return
    end
    local go = self:getFish(args.id)
    if go == nil then return end
    go:reset()
    go:set("timeline_id", tonumber(args.timeline_id))
    go:set("array_id", tonumber(args.array_id))
    go:setOffsetPos(args.offset)
    local path = self:find("SCConfig"):get("path")[args.path_id]
    go:setPath(path)
    go:gotoFrame(args.cur_frame)
    return go
end

-- 创建召唤鱼
function M:createSummonFish(args)
    local fish = self:createFish(args)
    if fish == nil then return end
    fish:setVisible(false)
end

-- 获得子弹对象
function M:getBullet()
    -- 对象表中找
    for _, bullet in ipairs(self.mBulletList) do
        if not bullet:isAlive() then
            return bullet
        end
    end
    -- 对象池里找
    for _, bullet in ipairs(self.mBulletPool) do
        if not bullet:isAlive() then
            table.insert(self.mBulletList, bullet)
            return bullet
        end
    end
    local go = self:createUnnameObject("GOBullet", id)
    table.insert(self.mBulletList, go)
    table.insert(self.mBulletPool, go)
    return go
end

-- 创建普通子弹
function M:createNormalBullet(viewID, id, srcPos, angle, bullet_id, duration)
    local go = self:getBullet()
    go:resetBullet(viewID)
    go.bullet_id = bullet_id
    go:launch(id, srcPos, angle, duration)
    return go
end

-- 创建跟踪子弹
function M:createFollowBullet(viewID, id, srcPos, angle, bullet_id, duration, bViolent)
    local go = self:getBullet()
    go:resetBullet(viewID, bViolent)
    go.bullet_id = bullet_id
    go:follow(id, srcPos, angle, duration)
    return go
end

-- 创建鱼网
function M:createNet(id, pos)
    local go = nil
    for _, net in ipairs(self.mNetPool) do
        if not net:isAlive() and net.id == id then
            go = net
            break
        end
    end
    if go == nil then
        go = self:createUnnameObject("GONet", id)
        table.insert(self.mNetPool, go)
    end
    go:reset()
    go:play(pos)
    return go
end

-- 创建时间线
function M:createTimeLine(idx, frame, bServer)
    local server = bServer and 90000 or 0
    local id = 320000000 + wls.RoomIdx * 100000 + idx * 1000 + server
    local go = self:createUnnameObject("GOFishTimeLine", id)
    go:gotoFrame(frame)
    table.insert(self.mTimeLineList, go)
    return go
end

-- 创建鱼群
function M:createFishArray(args)
    local go = self:createUnnameObject("GOFishArray", args.id)
    go:set("timeline_id", args.timeline_id)
    --print("fish array " .. go:get("timeline_id"))
    go:gotoFrame(args.frame)
    table.insert(self.mFishArrayList, go)
    return go
end

-- 创建鱼潮
function M:createFishGroup(id, frame)
    local go = self:createUnnameObject("GOFishGroup", id)
    go:gotoFrame(frame)
    table.insert(self.mFishGroupList, go)
    return go
end

----------------------------------
-- 测试
----------------------------------

function M:setKilledFishes(tb)
    self.mKilledFishes = tb
end

-- 是否是已经捕获了的鱼
function M:isKilledFish(timelineId, fishArrayId)
    for key, val in ipairs(self.mKilledFishes) do
        if val.timelineId == timelineId and val.fishArrayId == fishArrayId then
            table.remove(self.mKilledFishes, key)
            return true
        end
    end
    return false
end

-- 跟踪鱼
function M:getFollowFish(viewID)
    return self.mFollowFish[viewID]
end

function M:setFollowFish(viewID, fish)
    self.mFollowFish[viewID] = fish
end

-- 通时时间线，组id找鱼
function M:findFish(timelineId, fishArrayId)
    for _, fish in ipairs(self.mFishList) do
        if fish:isAlive() and fish:get("timeline_id") == timelineId and fish:get("array_id") == fishArrayId then
            return fish
        end
    end
end

-- 获得锁定的鱼
function M:findLockFish(pos)
    local fish
    local minDis = 150 * 150
    local cur = 0
    local x, y = 0, 0
    for _, val in ipairs(self.mFishList) do
        if val.alive then
            x = pos.x - val.position.x
            y = pos.y - val.position.y
            cur = x * x + y * y
            if cur < minDis then
                minDis = cur
                fish = val
            end
        end
    end
    return fish
end

-- 核弹影响的鱼
function M:calcAtomBombFish(tb, pos, raduis)
    for _, val in ipairs(self.mFishList) do
        if val.alive and val.fishType ~= 5 and val.fishType ~= 6 and val.fishType ~= 7 and val.fishType ~= 8 and val.fishType ~= 10 then
            if val:isInRange(pos, raduis) then
                table.insert(tb, val)
            end
        end
    end
end

-- 局部炸弹影响的鱼
function M:calcRangeBombFish(tb, pos, raduis)
    for _, val in ipairs(self.mFishList) do
        if val.alive and val.fishType ~= 5 and val.fishType ~= 6 and val.fishType ~= 7 and val.fishType ~= 8 and val.fishType ~= 3 then
            if val:isInRange(pos, raduis) then
                table.insert(tb, val)
            end
        end
    end
end

-- 闪电鱼效果
function M:calcThunderPool(tb)
    for _, val in ipairs(self.mFishList) do
        if val.alive and (val.fishType == 1 or val.fishType == 2 or val.fishType == 4) then
            table.insert(tb, val)
        end
    end
end

-- 同类鱼
function M:calcSameFish(tb, id)
    for _, fish in ipairs(self.mFishList) do
        if fish.alive and fish.id == id then
            table.insert(tb, fish)
        end
    end
end

-- 选择(屏幕内)钱多的鱼
function M:findFishByMoney()
    local fish
    for _, val in ipairs(self.mFishList) do
        if val.alive and val:isInScreen() then
            if fish == nil then
                fish = val
            elseif val.config.score > fish.config.score then
                fish = val
            end
        end
    end
    return fish
end

-- 捕到鱼
function M:killFish(timelineId, fishArrayId)
    local fish = self:findFish(timelineId, fishArrayId)
    if fish == nil then 
        print("+++++++cannot find fish " .. timelineId .. " " .. fishArrayId)
        return 
    end
    fish:onHit()
    return fish
end

-- 受影响的鱼
function M:calcEffectFish(fish, list)
    if fish.fishType == 6 then -- 局部炸弹
        return self:calcRangeBombFish(list, cc.p(fish:getPosition()), 225)
    elseif fish.fishType == 7 then-- 连锁闪电
        return self:calcThunderPool(list)
    elseif fish.fishType == 8 then-- 同类炸弹
        return self:calcSameFish(list, fish:getSameID())
    end
end

return M