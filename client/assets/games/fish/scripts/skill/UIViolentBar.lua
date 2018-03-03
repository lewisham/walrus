----------------------------------------------------------------------
-- 作者：lps
-- 日期：2018-3-1
-- 描述：狂暴进度
----------------------------------------------------------------------

local M = class("UIViolentBar", wls.UIGameObject)

function M:onCreate()

    self.spr_bar:setVisible(false)
    self.progress = cc.ProgressTimer:create(self.spr_bar)
    self.panel:addChild(self.progress, self.spr_bar:getLocalZOrder())
    self.progress:setPosition(cc.p(self.spr_bar:getPositionX(), self.spr_bar:getPositionY()))
    self.progress:setMidpoint(cc.p(0, 0.5))
    self.progress:setBarChangeRate(cc.p(1,0))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)

    self.totalTime = 0
    self.beginTime = 0
    self.progress:setPercentage(100)

end

function M:play(barTime)
    if barTime == nil then barTime = 0 end
    self.beginTime = os.time()
    self.totalTime = barTime
    self.progress:setPercentage(100)
    self:runCountdownAct(self.totalTime)
    self:setRate(tonumber(self:find("SCConfig"):getConfigByID(990000105)))
end

function M:runCountdownAct(time)
    self.progress:stopAllActions()
    local seq = cc.Sequence:create(cc.ProgressTo:create(time,0), cc.CallFunc:create(function()
        self:timeOver()
        end))
    self.progress:runAction(seq)
end

function M:updateCDTime()
    if self.totalTime<= 0 then
        return
    end
    local remainTime = self.totalTime-(os.time()-self.beginTime)
    if remainTime <= 0 then
        self:timeOver()
        return
    end
    self.progress:setPercentage(remainTime/self.totalTime*100)
    self:runCountdownAct(remainTime)

end

function M:timeOver()
    self:stop()
    self:find("SKViolent"):stopPlayerSkill(wls.SelfViewID)
end

function M:stop()
    self.progress:stopAllActions()
    self.progress:setPercentage(0)
    self.totalTime = 0
    self.beginTime = 0
end

function M:click_btn_tworate()
    self:setRate(2)
    wls.SendMsg("sendSetViolentRate", 2)
end

function M:click_btn_fourrate()
    self:setRate(4)
    wls.SendMsg("sendSetViolentRate", 4)
end

-- 设置倍率
function M:setRate(rate)
    self:find("SKViolent"):setRate(rate)
    if rate == 2 then
        self.btn_fourrate:setEnabled(true)
        self.btn_tworate:setEnabled(false)
    elseif rate == 4 then
        self.btn_fourrate:setEnabled(false)
        self.btn_tworate:setEnabled(true)
    end
end

return M