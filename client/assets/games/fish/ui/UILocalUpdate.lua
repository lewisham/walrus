----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：加载界面
----------------------------------------------------------------------

local M = class("UILocalUpdate", u3a.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uiLoadingLayer.csb"), true)
    self.sliderScale = self.slider_loading:getScale()
    self:updatePercent(0)
    self.text_message:setString("海象号扬帆起航...")
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uiLoadingLayer.csb"))
    self:runAction(action)
    action:gotoFrameAndPlay(0)
end

function M:updateString(str)
    self.text_message:setString(str)
end

function M:updatePercent(per)
    self.slider_loading:setPercent(per)
    local scaleY = self.sliderScale
    local scaleDis = 3
    if per > 100-scaleDis then
        scaleY = (100 - per)/scaleDis*scaleY
    end
    if per <= scaleDis then
        scaleY = per/scaleDis*scaleY
    end

    local size = self.slider_loading:getContentSize()
    self.spr_bar_light:setPositionX(size.width*per/100)
    self.spr_bar_light:setScale(scaleY)
end

return M