----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏场景
----------------------------------------------------------------------

local M = class("GameScene", require("games.fish.core.LuaObject"))

-- 构造函数
function M:ctor()
    M.super.ctor(self)
    self.mRootZorder = 0
    self.mGameObjects = {}
    self.mUniqueObjects = {}
    self.mLayers = {}
    self:set("lua_path", {})
    self:set("assets_path", "")
    self:set("tmp_name_id", 0)
end

function M:onCreate()
end

-- 自动自成require文件列表
function M:autoRequire(dir)
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

function M:getLuaPath(name)
    return self:get("lua_path")[name]
end

function M:require(name)
    local path = self:getLuaPath(name) or name
    if self:get("reload_lua_module") then
        return ReloadLuaModule(path)
    else
        return require(path)
    end
end

function M:fullPath(filename)
    return string.format("%s%s", self:get("assets_path"), filename)
end

function M:run()
end

function M:createAutoPath()
end

function M:destroy()
    u3a.SafeRemoveNode(self.mRoot)
	for _, obj in pairs(self.mGameObjects) do
		u3a.Invoke(obj, "releaseLuaObject")
	end
    self:releaseLuaObject()
    self:get("GameApp"):removeScene(self.__cname)
end

function M:getGameApp()
    return self:get("GameApp")
end

function M:setVisible(bVisible)
    self:getRoot():setVisible(bVisible)
end

-- 创建根结点
function M:createRoot()
    local widget = ccui.Widget:create()
    local scene = g_RootNode
    if scene == nil then
        scene = cc.Director:getInstance():getRunningScene()
    end
    scene:addChild(widget, self.mRootZorder)
    local size = cc.Director:getInstance():getWinSize()
    widget:setContentSize(size)
    widget:setTouchEnabled(true) -- 防止穿透
    widget:setPosition(0, 0)
    widget:setAnchorPoint(0, 0)
    local function update(dt)
        self:onUpdate(dt)
    end
    widget:scheduleUpdateWithPriorityLua(update, 0)
    self.mRoot = widget
end

function M:onUpdate(dt)
    -- 清除无用的对象
    for key, obj in pairs(self.mGameObjects) do
        if u3a.IsObjectAlive(obj) then
            u3a.Invoke(obj, "onUpdate", dt)
        else
            self.mGameObjects[key] = nil
        end
    end 
end


-- 事件派发
function M:post(eventName, ...)
    -- 清除无用的对象
    u3a.Invoke(self, eventName, ...)
    for _, obj in pairs(self.mGameObjects) do
        if u3a.IsObjectAlive(obj) then
            u3a.Invoke(obj, eventName, ...)
        end
    end 
end

function M:getRoot()
    return self.mRoot
end

-- 创建游戏对象
function M:createGameObject(filename, ...)
    local cls = self:require(filename)
	local ret = cls.new(...)
    if not u3a.IsKindOf(cls, "GameObject") then
        u3a.ExtendClass(ret, u3a.GameObject)
    end
    local name = ret.__cname
    ret.__path = self:getLuaPath(filename)
    ret.mRoot = self:getRoot()
    ret.mGameScene = self
    self.mGameObjects[name] = ret
    u3a.Invoke(ret, "start")
    ret:onCreate(...)
    return ret
end

-- 创建没有名字的对象(不加入对象列表里管理)
function M:createUnnameObject(filename, ...)
    local cls = self:require(filename)
	local ret = cls.new(...)
	if not u3a.IsKindOf(cls, "GameObject") then
        u3a.ExtendClass(ret, u3a.GameObject)
    end
    local name = ret.__cname
    ret.__path = self:getLuaPath(filename)
    ret.mRoot = self:getRoot()
    ret.mGameScene = self
    u3a.Invoke(ret, "start")
    ret:onCreate(...)
    return ret
end

function M:wrapGameObject(obj, path, ...)
    local cls = self:require(path)
    local ret = cls.new(obj)
    if not u3a.IsKindOf(cls, "GameObject") then
        u3a.ExtendClass(ret, u3a.GameObject)
    end
    local name = ret.__cname
    ret.__path = self:getLuaPath(filename)
    obj.mRoot = self:getRoot()
    obj.mGameScene = self
    obj.__cname = cls.__cname
    self.mGameObjects[name] = obj
    BindToUI(obj, ret)
    obj:onCreate(...)
    return obj
end

-- 查找游戏对象
function M:find(name)
    return self.mGameObjects[name]
end

-- 移除游戏对象
function M:removeGameObject(name, args)
    local obj = self:find(name)
    if obj == nil then return end
    self.mGameObjects[name] = nil
    obj:removeFromScene(args)
end

-- 对象重命名
function M:rename(go, name)
    for key, val in pairs(self.mGameObjects) do
        if val == go then
            self.mGameObjects[key] = nil
            self.mGameObjects[name] = go 
            break
        end
    end
end

return M

