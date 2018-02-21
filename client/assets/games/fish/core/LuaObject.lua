----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：lua 对象类
----------------------------------------------------------------------

local M = class("LuaObject")

local instance_id = 0

-- 构造函数
function M:ctor()
    self.mAutoAddToScene = true
    self.mProperty = {}
    self.mRefCnt   = 1
	self.mInstanceID = instance_id + 1
    instance_id = instance_id + 1
end


-- 获得实例id
function M:getInstanceID()
	return self.mInstanceID
end

-- 获取缓存数据
function M:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function M:set(name, value)
    self.mProperty[name] = value
end

-- 修改数据
function M:modify(name, value)
    self.mProperty[name] = self.mProperty[name] + value
    return self.mProperty[name]
end

function M:releaseLuaObject()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function M:getSelf()
    if self.mRefCnt < 1 then return nil end
    return self
end

function M:isObjectAlive()
    return self:getSelf()
end

function M:coroutine(target, name, ...)
    local args = {...}
    local function aliveCheckFunc()
        return self:isObjectAlive()
    end
    local function callback(co)
        wls.Invoke(target, name, unpack(args))
    end
	local co = wls.NewCoroutine(aliveCheckFunc, callback)
	co:resume("start run")
end

return M
