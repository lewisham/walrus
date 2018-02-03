----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：协程
----------------------------------------------------------------------

local M = class("Coroutine")

function M:init(aliveCheckFunc, func)
    assert(aliveCheckFunc, "need set life cycle func")
	self.mUpdateFunc = nil		-- 更新函数接口
    self.coroutine = nil
    self.mSchedulerId = nil
    self.mAlive = true
    self.mAliveCheckFunc = aliveCheckFunc
	local scheduler = cc.Director:getInstance():getScheduler()
    self.mSchedulerId = scheduler:scheduleScriptFunc(function(dt) self:onUpdate(dt) end, 0, false)
    local co = coroutine.create(func)
    self.coroutine = co
    u3a.mCoMap[co] = self
    return true
end

-- 清除协程
function M:cleanup()
    if not self.mAlive then return end
    self.mAlive = false
    u3a.mCoMap[self.coroutine] = nil
    if self.mSchedulerId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerId)
        self.mSchedulerId = nil
    end
end

-- 每帧更新
function M:onUpdate(dt)
	if not self.mAliveCheckFunc() then
        self.mNeedCleanup = true
        self:resume()
		self:cleanup()
		return
	end
    if self.mUpdateFunc then self.mUpdateFunc(dt) end
end

-- 暂停
function M:pause(name, timeout)
    self.timeout = timeout
    coroutine.yield()
    -- 强制杀死协程
    if self.mNeedCleanup then
        NEED_TRACK_COROUTINE_ERROR = false
        local errors = nil
        errors = errors + 1
    end
end

-- 设置更新函数
function M:setUpdateFunc(handler)
    self.mUpdateFunc = handler
end

-- 恢复
function M:resume(name)
    self.mUpdateFunc = nil
    local success, yieldType, yieldParam = coroutine.resume(self.coroutine, self)
    if not success then
        print("resume failed", success, yieldType, yieldParam)
        self:cleanup()
        return
    end
    local status = coroutine.status(self.coroutine)
    -- 判断协程是否结束
    if status == "dead" then
    	self:cleanup()
    end
end

return M
