----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：对象池管理器
----------------------------------------------------------------------

local M = class("SCPool", GameObject)

function M:onCreate()
    self.mNetPool = {}
    self.mFishList = {}
    self.mBulletList = {}
    self.mTimeLineList = {}
    self.mFishArrayList = {}
    self.mFishGroupList = {}
end

function M:removeTimeline()
    for _, timeline in ipairs(self.mTimeLineList) do
        SafeRemoveNode(timeline)
    end
    self.mTimeLineList = {}
    for _, array in ipairs(self.mFishArrayList) do
        SafeRemoveNode(array)
    end
    self.mFishArrayList = {}
end

-- 移除已经失效的对象
function M:removeDeadObject(name)
    local list = self[name]
    local tb = {}
    for _, timeline in ipairs(list) do
        if timeline:isAlive() then
            table.insert(tb, timeline)
        end
    end
    self[name] = tb
end

-- 存活的对象
function M:getAliveList(name)
    local list = self[name]
    local tb = {}
    for _, go in ipairs(list) do
        if go:isAlive() then
            table.insert(tb, go)
        end
    end
    return tb
end

-- 创建鱼
local NotCreateFish = 
{
    "100000301", "100000302", "100000303", "100000304", "100000305",
    "100000401", "100000402", "100000403", "100000404", "100000405",
    "100000406", "100000407",  "100000205", "100000203", "100000202",
}
function M:createFish(id, pathID, frame, offset)
    offset = offset or cc.p(0, 0)
    for _, val in ipairs(NotCreateFish) do
        if val == id then return end
    end
    local go = nil
    for _, fish in ipairs(self.mFishList) do
        if not fish:isAlive() and fish.id == id then
            go = fish
            break
        end
    end
    if go == nil then
        go = self:createUnnameObject("GOFish", id)
        table.insert(self.mFishList, go)
    end
    go:reset()
    go:setOffsetPos(offset)
    local path = self:find("SCConfig"):get("path")[pathID]
    go:setPath(path)
    go:gotoFrame(frame)
    return go
end

-- 创建时间线
function M:createTimeLine(id, frame)
    local go = self:createUnnameObject("GOFishTimeLine", id)
    go:gotoFrame(frame)
    table.insert(self.mTimeLineList, go)
    return go
end

-- 创建普通子弹
function M:createNormalBullet(viewID, id, srcPos, angle)
    local go = nil
    for _, bullet in ipairs(self.mBulletList) do
        if not bullet:isAlive() then
            go = bullet
            break
        end
    end
    if go == nil then
        go = self:createUnnameObject("GOBullet", id)
        table.insert(self.mBulletList, go)
    end
    go:resetBullet(viewID)
    go:launch(id, srcPos, angle)
    return go
end

-- 创建跟踪子弹
function M:createFollowBullet(viewID, id, srcPos, angle)
    local go = nil
    for _, bullet in ipairs(self.mBulletList) do
        if not bullet:isAlive() then
            go = bullet
            break
        end
    end
    if go == nil then
        go = self:createUnnameObject("GOBullet", id)
        table.insert(self.mBulletList, go)
    end
    go:reset(viewID)
    go:follow(id, srcPos, angle)
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

-- 创建鱼群
function M:createFishArray(id, frame)
    local go = self:createUnnameObject("GOFishArray", id)
    go:gotoFrame(frame)
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

function M:calcBulletCnt(viewID)
    local cnt = 0
    for _, bullet in ipairs(self.mBulletList) do
        if bullet.mViewID == viewID then
            cnt = cnt + 1
        end
    end
    return cnt
end

function M:getCollsionBullet()
    local tb = {}
    for _, bullet in ipairs(self.mBulletList) do
        if bullet:isAlive() and bullet:isNeedCollionCheck() then
            table.insert(tb, bullet)
        end
    end
    return tb
end

function M:getFollowFish(viewID)
    for _, fish in ipairs(self.mFishList) do
        if fish:isAlive() then
            return fish
        end
    end
end

return M