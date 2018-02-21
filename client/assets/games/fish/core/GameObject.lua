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

return M