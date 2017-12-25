----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：lua 对象类
----------------------------------------------------------------------

LuaObject = class("LuaObject")

local instance_id = 0

-- 构造函数
function LuaObject:ctor()
    self.mAutoAddToScene = true
    self.mProperty = {}
    self.mRefCnt   = 1
	self.mInstanceID = instance_id + 1
    instance_id = instance_id + 1
end

function LuaObject:init()
end

-- 获得实例id
function LuaObject:getInstanceID()
	return self.mInstanceID
end

-- 获取缓存数据
function LuaObject:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function LuaObject:set(name, value)
    self.mProperty[name] = value
end

-- 修改数据
function LuaObject:modify(name, value)
    self.mProperty[name] = self.mProperty[name] + value
    return self.mProperty[name]
end

function LuaObject:releaseLuaObject()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function LuaObject:getSelf()
    if self.mRefCnt < 1 then return nil end
    return self
end

function LuaObject:isObjectAlive()
    return self:getSelf()
end

function LuaObject:coroutine(target, name, ...)
    local args = {...}
    local function aliveCheckFunc()
        return self:isObjectAlive()
    end
    local function callback(co)
        Invoke(target, name, co, unpack(args))
    end
	local co = NewCoroutine(aliveCheckFunc, callback)
	co:resume("start run")
end

-- 自动自成require文件列表
function LuaObject:autoRequire(dir)
    if CreateLuaPath then
        CreateLuaPath(dir)
    end
    local pre = string.gsub(dir, "\\", ".")
    local tb = require(pre .. ".AutoPath")
    local list = self:get("lua_path") or {}
    for name, path in pairs(tb) do
        list[name] = path
    end
    self:set("lua_path", list)
end

function LuaObject:getLuaPath(name)
    return self:get("lua_path")[name]
end

function LuaObject:require(name)
    local path = self:getLuaPath(name) or name
    return ReloadLuaModule(path)
end
