----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：协程
----------------------------------------------------------------------

local mCoMap = {}

local Coroutine = class("Coroutine")

function Coroutine:init(aliveCheckFunc, func)
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
    mCoMap[co] = self
    return true
end

-- 清除协程
function Coroutine:cleanup()
    if not self.mAlive then return end
    self.mAlive = false
    mCoMap[self.coroutine] = nil
    if self.mSchedulerId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerId)
        self.mSchedulerId = nil
    end
end

-- 每帧更新
function Coroutine:onUpdate(dt)
	if not self.mAliveCheckFunc() then
        self.mNeedCleanup = true
        self:resume()
		self:cleanup()
		return
	end
    if self.mUpdateFunc then self.mUpdateFunc(dt) end
end

-- 暂停
function Coroutine:pause(name, timeout)
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
function Coroutine:setUpdateFunc(handler)
    self.mUpdateFunc = handler
end

-- 恢复
function Coroutine:resume(name)
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

------------------------------------------
--
------------------------------------------

local mCoroutineId = 0
NEED_TRACK_COROUTINE_ERROR = true

_CE_TRACKBACK_ = function(msg)
    if not NEED_TRACK_COROUTINE_ERROR then
        NEED_TRACK_COROUTINE_ERROR = true
        return
    end
    print(msg)
    printError("协程出错")
end

-- 创建新的协程
function NewCoroutine(aliveCheckFunc, func, args)
    local co = nil
    local function callback()
        func(args)
    end
	-- 协程主函数
    local function executeFunc()
        if not device:isWindows() then
            callback()
        else
            xpcall(function() callback() end, _CE_TRACKBACK_)
        end
    end
    co = Coroutine.new()
    co:init(aliveCheckFunc, executeFunc)
	return co
end

function GetRunningCO()
    local cor = coroutine.running()
    if cor == nil then return end
    return mCoMap[cor]
end

-- 开启协程
function StartCoroutine(aliveCheckFunc, func, args)
    local co = NewCoroutine(aliveCheckFunc, func, args)
    co:resume("start run")
	return co
end

-- 等待数秒
function WaitForSeconds(seconds)
    local co = GetRunningCO()
    if co == nil then return end
    local function onUpdate(dt)
        if seconds > 0 then
            seconds = seconds - dt
        end
        if seconds <= 0 then
            co:resume("WaitForSeconds")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForSeconds")
end

-- 等待数帧
function WaitForFrames(frames)
    local co = GetRunningCO()
    if co == nil then return end
    local function onUpdate(dt)
        if frames > 0 then
            frames = frames - 1
        end
        if frames <= 0 then
            co:resume("WaitForFrames")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForFrames")
end

-- 等待函数返回值为true 或不为nil
function WaitForFuncResult(func)
    local co = GetRunningCO()
    if co == nil then return end
    local function onUpdate()
        if func() then
            co:resume("WaitForFuncResult")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForFuncResult")
end

return Coroutine
