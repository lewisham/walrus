----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：对象池管理器
----------------------------------------------------------------------

local M = class("SCPool", GameObject)

function M:onCreate()
    self.mFishList = {}
    self.mTimeLineList = {}
    self.mBulletList = {}
    self.mNetList = {}
    self.mFishArrayList = {}
    self.mFishGroupList = {}
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
    "100000201"
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

-- 创建子弹
function M:createBullet(id, srcPos, angle)
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
    go:reset()
    go:launch(id, srcPos, angle)
    return go
end

-- 创建鱼网
function M:createNet(id, pos)
    local go = nil
    for _, net in ipairs(self.mNetList) do
        if not net:isAlive() then
            go = net
            break
        end
    end
    if go == nil then
        go = self:createUnnameObject("GONet")
        table.insert(self.mNetList, go)
    end
    go:reset()
    go:play(id, pos)
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

function M:randomTimeLine()
    local roomID = math.random(1, 4)
    local idx = math.random(1, 6)
    local id = 320000000 + roomID * 100000 + idx * 1000 + 1
    self:find("SCGameLoop"):createTimeLine(id, 0)
end

function M:testFish(id)
    local go = self:createFish(id, "300000663", 105)
    go:setState(1)
end

function M:testBullet(id, srcPos, dstPos)
    local go = self:createUnnameObject("GOBullet", id)
    table.insert(self.mBulletList, go)
    go:laucherToPos(id, srcPos, dstPos)
    return go
end

function M:testAllFish()
    for _, val in pairs(self:require("fish")) do
        print(val.id, val.name)
        self:find("SCGameLoop"):createFish(val.id, "300000805", 1)
        WaitForSeconds(4.0)
    end
end

return M