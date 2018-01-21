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
    self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrame() end, 0.05, false)
end

function M:updateFrame()
    local go = self:find("SCPool")
    -- 更新鱼
    go:removeDeadObject("mFishList")
    for _, fish in ipairs(go.mFishList) do
        fish:updateFrame()
    end
    -- 更新子弹
    go:removeDeadObject("mBulletList")
    for _, bullet in ipairs(go.mBulletList) do
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

    -- local t1 = os.clock()
    -- if TEST_COUNT then
    --     TEST_COUNT = 0
    -- end
    self:collsionCheck()
    -- if TEST_COUNT then
    --     print("运算耗时", os.clock() - t1, #go.mBulletList, #go.mFishList)
    -- end
end

-- log2 4 * M算法
function M:collsionCheck()
    local grid = self:find("SCGrid")
    local go = self:find("SCPool")
    grid:reset()
    for idx, fish in ipairs(go.mFishList) do
        grid:addFish(idx, fish.points)
    end
    for _, bullet in ipairs(go.mBulletList) do
        if bullet:isNeedCollionCheck() then
            local list = grid:getFishes(bullet)
            if list then
                for idx, _ in pairs(list) do
                    local fish = go.mFishList[idx]
                    if bullet:sat(fish) then
                        bullet:onCollsion()
                        self:find("SCPool"):createNet(bullet.config.id, cc.p(bullet:getPosition()))
                        if bullet.mbSelf then

                        end
                        break
                    end
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