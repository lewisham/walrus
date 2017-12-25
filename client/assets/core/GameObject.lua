﻿----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏对象
----------------------------------------------------------------------

GameObject = class("GameObject", LuaObject)

-- 构造函数
function GameObject:ctor()
    GameObject.super.ctor(self)
    self.mGameScene = nil
    self.mComponents = {}
    self.mChildren = {}
    self:set("destroy_frames", -1)
end

function GameObject:awake()
end

-- 获得添加到的场景
function GameObject:getScene()
    return self.mGameScene
end

function GameObject:getGameApp()
    return self:getScene():getGameApp()
end

function GameObject:coroutine(target, name, ...)
	self:getScene():coroutine(target, name, ...)
end

function GameObject:rename(name)
    self:getScene():rename(self, name)
end

function GameObject:require(name)
    return self:getScene():require(name)
end

-- 从场景中移除
function GameObject:removeFromScene(frames)
    self:releaseLuaObject()
    for _, child in pairs(self.mChildren) do
        if child:getSelf() then
            child:removeFromScene()
        end
    end
    SafeRemoveNode(self.ui_root)
end

-- 创建组件
function GameObject:createComponent(filename, ...)
	local path = filename
    local cls = self:require(path)
	local ret = cls.new(...)
    if not IsKindOf(cls, "Component") then
        ExtendClass(ret, Component)
    end
    local name = ret.__cname
	ret.mGameOject = self
    self.mComponents[name] = ret
	ret:init(...)
    return ret
end

-- 添加组件
function GameObject:addComponent(name, val)
    self.mComponents[name] = val
end

-- 查找组件
function GameObject:getComponent(name)
    return self.mComponents[name]
end

-- 移除组件
function GameObject:removeComponent(args)
    local obj = self:getComponent(name)
    if obj == nil then return end
    self.mComponents[name] = nil
    obj:removeFromObject(args)
end

-- 查找场景中的其他游戏对角
function GameObject:find(name)
    return self:getScene():find(name)
end

------------------------------------
-- 子结点管理与操作
------------------------------------
function GameObject:createGameObject(path, ...)
    return self:getScene():createGameObject(path, ...)
end

function GameObject:removeGameObject(name)
    self:getScene():removeGameObject(name)
end

function GameObject:reloadGameObject(name, ...)
    self:removeGameObject(name)
    return self:createGameObject(path, ...)
end
