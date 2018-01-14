----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：加载界面
----------------------------------------------------------------------

local M = class("UILoading", UIBase)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uiLoadingLayer.csb"), true)
    self.sliderScale = self.slider_loading:getScale()
    self:updatePercent(0)
    self.text_message:setString("海象号扬帆起航...")
end

function M:play()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    local tb = self:require("fish")
    local total = table.nums(tb)
    local idx = 0
    for _, val in pairs(tb) do
        local name = string.format("games/fish/assets/plist/fish/%s.plist", val.fish_res)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(name)
        idx = idx + 1
        self:updatePercent(idx / total * 100)
        WaitForFrames(1)
    end
    for i = 1, 10 do
        local name = string.format("games/fish/assets/plist/nets/net_%d.plist", i)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(name)
    end
    WaitForSeconds(0.1)
    self:find("SCSound"):playMusic("music_00" .. self:getScene():get("room_idx"))
    self:removeFromScene()
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