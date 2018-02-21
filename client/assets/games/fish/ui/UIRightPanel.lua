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
end

function M:click_btn_openlist()
    if not self.isOpen then 
        self:open() 
    else
        self:close()
    end
    if not self:getScene():get("enable_fps") then return end
    cc.Director:getInstance():setDisplayStats(self.isOpen)
end

function M:click_btn_pokedex()
    self:close()
    self:createGameObject("UIFishHandBook")
end

function M:click_btn_sound()
    self:close()
    self:createGameObject("UISetting")
end

function M:click_btn_exit()
    self:createGameObject("SCUpdate"):publish("games\\fish", "F:/http/fish/")
    self:close()
    --self:getScene():doExitGame()
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