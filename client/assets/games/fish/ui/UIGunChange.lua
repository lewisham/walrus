----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台Panel
----------------------------------------------------------------------

local M = class("UIGunChange", UIBase)

function M:onCreate(viewID)
    self:loadCsb(self:fullPath("ui/uigunchange.csb"))
    self.mViewID = viewID
    self:setVisible(false)
end

function M:show()
    self:setVisible(true)
    local bAutoFire = self:getScene():get("auto_fire")
    self.spr_autofire:setVisible(not bAutoFire)
    self.spr_cancelauto:setVisible(bAutoFire)
    self:openTouchBegan()
end

function M:openTouchBegan()
    local node = cc.Node:create()
    self:addChild(node, -1)
    local function onTouchBegan(touch, event)
        self:setVisible(false)
        SafeRemoveNode(node)
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)
end

function M:click_btn_autofire()
    self:setVisible(false)
    local bAutoFire = not self:getScene():get("auto_fire")
    self:getScene():set("auto_fire", bAutoFire)
    if not bAutoFire then
        self:find("UITouch"):stopTimer()
    end
end

function M:click_btn_face()
    self:setVisible(false)
end

function M:click_btn_changecannon()
    self:setVisible(false)
end

return M