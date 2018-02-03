----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：捕鱼全局定义
----------------------------------------------------------------------

local _M = {}
setmetatable(_M, {__index = _G})
setfenv(1, _M)

MAX_BULLET_CNT = 25
BULLET_LANCHER_INTERVAL = 0.2

function CreateSpriteFrameAnimation(strFormat, inteval)
    local animation = cc.Animation:create()
    local idx = 0
    while true do
        local frameName = string.format(strFormat, idx)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        if spriteFrame == nil then break end
        animation:addSpriteFrame(spriteFrame)
        idx = idx + 1
    end
    animation:setDelayPerUnit(3 / 20.0)
    return animation
end

local mustExtendFunc = {}
mustExtendFunc["require"] = true
mustExtendFunc["getComponent"] = true
mustExtendFunc["getScene"] = true

-- 对象是否还存活
function IsObjectAlive(obj)
	if obj == nil then return false end
	local t = type(obj)
	if t == "userdate" then
		return not tolua.isnull(obj)
	elseif obj.getSelf then
		return obj:getSelf()
	end
	return false
end

-- 继承类
function ExtendClass(obj, cls)
    local parent = cls.new()
    if parent.super then
        ExtendClass(obj, parent.super)
    end

    -- 继承变量
    for name, val in pairs(parent) do
        if obj[name] == nil and name ~= "class" then
            --print("value", name, obj[name], val)
            obj[name] = val
        end
    end

    -- 继承方法
	for name, val in pairs(cls) do
        if obj[name] == nil then
            --print("function", name, obj[name], val)
            obj[name] = val
        end

		if mustExtendFunc[name] then
			--print(parent.__cname, name, obj.__cname)
            obj[name] = val
        end
    end
end

-- 是否属于某个类
function IsKindOf(cls, name)
    if cls.__cname == name then return true end
    if cls.super then
        return IsKindOf(cls.super, name)
    end
    return false
end

-- 调用
function Invoke(target, name, ...)
    if target == nil then return end
    local func = target[name]
    if func == nil then return end
    return func(target, ...)
end

function ccui.Widget:onClicked(callback)
	assert(type(callback) == 'function')
    local function touchEvent(_sender, eventType)
		if eventType == ccui.TouchEventType.ended then
            if PlayBtnSound then PlayBtnSound(self.sound_type) end
			callback(self)
		end
	end
    self._onClickedHandler = callback
	self:addTouchEventListener(touchEvent)
    return self
end

-- 把node里的子控件挂载在ui对象上
function BindToUI(widget, obj)
    -- 按钮事件
    local function buttonEventHandler(child)
        local name = child:getName()
        local func = obj["click_"..name]
        if func then 
            func(obj, child)
        else
            print("no function", obj.__cname, "click_"..name)
        end
    end

    local function visitChild(child)
        local name = child:getName()
		if (not name) or name == '' then
			return
		end
        --print(name)
		obj[name] = child -- 
		if tolua.iskindof(child, 'ccui.Button') or tolua.iskindof(child, 'ccui.CheckBox') then
			child:onClicked(function() buttonEventHandler(child) end)
		end
    end
    widget:visitAll(visitChild)
end

function ChangeParentNode(nd, newParent)
	nd:retain()
	local parent = nd:getParent()
	if parent then
		parent:removeChild(nd, false)
	end
	newParent:addChild(nd)
	nd:release()
end

-- 加载csb
function LoadCsb(filename, obj, bShield)
    local widget = ccui.Widget:create()
    local node = cc.CSLoader:createNode(filename)
 	widget:setContentSize(node:getContentSize())
 	widget:setTouchEnabled(bShield) --
    widget:setPosition(0, 0)
    widget:setAnchorPoint(0, 0)
	for k, v in pairs(node:getChildren()) do
		ChangeParentNode(v, widget)
	end
	if obj then
		BindToUI(widget, obj)
	end
    return widget
end

-- 移除某个结点
function SafeRemoveNode(node)
    if node == nil or tolua.isnull(node) then return end
    node:removeFromParent(true)
end


------------------------------------------
-- 协程相关
------------------------------------------

mCoMap = {}
local Coroutine = require("games.fish.core.Coroutine")

local mCoroutineId = 0
NEED_TRACK_COROUTINE_ERROR = true

local _CE_TRACKBACK_ = function(msg)
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
    local bWindows = cc.Application:getInstance():getTargetPlatform() == 0
	-- 协程主函数
    local function executeFunc()
        if not bWindows then
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

return _M