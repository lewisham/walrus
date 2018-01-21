----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：右边的菜单栏
----------------------------------------------------------------------

local M = class("UIRightPanel", UIBase)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uisetbutton.csb"))
    self:setPosition(display.width, display.height / 2)
    self.isOpen = false
end

function M:click_btn_openlist()
    self:open()
end

function M:click_btn_pokedex()
    self:open()
    self:createGameObject("UIFishHandBook")
end

function M:click_btn_sound()
end

function M:click_btn_exit()
    self:getScene():doExitGame()
end

function M:open()
    self.isOpen = not self.isOpen 
    if self.originPos == nil then 
        self.originPos = cc.p(self:getPosition())
    end 
    self:stopAllActions()
    if self.isOpen == true then
        self.spr_triangle:setRotation(0)
        self:runAction(cc.MoveTo:create(0.1, cc.p(self.originPos.x-self.image_bg:getContentSize().width * 0.9, self.originPos.y)))
    else
        self.spr_triangle:setRotation(180)
        self:runAction(cc.MoveTo:create(0.1, cc.p(self.originPos.x,self.originPos.y)))
    end
end

return M