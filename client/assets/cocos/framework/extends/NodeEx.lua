--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local Node = cc.Node

-- ���������ӿؼ�
function Node:visitAll(fn)
	local function fnVisitAll(nd, fn)
		for k, child in pairs(nd:getChildren()) do
			local bStop = fn(child)
			if bStop then
				return bStop
			end
            if not tolua.iskindof(child, 'cc.TMXTiledMap') then
                bStop = fnVisitAll(child, fn)
			    if bStop then
				    return bStop
			    end
            end
		end
	end

	return fnVisitAll(self, fn)
end

-- ���ܣ���ʼ�ڵ㶨ʱ��
-- ����fnTimer: Ҫ��������
-- ����bSkipFirst: ������ִ��
-- ���ӣ�g_rootNode:startTimer(function() print(os.time()) end, 2)
function Node:startTimer1(fnTimer, seconds, bSkipFirst)
	self:stopAllActions()

	local function fnWrap() -- ����ʱ�رն�ʱ��
		return TryCatch(fnTimer, function() self:stopAllActions() end)
	end

	local acList = {}
	if bSkipFirst then -- ������һ��
		acList:insert(cc.DelayTime:create(seconds))
		acList:insert(cc.CallFunc:create(fnWrap))
	else
		acList:insert(cc.CallFunc:create(fnWrap))
		acList:insert(cc.DelayTime:create(seconds))
	end

	self:runAction(cc.RepeatForever:create(cc.Sequence:create(acList)))
	return self
end

-- ����: ֹͣ��ʱ��
function Node:stopTimer1()
	self:stopAllActions()
	return self
end

----------------------------------------------------------------------
-- ��  �ܣ�������ʱ�ظ�����
----------------------------------------------------------------------
function Node:timerWhile(fnCond, seconds, fnOnError)
	local nd = cc.Node:create()
	self:addChild(nd)

	local function fnCatch()
		SafeRemoveNode(nd) -- ������ɾ�Լ�, ��ֹ��Դй¶
		fnOnError()
	end

	local function fnCondWrap()
		return TryCatch(fnCond, fnCatch)
	end

	local hasFinish = false -- �����������ֹcocos2dx bug������������ܱ�ִ�ж��
	local function fnTimer()
		if hasFinish then
			return
		end
		if not fnCondWrap() then
			hasFinish = true
			SafeRemoveNode(nd)
		end
	end

	nd:startTimer(fnTimer, seconds, true)
end

function Node:getMidPos()
	local sz = self:getContentSize()
	return cc.p(sz.width/2, sz.height/2)
end

function Node:setMidPosition(node, difX, difY)
    difX = difX or 0
    difY = difY or 0
    local pos = self:getMidPos()
    node:setPosition(cc.p(pos.x+difX, pos.y+difY))
end

-- ��ӵ��ؼ��е�
function Node:addChildToMid(node, difX, difY)
    self:addChild(node)
    self:setMidPosition(node, difX, difY)
end

-- ����: �󶨵���Ļ��ĳ����, ����ȷ�����ڵ��Ѽ��볡����
-- ����: nd:bindScreen(0.5, 0.5) -- ����Ļ����
-- ����: nd:bindScreen(0, 0) -- ����Ļ���½�
-- ����: nd:bindScreen(1, 1) -- ����Ļ���Ͻ�
function Node:bindScreen(xAnchor, yAnchor)
	assert(xAnchor and yAnchor, "�봫��x, y�󶨵�, ȡֵ��Χ0.0��1.0!")
	-- ���ڵ�
	local ndParent = self:getParent()
	assert(ndParent, "û���ڵ���Ļ�����㲻����!")
	local director = cc.Director:getInstance()
	local view = director:getOpenGLView()
	--Log(view:getVisibleRect())
	local rc = view:getVisibleRect()
	-- ��������
	local worldPos = cc.p(rc.x + rc.width * xAnchor, rc.y + rc.height * yAnchor)
	-- ת���Լ�������
	local selfPos = ndParent:convertToNodeSpace(worldPos)
	self:setPosition(selfPos)
	return self
end

-- ��ʾ�ؼ�
function Node:where()
	local sz = self:getContentSize()
	if sz.width < 50 then
		sz.width = 50
	end

	if sz.height < 50 then
		sz.height = 50
	end

	local ly = cc.LayerColor:create(cc.c4b(0,255,0, 128), sz.width, sz.height)
	self:addChild(ly)

	ly:runAction(cc.Sequence:create(
							cc.DelayTime:create(3),
							cc.CallFunc:create(function() SafeRemoveNode(ly) end)
							))
end

function Node:add(child, zorder, tag)
    if tag then
        self:addChild(child, zorder, tag)
    elseif zorder then
        self:addChild(child, zorder)
    else
        self:addChild(child)
    end
    return self
end

function Node:addTo(parent, zorder, tag)
    if tag then
        parent:addChild(self, zorder, tag)
    elseif zorder then
        parent:addChild(self, zorder)
    else
        parent:addChild(self)
    end
    return self
end

function Node:removeSelf()
    self:removeFromParent()
    return self
end

function Node:align(anchorPoint, x, y)
    self:setAnchorPoint(anchorPoint)
    return self:move(x, y)
end

function Node:show()
    self:setVisible(true)
    return self
end

function Node:hide()
    self:setVisible(false)
    return self
end

function Node:move(x, y)
    if y then
        self:setPosition(x, y)
    else
        self:setPosition(x)
    end
    return self
end

function Node:moveTo(args)
    transition.moveTo(self, args)
    return self
end

function Node:moveBy(args)
    transition.moveBy(self, args)
    return self
end

function Node:fadeIn(args)
    transition.fadeIn(self, args)
    return self
end

function Node:fadeOut(args)
    transition.fadeOut(self, args)
    return self
end

function Node:fadeTo(args)
    transition.fadeTo(self, args)
    return self
end

function Node:rotate(rotation)
    self:setRotation(rotation)
    return self
end

function Node:rotateTo(args)
    transition.rotateTo(self, args)
    return self
end

function Node:rotateBy(args)
    transition.rotateBy(self, args)
    return self
end

function Node:scaleTo(args)
    transition.scaleTo(self, args)
    return self
end

----------------------------------------------------------------------
-- ��  �ܣ���һ����ĳ������
----------------------------------------------------------------------
function Node:callAfter(seconds, fn)
	local arr = {cc.DelayTime:create(seconds),
					cc.CallFunc:create(fn)}
	self:runAction(cc.Sequence:create(arr))
	return self
end

----------------------------------------------------------------------
-- ��  �ܣ���һ����ĳ������(���ӽڵ�����ʱ��, ��ֹrunAction��ͻ)
----------------------------------------------------------------------
function Node:callAfterEx(seconds, fn)
	local nd = cc.Node:create()
	self:addChild(nd)
	local arr = {cc.DelayTime:create(seconds),
					cc.CallFunc:create(function() SafeRemoveNode(nd) end),
					cc.CallFunc:create(fn)}
	nd:runAction(cc.Sequence:create(arr))
	return self
end

-- ����һ֡����ֹ�����Ӿ�bug
function Node:runAtNextFrame(fn)
	local oldVal = cc.Director:getInstance():getTotalFrames()
	local function fnCond()
		if cc.Director:getInstance():getTotalFrames() > oldVal + 1 then -- ����2֡
			fn()
			return false
		else
			return true
		end
	end

	self:timerWhile(fnCond, 0.01, function() end)
end

----------------------------------------------------------------------
-- ��  �ܣ��ı丸�ڵ�
----------------------------------------------------------------------
function Node:changeParentNode(newParent)
	local nd = self
	nd:retain() -- ��ֹ���ͷ�
	local parent = nd:getParent()
	if parent then
		parent:removeChild(nd, false)
	end
	newParent:addChild(nd)
	nd:release()
end
----------------------------------------------------------------------
-- ��  �ܣ�ȥ��setParent��������ֹ����
----------------------------------------------------------------------
Node.setParent = nil


--[[
function Node:onUpdate(callback)
    self:scheduleUpdateWithPriorityLua(callback, 0)
    return self
end

-- scheduleUpdate�ڲ�����ɾ���κνڵ㣬������ܻ�����
Node.scheduleUpdate = Node.onUpdate
]]--

function Node:onNodeEvent(eventName, callback)
    if "enter" == eventName then
        self.onEnterCallback_ = callback
    elseif "exit" == eventName then
        self.onExitCallback_ = callback
    elseif "enterTransitionFinish" == eventName then
        self.onEnterTransitionFinishCallback_ = callback
    elseif "exitTransitionStart" == eventName then
        self.onExitTransitionStartCallback_ = callback
    elseif "cleanup" == eventName then
        self.onCleanupCallback_ = callback
    end
    self:enableNodeEvents()
end

function Node:enableNodeEvents()
    if self.isNodeEventEnabled_ then
        return self
    end

    self:registerScriptHandler(function(state)
        if state == "enter" then
            self:onEnter_()
        elseif state == "exit" then
            self:onExit_()
        elseif state == "enterTransitionFinish" then
            self:onEnterTransitionFinish_()
        elseif state == "exitTransitionStart" then
            self:onExitTransitionStart_()
        elseif state == "cleanup" then
            self:onCleanup_()
        end
    end)
    self.isNodeEventEnabled_ = true

    return self
end

function Node:disableNodeEvents()
    self:unregisterScriptHandler()
    self.isNodeEventEnabled_ = false
    return self
end


function Node:onEnter()
end

function Node:onExit()
end

function Node:onEnterTransitionFinish()
end

function Node:onExitTransitionStart()
end

function Node:onCleanup()
end

function Node:onEnter_()
    self:onEnter()
    if not self.onEnterCallback_ then
        return
    end
    self:onEnterCallback_()
end

function Node:onExit_()
    self:onExit()
    if not self.onExitCallback_ then
        return
    end
    self:onExitCallback_()
end

function Node:onEnterTransitionFinish_()
    self:onEnterTransitionFinish()
    if not self.onEnterTransitionFinishCallback_ then
        return
    end
    self:onEnterTransitionFinishCallback_()
end

function Node:onExitTransitionStart_()
    self:onExitTransitionStart()
    if not self.onExitTransitionStartCallback_ then
        return
    end
    self:onExitTransitionStartCallback_()
end

function Node:onCleanup_()
    self:onCleanup()
    if not self.onCleanupCallback_ then
        return
    end
    self:onCleanupCallback_()
end

-- ������(����ڵ��ƶ�)
function Node:setParticleGrouped()
	self:visitAll(function(v)
				local disNode = v:getDisplayRenderNode()
				if disNode then
					if tolua.iskindof(disNode, 'cc.ParticleSystem') then
						disNode:setPositionType(cc.POSITION_TYPE_GROUPED)
					end
				end
			end)
end
