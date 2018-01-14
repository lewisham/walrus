----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：游戏主循环
----------------------------------------------------------------------

local M = class("SCGameLoop", GameObject)

function M:onCreate()
end

function M:startUpdate()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrame() end, 0.05, false)
end

function M:collsionCheck()
    local go = self:find("SCPool")
    if TEST_COUNT then 
        t1 = os.clock()
    end
    local aliveFishes = go:getAliveList("mFishList")
    local aliveBullets = go:getAliveList("mBulletList")
    for _, bullet in ipairs(aliveBullets) do
        for _, fish in ipairs(aliveFishes) do
            if bullet:doCheck(fish) then
                self:find("SCPool"):createNet(bullet.config.id, cc.p(bullet:getPosition()))
                break
            end
        end
    end
    -- 碰撞检测
    if TEST_COUNT then
        print(TEST_COUNT, "运算耗时:", os.clock() - t1, "鱼的数量:", #aliveFishes, "子弹数量", #aliveBullets)
    end
end

function M:updateFrame()
    local go = self:find("SCPool")
    -- 更新鱼
    local aliveFishes = {}
    for _, fish in ipairs(go.mFishList) do
        if fish:isAlive() then
            fish:updateFrame()
            table.insert(aliveFishes, fish)
        end
    end
    -- 更新子弹
    local aliveBullets = {}
    for _, bullet in ipairs(go.mBulletList) do
        if bullet:isAlive() then
            bullet:updateFrame()
            table.insert(aliveBullets, bullet)
        end
    end
    -- 更新鱼时间线
    for _, timeline in ipairs(go.mTimeLineList) do
        timeline:updateFrame()
    end
    go:removeDeadObject("mTimeLineList")
    -- 更新鱼组
    for _, array in ipairs(go.mFishArrayList) do
        array:updateFrame()
    end
    go:removeDeadObject("mFishArrayList")
    -- 更新鱼潮
    for _, array in ipairs(go.mFishGroupList) do
        array:updateFrame()
    end
    go:removeDeadObject("mFishGroupList")

    self:collsionCheck()
end

return M