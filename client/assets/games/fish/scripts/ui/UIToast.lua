----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-02-28
-- 描述：吐司提示
----------------------------------------------------------------------

local M = class("UIToast", wls.UIGameObject)

function M:onCreate()
    local toastBg = ccui.ImageView:create()
    toastBg:loadTexture(self:fullPath("ui/images/common/layerbg/com_pic_infobg.png"), 0)
    toastBg:setScale9Enabled(true);
    toastBg:setCapInsets({x = 42, y = 26, width = 1, height = 1})
    toastBg:setAnchorPoint(cc.p(0.5, 0.5))
    toastBg:setPosition(cc.p(display.width / 2, display.height * 0.6))
    toastBg:setOpacity(0)
    toastBg:setScale(0.75)
    self:addChild(toastBg)
    self._toastBg = toastBg
    
    local txtTips = cc.LabelTTF:create("", "Arial", 32)
    txtTips:setOpacity(0)
    toastBg:addChild(txtTips)
    self._txtTips = txtTips

    self:setVisible(false)
    wls.Toast = function(msg, delayTime)
        self:showToast(msg, delayTime)
    end
end

function M:getZorder()
    return 101
end

function M:showToast(msg, delayTime)
    delayTime = delayTime or 5
    self._txtTips:setString(msg or "")
    self._toastBg:setContentSize(cc.size(self._txtTips:getContentSize().width + 50, 52))
    self._txtTips:setPosition(cc.p(self._toastBg:getContentSize().width / 2, self._toastBg:getContentSize().height / 2))
    
    self:setVisible(true)
    self:showAni(self._toastBg, delayTime)
    self:showAni(self._txtTips, delayTime)    
end

function M:showAni(node, delayTime)
    node:stopAllActions()
    node:setOpacity(255)
    node:runAction(cc.Sequence:create(
        cc.DelayTime:create(delayTime), 
        cc.FadeTo:create(0.5, 0), 
        cc.CallFunc:create(function()     
            self:setVisible(false)
        end))
    )
end

return M