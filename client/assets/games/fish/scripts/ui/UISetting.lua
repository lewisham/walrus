----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-12-24
-- 描述：设置界面
----------------------------------------------------------------------

local M = class("UISetting", wls.UIGameObject)

function M:onCreate()
    self:createMask()
    self:loadCenterNode(self:fullPath("ui/common/uisoundset.csb"), true)
    self.slider_music:setTag(1)
    self.slider_music:setMaxPercent(120)
    self.slider_music:addEventListener(handler(self,self.sliderCallback))
    self.slider_effect:setTag(2)
    self.slider_effect:setMaxPercent(120)
    self.slider_effect:addEventListener(handler(self,self.sliderCallback))
    self:setVisible(false)
end

function M:doShow()
    self:setVisible(true)
end

function M:initData()
    local musicvolume = FishGI.AudioControl:getMusicVolume()
    self.slider_music:setPercent(tonumber(musicvolume) * 100 + 10)
    local effectsvolume = FishGI.AudioControl:getEffectsVolume()
    self.slider_effect:setPercent(tonumber(effectsvolume) * 100 + 10)
end

function M:sliderCallback(sender, eventType)
    local function setCurPer()
        local curPer = sender:getPercent()
        if curPer < 10 then
            curPer = 10
        elseif curPer > 110 then
            curPer = 110
        end
        sender:setPercent(curPer)
        return curPer
    end

    local tag = sender:getTag()
    if eventType == ccui.SliderEventType.slideBallDown or eventType == ccui.SliderEventType.percentChanged then
        setCurPer()
    elseif eventType == ccui.SliderEventType.slideBallUp or eventType == ccui.SliderEventType.slideBallCancel then
        self:setVolumeByPer(tag, setCurPer())
    end
end

function M:setVolumeByPer(tag, curPer)
    local tag = tag
    if curPer == nil then curPer = 110 end
    local volume = curPer - 10

    -- warming 迁移到大厅后下面代码需修改为大厅的
    do return end
    if tag == 1 then
        FishGI.AudioControl:setMusicVolume(volume / 100)
        if volume <= 0 then
            FishGI.AudioControl:setMusicStatus(false)
            FishGI.AudioControl:pauseMusic()
        else
            if not FishGI.AudioControl:getMusicStatus() then
                FishGI.AudioControl:setMusicStatus(true)
                FishGI.AudioControl:playLayerBgMusic()
            end
        end
        FishGI.AudioControl:flushData()

    elseif tag == 2 then
        FishGI.AudioControl:setEffectsVolume(volume / 100)
        if volume <= 0 then
            FishGI.AudioControl:setEffectStatus(false)
            FishGI.AudioControl:stopAllEffects()
        else
            FishGI.AudioControl:setEffectStatus(true)
        end
        FishGI.AudioControl:flushData()
    end
end

function M:click_btn_close()
    self:setVisible(false)
end

return M