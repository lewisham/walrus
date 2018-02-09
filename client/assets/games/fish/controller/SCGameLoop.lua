----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：游戏主循环
----------------------------------------------------------------------

local M = class("SCGameLoop", u3a.GameObject)

function M:onCreate()
    self:set("freeze", false)
end

function M:onUpdate1()
    if u3a.TimeDelta > 0.02 then
        print(u3a.TimeDelta)
    end
end

function M:startUpdate()
    self:startUpdateFrame()
    u3a.WaitForFrames(1)
    self:startCollsion()
end

function M:startUpdateFrame()
    local scheduler = cc.Director:getInstance():getScheduler()
    if TEST_COUNT then
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrameTest() end, 0.05, false)
    else
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateFrame() end, 0.05, false)
    end
end

function M:startCollsion()
    local scheduler = cc.Director:getInstance():getScheduler()
    if TEST_COUNT then
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateCollsionTest() end, 0.09, false)
    else
        self.mSchedulerId = scheduler:scheduleScriptFunc(function() self:updateCollsion() end, 0.09, false)
    end
end

function M:updateFrame()
    local go = self:find("SCPool")
    -- 更新子弹
    for _, bullet in ipairs(go.mBulletList) do
        if bullet.alive then
            bullet:updateFrame()
        end
    end
    if self:get("freeze") then return end
    -- 更新鱼
    for _, fish in ipairs(go.mFishList) do
        if fish.alive then
            fish:updateFrame()
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

function M:updateCollsion()
    self:collsionCheck()
end

function M:updateCollsionTest()
    local t1 = os.clock()
    if TEST_COUNT then
        TEST_COUNT = 0
    end
    self:updateCollsion()
    if TEST_COUNT then
        print("运算耗时", os.clock() - t1, #go.mBulletList, #go.mFishList)
    end
end

-- log2 4 * M算法
function M:collsionCheck()
    local grid = self:find("SCGrid")
    grid:reset()
    local go = self:find("SCPool")
    local fishes = go.mFishList
    for idx, fish in ipairs(fishes) do
        if fish.alive then
            fish:updatePoints()
            grid:addFishRef(idx, fish.points, fish.position)
        end
    end
    local pos = cc.p(0, 0)
    local list = nil
    for _, bullet in ipairs(go.mBulletList) do
        if bullet:isNeedCollionCheck() then
            pos.x, pos.y = bullet:getPosition()
            list = grid:getFishesByPos(pos)
            if list then
                bullet:updatePoints()
                for idx, _ in pairs(list) do
                    local fish = fishes[idx]
                    if bullet:sat(fish) then
                        bullet:onCollsion()
                        local net = self:find("SCPool"):createNet(bullet.config.id, pos)
                        if bullet.mbSelf then
                            self:netCollsionCheck(fishes, net, grid)
                        end
                        break
                    end
                end
            end
        end
    end
end

-- 鱼网与鱼碰撞
function M:netCollsionCheck(fishes, net, grid)
    local list = grid:getFishesByPoints(net.points)
    for idx, _ in pairs(list) do
        local fish = fishes[idx]
        if fish and net:sat(fish) then
            fish:onHit()
        end
    end 
end

return M