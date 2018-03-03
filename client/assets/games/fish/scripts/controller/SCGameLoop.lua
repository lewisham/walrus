----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：游戏主循环
----------------------------------------------------------------------

local M = class("SCGameLoop", wls.GameObject)

function M:onCreate()
    self:set("freeze", false)
    self:set("timeline_idx", 0)
    self.mbTestFrame = false
    self.mbTestCollsion = false
    self.mClientFrame = 0
    self.mServerFrame = 0
    self.mCallFishes = {}
end

function M:setServerFrame(frame)
    self.mServerFrame = frame
end

function M:setClientFrame(frame)
    self.mClientFrame = frame
end

-- 添加要召唤的鱼
function M:addCallFish(args)
    table.insert(self.mCallFishes, args)
end

-- 释放对象，关闭定时器
function M:releaseLuaObject()
    M.super.releaseLuaObject(self)
    if self.mSchedulerUpdateFrame then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerUpdateFrame)
    end
    if self.mSchedulerCollsion then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerCollsion)
    end
end

-- 开启计时器
function M:startUpdate()
    self:startUpdateFrame()
    wls.WaitForFrames(1)
    self:startCollsion()
end

-- 开始更新帧
function M:startUpdateFrame()
    local scheduler = cc.Director:getInstance():getScheduler()
    if self.mbTestFrame then
        self.mSchedulerUpdateFrame = scheduler:scheduleScriptFunc(function() self:updateFrameTest() end, 0.05, false)
    else
        self.mSchedulerUpdateFrame = scheduler:scheduleScriptFunc(function() self:updateFrame() end, 0.05, false)
    end
end

-- 开启碰撞检测倒计时
function M:startCollsion()
    local scheduler = cc.Director:getInstance():getScheduler()
    if self.mbTestCollsion then
        self.mSchedulerCollsion = scheduler:scheduleScriptFunc(function() self:updateCollsionTest() end, 0.09, false)
    else
        self.mSchedulerCollsion = scheduler:scheduleScriptFunc(function() self:updateCollsion() end, 0.09, false)
    end
end

-- 同步帧数
function M:syncFrame(frame)
    self.mServerFrame = frame
    if self.mServerFrame - self.mClientFrame < 20 then
        return
    end
    wls.Skip_Frame = true
    for i = self.mClientFrame, self.mServerFrame do
        self:updateFrame()
    end
    wls.Skip_Frame = false
end

-- 遍历列表，不存在的移除
function M:updateList(list)
    for i = #list, 1, -1 do
        if list[i].alive then
            list[i]:updateFrame()
        else
            table.remove(list, i)
        end
    end
end

function M:updateFrame()
    local go = self:find("SCPool")
    -- 更新子弹
    self:updateList(go.mBulletList)
    if self:get("freeze") then return end
    self.mClientFrame = self.mClientFrame + 1
    -- 更新鱼
    self:updateList(go.mFishList)
    -- 更新鱼线
    self:updateList(go.mTimeLineList)
    -- 更新鱼组
    self:updateList(go.mFishArrayList)
    -- 更新鱼潮
    self:updateList(go.mFishGroupList)
    -- 更新召唤鱼
    self:updateCallFish()
end

-- 更新创建召唤鱼
function M:updateCallFish()
    local args
    for i = #self.mCallFishes, 1, -1 do
        args = self.mCallFishes[i]
        if args.cur_frame < self.mClientFrame then
            args.cur_frame = self.mClientFrame - args.cur_frame
            self:find("SCPool"):createSummonFish(args)
            table.remove(self.mCallFishes, i)
        elseif args.cur_frame == self.mClientFrame then
            args.cur_frame = 1
            self:find("SCPool"):createSummonFish(args)
            table.remove(self.mCallFishes, i)
        end
    end
end

function M:updateFrameTest()
    local go = self:find("SCPool")
    local t1 = os.clock()
    self:updateFrame()
    print("更新帧运算耗时 " .. os.clock() - t1 .. "  " .. #go.mBulletList .. "  " .. #go.mFishList)
end


---------------------------------
-- 碰撞检测
---------------------------------

function M:updateCollsion()
    self:collsionCheck()
end

function M:updateCollsionTest()
    local go = self:find("SCPool")
    local t1 = os.clock()
    self:updateCollsion()
    print("碰撞检测运算耗时 " .. os.clock() - t1 .. "  " .. #go.mBulletList .. "  " .. #go.mFishList)
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
                        local net = self:find("SCPool"):createNet(bullet.config.id, pos)
                        if bullet.mbSelf then
                            self:netCollsionCheck(bullet.bullet_id, fishes, net, grid)
                        end
                        bullet:onCollsion()
                        break
                    end
                end
            end
        end
    end
end

-- 鱼网与鱼碰撞
function M:netCollsionCheck(id, fishes, net, grid)
    self.catcheds = {}
    self.effectFish = {}
    local list = grid:getFishesByPoints(net.points)
    local specialFish = nil
    for idx, _ in pairs(list) do
        local fish = fishes[idx]
        if fish and net:sat(fish) then
            fish:onRed()
            if fish:isSpecailFish() then
                specialFish = fish
                table.insert(self.catcheds, 1, fish)
            else
                table.insert(self.catcheds, fish)
            end
        end
    end
    -- 特殊鱼
    if specialFish then
        self:find("SCPool"):calcEffectFish(specialFish, self.effectFish)
    end
    wls.SendMsg("sendHit", id, self.catcheds, self.effectFish)
end

return M