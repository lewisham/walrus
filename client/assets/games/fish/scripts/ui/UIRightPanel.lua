----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：右边的菜单栏
----------------------------------------------------------------------

local M = class("UIRightPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uisetbutton.csb"))
    self:setPosition(display.width, display.height / 2)
    self.originPos = cc.p(self:getPosition())
    self.isOpen = false

    --添加安卓返回键监听
    local function onKeyboardFunc(code, event)
        if code == cc.KeyCode.KEY_BACK then
            return self:doExitGame()
        end
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyboardFunc, cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function M:click_btn_openlist()
    if not self.isOpen then 
        self:open() 
    else
        self:close()
    end
end

function M:click_btn_pokedex()
    self:close()
    self:createGameObject("UIFishHandBook")
end

function M:click_btn_sound()
    self:close()
    self:find("UISetting"):doShow()
end

function M:click_btn_exit()
    self:close()
    self:doExitGame()
end

function M:doExitGame()
    local function callback(ret)
        if ret == 1 then self:getScene():doExitGame() end
    end
    if not self:find("SKTimeRevert"):exitCheck(callback) then
        return 
    end
    if self:find("ExitDialog") then return end
    local view = self:createGameObject("UIDialog", true)
    view:rename("ExitDialog")
    view:updateView(3, self:find("SCConfig"):getLanguageByID(800000004))
    view:setCallback(callback)
end

-- 开启
function M:open()
    self.isOpen = true
    self:stopAllActions()
    self.spr_triangle:setRotation(0)
    local tb =
    {
        cc.MoveTo:create(0.1, cc.p(self.originPos.x-self.image_bg:getContentSize().width * 0.9, self.originPos.y)),
        cc.CallFunc:create(function() self:openTouchBegan() end),
    }
    self:runAction(cc.Sequence:create(tb))
end

-- 关闭
function M:close()
    self.isOpen = false
    self:stopAllActions()
    self.spr_triangle:setRotation(180)
    self:runAction(cc.MoveTo:create(0.1, cc.p(self.originPos.x,self.originPos.y)))
end

function M:onEventTouchBegan()
    if not self.bStartListen then return end
    self.bStartListen = false
    self:close()
end

function M:openTouchBegan()
    self.bStartListen = true
end

return M