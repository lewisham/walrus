----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：游戏主循环
----------------------------------------------------------------------

local M = class("SCGameLoop", GameObject)

function M:onCreate()
    self:createGameObject("SCGrid")
end

function M:startUpdate()
    local scheduler = cc.Director:getInstance():getScheduler()
    if TEST_COUNT then
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrameTest() end, 0.05, false)
    else
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrame() end, 0.05, false)
    end
end

function M:updateFrame()
    local go = self:find("SCPool")
    -- 更新鱼
    for _, fish in ipairs(go:getAliveList("mFishList")) do
        fish:updateFrame()
    end
    -- 更新子弹
    for _, bullet in ipairs(go:getAliveList("mBulletList")) do
        bullet:updateFrame()
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

function M:updateFrameTest()
    local t1 = os.clock()
    if TEST_COUNT then
        TEST_COUNT = 0
    end
    self:updateFrame()
    if TEST_COUNT then
        print("运算耗时", os.clock() - t1, #go.mBulletList, #go.mFishList)
    end
end

-- log2 4 * M算法
function M:collsionCheck()
    local grid = self:find("SCGrid")
    grid:reset()
    local go = self:find("SCPool")
    local bulletList = go:getCollsionBullet()
    local fishes = go:getAliveList("mFishList")
    for idx, fish in ipairs(fishes) do
        grid:addFish(idx, fish.points)
    end
    for _, bullet in ipairs(bulletList) do
        local list = grid:getFishes(bullet)
        if list then
            for idx, _ in pairs(list) do
                local fish = fishes[idx]
                if bullet:sat(fish) then
                    bullet:onCollsion()
                    fish:onCollsion()
                    self:find("SCPool"):createNet(bullet.config.id, cc.p(bullet:getPosition()))
                    if bullet.mbSelf then

                    end
                    break
                end
            end
        end
    end
end

-- n*m时间复杂度算法
function M:collsionCheck1()
    local go = self:find("SCPool")
    for _, bullet in ipairs(go.mBulletList) do
        if bullet:isNeedCollionCheck() then
            for _, fish in ipairs(go.mFishList) do
                if bullet:doCheck(fish) then
                    bullet:onCollsion()
                    self:find("SCPool"):createNet(bullet.config.id, cc.p(bullet:getPosition()))
                    break
                end
            end
        end
    end
end

return M