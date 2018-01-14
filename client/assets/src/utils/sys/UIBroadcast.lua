----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：广播消息
----------------------------------------------------------------------

local MOVE_SPEED = 120.0
local OFFSET_Y = 100

local M = class("UIBroadcast", UIBase)

function M:onCreate()
	self:setVisible(false)
	self:loadCsb("ui/hall/message_layer.csb", false)
	self.img_bg.originPos = cc.p(self.img_bg:getPosition())
	self.img_bg.hidePos = cc.p(self.img_bg.originPos.x, self.img_bg.originPos.y + OFFSET_Y)
	self.img_bg:setPosition(self.img_bg.hidePos)
	self.mMsglist = {}
	self:coroutine(self, "loop")
end

function M:play(str, priority)
	local unit = {}
	unit.priority = priority or 0
	unit.str = str
	table.insert(self.mMsglist, unit)
end

function M:loop()
	WaitForSeconds(0.5)
	while true do
		self:playOne()
		WaitForSeconds(0.3)
		self:showExit()
	end
end

function M:showEnter()
	self:setVisible(true)
	if self.img_bg:getPositionY() == self.img_bg.originPos.y then
		return
	end
	self.img_bg:setPosition(self.img_bg.hidePos)
	local t1 = 0.2
	self.img_bg:runAction(cc.MoveTo:create(t1, self.img_bg.originPos))
	WaitForSeconds(t1)
end

function M:showExit()
	if #self.mMsglist > 0 then return end
	if self.img_bg:getPositionY() == self.img_bg.hidePos.y then
		return
	end
	self.img_bg:setPosition(self.img_bg.originPos)
	local t1 = 0.2
	self.img_bg:runAction(cc.MoveTo:create(t1, cc.p(self.img_bg.hidePos)))
	WaitForSeconds(t1)
	self:setVisible(false)
end

function M:playOne()
	local unit = self.mMsglist[1]
	if unit == nil then return end
	table.remove(self.mMsglist, 1)
	self:showEnter()
	local txtView = self:createMessageText(unit.str)
	-- 开始滚动文字
	local t1 = display.width / MOVE_SPEED
	txtView:runAction(cc.MoveBy:create(t1 , cc.p(-display.width - txtView:getContentSize().width , 0)))
	WaitForSeconds(t1 + 0.01)
	SafeRemoveNode(txtView)
end

function M:createMessageText(str)
    local txtView = ccui.Text:create()
    txtView:setString(str)
    txtView:setColor(cc.c3b(255, 255, 255))
    txtView:setFontSize(32)
    txtView:setAnchorPoint(cc.p(0, 0))
    txtView:setPosition(cc.p(display.width , display.height - 50))
    txtView:setFontName( "ttf/MNCY.ttf" )
	self:addChild( txtView )
	return txtView
end

return M
