----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏场景
----------------------------------------------------------------------

GameScene = class("GameScene", LuaObject)

-- 构造函数
function GameScene:ctor()
    GameScene.super.ctor(self)
    self.mRootZorder = 0
    self.mGameObjects = {}
    self.mUniqueObjects = {}
    self.mLayers = {}
    self:set("lua_path", {})
    self:set("tmp_name_id", 0)
end

function GameScene:run()
end

function GameScene:createAutoPath()
end

function GameScene:destroy()
    SafeRemoveNode(self.mRoot)
	for _, obj in pairs(self.mGameObjects) do
		Invoke(obj, "releaseLuaObject")
	end
    self:releaseLuaObject()
    self:get("GameApp"):removeScene(self.__cname)
end

function GameScene:getGameApp()
    return self:get("GameApp")
end

--
function GameScene:awaken()
	local tb = self:getGameObjects()
    for _, obj in pairs(tb) do
		Invoke(obj, "awake")
	end
end

function GameScene:setVisible(bVisible)
    self:getRoot():setVisible(bVisible)
end

-- 创建根结点
function GameScene:createRoot()
    local widget = ccui.Widget:create()
    g_RootNode:addChild(widget, self.mRootZorder)
    local size = cc.Director:getInstance():getWinSize()
    widget:setContentSize(size)
    widget:setTouchEnabled(true) -- 防止穿透
    widget:setPosition(0, 0)
    widget:setAnchorPoint(0, 0)
    local function update(dt)
        if not device:isWindows() then
            self:onUpdate(dt)
        else
            xpcall(function() self:onUpdate(dt) end, __G__TRACKBACK__)
        end
    end
    widget:scheduleUpdateWithPriorityLua(update, 0)
    self.mRoot = widget
end

function GameScene:onUpdate(dt)
    -- 清除无用的对象
    local tb = self:getGameObjects()
    for _, obj in pairs(tb) do
        Invoke(obj, "onUpdate", dt)
    end 
end

function GameScene:getGameObjects()
	-- 清除无用的对象
    local tb = {}
    for key, val in pairs(self.mGameObjects) do
        if IsObjectAlive(val) then
            tb[key] = val
        end
    end  
    self.mGameObjects = tb
	return tb
end

function GameScene:getRoot()
    return self.mRoot
end

-- 创建游戏对象
function GameScene:createGameObject(filename, ...)
    local cls = self:require(filename)
	local ret = cls.new(...)
	if not IsKindOf(cls, "GameObject") then
        ExtendClass(ret, GameObject)
    end
    local name = ret.__cname
    ret.__path = self:getLuaPath(filename)
    ret.mRoot = self:getRoot()
    ret.mGameScene = self
    self.mGameObjects[name] = ret
	ret:init(...)
    return ret
end

-- 查找游戏对象
function GameScene:find(name)
    return self.mGameObjects[name]
end

-- 移除游戏对象
function GameScene:removeGameObject(name, args)
    local obj = self:find(name)
    if obj == nil then return end
    self.mGameObjects[name] = nil
    obj:removeFromScene(args)
end

-- 对象重命名
function GameScene:rename(go, name)
    for key, val in pairs(self.mGameObjects) do
        if val == go then
            self.mGameObjects[key] = nil
            self.mGameObjects[name] = go 
            break
        end
    end
end

-------------------------------------
-- 场景切换的特效
-------------------------------------
function GameScene:balckOut(co, duration)
    local mask = ccui.Layout:create()
    self:getRoot():addChild(mask, 1)
    local size = cc.Director:getInstance():getWinSize()
    mask:setContentSize(size)
    mask:setTouchEnabled(true) -- 防止穿透
    mask:setBackGroundColor(cc.c3b(0, 0, 0))
    mask:setBackGroundColorOpacity(255)
    mask:setBackGroundColorType(1)
    local tb = 
    {
        cc.FadeOut:create(duration),
        cc.RemoveSelf:create(),
    }
    mask:runAction(cc.Sequence:create(tb))
    if co then WaitForSeconds(co, duration) end
end

