----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：AppBase
----------------------------------------------------------------------

AppBase = class("AppBase", LuaObject)

function AppBase:init()
    self.mSceneList = {}
    self.mSceneStack = {}
    self.mRunningScene = nil
    math.randomseed(os.clock())
end

-- 创建场景
function AppBase:createScene(name, ...)
    local scene = require(name).new()
    scene:set("GameApp", self)
    scene:createRoot()
    scene:createAutoPath()
    scene:onCreate(...)
    self.mSceneList[scene.__cname] = scene
    return scene
end

-- 运行场景
function AppBase:runScene(name, ...)
    local scene = self:createScene(name, ...)
    table.insert(self.mSceneStack, 1, scene)
    scene:run()
end

function AppBase:getRunningScene()
	return self.mSceneStack[1]
end

-- 替换场景
function AppBase:replaceScene(name, ...)
    for _, scene in ipairs(self.mSceneStack) do
        if scene:getSelf() then
            scene:destroy()
        end
    end
    self.mSceneStack = {}
    self:runScene(name, ...)
end

-- 添加场景
function AppBase:pushScene(name, ...)
    for _, scene in ipairs(self.mSceneStack) do
        if scene:getSelf() then
            scene:getRoot():setVisible(false)
        end
    end
    local scene = self:createScene(name, ...)
    table.insert(self.mSceneStack, 1, scene)
    scene:run()
end

function AppBase:popScene()
	local pop = self.mSceneStack[1]
	if pop and pop:getSelf() then
        pop:destroy()
		table.remove(self.mSceneStack, 1)
    end
	for _, scene in ipairs(self.mSceneStack) do
        if scene:getSelf() then
            scene:getRoot():setVisible(true)
        end
    end
end

-- 查找场景
function AppBase:findScene(name)
    return self.mSceneList[name]
end

-- 移除场景
function AppBase:removeScene(name)
    self.mSceneList[name] = nil
end


