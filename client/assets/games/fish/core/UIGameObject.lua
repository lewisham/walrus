----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-10-18
-- 描述：ui基类
----------------------------------------------------------------------

local function newFunc(obj)
	if type(obj) == "userdata" then
		return obj
	else
		return ccui.Widget:create()
	end
end

local M = class("UIGameObject", newFunc)


function M:start()
    local parent = self:getParentNode()
    if parent then
        self:addTo(parent, self:getZorder())
    end
end

function M:getParentNode()
    return self.mRoot
end

function M:getZorder()
    return 0
end

function M:onCreate(...)
end

function M:isObjectAlive()
    return not tolua.isnull(self)
end

-- 加载csb
function M:loadCsb(filename, bShield)
    local node = cc.CSLoader:createNode(filename)
	local size = cc.Director:getInstance():getVisibleSize()
	local bLayer = node:getName() == "Layer"
    if bLayer then
        self:setContentSize(size)
    end
 	self:setTouchEnabled(bShield)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)
	-- csb 绑定到的节点
	local bindWidget = self
	for k, v in ipairs(node:getChildren()) do
		u3a.ChangeParentNode(v, bindWidget)
	end
	if bLayer then
		ccui.Helper:doLayout(self)
	end
	u3a.BindToUI(bindWidget, self)
end

-- 加载csb
function M:loadCenterNode(filename, bShield, aniType)
    local node = cc.CSLoader:createNode(filename)
	local size = cc.Director:getInstance():getVisibleSize()
    self:setContentSize(size)
 	self:setTouchEnabled(bShield)
    self:setPosition(0, 0)
    self:setAnchorPoint(0, 0)

	-- csb 绑定到的节点
	local bindWidget = self
	node:setPosition(size.width / 2, size.height / 2)
	-- 开场特效
	if aniType == "scaleTo" then
		bindWidget = self:scaleToEnter()
	end
	node:addTo(bindWidget)
	u3a.BindToUI(bindWidget, self)
end

function M:scaleToEnter()
	local size = cc.Director:getInstance():getWinSize()
	local mask = ccui.Layout:create()
	self:addChild(mask)
	mask:setContentSize(size)
	mask:setBackGroundColor(cc.c3b(0, 0, 0))
	mask:setBackGroundColorOpacity(168)
	mask:setBackGroundColorType(1)

	-- 动作结点
	local action = ccui.Widget:create()
	self:addChild(action)
	action:setContentSize(size)
	action:setAnchorPoint(0.5, 0.5)
	action:setPosition(size.width / 2, size.height / 2)

	local root = ccui.Layout:create()
	action:addChild(root)
	root:setContentSize(size)

	-- action
	action:setScale(0.82)
	action:runAction(cc.ScaleTo:create(0.1, 1.0))

	action:setScale(0.82)
    action:setCascadeOpacityEnabled(true)
    action:setOpacity(0)
    local spawnaction = cc.Spawn:create(cc.FadeIn:create(0.09), cc.ScaleTo:create(0.1, 1.0))
    action:runAction(spawnaction)
	return root
end

function M:onUpdate()
end

------------------------------------
-- 继承GameObject接口
------------------------------------



-- 从场景中移除
function M:removeFromScene()
	u3a.SafeRemoveNode(self)
end

-- 获得添加到的场景
function M:getScene()
    return self.mGameScene
end

function M:createUnnameChild(root, filename, ...)
	local child = self:getScene():createUnnameObject(filename, ...)
	child:changeParentNode(root)
	return child
end

function M:createUnnameObject(filename, ...)
	local child = self:getScene():createUnnameObject(filename, ...)
	return child
end

function M:wrapGameObject(obj, path, ...)
    return self.mGameScene:wrapGameObject(obj, path, ...)
end

function M:fullPath(filename)
	return self.mGameScene:fullPath(filename)
end

function M:coroutine(target, name, ...)
    local args = {...}
    local function aliveCheckFunc()
        return not tolua.isnull(self)
    end
    local function callback(co)
        u3a.Invoke(target, name, unpack(args))
    end
	local co = u3a.NewCoroutine(aliveCheckFunc, callback)
	co:resume("start run")
end


function M:toast(str)
	return self.mGameScene:toast(str)
end

return M

