----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：测试界面
----------------------------------------------------------------------

local M = class("UITestPanel", wls.UIGameObject)

function M:getZorder()
    return 10000
end

function M:onCreate()
    self:loadCsb(self:fullPath("ui/TestPanel.csb"))
    self:listenKeyEvent()
    self:createSecretLayer()
    self.Node_Btn:setVisible(false)
    self.Panel_2:setVisible(false)
    self.btn_openlist:setVisible(false)
end

function M:onUpdate()
    if not self.Panel_2:isVisible() then return end
    local go = self:find("SCGameLoop")
    self.Text_ServerFrame:setString(go.mServerFrame)
    self.Text_ClientFrame:setString(go.mClientFrame)
    self.Text_Timeline:setString(go:get("timeline_idx"))
end

function M:click_btn_openlist()
    self.Node_Btn:setVisible(not self.Node_Btn:isVisible())
end

function M:click_btn_publish()
    self:createGameObject("SCUpdate"):publish("games\\fish", "F:/http/fish/")
end

function M:click_btn_reload()
    self:getScene():reloadAllGameObject()
end

function M:click_btn_show_frame()
    local bool = not self.Panel_2:isVisible()
    self.Panel_2:setVisible(bool)
    cc.Director:getInstance():setDisplayStats(bool)
end

function M:click_btn_secrect()
    self.secretLayer:setVisible(not self.secretLayer:isVisible())
end


function M:onKeyboard(code, event)
    if code == cc.KeyCode.KEY_T then
        self.Node_Btn:setVisible(not self.Node_Btn:isVisible())
    end
end

function M:listenKeyEvent()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self,self.onKeyboard),cc.Handler.EVENT_KEYBOARD_RELEASED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end


--秘籍面板
function M:createSecretLayer()
    local inputLayer = ccui.ImageView:create("common/layerbg/com_pic_infobg.png")
    inputLayer:setSwallowTouches(true)
    inputLayer:setScale9Enabled(true)
    inputLayer:setAnchorPoint(cc.p(0.5, 0.5))
    inputLayer:setPosition(cc.p(display.width / 2 - 200, display.height / 2))
    inputLayer:setContentSize(cc.size(200, 200))
    self:addChild(inputLayer, 1888)
    self.secretLayer = inputLayer
    self.secretLayer:setVisible(false)

    local closeBt = ccui.Button:create("common/btn/com_btn_close_ex_0.png", "common/btn/com_btn_close_ex_1.png")
    closeBt:setScale9Enabled(true)
    closeBt:setContentSize(cc.size(60, 60))
    closeBt:setTitleFontSize(30)
    closeBt:setPosition(cc.p(inputLayer:getContentSize().width*0.8, inputLayer:getContentSize().height*0.78))
    closeBt:addTouchEventListener(function (pSender, eventName) if eventName == ccui.TouchEventType.ended then layer:removeChild(inputLayer) openSecretBt:setVisible(true) end end)
    inputLayer:addChild(closeBt)

    local propNumEdit = ccui.EditBox:create(cc.size(150 , 40 ), "we")
    propNumEdit:setPosition(cc.p(inputLayer:getContentSize().width/2, inputLayer:getContentSize().height*0.4))
    propNumEdit:setAnchorPoint(cc.p(0.5, 0.5))
    propNumEdit:setPlaceHolder("NUMBER")
    propNumEdit:setPlaceholderFontColor(cc.c3b(255, 100, 100))
    propNumEdit:setFontColor(cc.c3b(100, 100, 100))
    propNumEdit:setInputFlag(5)
    propNumEdit:setFontSize(25)
    propNumEdit:setPlaceholderFontSize(20)
    inputLayer:addChild(propNumEdit)

    local propIdEdit = ccui.EditBox:create(cc.size(150 , 40 ), "we")
    propIdEdit:setPosition(cc.p(inputLayer:getContentSize().width/2, inputLayer:getContentSize().height*0.6))
    propIdEdit:setAnchorPoint(cc.p(0.5, 0.5))
    propIdEdit:setPlaceHolder("ID")
    propIdEdit:setPlaceholderFontColor(cc.c3b(255, 100, 100))
    propIdEdit:setFontColor(cc.c3b(100, 100, 100))
    propIdEdit:setInputFlag(5)
    propIdEdit:setFontSize(25)
    propIdEdit:setPlaceholderFontSize(20)
    inputLayer:addChild(propIdEdit)

    local function sendSecretMessage(pSender, eventName)
        if eventName == ccui.TouchEventType.ended then
            local num = tonumber(propNumEdit:getText())
            local id = tonumber(propIdEdit:getText())
            local data = {}
            data.newProps = {}
            local prop = {}
            prop.propId = id
            prop.propCount = num
            table.insert(data.newProps,prop)
            wls.SendMsg("sendAddMoney", data)
            wls.SendMsg("sendReChargeSucceed")
        end
    end

    local addBt = ccui.Button:createInstance()
    addBt:setTitleText("add")
    addBt:setTitleFontSize(30)
    addBt:setTag(2)
    addBt:setPosition(cc.p(inputLayer:getContentSize().width/2, inputLayer:getContentSize().height*0.2))
    addBt:addTouchEventListener(sendSecretMessage)
    inputLayer:addChild(addBt)

    --[[local addMoneyBt = ccui.Button:createInstance()
    addMoneyBt:setTitleText("add Money")
    addMoneyBt:setTitleFontSize(15)
    addMoneyBt:setTag(1)
    addMoneyBt:setPosition(cc.p(inputLayer:getContentSize().width/2, inputLayer:getContentSize().height*0.1))
    addMoneyBt:addTouchEventListener(sendSecretMessage)
    inputLayer:addChild(addMoneyBt)]]--
end

return M