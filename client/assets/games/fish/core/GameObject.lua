----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏对象
----------------------------------------------------------------------

local M = class("GameObject", require("games.fish.core.LuaObject"))

-- 构造函数
function M:ctor()
    M.super.ctor(self)
    self.mGameScene = nil
    self.mComponents = {}
    self.mChildren = {}
    self.mTimerList = {}
    self.mTimerID = 0
    self:set("destroy_frames", -1)
end

-- 获得添加到的场景
function M:getScene()
    return self.mGameScene
end

function M:coroutine(target, name, ...)
	self:getScene():coroutine(target, name, ...)
end

function M:rename(name)
    self:getScene():rename(self, name)
end

function M:require(name)
    return self:getScene():require(name)
end

-- 从场景中移除
function M:removeFromScene(frames)
    self:releaseLuaObject()
    for _, child in pairs(self.mChildren) do
        if child:getSelf() then
            child:removeFromScene()
        end
    end
    wls.SafeRemoveNode(self.ui_root)
end

-- 创建组件
function M:createComponent(filename, ...)
	local path = filename
    local cls = self:require(path)
	local ret = cls.new(...)
    if not IsKindOf(cls, "Component") then
        ExtendClass(ret, Component)
    end
    local name = ret.__cname
	ret.mGameOject = self
    self.mComponents[name] = ret
	ret:onCreate(...)
    return ret
end

-- 添加组件
function M:addComponent(name, val)
    self.mComponents[name] = val
end

-- 查找组件
function M:getComponent(name)
    return self.mComponents[name]
end

-- 移除组件
function M:removeComponent(args)
    local obj = self:getComponent(name)
    if obj == nil then return end
    self.mComponents[name] = nil
    obj:removeFromObject(args)
end

-- 查找场景中的其他游戏对角
function M:find(name)
    return self:getScene():find(name)
end

function M:post(eventName, ...)
    self:getScene():post(eventName, ...)
end

function M:fullPath(filename)
	return self.mGameScene:fullPath(filename)
end

function M:toast(str)
	return self.mGameScene:toast(str)
end

------------------------------------
-- 子结点管理与操作
------------------------------------
function M:createGameObject(path, ...)
    return self:getScene():createGameObject(path, ...)
end

function M:createUnnameObject(path, ...)
    return self:getScene():createUnnameObject(path, ...)
end

function M:removeGameObject(name)
    self:getScene():removeGameObject(name)
end

function M:reloadGameObject(name, ...)
    self:removeGameObject(name)
    return self:createGameObject(path, ...)
end

function M:wrapGameObject(obj, path, name, ...)
    return self:getScene():wrapGameObject(obj, path, name, ...)
end

------------------------------------
-- 定时器
------------------------------------
function M:doUpdateTimer(dt)
    local timer
    for i = #self.mTimerList, 1, -1 do
        timer =  self.mTimerList[i]
        if timer.alive then
            self:updateOneTimer(timer, dt)
        else
            table.remove(self.mTimerList, i)
        end
    end
end

function M:updateOneTimer(timer, dt)
    timer.curTimer = timer.curTimer + dt
    if timer.curTimer < timer.maxTimer then return end
    timer.curTimer = 0
    timer.curCount = timer.curCount + 1
    if timer.maxCount > 0 and timer.curCount >= timer.maxCount then
        timer.alive = false
    end
    timer.func()
end

function M:stopTimer(id)
    for _, timer in ipairs(self.mTimerList) do
        if timer.id == id then
            timer.alive = false
            break
        end
    end
end

function M:startTimer(interval, func, id, cnt)
    assert(type("interval") ~= "number", "设置间隔时间")
    assert(func ~= nil, "设置回掉函数")
    self.mTimerID = self.mTimerID + 1
    local timer = {}
    timer.id = id or self.mTimerID
    timer.curTimer = 0
    timer.maxTimer = interval
    timer.curCount = 0
    timer.maxCount = cnt or 1
    timer.alive = true
    timer.func = func
    if type(func) == "string" then
        timer.func = function() wls.Invoke(self, func) end
    end
    table.insert(self.mTimerList, timer)
    return timer.id
end

return M